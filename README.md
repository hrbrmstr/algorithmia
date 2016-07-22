
`algorithmia` : R interface to the [Algorithmia](https://algorithmia.com/) API

The following functions are implemented:

-   `algo_api_key`: Get or set ALGORITHMIA\_API\_KEY value
-   `algo_call`: Call an Algorithmia algorithm
-   `algo_client`: Initialize a new Algorithmia API client call
-   `algo_dir_exists`: Test if a directory exists
-   `algo_dir_list`: List a directory accessible by the Algorithmia service
-   `algo_download_file`: Read a file from a URI accessible by the Algorithmia service & write to disk
-   `algo_file_exists`: Test if a file exists
-   `algo_options`: Set options for an algorithm call
-   `algo_pipe`: Execute an Algorithmia algorithm call
-   `algo_read_file`: Read a file from a URI accessible by the Algorithmia service

### TODO

-   Finish file & dir functions
-   Wrap things with `purrr::safely()`
-   Craft something elegant for `output=void` option
-   Test with more gnarly endpoints
-   Finish documentation

### Installation

``` r
devtools::install_github("hrbrmstr/algorithmia")
```

### Usage

``` r
library(algorithmia)

# current verison
packageVersion("algorithmia")
```

    ## [1] '0.1.0'

### Test Results

``` r
library(algorithmia)
library(testthat)
library(magrittr)
```

``` r
date()
```

    ## [1] "Fri Jul 22 14:31:55 2016"

``` r
algo_client() %>%
  algo_call("demo", "Hello", "0.1.1") %>%
  algo_options(30) %>%
  algo_pipe("there", "text")
```

    ## [1] "Hello there"

``` r
# Have to provide some assistance to `httr` if the input is not a named list
# and the content type is set to "json"

algo_client() %>%
  algo_call("demo", "Hello", "0.1.1") %>%
  algo_options(30) %>%
  algo_pipe('"there"', "json")
```

    ## [1] "Hello there"

``` r
algo_client() %>%
  algo_dir_exists("s3://public-r-data/")
```

    ## [1] TRUE

``` r
algo_client() %>%
  algo_dir_list("s3://public-r-data/")
```

    ## Files:
    ## 
    ## ghcran.Rdata  2888226  2016-07-21T00:09:58.000Z
    ##  ghcran.json  1809154  2016-07-21T00:10:00.000Z

``` r
algo_client() %>%
  algo_file_exists("s3://public-r-data/ghcran.json")
```

    ## [1] TRUE

``` r
algo_client() %>%
  algo_read_file("s3://public-r-data/ghcran.json", fmt="parsed") -> cran

str(cran[[1]])
```

    ## List of 20
    ##  $ Package         : chr "abbyyR"
    ##  $ Title           : chr "Access to Abbyy Optical Character Recognition (OCR) API"
    ##  $ Version         : chr "0.5.0"
    ##  $ Author          : chr "Gaurav Sood [aut, cre]"
    ##  $ Maintainer      : chr "Gaurav Sood <gsood07@gmail.com>"
    ##  $ Description     : chr "Get text from images of text using Abbyy Cloud Optical Character\nRecognition (OCR) API. Easily OCR images, barcodes, forms, do"| __truncated__
    ##  $ License         : chr "MIT + file LICENSE"
    ##  $ Depends         : chr "R (>= 3.2.0)"
    ##  $ Suggests        : chr "testthat, rmarkdown, knitr (>= 1.11)"
    ##  $ NeedsCompilation: chr "no"
    ##  $ Packaged        : chr "2016-06-20 13:01:38 UTC; gsood"
    ##  $ Repository      : chr "CRAN"
    ##  $ Date/Publication: chr "2016-06-20 17:32:00"
    ##  $ Authors@R       : chr "person(\"Gaurav\", \"Sood\", email = \"gsood07@gmail.com\", role = c(\"aut\", \"cre\"))"
    ##  $ URL             : chr "http://github.com/soodoku/abbyyR"
    ##  $ BugReports      : chr "http://github.com/soodoku/abbyyR/issues"
    ##  $ LazyData        : chr "true"
    ##  $ VignetteBuilder : chr "knitr"
    ##  $ Imports         : chr "httr, XML, curl, readr, progress"
    ##  $ RoxygenNote     : chr "5.0.1"

``` r
#test_dir("tests/")
```
