#' Fetch images from the imgix rest api
#'
#' functions to load images using the imgixr rest api
#'
#' @param img an url to an image or a numeric. If a numeric is given,
#'   it is treated as an image id for pexels.com
#' @param fit Resize fit mode. See \url{https://docs.imgix.com/apis/rendering/size/fit}.
#'   the Default value was changed from `clip` to `crop`.
#' @param ... API query parameters
#' @inheritParams htmlwidgets::createWidget
#' @examples
#' # images from gregordecillia.github.io/pipedream
#' imgixr(7417579)
#' imgixr(268854)
#' imgixr('https://images.pexels.com/photos/45848/kumamoto-japan-aso-cloud-45848.jpeg')
#' imgixr(4203587)
#' imgixr(2837863)
#'
#' imgixr(4203587, txt = "hello", txt_size = 262, txt_color = "fff")
#' imgixr(4203587, rot = 45)
#' imgixr(4203587, blur = 50)
#' imgixr(2837863, sepia = 50)
#' imgixr(2837863, duotone = "191970,F08080", duotone_alpha = 60)
#'
#' imgixr(2339009)
#' imgixr(2339009, invert = TRUE)
#'
#' imgixr("https://images.unsplash.com/photo-1459478309853-2c33a60058e7")
#' imgixr("https://images.unsplash.com/photo-1523712999610-f77fbcfc3843")
#' imgixr("https://images.unsplash.com/photo-1485345488606-f2ab4a113932")
#'
#' imgixr("https://assets.imgix.net/unsplash/hotairballoon.jpg")
#' @import htmlwidgets
#' @export
imgixr <- function(
  img,
  fit = c("crop", "clamp", "clip", "facearea", "fill", "fillmax", "max", "scale"),
  ...,
  width = NULL, height = NULL, elementId = NULL)
{
  if (is.numeric(img))
    img = sprintf("https://images.pexels.com/photos/%s/pexels-photo-%s.jpeg", img, img)

  query_params <- list(
    fit = match.arg(fit),
    ...
  )

  names(query_params) <- gsub('_', '-', names(query_params))
  for (i in seq_along(query_params)) {
    query_params[[i]] <- gsub(" ", "%20", query_params[[i]])
  }
  x = list(url = img, query = query_params)

  x$height = height
  x$width = width
  x$elementId <- elementId
  structure(x, class = "imgixr")
}

get_dimension <- function(value, key, default) {
  if (!is.null(value))
    return(value)
  if (!is.null(knitr::opts_chunk$get(key)))
    return(knitr::opts_chunk$get(key))
  default
}

imgixr_get_url <- function(x) {
  height <- x$height
  width <- x$width
  height <- get_dimension(height, "out.height", 400)
  width <- get_dimension(width, "out.width", 800)
  query <- x$query
  query$h <- height
  query$w <- width
  paste0(
    x$url, "?",
    paste0(names(query), "=", query, collapse = "&")
  )
}

imgixr_to_html <- function(x) {
  htmltools::tags$img(
    src = paste0(imgixr_get_url(x)))
}

#' Show an image inside rmarkdown
#' @param x an object of class `imgxr`
#' @param ... further parameters passed down to other methods
#' @export
knit_print.imgixr <- function(x, ...) {
  pt <- knitr::pandoc_to()
  if (!is.null(pt) && pt == "latex")
    return(knit_print_imgxr_latex(x, ...))
  html <- imgixr_to_html(x)
  knitr::asis_output(as.character(html))
}

knit_print_imgxr_latex <- function(x, ...) {
  fig_path <- knitr::opts_chunk$get("fig.path")
  fig_name <- paste0(
    fig_path,
    "imgixr-",
    substr(digest::digest(x), 1, 10),
    ".jpeg"
  )
  utils::download.file(
    imgixr_get_url(x),
    fig_name
  )
  knitr::include_graphics(fig_name)
}

#' @export
print.imgixr <- function(x, as_widget = TRUE, ...) {
  if (as_widget) {
    print(imgixr_as_widget(x))
  } else {
    print(imgixr_to_html(x), browse = interactive(), ...)
  }
  invisible(x)
}

summary.imgixr <- function(x, ...) {
  cat('An object of class imgixr\n\n')
  cat('- source:', x$url, "\n")
  cat("- query parameters: \n")
  n <- max(nchar(names(x$query)))
  for (i in seq_along(x$query)) {
    cat("  -", sprintf(paste0("%-", n, "s"), names(x$query)[i]), ":", x$query[[i]], "\n")
  }
}

#' Convert imgxr to a html tag
#' @inheritParams htmltools::as.tags
#' @export
as.tags.imgixr <- function(x, ...) {
  imgixr_to_html(x)
}
