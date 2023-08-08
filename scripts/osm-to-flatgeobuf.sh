#!/bin/bash

#
# Convert OSM PBF to FlatGeobuf format
#

# Stop on any error
set -e

# Accept input variables from command flags
while getopts c:i:o:l: flag
do
    case "${flag}" in
        c) CONFIG=${OPTARG};;
        i) INPUT=${OPTARG};;
        o) OUTPUT=${OPTARG};;
        l) LAYER=${OPTARG};;
    esac
done

# Fallback to environment vars or defaults for input variables
CONFIG="${CONFIG:=./osmconf.ini}" # Default: ./osmconf.ini
INPUT="${INPUT:=data/data.osm.pbf}" # Default: data/data.osm.pbf
OUTPUT="${OUTPUT:=data/data.fgb}" # Default: data/data.fgb
LAYER="${LAYER:=lines}" # Default: lines

# Run command using ogr2ogr (part of GDAL)
ogr2ogr \
-oo CONFIG_FILE=$CONFIG \
$OUTPUT \
$INPUT \
$LAYER

# Confirm completion
echo "Process completed!"
