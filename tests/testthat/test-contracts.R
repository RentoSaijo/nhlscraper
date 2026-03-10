test_that("contracts() returns non-empty data.frame", {
  skip_if_offline()
  test <- contracts()
  expect_true(is.data.frame(test) && nrow(test) > 0)
  expect_false(any(c("twoYearCash", "threeYearCash") %in% names(test)))
})

test_that("contracts() returns matched player name and position from players()", {
  ns <- asNamespace("nhlscraper")
  old_locked <- bindingIsLocked(".contracts_base", ns)
  if (old_locked) {
    unlockBinding(".contracts_base", ns)
  }
  old_contracts_base <- get(".contracts_base", envir = ns, inherits = FALSE)
  assign(
    ".contracts_base",
    data.frame(
      playerFullName = "Jon Example",
      positionCode = "LW",
      teamId = 5L,
      signedWithTeamId = 5L,
      signedWithTriCode = "ABC",
      ageAtSigning = 25L,
      startSeasonId = 20242025L,
      endSeasonId = 20252026L,
      contractYears = 2L,
      contractAAV = 1.5,
      contractValue = 3,
      signingBonus = 0.5,
      stringsAsFactors = FALSE
    ),
    envir = ns
  )
  on.exit({
    assign(".contracts_base", old_contracts_base, envir = ns)
    if (old_locked) {
      lockBinding(".contracts_base", ns)
    }
  }, add = TRUE)

  local_mocked_bindings(
    players = function() {
      data.frame(
        playerId = 42L,
        playerFullName = "Jonathan Example",
        playerFirstName = "Jon",
        playerLastName = "Example",
        positionCode = "L",
        birthDate = "1999-07-01",
        currentTeamId = 5L,
        careerTeamId = 5L,
        firstSignedByTeamId = 5L,
        lastNHLTeamId = 5L,
        onRoster = "Y",
        stringsAsFactors = FALSE
      )
    },
    .package = "nhlscraper"
  )

  test <- get("contracts", envir = ns)()

  expect_equal(test$playerId, 42L)
  expect_equal(test$playerFullName, "Jonathan Example")
  expect_equal(test$positionCode, "L")
})
