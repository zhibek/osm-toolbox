#!/bin/bash

#
# Filter OSM PBF by tags
#

# Stop on any error
set -e

# Accept input variables from command flags
while getopts a:f:i:o: flag
do
    case "${flag}" in
        a) AREA=${OPTARG};;
        f) FILTER=${OPTARG};;
        i) INPUT=${OPTARG};;
        o) OUTPUT=${OPTARG};;
    esac
done

# Fallback to environment vars or defaults for input variables
AREA="${AREA:=}" # Required. Example: greater_london
FILTER="${FILTER:=}" # Required. Example: w/railway=rail
INPUT="${INPUT:=data/sources/geofabrik_$AREA.osm.pbf}" # Default: data/sources/geofabrik_$AREA.osm.pbf
OUTPUT="${OUTPUT:=data/data.osm.pbf}" # Default: data/data.osm.pbf

# Validate input variables are set
[ -z "$AREA" ] && echo "AREA must be set, either as an environment variable or using -a command flag." && exit 1;
[ -z "$FILTER" ] && echo "FILTER must be set, either as an environment variable or using -f command flag." && exit 1;

# Run command using osmium
osmium tags-filter \
$INPUT \
$FILTER \
-o $OUTPUT \
--overwrite

# Confirm completion
echo "Process completed!"
