#!/bin/bash

#
# Build MBTiles from FlatGeobuf format
#

# Stop on any error
set -e

# Accept input variables from command flags
while getopts i:o: flag
do
    case "${flag}" in
        i) INPUTS=${OPTARG};;
        o) OUTPUT=${OPTARG};;
    esac
done

# Fallback to environment vars or defaults for input variables
INPUTS="${INPUTS:=-L data:data/data.fgb}" # Default: -L data:data/data.fgb
OUTPUT="${OUTPUT:=data/data.mbtiles}" # Default: data/data.mbtiles

# Run command using tippecanoe
tippecanoe -zg \
-o $OUTPUT \
$INPUTS \
--drop-densest-as-needed \
--force

# Confirm completion
echo "Process completed!"
