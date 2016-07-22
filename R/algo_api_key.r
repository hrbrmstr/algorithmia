#' Get or set ALGORITHMIA_API_KEY value
#'
#' The API wrapper functions in this package all rely on a Algorithmia API
#' key residing in the environment variable \code{ALGORITHMIA_API_KEY}. The
#' easiest way to accomplish this is to set it in the `.Renviron` file in your
#' home directory.
#'
#' @param force Force setting a new Algorithmia API key for the current environment?
#' @return atomic character vector containing the Algorithmia API key
#' @export
algo_api_key <- function(force = FALSE) {

  env <- Sys.getenv('ALGORITHMIA_API_KEY')
  if (!identical(env, "") && !force) return(env)

  if (!interactive()) {
    stop("Please set env var ALGORITHMIA_API_KEY to your BEA API key",
      call. = FALSE)
  }

  message("Couldn't find env var ALGORITHMIA_API_KEY See ?algo_api_key for more details.")
  message("Please enter your Algorithmia API key and press enter:")
  pat <- readline(": ")

  if (identical(pat, "")) {
    stop("Algorithmia API key entry failed", call. = FALSE)
  }

  message("Updating ALGORITHMIA_API_KEY env var to PAT")
  Sys.setenv(ALGORITHMIA_API_KEY = pat)

  pat

}
