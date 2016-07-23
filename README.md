
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
-   Test with more gnarly endpoints (somewhat done)
-   Finish documentation (nearly done)

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
library(dplyr)
```

``` r
date()
```

    ## [1] "Sat Jul 23 18:29:02 2016"

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

    ## [1] "Hello \"there\""

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
txt <- "A purely peer-to-peer version of electronic cash would allow online payments to be sent directly from one party to another without going through a financial institution. Digital signatures provide part of the solution, but the main benefits are lost if a trusted third party is still required to prevent double-spending. We propose a solution to the double-spending problem using a peer-to-peer network. The network timestamps transactions by hashing them into an ongoing chain of hash-based proof-of-work, forming a record that cannot be changed without redoing the proof-of-work. The longest chain not only serves as proof of the sequence of events witnessed, but proof that it came from the largest pool of CPU power. As long as a majority of CPU power is controlled by nodes that are not cooperating to attack the network, they'll generate the longest chain and outpace attackers. The network itself requires minimal structure. Messages are broadcast on a best effort basis, and nodes can leave and rejoin the network at will, accepting the longest proof-of-work chain as proof of what happened while they were gone."
algo_client() %>%
  algo_call("nlp", "Summarizer", "0.1.3") %>%
  algo_pipe(txt, "text")
```

    ## [1] "A purely peer-to-peer version of electronic cash would allow online payments to be sent directly from one party to another without going through a financial institution. We propose a solution to the double-spending problem using a peer-to-peer network. The network timestamps transactions by hashing them into an ongoing chain of hash-based proof-of-work, forming a record that cannot be changed without redoing the proof-of-work."

``` r
URL <- 'rud.is/b/2016/07/12/slaying-cidr-orcs-with-triebeard-a-k-a-fast-trie-based-ipv4-in-cidr-lookups-in-r/'
algo_client() %>%
  algo_call("util", "Html2Text", "0.1.4") %>%
  algo_pipe(URL, "text")
```

    ## [1] "Email Address  The insanely productive elf-lord, @quominus put together a small package () that exposes an API for radix/prefix tries at both the R and Rcpp levels. I know he had some personal needs for this and we both kinda need these to augment some functions in our package. Despite having both a vignette and function-level examples, I thought it might be good to show a real-world use of the package (at least in the cyber real world): fast determination of which autonomous system an IPv4 address is in (if it’s in one at all). I’m not going to delve to deep into routing (you can find a good primer here and one that puts routing in the context of radix tries here) but there exists, essentially, abbreviated tables of which IP addresses belong to a particular network. These tables are in routers on your local networks and across the internet. Groups of these networks (on the internet) are composed into those autonomous systems I mentioned earlier and these tables are used to get the packets that make up the cat videos you watch routed to you as efficiently as possible. When dealing with cybersecurity data science, it’s often useful to know which autonomous system an IP address belongs in. The world is indeed full of peril and in it there are many dark places. It’s a dangerous business, going out on the internet and we sometimes find it possible to identify unusually malicious autonomous systems by looking up suspicious IP addresses en masse. These mappings look something like this: Each CIDR has a start and end IP address which can ultimately be converted to integers. Now, one could just sequentially compare start and end ranges to see which CIDR an IP address belongs in, but there are (as of the day of this post) CIDRs to compare against, which—in the worst case—would mean having to traverse through the entire list to find the match (or discover there is no match). There are some trivial ways to slightly optimize this, but the search times could still be fairly long, especially when you’re trying to match a billion IPv4 addresses to ASNs. By storing the CIDR mask (the number of bits of the leading IP address specified after the ) in binary form (strings of 1’s and 0’s) as keys for the trie, we get much faster lookups (only a few comparisons at worst-case vs 647,563). I made an initial, naïve, mostly straight R, implementation as a precursor to a more low-level implementation in Rcpp in our package and to illustrate this use of the package. One thing we’ll need is a function to convert an IPv4 address (in long integer form) into a binary character string. We could do this with base R, but it’ll be super-slow and it doesn’t take much effort to create it with an Rcpp inline function: We take a vector from R and use some C++ standard library functions to convert them to bits. I vectorized this in C++ for speed (which is just a fancy way to say I used a loop). In this case, our short cut will not make for a long delay. Now, we’ll need a CIDR file. There are historical ones avaialble, and I use one that I generated the day of this post (and, referenced in the code block below). You can use to make new ones daily (relegating mindless, automated, menial data retrieval tasks to the python goblins, like one should). You can save off that to an R data file to pull in later (but it’s pretty fast to regenerate). Now, we create the trie, using the prefix we calculated and a value we’ll piece together for this example: Yep, that’s it. If you ran this yourself, it should have taken less than 2s on most modern systems to create the nigh 700,000 element trie. Now, we’ll generate a million random IP addresses and look them up: On most modern systems, that should have taken less than 3s. The values are not busted lookups. Many IP networks are assigned but not accessible (see this for more info). You can validate this with on your own, too). The trie structure for these CIDRs takes up approximately 9MB of RAM, a small price to pay for speedy lookups (and, memory really is not what the heart desires, anyway). Hopefully the package will help you speed up your own lookups and stay-tuned for a new version of with some new and enhanced functions. Pingback: Slaying CIDR Orcs with Triebeard (a.k.a. fast trie-based ‘IPv4-in-CIDR’ lookups in R) – sec.uno Pingback: Slaying CIDR Orcs with Triebeard (a.k.a. fast trie-based ‘IPv4-in-CIDR’ lookups in R) – Mubashir Qasim"

``` r
bits <- list("This is a test of what this is. Hopefully this is going to work well as a test.", 2, 5, FALSE, TRUE)
out <- algo_client() %>%
  algo_call("WebPredict", "GetNGramFrequencies", "0.1.1") %>%
  algo_pipe(bits, "json")

bind_rows(out$result)
```

    ## # A tibble: 5 x 2
    ##      ngram frequency
    ##      <chr>     <int>
    ## 1  this is         2
    ## 2   a test         2
    ## 3  to work         1
    ## 4 is going         1
    ## 5  well as         1

``` r
algo_client() %>% 
  algo_call("TimeSeries", "TimeSeriesSummary", "0.1.2") %>% 
  algo_pipe(list(uniformData=as.double(USAccDeaths)), "json")
```

    ## $max
    ## [1] 11317
    ## 
    ## $var
    ## [1] 917290.1
    ## 
    ## $geometricMean
    ## [1] 8737.949
    ## 
    ## $populationVariance
    ## [1] 904549.9
    ## 
    ## $slope
    ## [1] -8.428404
    ## 
    ## $kurtosis
    ## [1] -0.1335658
    ## 
    ## $min
    ## [1] 6892
    ## 
    ## $correlation
    ## [1] -0.1841743
    ## 
    ## $intercept
    ## [1] 9088
    ## 
    ## $mean
    ## [1] 8788.792
    ## 
    ## $rmse
    ## [1] 934.8088
    ## 
    ## $skewness
    ## [1] 0.3504949
    ## 
    ## $standardDeviation
    ## [1] 957.7526

``` r
# matches the `base::svd()` example
hilbert <- function(n) { i <- 1:n; 1 / outer(i - 1, i, "+") }
X <- hilbert(9)[, 1:6]
algo_client() %>% 
  algo_call("joannetang", "SVD", "0.1.0") %>% 
  algo_pipe(X, "json")
```

    ## $U
    ## $U[[1]]
    ## $U[[1]][[1]]
    ## [1] 0.724492
    ## 
    ## $U[[1]][[2]]
    ## [1] -0.6266306
    ## 
    ## $U[[1]][[3]]
    ## [1] 0.2732317
    ## 
    ## $U[[1]][[4]]
    ## [1] -0.08577864
    ## 
    ## $U[[1]][[5]]
    ## [1] 0.001069589
    ## 
    ## $U[[1]][[6]]
    ## [1] 0.005814147
    ## 
    ## 
    ## $U[[2]]
    ## $U[[2]][[1]]
    ## [1] 0.4281539
    ## 
    ## $U[[2]][[2]]
    ## [1] 0.1299407
    ## 
    ## $U[[2]][[3]]
    ## [1] -0.6422804
    ## 
    ## $U[[2]][[4]]
    ## [1] 0.5521006
    ## 
    ## $U[[2]][[5]]
    ## [1] 0.00978497
    ## 
    ## $U[[2]][[6]]
    ## [1] -0.07054988
    ## 
    ## 
    ## $U[[3]]
    ## $U[[3]][[1]]
    ## [1] 0.3121935
    ## 
    ## $U[[3]][[2]]
    ## [1] 0.2805368
    ## 
    ## $U[[3]][[3]]
    ## [1] -0.3365161
    ## 
    ## $U[[3]][[4]]
    ## [1] -0.3097081
    ## 
    ## $U[[3]][[5]]
    ## [1] -0.157559
    ## 
    ## $U[[3]][[6]]
    ## [1] 0.2632134
    ## 
    ## 
    ## $U[[4]]
    ## $U[[4]][[1]]
    ## [1] 0.2479045
    ## 
    ## $U[[4]][[2]]
    ## [1] 0.3142639
    ## 
    ## $U[[4]][[3]]
    ## [1] -0.0695403
    ## 
    ## $U[[4]][[4]]
    ## [1] -0.4673775
    ## 
    ## $U[[4]][[5]]
    ## [1] 0.2397472
    ## 
    ## $U[[4]][[6]]
    ## [1] -0.5047376
    ## 
    ## 
    ## $U[[5]]
    ## $U[[5]][[1]]
    ## [1] 0.2063934
    ## 
    ## $U[[5]][[2]]
    ## [1] 0.3141224
    ## 
    ## $U[[5]][[3]]
    ## [1] 0.1068881
    ## 
    ## $U[[5]][[4]]
    ## [1] -0.2930391
    ## 
    ## $U[[5]][[5]]
    ## [1] 0.4126682
    ## 
    ## $U[[5]][[6]]
    ## [1] 0.3922153
    ## 
    ## 
    ## $U[[6]]
    ## $U[[6]][[1]]
    ## [1] 0.1771639
    ## 
    ## $U[[6]][[2]]
    ## [1] 0.3025948
    ## 
    ## $U[[6]][[3]]
    ## [1] 0.2209075
    ## 
    ## $U[[6]][[4]]
    ## [1] -0.06413692
    ## 
    ## $U[[6]][[5]]
    ## [1] -0.4855462
    ## 
    ## $U[[6]][[6]]
    ## [1] 0.2419519
    ## 
    ## 
    ## $U[[7]]
    ## $U[[7]][[1]]
    ## [1] 0.1553568
    ## 
    ## $U[[7]][[2]]
    ## [1] 0.2875511
    ## 
    ## $U[[7]][[3]]
    ## [1] 0.2937597
    ## 
    ## $U[[7]][[4]]
    ## [1] 0.1054972
    ## 
    ## $U[[7]][[5]]
    ## [1] -0.5852104
    ## 
    ## $U[[7]][[6]]
    ## [1] -0.2443188
    ## 
    ## 
    ## $U[[8]]
    ## $U[[8]][[1]]
    ## [1] 0.1384165
    ## 
    ## $U[[8]][[2]]
    ## [1] 0.27205
    ## 
    ## $U[[8]][[3]]
    ## [1] 0.3384293
    ## 
    ## $U[[8]][[4]]
    ## [1] 0.280313
    ## 
    ## $U[[8]][[5]]
    ## [1] 0.2909076
    ## 
    ## $U[[8]][[6]]
    ## [1] -0.4860329
    ## 
    ## 
    ## $U[[9]]
    ## $U[[9]][[1]]
    ## [1] 0.1248757
    ## 
    ## $U[[9]][[2]]
    ## [1] 0.2570089
    ## 
    ## $U[[9]][[3]]
    ## [1] 0.3656324
    ## 
    ## $U[[9]][[4]]
    ## [1] 0.4401996
    ## 
    ## $U[[9]][[5]]
    ## [1] 0.2906044
    ## 
    ## $U[[9]][[6]]
    ## [1] 0.4033043
    ## 
    ## 
    ## 
    ## $Sigma
    ## $Sigma[[1]]
    ## $Sigma[[1]][[1]]
    ## [1] 1.668442
    ## 
    ## $Sigma[[1]][[2]]
    ## [1] 0
    ## 
    ## $Sigma[[1]][[3]]
    ## [1] 0
    ## 
    ## $Sigma[[1]][[4]]
    ## [1] 0
    ## 
    ## $Sigma[[1]][[5]]
    ## [1] 0
    ## 
    ## $Sigma[[1]][[6]]
    ## [1] 0
    ## 
    ## 
    ## $Sigma[[2]]
    ## $Sigma[[2]][[1]]
    ## [1] 0
    ## 
    ## $Sigma[[2]][[2]]
    ## [1] 0.2773673
    ## 
    ## $Sigma[[2]][[3]]
    ## [1] 0
    ## 
    ## $Sigma[[2]][[4]]
    ## [1] 0
    ## 
    ## $Sigma[[2]][[5]]
    ## [1] 0
    ## 
    ## $Sigma[[2]][[6]]
    ## [1] 0
    ## 
    ## 
    ## $Sigma[[3]]
    ## $Sigma[[3]][[1]]
    ## [1] 0
    ## 
    ## $Sigma[[3]][[2]]
    ## [1] 0
    ## 
    ## $Sigma[[3]][[3]]
    ## [1] 0.02217799
    ## 
    ## $Sigma[[3]][[4]]
    ## [1] 0
    ## 
    ## $Sigma[[3]][[5]]
    ## [1] 0
    ## 
    ## $Sigma[[3]][[6]]
    ## [1] 0
    ## 
    ## 
    ## $Sigma[[4]]
    ## $Sigma[[4]][[1]]
    ## [1] 0
    ## 
    ## $Sigma[[4]][[2]]
    ## [1] 0
    ## 
    ## $Sigma[[4]][[3]]
    ## [1] 0
    ## 
    ## $Sigma[[4]][[4]]
    ## [1] 0.00110405
    ## 
    ## $Sigma[[4]][[5]]
    ## [1] 0
    ## 
    ## $Sigma[[4]][[6]]
    ## [1] 0
    ## 
    ## 
    ## $Sigma[[5]]
    ## $Sigma[[5]][[1]]
    ## [1] 0
    ## 
    ## $Sigma[[5]][[2]]
    ## [1] 0
    ## 
    ## $Sigma[[5]][[3]]
    ## [1] 0
    ## 
    ## $Sigma[[5]][[4]]
    ## [1] 0
    ## 
    ## $Sigma[[5]][[5]]
    ## [1] 4.199754e-05
    ## 
    ## $Sigma[[5]][[6]]
    ## [1] 0
    ## 
    ## 
    ## $Sigma[[6]]
    ## $Sigma[[6]][[1]]
    ## [1] 0
    ## 
    ## $Sigma[[6]][[2]]
    ## [1] 0
    ## 
    ## $Sigma[[6]][[3]]
    ## [1] 0
    ## 
    ## $Sigma[[6]][[4]]
    ## [1] 0
    ## 
    ## $Sigma[[6]][[5]]
    ## [1] 0
    ## 
    ## $Sigma[[6]][[6]]
    ## [1] 2.155366e-05
    ## 
    ## 
    ## 
    ## $V
    ## $V[[1]]
    ## $V[[1]][[1]]
    ## [1] 0.7364879
    ## 
    ## $V[[1]][[2]]
    ## [1] -0.6225439
    ## 
    ## $V[[1]][[3]]
    ## [1] 0.2548565
    ## 
    ## $V[[1]][[4]]
    ## [1] -0.06975955
    ## 
    ## $V[[1]][[5]]
    ## [1] 0.01338283
    ## 
    ## $V[[1]][[6]]
    ## [1] 0.005238707
    ## 
    ## 
    ## $V[[2]]
    ## $V[[2]][[1]]
    ## [1] 0.4432798
    ## 
    ## $V[[2]][[2]]
    ## [1] 0.1819084
    ## 
    ## $V[[2]][[3]]
    ## [1] -0.686476
    ## 
    ## $V[[2]][[4]]
    ## [1] 0.505762
    ## 
    ## $V[[2]][[5]]
    ## [1] -0.1901786
    ## 
    ## $V[[2]][[6]]
    ## [1] -0.08485235
    ## 
    ## 
    ## $V[[3]]
    ## $V[[3]][[1]]
    ## [1] 0.327472
    ## 
    ## $V[[3]][[2]]
    ## [1] 0.3509816
    ## 
    ## $V[[3]][[3]]
    ## [1] -0.2612585
    ## 
    ## $V[[3]][[4]]
    ## [1] -0.493219
    ## 
    ## $V[[3]][[5]]
    ## [1] 0.5624067
    ## 
    ## $V[[3]][[6]]
    ## [1] 0.3764992
    ## 
    ## 
    ## $V[[4]]
    ## $V[[4]][[1]]
    ## [1] 0.2626546
    ## 
    ## $V[[4]][[2]]
    ## [1] 0.3921917
    ## 
    ## $V[[4]][[3]]
    ## [1] 0.1044963
    ## 
    ## $V[[4]][[4]]
    ## [1] -0.4509076
    ## 
    ## $V[[4]][[5]]
    ## [1] -0.2780641
    ## 
    ## $V[[4]][[6]]
    ## [1] -0.6968797
    ## 
    ## 
    ## $V[[5]]
    ## $V[[5]][[1]]
    ## [1] 0.2204295
    ## 
    ## $V[[5]][[2]]
    ## [1] 0.3945285
    ## 
    ## $V[[5]][[3]]
    ## [1] 0.350554
    ## 
    ## $V[[5]][[4]]
    ## [1] 0.01879438
    ## 
    ## $V[[5]][[5]]
    ## [1] -0.5820029
    ## 
    ## $V[[5]][[6]]
    ## [1] 0.5777451
    ## 
    ## 
    ## $V[[6]]
    ## $V[[6]][[1]]
    ## [1] 0.1904576
    ## 
    ## $V[[6]][[2]]
    ## [1] 0.3830055
    ## 
    ## $V[[6]][[3]]
    ## [1] 0.5116007
    ## 
    ## $V[[6]][[4]]
    ## [1] 0.5407425
    ## 
    ## $V[[6]][[5]]
    ## [1] 0.4809415
    ## 
    ## $V[[6]][[6]]
    ## [1] -0.1777365
    ## 
    ## 
    ## 
    ## $singularValues
    ## $singularValues[[1]]
    ## $singularValues[[1]][[1]]
    ## [1] 1.668442
    ## 
    ## $singularValues[[1]][[2]]
    ## [1] 0.2773673
    ## 
    ## $singularValues[[1]][[3]]
    ## [1] 0.02217799
    ## 
    ## $singularValues[[1]][[4]]
    ## [1] 0.00110405
    ## 
    ## $singularValues[[1]][[5]]
    ## [1] 4.199754e-05
    ## 
    ## $singularValues[[1]][[6]]
    ## [1] 2.155366e-05
