#' @importFrom magrittr %>%
#' @export
magrittr::`%>%`

#' Initialize a new Algorithmia API client call
#'
#' @param api_key Algorithmia API key (picked up automagically if you
#'        have the environment variable set)
#' @export
#' @references \url{http://docs.algorithmia.com/}
#' @examples
#' library(magrittr)
#' algo_client() %>%
#'   algo_call("demo", "Hello", "0.1.1") %>%
#'   algo_pipe("there", "text")
algo_client <- function(api_key=algo_api_key()) {

  algo_obj <- list(api_key=api_key)
  class(algo_obj) <- c("algo", class(algo_obj))

  invisible(algo_obj)

}

#' Call an Algorithmia algorithm
#'
#' For each algorithm on the marketplace, you’ll find an owner (the user who created the
#' algorithm), an algorithm name, and a version number.
#'
#' Specifying a version is recommended, but optional. If not specified, the latest
#' publicly published version will be used.
#'
#' @param algo_obj an \code{algorithmia} object
#' @param owner Algorithmia handle of the user who created the algorithm
#' @param name algorithm name
#' @param version algorithm version (optional). When explicitly specifying a version, the
#'   following following formats are accepted: Fully specified version (e.g.
#'   \code{1.1.1}); Specified to the minor level (e.g. \code{1.2.*}); Specified to a major
#'   version (e.g. \code{1.*})
#' @export
#' @references \url{http://docs.algorithmia.com/}
#' @examples
#' library(magrittr)
#' algo_client() %>%
#'   algo_call("demo", "Hello", "0.1.1") %>%
#'   algo_pipe("there", "text")
algo_call <- function(algo_obj, owner, name, version=NULL) {

  algo_obj$owner <- owner
  algo_obj$name <- name
  algo_obj$version <- version

  invisible(algo_obj)

}

#' Set options for an algorithm call
#'
#' @param algo_obj an \code{algorithmia} object
#' @param timeout Specifies a timeout for the call in seconds. default=300 (5min),
#'   max=3000 (50min)
#' @param stdout Indicates algorithm stdout should be returned in the response metadata
#'   (ignored unless you are the algorithm owner)
#' @param output if not \code{NULL} then one of "\code{raw}" to return the result of the
#'   algorithm call without the JSON-RPC wrapper or "\code{void}" which returns
#'   immediately and does not wait for the algorithm to run
#' @export
#' @references \url{http://docs.algorithmia.com/}
#' @examples
#' library(magrittr)
#' algo_client() %>%
#'   algo_call("demo", "Hello", "0.1.1") %>%
#'   algo_options(30) %>%
#'   algo_pipe("there", "text")
algo_options <- function(algo_obj, timeout=300, stdout=FALSE, output=NULL) {

  algo_obj$options <- list(timeout=timeout, stdout=stdout, output=output)
  invisible(algo_obj)

}

#' Execute an Algorithmia algorithm call
#'
#' @param algo_obj an \code{algorithmia} object
#' @param input data to feed to the API call
#' @param content_type specify encoding
#' @export
#' @references \url{http://docs.algorithmia.com/}
#' @examples
#' library(magrittr)
#' algo_client() %>%
#'   algo_call("demo", "Hello", "0.1.1") %>%
#'   algo_options(30) %>%
#'   algo_pipe("there", "text")
algo_pipe <- function(algo_obj, input, content_type=c("text", "json")) {

  content_type <- match.arg(content_type, c("json", "text"))

  ctype <- switch(content_type,
                         `json`="application/json",
                         `text`="application/text",
                         `octet-stream`="application/octet-stream")

  encode <- switch(content_type,
                   `json`="json",
                   `text`="multipart",
                   `octet-stream`="multipart")

  URL <- sprintf("https://api.algorithmia.com/v1/algo/%s/%s", algo_obj$owner, algo_obj$name)
  if (!is.null(algo_obj$version)) {
    URL <- sprintf("%s/%s", URL, algo_obj$version)
  }

  params <- NULL
  if (!is.null(algo_obj$options)) params <- algo_obj$options

  if (encode=="json") input <- jsonlite::toJSON(input, auto_unbox=TRUE)

  ret <- httr::POST(URL,
                    httr::add_headers(`Authorization`=sprintf("Simple %s", algo_obj$api_key)),
                    httr::content_type(ctype),
                    encode=encode,
                    body=input,
                    query=params)

  res <- httr::content(ret)

  if (length(res[["error"]][["message"]] > 0)) {
    message(res$error$message)
  } else {
    class(res) <- c("algo_result", class(res))
    res
  }

}

#' List a directory accessible by the Algorithmia service
#'
#' @param algo_obj an \code{algorithmia} object
#' @param dir_spec URI (See \url{http://docs.algorithmia.com/#data-uri})
#' @export
#' @references \url{http://docs.algorithmia.com/}
algo_dir_list <- function(algo_obj, dir_spec) {

  parts <- stri_split_regex(dir_spec, "://")[[1]]

  connector <- parts[1]
  path <- parts[2]

  URL <- sprintf("https://api.algorithmia.com/v1/connector/%s/%s", connector, URLencode(path))

  params <- NULL

  ret <- httr::GET(URL,
                   httr::add_headers(`Authorization`=sprintf("Simple %s", algo_obj$api_key)))

  res <- httr::content(ret)

  class(res) <- c("algo_dirlist", class(res))
  res

}

#' Test if a directory exists
#'
#' @param algo_obj an \code{algorithmia} object
#' @param dir_spec URI (See \url{http://docs.algorithmia.com/#data-uri})
#' @export
#' @references \url{http://docs.algorithmia.com/}
algo_dir_exists <- function(algo_obj, dir_spec) {

  parts <- stri_split_regex(dir_spec, "://")[[1]]

  connector <- parts[1]
  path <- parts[2]

  URL <- sprintf("https://api.algorithmia.com/v1/connector/%s/%s", connector, URLencode(path))

  ret <- httr::HEAD(URL,
                    httr::add_headers(`Authorization`=sprintf("Simple %s", algo_obj$api_key)))

  httr::status_code(ret) == 200 && headers(ret)$`X-Data-Type` == "directory"

}

#' Test if a file exists
#'
#' @param algo_obj an \code{algorithmia} object
#' @param fil_spec URI (See \url{http://docs.algorithmia.com/#data-uri})
#' @export
#' @references \url{http://docs.algorithmia.com/}
algo_file_exists <- function(algo_obj, fil_spec) {

  parts <- stri_split_regex(fil_spec, "://")[[1]]

  connector <- parts[1]
  path <- parts[2]

  URL <- sprintf("https://api.algorithmia.com/v1/connector/%s/%s", connector, URLencode(path))

  ret <- httr::HEAD(URL,
                    httr::add_headers(`Authorization`=sprintf("Simple %s", algo_obj$api_key)))

  httr::status_code(ret) == 200 && headers(ret)$`X-Data-Type` == "file"

}

#' Read a file from a URI accessible by the Algorithmia service
#'
#' @param algo_obj an \code{algorithmia} object
#' @param fil_spec URI (See \url{http://docs.algorithmia.com/#data-uri})
#' @param fmt result object format; "\code{text}" to retrieve the plain text of the
#'   response; "\code{parsed}" to parse the response and return an R object; "\code{raw}"
#'   to retrieve the binary response (useful for images)
#' @param encoding content encoding
#' @export
#' @references \url{http://docs.algorithmia.com/}
algo_read_file <- function(algo_obj, fil_spec, fmt=c("text", "parsed", "raw"), encoding=NULL) {

  fmt <- match.arg(fmt, c("text", "parsed", "raw"))

  parts <- stri_split_regex(fil_spec, "://")[[1]]

  connector <- parts[1]
  path <- parts[2]

  URL <- sprintf("https://api.algorithmia.com/v1/connector/%s/%s", connector, URLencode(path))

  ret <- httr::GET(URL,
                   httr::add_headers(`Authorization`=sprintf("Simple %s", algo_obj$api_key)))

  if (!is.null(encoding)) {
    httr::content(ret, as=fmt, encoding=encoding)
  } else {
    httr::content(ret, as=fmt)
  }

}

#' Read a file from a URI accessible by the Algorithmia service & write to disk
#'
#' Useful if the file is larger than memory.
#'
#' @param algo_obj an \code{algorithmia} object
#' @param fil_spec URI
#' @param local_file local file name to write to
#' @param overwrite overwrite file if it exists?
#' @export
#' @references \url{http://docs.algorithmia.com/}
algo_download_file <- function(algo_obj, fil_spec, local_file, overwrite=TRUE) {

  parts <- stri_split_regex(fil_spec, "://")[[1]]

  connector <- parts[1]
  path <- parts[2]

  URL <- sprintf("https://api.algorithmia.com/v1/connector/%s/%s", connector, URLencode(path))

  ret <- httr::GET(URL,
                   httr::add_headers(`Authorization`=sprintf("Simple %s", algo_obj$api_key)),
                   httr::write_disk(local_file, overwrite=overwrite))

  invisible(httr::status_code(ret) == 200 &  headers(ret)$`X-Data-Type` == "file")

}


#' @export
print.algo_result <- function(x, ...) {
  print(x$result)
}

#' @export
print.algo_dirlist <- function(x, ...) {

  dirs <- NULL
  if (length(x$folders) > 0) {
    pad <-max(purrr::map_int(unlist(x$folders), ~nchar(.x)))
    out <- purrr::map_chr(unlist(x$folders), function(y) {
      sprintf("%s/", stringi::stri_pad(y, pad))
    })
    dirs <- sprintf("Folders:\n\n%s", paste0(out, collapse="\n"))
  }

  fils <- NULL
  if (length(x$files) > 0) {
    pad <-max(purrr::map_int(x$files, ~nchar(.x$filename)))
    out <- purrr::map_chr(x$files, function(y) {
      sprintf("%s  %s  %s", stringi::stri_pad(y$filename, pad), y$size, y$last_modified)
    })
    fils <- sprintf("Files:\n\n%s", paste0(out, collapse="\n"))
  }

  cat(paste0(c(dirs, fils), collapse="\n\n"))

}