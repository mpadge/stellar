#' print_one_repo
#'
#' Dump title and description of one repository to screen
#'
#' @param repos Result of 
#' @noRd
print_repo <- function (repos, n)
{
    col_blue <- "\033[34m"
    col_green <- "\033[32m"
    col0 <- "\033[39m\033[49m" # 49m = normal BG

    message (paste0 (col_blue, "[", n, "] ", col_green, repos$name [n], col0,
                     " : "), appendLF = FALSE)
    message (paste0 (col_blue, repos$description [n], col0))
}

