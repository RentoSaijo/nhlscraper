#!/usr/bin/env python3

import csv
import re
import sys
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path
from urllib.request import Request, urlopen

from lxml import html


# Paths -----------------------------------------------------------------

ROOT = Path(__file__).resolve().parents[4]
AUDIT_DIR = ROOT / 'other' / 'audits' / 'shots'
OUT_DIR = AUDIT_DIR / 'outputs'
GAME_IDS = OUT_DIR / 'regular_game_ids.csv'
EVENTS_OUT = OUT_DIR / 'nhl_html_5v5_attempt_events.csv'
TOTALS_OUT = OUT_DIR / 'nhl_html_5v5_totals.csv'

# Event Constants -------------------------------------------------------

TYPE_MAP = {
    'SHOT': 'shot-on-goal',
    'MISS': 'missed-shot',
    'BLOCK': 'blocked-shot',
    'GOAL': 'goal',
}
SHOT_TYPES = set(TYPE_MAP.values())
ON_ICE_RE = re.compile(r'([0-9]{1,2})\s+([A-Z]{1,3})')


# Helpers ---------------------------------------------------------------

def report_url(game_id: int) -> str:
    season_start = game_id // 1_000_000
    season = f'{season_start}{season_start + 1}'
    suffix = f'{game_id % 1_000_000:06d}'
    return f'https://www.nhl.com/scores/htmlreports/{season}/PL{suffix}.HTM'


def parse_on_ice_counts(text: str) -> tuple[int, int]:
    positions = [m.group(2) for m in ON_ICE_RE.finditer(text or '')]
    return int('G' in positions), sum(1 for pos in positions if pos != 'G')


def elapsed_seconds(clock_text: str) -> int | None:
    match = re.match(r'\s*([0-9]{1,2}):([0-9]{2})', clock_text or '')
    if not match:
        return None
    return int(match.group(1)) * 60 + int(match.group(2))


# Fetching --------------------------------------------------------------

def fetch_game(game_id: int) -> list[dict[str, object]]:
    req = Request(
        report_url(game_id),
        headers={'User-Agent': 'nhlscraper-shot-audit/1.0'},
    )
    with urlopen(req, timeout=20) as resp:
        doc = html.fromstring(resp.read())

    events: list[dict[str, object]] = []
    for row in doc.xpath('.//tr'):
        cells = [
            cell.text_content().replace('\xa0', ' ').strip()
            for cell in row.xpath('./th|./td')
        ]
        if len(cells) < 8 or not cells[0].isdigit():
            continue
        event_code = (cells[4] or '').strip().upper()
        event_type = TYPE_MAP.get(event_code)
        if event_type not in SHOT_TYPES:
            continue

        away_goalie, away_skaters = parse_on_ice_counts(cells[-2])
        home_goalie, home_skaters = parse_on_ice_counts(cells[-1])
        if not (away_goalie == home_goalie == 1 and away_skaters == home_skaters == 5):
            continue

        events.append(
            {
                'gameId': game_id,
                'period': cells[1],
                'secondsElapsedInPeriod': elapsed_seconds(cells[3]),
                'htmlEventNumber': int(cells[0]),
                'htmlEventCode': event_code,
                'eventTypeDescKey': event_type,
                'description': cells[5],
            }
        )
    return events


# Script Entry Point ----------------------------------------------------

def main() -> int:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    if not GAME_IDS.exists():
        print(f'Missing {GAME_IDS}. Run the R audit script first.', file=sys.stderr)
        return 1

    with GAME_IDS.open(newline='') as f:
        reader = csv.DictReader(f)
        game_ids = [int(row['gameId']) for row in reader]

    all_events: list[dict[str, object]] = []
    failures: list[tuple[int, str]] = []
    workers = 24
    with ThreadPoolExecutor(max_workers=workers) as pool:
        futures = {pool.submit(fetch_game, game_id): game_id for game_id in game_ids}
        for n, future in enumerate(as_completed(futures), start=1):
            game_id = futures[future]
            try:
                all_events.extend(future.result())
            except Exception as exc:  # noqa: BLE001 - audit script should record all failures
                failures.append((game_id, str(exc)))
            if n % 100 == 0:
                print(f'Fetched {n} / {len(game_ids)} reports')

    all_events.sort(
        key=lambda x: (
            int(x['gameId']),
            str(x['period']),
            x['secondsElapsedInPeriod'] or -1,
            int(x['htmlEventNumber']),
        )
    )
    fieldnames = [
        'gameId',
        'period',
        'secondsElapsedInPeriod',
        'htmlEventNumber',
        'htmlEventCode',
        'eventTypeDescKey',
        'description',
    ]
    with EVENTS_OUT.open('w', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(all_events)

    counts = {event_type: 0 for event_type in SHOT_TYPES}
    for event in all_events:
        counts[str(event['eventTypeDescKey'])] += 1
    goals = counts['goal']
    saved = counts['shot-on-goal']
    missed = counts['missed-shot']
    blocked = counts['blocked-shot']
    with TOTALS_OUT.open('w', newline='') as f:
        writer = csv.DictWriter(
            f,
            fieldnames=[
                'source',
                'rows',
                'G',
                'saved',
                'iSF',
                'missed',
                'iFF',
                'blocked',
                'iCF',
                'failures',
            ],
        )
        writer.writeheader()
        writer.writerow(
            {
                'source': 'NHL HTML PL 5v5 by on-ice counts',
                'rows': len(all_events),
                'G': goals,
                'saved': saved,
                'iSF': goals + saved,
                'missed': missed,
                'iFF': goals + saved + missed,
                'blocked': blocked,
                'iCF': goals + saved + missed + blocked,
                'failures': len(failures),
            }
        )

    if failures:
        failures_out = OUT_DIR / 'nhl_html_fetch_failures.csv'
        with failures_out.open('w', newline='') as f:
            writer = csv.writer(f)
            writer.writerow(['gameId', 'error'])
            writer.writerows(failures)
        print(
            f'Completed with {len(failures)} failures; see {failures_out}',
            file=sys.stderr,
        )
    else:
        print(f'Wrote {len(all_events)} parsed 5v5 HTML attempt rows')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
