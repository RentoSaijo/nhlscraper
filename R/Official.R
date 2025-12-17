#' Access all the officials
#' 
#' `officials()` scrapes all the officials.
#' 
#' @returns data.frame with one row per official
#' @examples
#' all_officials <- officials()
#' @export

officials <- function() {
  tryCatch({
    nhl_api(
      path = 'officials',
      type = 'r'
    )$data
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}
