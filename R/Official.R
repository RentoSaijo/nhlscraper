#' Access all the officials
#'
#' `officials()` returns the records-site official registry with one row per
#' official and normalized official ID, name, and referee-association fields.
#'
#' @returns data.frame with one row per official
#' @examples
#' all_officials <- officials()
#' @export

officials <- function() {
  tryCatch({
    officials <- nhl_api(
      path = 'officials',
      type = 'r'
    )$data
    names(officials)[names(officials) == 'id']                   <- 'officialId'
    names(officials)[names(officials) == 'firstName']            <- 'officialFirstName'
    names(officials)[names(officials) == 'lastName']             <- 'officialLastName'
    names(officials)[names(officials) == 'referreeAssociationId'] <- 'refereeAssociationId'
    officials
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}
