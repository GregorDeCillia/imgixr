#' Fetch images from the imgix rest api
#'
#' functions to load images using the imgix rest api
#'
#' @param img an url to an image or a numeric. If a numeric is given,
#'   it is treated as an image id for pexels.com
#' @param fit Resize fit mode. See \url{https://docs.imgix.com/apis/rendering/size/fit}.
#'   the Default value was changed from `clip` to `crop`.
#' @param ... API query parameters
#' @inheritParams htmlwidgets::createWidget
#' @examples
#' # images from gregordecillia.github.io/pipedream
#' imgix(7417579)
#' imgix(268854)
#' imgix('https://images.pexels.com/photos/45848/kumamoto-japan-aso-cloud-45848.jpeg')
#' imgix(4203587)
#' imgix(2837863)
#'
#' imgix(4203587, txt = "hello", txt_size = 262, txt_color = "fff")
#' imgix(4203587, rot = 45)
#' imgix(4203587, blur = 50)
#' imgix(2837863, sepia = 50)
#' imgix(2837863, duotone = "191970,F08080", duotone_alpha = 60)
#'
#' imgix(2339009)
#' imgix(2339009, invert = TRUE)
#'
#' imgix("https://images.unsplash.com/photo-1459478309853-2c33a60058e7")
#' imgix("https://images.unsplash.com/photo-1523712999610-f77fbcfc3843")
#' imgix("https://images.unsplash.com/photo-1485345488606-f2ab4a113932")
#'
#' imgix("https://assets.imgix.net/unsplash/hotairballoon.jpg")
#'
#' imgix('https://static.imgix.net/espresso.jpg')
#' imgix('https://static.imgix.net/treefrog.jpg')
#' imgix('https://assets.imgix.net/examples/couple.jpg')
#' imgix('https://assets.imgix.net/unsplash/umbrella.jpg')
#' imgix('https://static.imgix.net/lorie.png')
#' imgix('https://assets.imgix.net/trim-ex4.jpg')
#' imgix('https://assets.imgix.net/trim-ex3.jpg')
#' imgix('https://assets.imgix.net/trim-ex5.jpg')
#' imgix('https://assets.imgix.net/examples/redleaf.jpg')
#' imgix('https://assets.imgix.net/examples/blueberries.jpg')
#' imgix('https://assets.imgix.net/examples/bluehat.jpg')
#' imgix('https://assets.imgix.net/blog/unsplash-kiss.jpg')
#' imgix('https://assets.imgix.net/examples/pione.jpg')
#' imgix('https://assets.imgix.net/dog.jpg')
#' imgix('https://assets.imgix.net/blog/woman-hat.jpg')
#' imgix('https://assets.imgix.net/flower.jpg')
#' imgix('https://assets.imgix.net/coffee.jpg')
#' imgix('https://ix-www.imgix.net/solutions/kingfisher.jpg')
#' imgix('https://ix-www.imgix.net/solutions/daisy.png')
#'
#' imgix(2526037)
#' @import htmlwidgets
#' @export
imgix <- function(
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
  structure(x, class = "imgix")
}

get_dimension <- function(value, key, default) {
  if (!is.null(value))
    return(value)
  if (!is.null(knitr::opts_chunk$get(key)))
    return(knitr::opts_chunk$get(key))
  default
}

imgix_get_url <- function(x) {
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

imgix_to_html <- function(x) {
  htmltools::tags$img(
    src = paste0(imgix_get_url(x)))
}

#' Show an image inside rmarkdown
#' @param x an object of class `imgxr`
#' @param ... further parameters passed down to other methods
#' @export
knit_print.imgix <- function(x, ...) {
  pt <- knitr::pandoc_to()
  if (!is.null(pt) && pt == "latex")
    return(knit_print_imgxr_latex(x, ...))
  html <- imgix_to_html(x)
  knitr::asis_output(as.character(html))
}

#' Download an image from the REST api
#' @param x an object of class `imgix`
#' @param file destination path for `download.file`
#' @export
imgix_download <- function(x, file) {
  utils::download.file(
    imgix_get_url(x),
    file
  )
}

knit_print_imgxr_latex <- function(x, ...) {
  fig_path <- knitr::opts_chunk$get("fig.path")
  fig_name <- paste0(
    fig_path,
    "imgix-",
    substr(digest::digest(x), 1, 10),
    ".jpeg"
  )
  imgix_download(x, fig_name)
  knitr::include_graphics(fig_name)
}

#' @export
print.imgix <- function(x, as_widget = TRUE, ...) {
  if (as_widget) {
    print(imgix_as_widget(x))
  } else {
    print(imgix_to_html(x), browse = interactive(), ...)
  }
  invisible(x)
}

summary.imgix <- function(x, ...) {
  cat('An object of class imgix\n\n')
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
as.tags.imgix <- function(x, ...) {
  imgix_to_html(x)
}
