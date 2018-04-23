#' stars
#'
#' Text search github stars
#'
#' @param text Text string to search for
#' @param user Name of github user whose stars you want to search. Defaults to
#' your own profile
#' @param language Filter results to specified primary repository language
#' @param newest_first Sort by newest stars first
#'
#' @return Interactive screen dump of results enabling you to select the best
#' match and open the corresponding github repository
#' @export
stars <- function (text = "", user = NULL, language = NULL, newest_first = TRUE)
{
    getstars (text, user, newest_first)
}

getstars <- function (text, user, newest_first)
{
    ord <- 'orderBy: {field: STARRED_AT, direction: DESC}'
    if (!newest_first)
        ord <- 'orderBy: {field: STARRED_AT, direction: ASC}'

    query <- paste0 ('{
                     user(login:"', user, '"){
                         starredRepositories(first: 10, ', ord, ')
                         {
                             edges{
                                 node {
                                     name
                                     description
                                     primaryLanguage
                                     {
                                         name
                                     }
                                 }
                             }
                         }
                     }
            }')
    qry <- ghql::Query$new()
    qry$query('getstars', query)
    create_client()$exec(qry$queries$getstars) %>%
        jsonlite::fromJSON ()
}
