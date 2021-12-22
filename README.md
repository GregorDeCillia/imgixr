
# Imgixr

[`{htmlwidgets}`](https://www.htmlwidgets.org/) bindings for the [imgix
rendering API](https://docs.imgix.com/apis/rendering). Use images from
the API in your shiny apps and rmarkdown documents.

## Installation

This package can be installed directly from github using the `{remotes}`
package

``` r
remotes::install_github("GregorDeCillia/imgixr")
```

## Usage

Images can be defined with the `imgxr()` function. You can either enter
a full URL or an id from <https://pexels.com>.

``` r
library(imgixr)
imgixr(2339009)
```

<img src="https://images.pexels.com/photos/2339009/pexels-photo-2339009.jpeg?fit=crop&amp;h=400&amp;w=800"/>

``` r
imgixr("https://images.unsplash.com/photo-1459478309853-2c33a60058e7")
```

<img src="https://images.unsplash.com/photo-1459478309853-2c33a60058e7?fit=crop&amp;h=400&amp;w=800"/>

## API Parameters

API parameters can be passed directly to `imgixr()`. Underscores are
automatically converted to hyphens.

``` r
imgixr(2422497, rot = 30)
```

<img src="https://images.pexels.com/photos/2422497/pexels-photo-2422497.jpeg?fit=crop&amp;rot=30&amp;h=400&amp;w=800"/>

``` r
imgixr(1529360, txt = "Enjoy the rain", txt_size = 100, txt_color = "ddd", 
       txt_align = "center,middle", blur = 20)
```

<img src="https://images.pexels.com/photos/1529360/pexels-photo-1529360.jpeg?fit=crop&amp;txt=Enjoy%20the%20rain&amp;txt-size=100&amp;txt-color=ddd&amp;txt-align=center,middle&amp;blur=20&amp;h=400&amp;w=800"/>

## Shiny

Use `renderImgixr()` to include images to your shiny application.

``` r
output$imgixr <- renderImgixr({
  imgixr_as_widget(imgixr(2339009))
})
```

## Rendering Modes

This packages uses three different strategies to render images depending
on the context.

#### Mode 1: htmlwidget

The default mode. The widget is shown using the
[`{htmlwidgets}`](https://www.htmlwidgets.org/) interface. Typical
usecases are shiny applications and the rstudio viewer pane.

#### Mode 2: html tag

The image is rendered to an html tag using to the `{htmltools}` package.
The `htmltools::as.tag()` is implemented so `imgixr` objects can be
embedded into `tagList`s. This mode is currently used for all html-based
rmarkdown formats.

#### Mode 3: image file

The image is downloaded to a local image and referenced via a local
path. For LaTex-based rmarkdown formats

## More examples

``` r
imgixr(2837863, sepia = 50, height = 800, fit = "clip")
```

<img src="https://images.pexels.com/photos/2837863/pexels-photo-2837863.jpeg?fit=clip&amp;sepia=50&amp;h=800&amp;w=800"/>

``` r
imgixr(2745224, mask = "ellipse", width = 600, height = 600)
```

<img src="https://images.pexels.com/photos/2745224/pexels-photo-2745224.jpeg?fit=crop&amp;mask=ellipse&amp;h=600&amp;w=600"/>

``` r
imgixr("https://images.unsplash.com/photo-1523712999610-f77fbcfc3843", 
       duotone = "000080,FA8072")
```

<img src="https://images.unsplash.com/photo-1523712999610-f77fbcfc3843?fit=crop&amp;duotone=000080,FA8072&amp;h=400&amp;w=800"/>
