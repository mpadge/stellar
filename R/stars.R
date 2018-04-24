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
    getstars (user, language, newest_first)
}

getstars <- function (user = NULL, language = NULL, newest_first = TRUE)
{
    dat <- getstars_qry (user, newest_first, after = NULL)
    star_dat <- dat$dat
    while (dat$has_next_page)
    {
        dat <- getstars_qry (user, newest_first, after = dat$endCursor)
        star_dat <- rbind (star_dat, dat$dat)
    }

    if (!is.null (language))
        star_dat <- star_dat [star_dat$language %in% language]

    return (star_dat)
}

form_qry_start <- function (user, ord)
{
    paste0 ('{
            user(login:"', user, '"){
                starredRepositories(first: 100, ', ord, ')
                {
                    pageInfo{
                        endCursor
                        hasNextPage
                    }
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
}

form_qry_next <- function (user, ord, after)
{
    paste0 ('{
            user(login:"', user, '"){
                starredRepositories(first: 100, ', ord, ', after: "', after, '")
                {
                    pageInfo{
                        endCursor
                        hasNextPage
                    }
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
}

get_order <- function (newest_first)
{
    ord <- 'orderBy: {field: STARRED_AT, direction: DESC}'
    if (!newest_first)
        ord <- 'orderBy: {field: STARRED_AT, direction: ASC}'
    return (ord)
}

getstars_qry <- function (user, newest_first, after = NULL)
{
    ord <- get_order (newest_first)

    if (is.null (after))
        query <- form_qry_start (user, ord)
    else
        query <- form_qry_next (user, ord, after)

    qry <- ghql::Query$new()
    qry$query('getstars', query)
    dat <- create_client()$exec(qry$queries$getstars) %>%
        jsonlite::fromJSON ()

    has_next_page <- dat$data$user$starredRepositories$pageInfo$hasNextPage
    endCursor <- dat$data$user$starredRepositories$pageInfo$endCursor

    # non-dplyr, non-jqr, dependency-free processing:
    dat <- dat$data$user$starredRepositories$edges$node
    dat <- tibble::tibble (name = dat$name,
                           description = dat$description,
                           language = dat$primaryLanguage [, 1])
    return (list (dat = dat,
                  has_next_page = has_next_page, endCursor = endCursor))
}
