#' stars
#'
#' Text search github stars
#'
#' @param text Text string to search for
#' @param user Name of github user whose stars you want to search. Defaults to
#' your own profile
#' @param language Filter results to specified primary repository language
#' @return Interactive screen dump of results enabling you to select the best
#' match and open the corresponding github repository
#' @export
stars <- function (text = "", user = NULL, language = NULL)
{
    getstars (text = text, user = user)
}

getstars <- function (text = "", user = NULL)
{
    query <- paste0 ('{
                     user(login:"', user, '"){
                         starredRepositories(first: 5)
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
