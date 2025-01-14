% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/palette.R
\name{imgix_palette}
\alias{imgix_palette}
\title{Get infomation about the color palette}
\usage{
imgix_palette(img)
}
\arguments{
\item{img}{an url to an image or a numeric. If a numeric is given,
it is treated as an image id for pexels.com}
}
\description{
Recieves information of the most important colors of an image
using the palette parameter of the API.
See \url{https://docs.imgix.com/apis/rendering/color-palette/palette#json}.
}
\examples{
imgix_palette(2339009)
}
