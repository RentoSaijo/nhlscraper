#' Access all the general managers
#' 
#' `ns_general_managers()` scrapes information on all the general managers.
#' 
#' @returns data.frame with one row per general manager
#' @examples
#' all_GMs <- ns_general_managers()
#' @export

ns_general_managers <- function() {
  nhl_api(
    path = 'general-manager',
    type = 'r'
  )$data
}

#' @rdname ns_general_managers
#' @export
ns_gms <- function() {
  ns_general_managers()
}
