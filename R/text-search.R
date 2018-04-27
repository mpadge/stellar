#' star_search
#'
#' Text search functionality of star function
#'
#' @param corpus Result of \code{getstars}, a tibble of titles and descriptions
#' of packages
#' @param phrase Text phrase to search for
#'
#' @return Same structure as corpus, but ordered by degree of matching to
#' \code{text}
#' @noRd
star_search <- function (corpus, phrase)
{
    tokens <- apply (cbind (corpus$name, corpus$description), 1, paste,
                      collapse = " ") %>%
        quanteda::char_tolower () %>%
        quanteda::tokens (remove_punct = TRUE) %>%
        quanteda::tokens_wordstem ()
    names (tokens) <- corpus$name

    dfm <- quanteda::dfm (tokens,
                   remove = quanteda::stopwords ("english"),
                   stem = TRUE,
                   remove_punct = TRUE,
                   verbose = FALSE)

    phrase <- tokenize_phrase (phrase)

    indx <- phrase_in_dfm (dfm, phrase)
    tokens <- tokens [indx]

    pos <- quanteda::kwic (tokens, phrase, join = FALSE)
    pos <- data.frame (reponame = pos$docname,
                       pos = pos$from,
                       kw  = pos$keyword,
                       stringsAsFactors = FALSE)

    ret <- NULL
    if (nrow (pos) > 0)
    {
        repo_names <- names (tokens)
        phrase_len <- nkw <- rep (NA, length (repo_names))
        for (i in seq (repo_names))
        {
            indx <- which (pos$reponame == repo_names [i])
            posi <- split (pos$pos [indx], pos$kw [indx])
            nkw [i] <- length (posi)

            if (length (posi) == 1)
            {
                # For single-token phrases, use first position as substitute for
                # minimal phrase length, so earlier positions are preferred.
                # Keyword can still occur multiple times, so min is necessary
                phrase_len [i] <- min (posi [[1]])
            } else
            {
                combs <- combn (length (posi), 2)
                dmin <- rep (NA, ncol (combs))
                for (j in seq (ncol (combs)))
                {
                    pj1 <- posi [[combs [1, j] ]]
                    pj2 <- posi [[combs [2, j] ]]
                    dj1 <- matrix (pj1, nrow = length (pj1),
                                   ncol = length (pj2))
                    dj2 <- t (matrix (pj2, nrow = length (pj2),
                                      ncol = length (pj1)))
                    dmin [j] <- min (abs (dj1 - dj2))
                }
                phrase_len [i] <- max (dmin) + 1
            }
        }

        indx <- order (-nkw, phrase_len) # highest #keywords; lowest s

        ret <- data.frame (min_phrase_len = phrase_len [indx],
                           num_key_words = nkw [indx],
                           repo_names = repo_names [indx],
                           stringsAsFactors = FALSE)
    }

    return (ret)
}

#' tokenize_phrase
#'
#' Convert a phrase to a vector of wordstem tokens, minus English-language
#' stopwords.
#'
#' @param aphase A single character string
#' @return Vector of tokens
#' @noRd
tokenize_phrase <- function (aphrase)
{
    tks <- quanteda::tokens (aphrase, remove_punct = TRUE,
                             remove_symbols = TRUE) %>%
                quanteda::tokens_wordstem (language = "english") %>%
                as.character ()
    tks [which (!tks %in% quanteda::stopwords ("english"))]
}

#' phrase_in_dfm
#' 
#' Get index into documents of those which contain terms in phrase
#'
#' @param mycorpus \code{quanteda::corpus} of descriptions of starred repos
#' @param aphrase tokenized phrase resulting from \code{tokenize_phrase}
#' @return Numberic index of documents in corpus which contain at least two of
#' the tokens in phrase
#' @noRd
phrase_in_dfm <- function (dfm, aphrase)
{
    aphrase <- aphrase [which (aphrase %in% quanteda::featnames (dfm))]
    indx <- apply (dfm [, aphrase], 1, function (i) sum (i > 0))
    which (indx > 1 | indx >= length (aphrase))
}
