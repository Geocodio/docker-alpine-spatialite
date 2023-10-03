FROM alpine:3.18

RUN apk add file wget gcc g++ make cmake automake libtool autoconf curl git libc-dev sqlite sqlite-dev zlib-dev \
    libxml2-dev libc6-compat librttopo-dev minizip-dev proj-dev fossil

# libgeos
RUN wget https://download.osgeo.org/geos/geos-3.11.1.tar.bz2 && \
    tar xvfj geos-3.11.1.tar.bz2 && \
    cd geos-3.11.1 && \
    cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr/local && \
    make && \
    ctest && \
    make install

# libspatialite
RUN fossil clone https://www.gaia-gis.it/fossil/libspatialite libspatialite.fossil --user anonymous

RUN mkdir libspatialite && \
    cd libspatialite && \
    fossil open ../libspatialite.fossil && \
    ./configure --build=unknown-unknown-linux --enable-freexl=no && \
    make -j8 && \
    make install

RUN cp -r /usr/local/lib/* /usr/lib/

RUN sqlite3 test.db "SELECT load_extension('mod_spatialite'); SELECT spatialite_version();"
