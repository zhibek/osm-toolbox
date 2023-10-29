# OSM Toolbox

A toolbox of useful OSM applications and helper commands.


## Applications

* Osmium - https://docs.osmcode.org/osmium/latest/index.html
* ogr2ogr (part of GDAL) - https://gdal.org/programs/ogr2ogr.html
* Tippecanoe - https://github.com/felt/tippecanoe


## Helper Commands

* `osm-download` - Download OSM PBF for area
* `osm-filter` - Filter OSM PBF by tags
* `osm-to-geojson` - Export OSM PBF to GeoJson format
* `osm-to-flatgeobuf` - Convert OSM PBF to FlatGeobuf format
* `flatgeobuf-to-mbtiles` - Build MBTiles from FlatGeobuf format


## Docker Image

### Building Image Locally

```
docker build -t zhibek/osm-toolbox .
```

### Example Running Image

```
docker run --rm -v "$(pwd):/workspace" -w /workspace zhibek/osm-toolbox osmium --version
docker run --rm -v "$(pwd):/workspace" -w /workspace zhibek/osm-toolbox ogr2ogr --version
docker run --rm -v "$(pwd):/workspace" -w /workspace zhibek/osm-toolbox tippecanoe --version
```
