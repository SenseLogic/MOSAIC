#!/bin/sh
set -x
dmd -m64 mosaic.d color.d png.d
rm *.o
