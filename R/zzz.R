create_client <- function(){
  token <- Sys.getenv("GITHUB_GRAPHQL_TOKEN")
  if(token == "")
  {
    stop ("Please set your GITHUB_GRAPHQL_TOKEN environment variable.")
  } else
  {
    if (!exists ("ghql_gh_cli")) {
      ghql_gh_cli <- ghql::GraphqlClient$new (
        url = "https://api.github.com/graphql",
        headers = httr::add_headers (Authorization =
                                     paste0 ("Bearer ", token))
      )
      ghql_gh_cli$load_schema()
      ghql_gh_cli <<- ghql_gh_cli
    }
    return (ghql_gh_cli)
  }
}
