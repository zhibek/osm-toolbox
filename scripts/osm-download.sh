#!/bin/bash

#
# Download OSM PBF for area
#

# Stop on any error
set -e

# Declare constants
INDEX_URL="https://download.geofabrik.de/index-v1-nogeom.json"

# Accept input variables from command flags
while getopts a:o:f: flag
do
    case "${flag}" in
        a) AREA=${OPTARG};;
        o) OUTPUT=${OPTARG};;
        f) FORCE=${OPTARG};;
    esac
done

# Fallback to environment vars or defaults for input variables
AREA="${AREA:=}" # Required. Example: greater_london
OUTPUT="${OUTPUT:=data/sources/geofabrik_$AREA.osm.pbf}" # Default: data/sources/geofabrik_$AREA.osm.pbf
FORCE="${FORCE:=false}" # Default: False (i.e. Don't re-download if file already exists)

# Validate input variables are set
[ -z "$AREA" ] && echo "AREA must be set, either as an environment variable or using -a command flag." && exit 1;

# Skip if OSM data already downloaded
if [ "$FORCE" == false ] && [ -f "$OUTPUT" ]
then
  echo "Skipping process as OSM data already downloaded!"
  exit 0
fi

# Search Geofabrik index JSON for area
AREA_MODIFIED=${AREA//\_/\-} # Replace "_" with "-"
DATA_URL=`curl -s $INDEX_URL | jq -r ".features[].properties| select(.id == \"$AREA_MODIFIED\")| .urls.pbf"`

# Validate input variables are set
[ -z "$DATA_URL" ] && echo "AREA=$AREA could not be found!" && exit 1;

# Download OSM PBF data
curl $DATA_URL -o $OUTPUT

# Confirm completion
echo "Process completed!"
