#' @name imgix-shiny
#' @param x an object of class `imgix`
#' @export
imgix_as_widget <- function(x) {
  htmlwidgets::createWidget(
    name = 'imgix_widget',
    x,
    width = x$width,
    height = x$height,
    package = 'imgix',
    elementId = x$elementId
  )
}

#' Shiny bindings for imgix
#'
#' Output and render functions for using imgix within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a imgix
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name imgix-shiny
#'
#' @export
imgixOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'imgix_widget', width, height, package = 'imgix')
}

#' @rdname imgix-shiny
#' @export
renderImgix <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, imgixOutput, env, quoted = TRUE)
}
