# Manager Functions ---------------------------------------------------------

#' Access all the general managers
#'
#' `general_managers()` returns the records-site general-manager registry with
#' one row per general manager and normalized ID/name fields.
#'
#' @returns data.frame with one row per general manager
#' @examples
#' all_GMs <- general_managers()
#' @export
general_managers <- function() {
  tryCatch({
    gms <- .nhl_api(
      path = 'general-manager',
      type = 'r'
    )$data
    names(gms)[names(gms) == 'id']        <- 'generalManagerId'
    names(gms)[names(gms) == 'firstName'] <- 'generalManagerFirstName'
    names(gms)[names(gms) == 'fullName']  <- 'generalManagerFullName'
    names(gms)[names(gms) == 'lastName']  <- 'generalManagerLastName'
    gms
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' @rdname general_managers
#' @export
gms <- function() {
  general_managers()
}
