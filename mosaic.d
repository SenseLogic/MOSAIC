/*
    This file is part of the Mosaic distribution.

    https://github.com/senselogic/MOSAIC

    Copyright (C) 2024 Eric Pelzer (ecstatic.coder@gmail.com)

    Mosaic is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, version 3.

    Mosaic is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mosaic.  If not, see <http://www.gnu.org/licenses/>.
*/

// -- IMPORTS

import arsd.color : Color, MemoryImage, TrueColorImage;
import arsd.png : readPng, writePng;
import core.stdc.stdlib : exit;
import std.conv : to;
import std.file : exists, mkdirRecurse;
import std.stdio : writeln;
import std.string : endsWith, indexOf, join, lastIndexOf, replace, split, startsWith;

// -- TYPES

class RECTANGLE
{
    // -- ATTRIBUTES

    COLOR
        Color;
    long
        ColumnIndex,
        ColumnCount,
        RowIndex,
        RowCount;

    // -- CONSTRUCTORS

    this(
        COLOR color,
        long column_index,
        long row_index
        )
    {
        Color = color;
        ColumnIndex = column_index;
        ColumnCount = 1;
        RowIndex = row_index;
        RowCount = 1;
    }

    // -- OPERATIONS

    void Extend(
        long column_index,
        long row_index
        )
    {
        if ( column_index >= ColumnIndex + ColumnCount )
        {
            ColumnCount = column_index + 1 - ColumnIndex;
        }

        if ( row_index >= RowIndex + RowCount )
        {
            RowCount = row_index + 1 - RowIndex;
        }
    }
}

// ~~

struct COLOR
{
    // -- ATTRIBUTES

    ubyte
        Red,
        Green,
        Blue,
        Opacity;

    // -- OPERATIONS

    void Clear(
        )
    {
        Red = 0;
        Green = 0;
        Blue = 0;
        Opacity = 0;
    }

    // ~~

    void Set(
        ubyte red,
        ubyte green,
        ubyte blue,
        ubyte opacity = 255
        )
    {
        Red = red;
        Green = green;
        Blue = blue;
        Opacity = opacity;
    }
}

// ~~

alias PIXEL = COLOR;

// ~~

class IMAGE
{
    // -- ATTRIBUTES

    long
        ColumnCount,
        RowCount;
    PIXEL[]
        PixelArray;

    // -- INQUIRIES

    long GetPixelIndex(
        long column_index,
        long row_index
        )
    {
        return row_index * ColumnCount + column_index;
    }

    // ~~

    PIXEL GetPixel(
        long column_index,
        long row_index
        )
    {
        return PixelArray[ row_index * ColumnCount + column_index ];
    }

    // ~~

    RECTANGLE[] GetRectangleArray(
        )
    {
        bool
            rectange_was_found;
        COLOR
            color;
        RECTANGLE[]
            rectangle_array;

        foreach ( row_index; 0 .. RowCount )
        {
            foreach ( column_index; 0 .. ColumnCount )
            {
                color = GetPixel( column_index, row_index );
                rectange_was_found = false;

                foreach ( rectangle; rectangle_array )
                {
                    if ( color == rectangle.Color )
                    {
                        rectangle.Extend( column_index, row_index );
                        rectange_was_found = true;

                        break;
                    }
                }

                if ( !rectange_was_found )
                {
                    rectangle_array ~= new RECTANGLE( color, column_index, row_index );
                }
            }
        }

        return rectangle_array;
    }

    // ~~

    IMAGE GetImage(
        RECTANGLE rectangle
        )
    {
        IMAGE
            image;

        image = new IMAGE();
        image.ColumnCount = rectangle.ColumnCount;
        image.RowCount = rectangle.RowCount;
        image.PixelArray.length = rectangle.RowCount * rectangle.ColumnCount;

        foreach ( row_index; 0 .. image.RowCount )
        {
            foreach ( column_index; 0 .. image.ColumnCount )
            {
                image.SetPixel(
                    column_index,
                    row_index,
                    GetPixel(
                        rectangle.ColumnIndex + column_index,
                        rectangle.RowIndex + row_index
                        )
                    );
            }
        }

        return image;
    }

    // ~~

    void WritePngFile(
        string png_file_path
        )
    {
        long
            column_index,
            row_index,
            pixel_index;
        Color
            color;
        TrueColorImage
            true_color_image;
        PIXEL
            pixel;

        CreateFolder( png_file_path.GetFolderPath() );

        writeln( "Writing file : ", png_file_path );

        true_color_image = new TrueColorImage( cast( int )ColumnCount, cast( int )RowCount );

        for ( row_index = 0;
              row_index < RowCount;
              ++row_index )
        {
            for ( column_index = 0;
                  column_index < ColumnCount;
                  ++column_index )
            {
                pixel_index = GetPixelIndex( column_index, row_index );
                pixel = PixelArray[ pixel_index ];

                color.r = pixel.Red.to!ubyte();
                color.g = pixel.Green.to!ubyte();
                color.b = pixel.Blue.to!ubyte();
                color.a = 255;

                true_color_image.setPixel( cast( int )column_index, cast( int )row_index, color );
            }
        }

        writePng( png_file_path, true_color_image );
    }

    // -- OPERATIONS

    void SetPixel(
        long column_index,
        long row_index,
        PIXEL pixel
        )
    {
        PixelArray[ row_index * ColumnCount + column_index ] = pixel;
    }

    // ~~

    void ReadPngFile(
        string png_file_path
        )
    {
        long
            column_index,
            row_index,
            pixel_index;
        Color
            color;
        TrueColorImage
            true_color_image;
        PIXEL
            pixel;

        writeln( "Reading file : ", png_file_path );

        true_color_image = readPng( png_file_path ).getAsTrueColorImage();

        RowCount = true_color_image.height();
        ColumnCount = true_color_image.width();
        PixelArray.length = RowCount * ColumnCount;

        for ( row_index = 0;
              row_index < RowCount;
              ++row_index )
        {
            for ( column_index = 0;
                  column_index < ColumnCount;
                  ++column_index )
            {
                color = true_color_image.getPixel( cast( int )column_index, cast( int )row_index );

                pixel.Red = color.r;
                pixel.Green = color.g;
                pixel.Blue = color.b;
                pixel.Opacity = color.a;

                pixel_index = GetPixelIndex( column_index, row_index );
                PixelArray[ pixel_index ] = pixel;
            }
        }
    }
}

// -- FUNCTIONS

void PrintError(
    string message
    )
{
    writeln( "*** ERROR : ", message );
}

// ~~

void Abort(
    string message
    )
{
    PrintError( message );

    exit( -1 );
}

// ~~

void Abort(
    string message,
    Exception exception
    )
{
    PrintError( message );
    PrintError( exception.msg );

    exit( -1 );
}

// ~~

string GetPhysicalPath(
    string path
    )
{
    return path.replace( '/', '\\' );
}

// ~~

string GetLogicalPath(
    string path
    )
{
    return path.replace( '\\', '/' );
}

// ~~

string GetFolderPath(
    string file_path
    )
{
    long
        slash_character_index;

    slash_character_index = file_path.lastIndexOf( '/' );

    if ( slash_character_index >= 0 )
    {
        return file_path[ 0 .. slash_character_index + 1 ];
    }
    else
    {
        return "";
    }
}

// ~~

void CreateFolder(
    string folder_path
    )
{
    try
    {
        if ( folder_path != ""
             && folder_path != "/"
             && !folder_path.exists() )
        {
            writeln( "Creating folder : ", folder_path );

            folder_path.GetPhysicalPath().mkdirRecurse();
        }
    }
    catch ( Exception exception )
    {
        Abort( "Can't create folder : " ~ folder_path, exception );
    }
}

// ~~

void MosaicImage(
    string input_image_file_path,
    string mosaic_image_file_path,
    string ouput_image_file_prefix
    )
{
    IMAGE
        input_image,
        mosaic_image,
        output_image;
    RECTANGLE[]
        rectangle_array;

    input_image = new IMAGE();
    input_image.ReadPngFile( input_image_file_path );

    mosaic_image = new IMAGE();
    mosaic_image.ReadPngFile( mosaic_image_file_path );

    rectangle_array = mosaic_image.GetRectangleArray();

    foreach ( rectangle_index, rectangle; rectangle_array )
    {
        output_image = input_image.GetImage( rectangle );
        output_image.WritePngFile( ouput_image_file_prefix ~ ( rectangle_index + 1 ).to!string() ~ ".png" );
    }
}

// ~~

void main(
    string[] argument_array
    )
{
    string
        option;

    argument_array = argument_array[ 1 .. $ ];

    if ( argument_array.length == 3
         && argument_array[ 0 ].endsWith( ".png" )
         && argument_array[ 1 ].endsWith( ".png" ) )
    {
        MosaicImage(
            argument_array[ 0 ].GetLogicalPath(),
            argument_array[ 1 ].GetLogicalPath(),
            argument_array[ 2 ].GetLogicalPath()
            );
    }
    else
    {
        writeln( "Usage :" );
        writeln( "    mosaic image.png mosaic.png OUT/image_" );

        Abort( "Invalid arguments : " ~ argument_array.to!string() );
    }
}
