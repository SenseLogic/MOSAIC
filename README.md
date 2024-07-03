![](https://github.com/senselogic/MOSAIC/blob/master/LOGO/mosaic.png)

# Mosaic

Color-based image splitter.

## Installation

Install the [DMD 2 compiler](https://dlang.org/download.html) (using the MinGW setup option on Windows).

Build the executable with the following command line :

```bash
dmd -m64 mosaic.d color.d png.d
```

## Command line

```bash
mosaic image.png mosaic.png OUT/image_
```

## Dependencies

*   [ARSD PNG library](https://github.com/adamdruppe/arsd)

## Sample

Image :

![](https://github.com/senselogic/MOSAIC/blob/master/TEST/image.png)

Mosaic :

![](https://github.com/senselogic/MOSAIC/blob/master/TEST/mosaic.png)

Output :

![](https://github.com/senselogic/MOSAIC/blob/master/TEST/OUT/image_1.png)
![](https://github.com/senselogic/MOSAIC/blob/master/TEST/OUT/image_2.png)
![](https://github.com/senselogic/MOSAIC/blob/master/TEST/OUT/image_3.png)
![](https://github.com/senselogic/MOSAIC/blob/master/TEST/OUT/image_4.png)
![](https://github.com/senselogic/MOSAIC/blob/master/TEST/OUT/image_5.png)
![](https://github.com/senselogic/MOSAIC/blob/master/TEST/OUT/image_6.png)
![](https://github.com/senselogic/MOSAIC/blob/master/TEST/OUT/image_7.png)

## Limitations

Only supports PNG files.

## Version

1.0

## Author

Eric Pelzer (ecstatic.coder@gmail.com).

## License

This project is licensed under the GNU General Public License version 3.

See the [LICENSE.md](LICENSE.md) file for details.
