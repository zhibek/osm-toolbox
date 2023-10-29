#!/bin/bash

#
# Export OSM PBF to GeoJson format
#

# Stop on any error
set -e

# Accept input variables from command flags
while getopts a:f:i:o: flag
do
    case "${flag}" in
        i) INPUT=${OPTARG};;
        o) OUTPUT=${OPTARG};;
    esac
done

# Fallback to environment vars or defaults for input variables
INPUT="${INPUT:=data/data.osm.pbf}" # Default: data/data.osm.pbf
OUTPUT="${OUTPUT:=data/data.geojson}" # Default: data/data.geojson

# Run command using osmium
osmium export \
$INPUT \
-o $OUTPUT \
--overwrite

# Confirm completion
echo "Process completed!"
