context("internals")

test_that("query construction", {
  expect_silent(ordTRUE <- stellar:::get_order(TRUE))
  expect_equal(ordTRUE, "orderBy: {field: STARRED_AT, direction: DESC}")
  expect_is(ordTRUE, "character")

  expect_silent(ordFALSE <- stellar:::get_order(FALSE))
  expect_equal(ordFALSE, "orderBy: {field: STARRED_AT, direction: ASC}")
  expect_is(ordFALSE, "character")

  expect_silent(queryTRUE <- stellar:::form_qry_start("ropensci", ordTRUE))
  expect_silent(queryFALSENULL <- stellar:::form_qry_next("ropensci", ordTRUE, NULL))
  expect_silent(queryFALSE10 <- stellar:::form_qry_next("ropensci", ordTRUE, 10))

  expect_is(queryTRUE, "character")
  expect_match(queryTRUE, "ropensci")
  expect_is(queryFALSENULL, "character")
  expect_match(queryFALSENULL, "after: \"\"")
  expect_is(queryFALSE10, "character")
  expect_match(queryFALSE10, "ropensci")
  expect_match(queryFALSE10, "after: \"10\"")

  expect_error(stellar:::getstars_qry(), regexp = "newest_first.*missing")
  expect_error(stellar:::getstars_qry(newest_first = TRUE), regexp = "user.*missing")
  expect_error(stellar:::getstars_qry(user = "", newest_first = TRUE), regexp = "Could not resolve to a User")

  expect_silent(mpadge_stars1 <- stellar:::getstars_qry(user = "mpadge", newest_first = TRUE))
  mpadge_cursor <- mpadge_stars1$endCursor
  expect_silent(mpadge_stars2 <- stellar:::getstars_qry(user = "mpadge", newest_first = TRUE, after = mpadge_cursor))
  expect_is(mpadge_stars1, "list")
  expect_is(mpadge_stars1$dat, "data.frame")
  expect_equal(names(mpadge_stars1), c("dat", "has_next_page", "endCursor"))

  expect_is(mpadge_cursor, "character")

  expect_is(mpadge_stars2, "list")
  expect_is(mpadge_stars2$dat, "data.frame")
  expect_equal(names(mpadge_stars2), c("dat", "has_next_page", "endCursor"))

})

context("token input")

test_that("token processing", {
  token <- Sys.getenv("GITHUB_GRAPHQL_TOKEN")
  expect_silent(client <- stellar:::create_client())
  expect_is(client, "GraphqlClient")
  Sys.setenv(GITHUB_GRAPHQL_TOKEN = "")
  expect_error(stellar:::create_client(), regexp = "Please set your GITHUB_GRAPHQL_TOKEN")
  Sys.setenv(GITHUB_GRAPHQL_TOKEN = token)
})

context("retrieving stars")

test_that("stars can be retrieved", {
  expect_error(stellar:::getstars(), regexp = "Could not resolve to a User")
  expect_silent(mpadge_stars1 <- stellar:::getstars(user = "mpadge"))
  expect_is(mpadge_stars1, "data.frame")
  expect_equal(names(mpadge_stars1), c("name", "description", "language"))
  expect_silent(mpadge_stars_R <- stellar:::getstars(user = "mpadge", language = "R"))
  expect_true(all(mpadge_stars_R$language == "R"))
  expect_silent(mpadge_stars_ropensci <- stellar:::getstars(user = "mpadge", ghname = "ropensci"))
  expect_true(all(grepl("^ropensci/", mpadge_stars_ropensci$name)))
  expect_silent(mpadge_rev <- stellar:::getstars(user = "mpadge", newest_first = FALSE))
  expect_identical(mpadge_stars1$name, rev(mpadge_rev$name))
})

context("user-facing")

test_that("exported function behaves as expected", {
  expect_message(stars(user = "mpadge", phrase = "abcdefghijklkmnop"), "That text does not")
  mpadge_ggplot2 <- stars(user = "mpadge", phrase = "ggplot2", interactive = FALSE)
  expect_is(mpadge_ggplot2, "data.frame")
  skip_on_travis() ## whoami::gh_username() has nothing to find
  default_stars <- stars()
  expect_is(default_stars, "data.frame")
})
