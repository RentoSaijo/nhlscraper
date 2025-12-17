#' Access all the general managers
#' 
#' `general_managers()` scrapes all the general managers.
#' 
#' @returns data.frame with one row per general manager
#' @examples
#' all_GMs <- general_managers()
#' @export

general_managers <- function() {
  tryCatch({
    nhl_api(
      path = 'general-manager',
      type = 'r'
    )$data
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
