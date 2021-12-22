#' Get metadata from an imgix picture
#'
#' Use the json format of the response to recieve metadata about an image
#' See \url{https://docs.imgix.com/apis/rendering/format/fm#json}.
#' @inheritParams imgix
#' @examples
#' imgix_meta(2422497)
#' @export
imgix_meta <- function(img) {
  if (is.numeric(img))
    img = sprintf("https://images.pexels.com/photos/%s/pexels-photo-%s.jpeg", img, img)
  resp <- httr::GET(paste0(img, "?fm=json"))
  httr::stop_for_status(resp)
  structure(
    list(
      response = resp
    ),
    class = "imgix_meta"
  )
}

#' @export
print.imgix_meta <- function(x, ...) {
  content <- httr::content(x$response)
  cat("[ imgix metadata ]\n")
  utils::str(content)
  invisible(x)
}
