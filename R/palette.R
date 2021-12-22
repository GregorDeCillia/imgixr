#' Get infomation about the color palette
#'
#' Recieves information of the most important colors of an image
#' using the palette parameter of the API.
#' See \url{https://docs.imgix.com/apis/rendering/color-palette/palette#json}.
#' @inheritParams imgix
#' @examples
#' imgix_palette(2339009)
#' @export
imgix_palette <- function(img) {
  if (is.numeric(img))
    img = sprintf("https://images.pexels.com/photos/%s/pexels-photo-%s.jpeg", img, img)
  resp <- httr::GET(paste0(img, "?palette=json"))
  httr::stop_for_status(resp)
  content <- httr::content(resp)
  structure(
    list(
      average_luminance = content$average_luminance,
      colors = sapply(content$colors, function(x) x$hex),
      dominant_colors = sapply(content$dominant_colors, function(x) x$hex)
    ),
    class = "imgix_palette"
  )
}
#' @export
print.imgix_palette <- function(x, ...) {
  y <- x
  names(y$dominant_colors) <- NULL
  cat("[ imgixr color palette ]\n")
  utils::str(unclass(y))
  invisible(x)
}

