[![Build Status](https://travis-ci.org/ropenscilabs/stellar.svg)](https://travis-ci.org/ropenscilabs/stellar) [![Project Status: Concept.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)

# stellar

Search your github stars in R

![](https://user-images.githubusercontent.com/6697851/39176684-b219d7b4-47ad-11e8-9aec-b30e284631e5.png)

## How?

The only thing you need is a Personal Access Token from github. If you don't
know how:
1. Go to your personal settings (under your profile pic, top right)
2. On the left, under the main "Peronsal Settings" box, click "Developer
   Settings" -> "Personal Access Tokens" and generate a new one. You'll need to
   check the box for accessing repository data via the github API v4.
3. Save this as an **R** environmental variable called `GITHUB_GRAPHQL_TOKEN`
   with `Sys.setenv("GITHUB_GRAPHQL_TOKEN" = <your token>)`. This can either be
   done within a single session, or automatically for all sessions by pasting
   this command within your `~/.Rprofile` file. (Simply create this file if it
   doesn't already exist.)
    

### Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](CONDUCT.md).  By participating in this project you agree to abide by
its terms.

