Tests and Coverage
================
29 April, 2018 17:01:58

-   [Coverage](#coverage)
-   [Unit Tests](#unit-tests)

This output is created by [covrpage](https://github.com/yonicd/covrpage).

Coverage
--------

Coverage summary is created using the [covr](https://github.com/r-lib/covr) package.

| Object                                | Coverage (%) |
|:--------------------------------------|:------------:|
| stellar                               |     87.69    |
| [R/text-search.R](../R/text-search.R) |     81.43    |
| [R/stars.R](../R/stars.R)             |     89.72    |
| [R/screen-out.R](../R/screen-out.R)   |    100.00    |
| [R/zzz.R](../R/zzz.R)                 |    100.00    |

<br>

Unit Tests
----------

Unit Test summary is created using the [testthat](https://github.com/r-lib/testthat) package.

| file                                  |    n|   time|  error|  failed|  skipped|  warning|
|:--------------------------------------|----:|------:|------:|-------:|--------:|--------:|
| [test-stars.R](testthat/test-stars.R) |   45|  15.14|      0|       0|        0|        0|

| file                                  | test                                  | context          | status |    n|   time|
|:--------------------------------------|:--------------------------------------|:-----------------|:-------|----:|------:|
| [test-stars.R](testthat/test-stars.R) | query construction                    | internals        | PASS   |   28|  2.817|
| [test-stars.R](testthat/test-stars.R) | token processing                      | token input      | PASS   |    3|  0.004|
| [test-stars.R](testthat/test-stars.R) | stars can be retrieved                | retrieving stars | PASS   |   10|  6.537|
| [test-stars.R](testthat/test-stars.R) | exported function behaves as expected | user-facing      | PASS   |    4|  5.782|
