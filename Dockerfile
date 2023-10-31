# Osmium Build Container
FROM debian:bookworm-slim AS build_osmium

ARG LIBOSMIUM_VERSION=2.19.0
ARG OSMIUM_TOOL_VERSION=1.15.0

# Osmium Build Prerequisites
RUN apt-get update \
&& apt-get install -y git libprotozero-dev libboost-program-options-dev libbz2-dev zlib1g-dev liblz4-dev libexpat1-dev cmake g++

# Osmium Download
RUN git clone https://github.com/osmcode/libosmium \
&& git clone https://github.com/osmcode/osmium-tool \
&& cd libosmium \
&& git checkout tags/v$LIBOSMIUM_VERSION \
&& cd ../osmium-tool \
&& git checkout tags/v$OSMIUM_TOOL_VERSION

# Osmium Build
RUN mkdir -p osmium-tool/build \
&& cd osmium-tool/build \
&& cmake .. \
&& make \
&& mv src/osmium /usr/local/bin/ \
&& which osmium \
&& osmium --version

################################################################################

# GDAL Build Container
FROM debian:bookworm-slim AS build_gdal

ARG GDAL_VERSION=3.7.1

# GDAL Download Prerequisites
RUN apt-get update \
&& apt-get install -y git

# GDAL Download
RUN git clone https://github.com/OSGeo/gdal \
&& cd gdal \
&& git checkout tags/v$GDAL_VERSION

# GDAL Build Prerequisites
RUN apt-get install -y  \
cmake g++ python3-dev python3-numpy python3-setuptools libjpeg-dev libgeos-dev libexpat-dev libxerces-c-dev libwebp-dev libpng-dev libzstd-dev bash zip curl libpq-dev libssl-dev libopenjp2-7-dev libspatialite-dev autoconf automake sqlite3 bash-completion swig

# build-essential ca-certificates unzip libtool automake zlib1g-dev libsqlite3-dev pkg-config sqlite3 libcurl4-gnutls-dev libtiff5-dev
# python3-dev python3-numpy python3-setuptools libjpeg-dev libgeos-dev libexpat-dev libxerces-c-dev libwebp-dev libpng-dev libzstd-dev bash zip curl libpq-dev libssl-dev libopenjp2-7-dev libspatialite-dev autoconf automake sqlite3 bash-completion swig
# apt-get install -y git libprotozero-dev libboost-program-options-dev libbz2-dev zlib1g-dev liblz4-dev libexpat1-dev

# GDAL Build
RUN mkdir -p gdal/build \
&& cd gdal/build \
&& cmake .. \
&& make

RUN cd gdal/build \
&& cmake --build . \
&& cmake --build . --target install

################################################################################

# Tippecanoe Build Container
FROM debian:bookworm-slim AS build_tippecanoe

ARG TIPPECANOE_VERSION=2.28.1

# Tippecanoe Build Prerequisites
RUN apt-get update \
&& apt-get install -y git build-essential libsqlite3-dev zlib1g-dev

# Tippecanoe Download
RUN git clone https://github.com/felt/tippecanoe.git \
&& cd tippecanoe \
&& git checkout tags/$TIPPECANOE_VERSION

# Tippecanoe Build
RUN cd tippecanoe \
&& make -j \
&& make install \
&& which tippecanoe \
&& tippecanoe --version

################################################################################

# Main Container
FROM debian:bookworm-slim

# Osmium Runtime Prerequisites
RUN apt-get update \
&& apt-get install -y libboost-program-options-dev

# Osmium Binary
COPY --from=build_osmium /usr/local/bin/osmium /usr/bin
RUN osmium --version

# GDAL Binaries & Libraries
COPY --from=build_gdal  /usr/lib /usr/lib
COPY --from=build_gdal  /usr/local/lib/gdalplugins /usr/lib/gdalplugins
COPY --from=build_gdal  /usr/local/lib/libgdal.so* /usr/lib
COPY --from=build_gdal  /usr/local/bin /usr/bin
RUN ogr2ogr --version

# Tippecanoe Runtime Prerequisites
RUN apt-get update \
&& apt-get install -y libsqlite3-dev

# Tippecanoe Binary
COPY --from=build_tippecanoe /usr/local/bin/tippecanoe /usr/bin
RUN tippecanoe --version

# Local Scripts Prerequisites
RUN apt-get update \
&& apt-get install -y curl jq git

# Copy Local Scripts
COPY --chmod=755 scripts /usr/local/scripts
RUN ln -s /usr/local/scripts/osm-download.sh /usr/local/bin/osm-download
RUN ln -s /usr/local/scripts/osm-filter.sh /usr/local/bin/osm-filter
RUN ln -s /usr/local/scripts/osm-to-geojson.sh /usr/local/bin/osm-to-geojson
RUN ln -s /usr/local/scripts/osm-to-flatgeobuf.sh /usr/local/bin/osm-to-flatgeobuf
RUN ln -s /usr/local/scripts/flatgeobuf-to-mbtiles.sh /usr/local/bin/flatgeobuf-to-mbtiles
