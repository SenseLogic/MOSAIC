![](https://github.com/senselogic/MOSAIC/blob/master/LOGO/mosaic.png)

# Mosaic

Image splitter.

## Installation

Install the [DMD 2 compiler](https://dlang.org/download.html) (using the MinGW setup option on Windows).

Build the executable with the following command line :

```bash
dmd -m64 mosaic.d color.d png.d
```

## Command line

```bash
mosaic image.png mosaic.png OUTPUT/image_
```

## Dependencies

*   [ARSD PNG library](https://github.com/adamdruppe/arsd)

## Limitations

Only supports PNG files.

## Version

1.0

## Author

Eric Pelzer (ecstatic.coder@gmail.com).

## License

This project is licensed under the GNU General Public License version 3.

See the [LICENSE.md](LICENSE.md) file for details.
