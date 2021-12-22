
# Imgixr

[`{htmlwidgets}`](https://www.htmlwidgets.org/) bindings for the [imgix
rendering API](https://docs.imgix.com/apis/rendering). Use images from
the API in your [`{shiny}`](https://shiny.rstudio.com/) apps and
[`{rmarkdown}`](https://rmarkdown.rstudio.com/) documents.

## Installation

This package can be installed directly from github using the
[`{remotes}`](https://remotes.r-lib.org/) package

``` r
remotes::install_github("r-webutils/imgixr")
```

## Usage

Images can be defined with the `imgxr()` function. You can either enter
a full URL or an id from <https://pexels.com>.

``` r
library(imgixr)
imgixr(2339009)
```

<img src="https://images.pexels.com/photos/2339009/pexels-photo-2339009.jpeg?fit=crop&amp;h=415&amp;w=830"/>

``` r
imgixr("https://images.unsplash.com/photo-1459478309853-2c33a60058e7")
```

<img src="https://images.unsplash.com/photo-1459478309853-2c33a60058e7?fit=crop&amp;h=415&amp;w=830"/>

## API Parameters

API parameters can be passed directly to `imgixr()`. Underscores are
automatically converted to hyphens.

``` r
imgixr(2422497, rot = 30)
```

<img src="https://images.pexels.com/photos/2422497/pexels-photo-2422497.jpeg?fit=crop&amp;rot=30&amp;h=415&amp;w=830"/>

``` r
imgixr(1529360, txt = "Enjoy the rain", txt_size = 100, txt_color = "ddd", 
       txt_align = "center,middle", blur = 20)
```

<img src="https://images.pexels.com/photos/1529360/pexels-photo-1529360.jpeg?fit=crop&amp;txt=Enjoy%20the%20rain&amp;txt-size=100&amp;txt-color=ddd&amp;txt-align=center,middle&amp;blur=20&amp;h=415&amp;w=830"/>

## Shiny

Use `renderImgixr()` to include images to your shiny application.

``` r
output$imgixr <- renderImgixr({
  imgixr_as_widget(imgixr(2339009))
})
```

The sizing must be defined in the corresponding output function
`imgixrOutput()`.

## Rendering Modes

This packages uses three different strategies to render images depending
on the context.

#### Mode 1: htmlwidget

The default mode. The widget is shown using the
[`{htmlwidgets}`](https://www.htmlwidgets.org/) interface. Typical
usecases are shiny applications and the rstudio viewer pane. Use
`imgixr_as_widget()` to directly generate the widget object.

``` r
widget <- imgixr_as_widget(imgixr(2339009))
```

#### Mode 2: html tag

The image is rendered to an html tag using the
[`{htmltools}`](https://rstudio.github.io/htmltools/) package. The
`htmltools::as.tag()` generic is implemented and returns an `<img>` tag.
This means that `imgixr` objects can be embedded into `tagList`s and
other ui definitions that are built with the
[`{htmltools}`](https://rstudio.github.io/htmltools/) package.

``` r
htmltools::div(
  imgixr(2745224, mask = "ellipse", width = 400, height = 400),
  imgixr('https://images.pexels.com/photos/45848/kumamoto-japan-aso-cloud-45848.jpeg', 
           mask = "ellipse", width = 400, height = 400)
)
```

<div>
<img src="https://images.pexels.com/photos/2745224/pexels-photo-2745224.jpeg?fit=crop&amp;mask=ellipse&amp;h=400&amp;w=400"/>
<img src="https://images.pexels.com/photos/45848/kumamoto-japan-aso-cloud-45848.jpeg?fit=crop&amp;mask=ellipse&amp;h=400&amp;w=400"/>
</div>

This mode is currently used for all html-based rmarkdown formats.

#### Mode 3: image file

The image is downloaded to a local image and referenced via a local
path. For LaTeX-based rmarkdown formats. To directly download an image,
use `imgixr_download()`

``` r
imgixr_download(imgixr(2339009), file = "awesome_picture.jpeg")
```

## Palette

`imgixr_palette()` allows you to extract the most dominant colors from
an image.

``` r
imgixr_palette(2339009)
```

    ## [ imgixr color palette ]
    ## List of 3
    ##  $ average_luminance: num 0.261
    ##  $ colors           : chr [1:6] "#fede10" "#e53414" "#a78c6e" "#786578" ...
    ##  $ dominant_colors  : chr [1:6] "#fede10" "#abd5bc" "#57a5a5" "#0b4752" ...

## Metadata

To get metadata about an image, use `imgixr_meta()`

``` r
imgixr_meta(2422497)
```

    ## [ imgixr metadata ]
    ## List of 15
    ##  $ ColorModel    : chr "RGB"
    ##  $ Exif          :List of 38
    ##   ..$ SerialNumber            : chr "372051004311"
    ##   ..$ FocalPlaneXResolution   : int 1520
    ##   ..$ WhiteBalance            : int 0
    ##   ..$ CustomRendered          : int 0
    ##   ..$ ExposureProgram         : int 1
    ##   ..$ FlashCompensation       : int 0
    ##   ..$ SubsecTimeDigitized     : chr "22"
    ##   ..$ ExposureTime            : num 0.00625
    ##   ..$ DateTimeOriginal        : chr "2019:02:05 19:07:54"
    ##   ..$ BodySerialNumber        : chr "372051004311"
    ##   ..$ LensSpecification       :List of 4
    ##   .. ..$ : int 35
    ##   .. ..$ : int 35
    ##   .. ..$ : int 0
    ##   .. ..$ : int 0
    ##   ..$ MaxApertureValue        : int 1
    ##   ..$ PixelXDimension         : int 3154
    ##   ..$ ExposureBiasValue       : int 0
    ##   ..$ DateTimeDigitized       : chr "2019:02:05 19:07:54"
    ##   ..$ LensModel               : chr "35mm F1.4 DG HSM | Art 012"
    ##   ..$ LensID                  : int 368
    ##   ..$ ExposureMode            : int 1
    ##   ..$ ExifVersion             :List of 2
    ##   .. ..$ : int 2
    ##   .. ..$ : int 3
    ##   ..$ FNumber                 : num 1.8
    ##   ..$ SceneCaptureType        : int 0
    ##   ..$ ColorSpace              : int 1
    ##   ..$ LensSerialNumber        : chr "0000000000"
    ##   ..$ SensitivityType         : int 2
    ##   ..$ ImageNumber             : int 0
    ##   ..$ ISOSpeedRatings         :List of 1
    ##   .. ..$ : int 640
    ##   ..$ RecommendedExposureIndex: int 640
    ##   ..$ FocalPlaneResolutionUnit: int 3
    ##   ..$ ShutterSpeedValue       : num 7.32
    ##   ..$ Firmware                : chr "1.1.6"
    ##   ..$ SubsecTimeOriginal      : chr "22"
    ##   ..$ MeteringMode            : int 5
    ##   ..$ Flash                   : int 16
    ##   ..$ LensInfo                :List of 4
    ##   .. ..$ : int 35
    ##   .. ..$ : int 35
    ##   .. ..$ : int 0
    ##   .. ..$ : int 0
    ##   ..$ PixelYDimension         : int 3942
    ##   ..$ FocalLength             : int 35
    ##   ..$ ApertureValue           : num 1.7
    ##   ..$ FocalPlaneYResolution   : int 1520
    ##  $ Orientation   : int 1
    ##  $ Depth         : int 8
    ##  $ Output        : Named list()
    ##  $ Content-Type  : chr "image/jpeg"
    ##  $ JFIF          :List of 1
    ##   ..$ IsProgressive: logi TRUE
    ##  $ DPIWidth      : int 240
    ##  $ Content-Length: chr "9988613"
    ##  $ IPTC          :List of 4
    ##   ..$ DigitalCreationTime: chr "190754"
    ##   ..$ DigitalCreationDate: chr "20190205"
    ##   ..$ TimeCreated        : chr "190754"
    ##   ..$ DateCreated        : chr "20190205"
    ##  $ DPIHeight     : int 240
    ##  $ TIFF          :List of 9
    ##   ..$ ResolutionUnit           : int 2
    ##   ..$ Orientation              : int 1
    ##   ..$ Software                 : chr "Adobe Photoshop CS6 (Macintosh)"
    ##   ..$ YResolution              : int 240
    ##   ..$ DateTime                 : chr "2019:02:06 10:49:44"
    ##   ..$ Make                     : chr "Canon"
    ##   ..$ XResolution              : int 240
    ##   ..$ Model                    : chr "Canon EOS 6D"
    ##   ..$ PhotometricInterpretation: int 2
    ##  $ PixelWidth    : int 3154
    ##  $ PixelHeight   : int 3942
    ##  $ ProfileName   : chr "sRGB IEC61966-2.1"

## More examples

The rendering API exposes a lot of parameters that can be used to modify
images. All parameters to `imgixr()` are directly sent as query
parameters to the API. See <https://docs.imgix.com/apis/rendering> for
the full API documentation.

``` r
imgixr('https://ix-www.imgix.net/solutions/kingfisher.jpg',
       rect = '2100,600,1800,900')
```

<img src="https://ix-www.imgix.net/solutions/kingfisher.jpg?fit=crop&amp;rect=2100,600,1800,900&amp;h=415&amp;w=830"/>

``` r
imgixr('https://assets.imgix.net/trim-ex4.jpg', monochrome = 787878)
```

<img src="https://assets.imgix.net/trim-ex4.jpg?fit=crop&amp;monochrome=787878&amp;h=415&amp;w=830"/>

``` r
imgixr("https://images.unsplash.com/photo-1523712999610-f77fbcfc3843", 
       duotone = "000080,FA8072")
```

<img src="https://images.unsplash.com/photo-1523712999610-f77fbcfc3843?fit=crop&amp;duotone=000080,FA8072&amp;h=415&amp;w=830"/>

``` r
imgixr(1048273, fit = "clip")
```

<img src="https://images.pexels.com/photos/1048273/pexels-photo-1048273.jpeg?fit=clip&amp;h=415&amp;w=830"/>
