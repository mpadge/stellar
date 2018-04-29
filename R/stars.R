#' stars
#'
#' Text search GitHub stars
#'
#' @param phrase Text string to search for. Defaults to "code"
#' @param user Name of GitHub user whose stars you want to search. Defaults to
#' your own profile
#' @param language Filter results to specified primary repository language
#' @param ghname Filter results to repos belonging to a specified GitHub name
#' @param newest_first Sort by newest stars first
#' @param interactive If \code{FALSE}, just print results to screen, invisibly
#' issue a return object, and exit.
#'
#' @return Interactive screen dump of results enabling you to select the best
#' match and open the corresponding GitHub repository
#' @export
stars <- function (phrase = "code", user = NULL, language = NULL, ghname = NULL,
                   newest_first = TRUE, interactive = TRUE)
{
    s <- getstars (user, language, ghname, newest_first)
    repos <- star_search (s, phrase)$repo_names
    ret <- NULL
    if (length (repos) == 0)
        message ("That text does not appear to describe any starred repositories")
    else
    {
        ret <- s [which (s$name %in% repos), ]
        for (i in seq (nrow (ret)))
            print_repo (ret, i)
        if (interactive)
        {
            val <- readline (paste0 ("\nchoose a repository to open, ",
                                     "or anything else to exit: "))
            val <- suppressWarnings (as.numeric (val))
            if (is.na (val))
                val <- -1
            if (val > 0 & val <= nrow (ret))
            {
                ghbase <- "https://github.com/"
                ghurl <- paste0 (ghbase, ret$name [val])
                browseURL (ghurl)
            }
        }
    }
    invisible (ret)
}

getstars <- function (user = NULL, language = NULL, ghname = NULL,
                      newest_first = TRUE)
{
    dat <- getstars_qry (user, newest_first, after = NULL)
    star_dat <- dat$dat
    while (dat$has_next_page)
    {
        dat <- getstars_qry (user, newest_first, after = dat$endCursor)
        star_dat <- rbind (star_dat, dat$dat)
    }

    if (!is.null (language))
        star_dat <- star_dat [star_dat$language %in% language, ]
    if (!is.null (ghname))
    {
        ghnames <- lapply (strsplit (star_dat$name, "/"),
                           function (i) i [[1]]) %>%
                unlist ()
        star_dat <- star_dat [ghnames %in% ghname, ]
    }

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
                            nameWithOwner
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
                            nameWithOwner
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
