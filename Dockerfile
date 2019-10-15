FROM alpine:3.10

RUN echo "@edge-testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing geos-dev
RUN apk add file wget gcc g++ make automake libtool autoconf curl git libc-dev sqlite sqlite-dev zlib-dev \
    libxml2-dev libc6-compat

RUN wget https://download.osgeo.org/proj/proj-6.2.0.tar.gz && tar zxvf proj-6.2.0.tar.gz && mv proj-6.2.0 proj
RUN wget https://download.osgeo.org/proj/proj-datumgrid-1.8.zip && unzip -o proj-datumgrid-1.8.zip -d proj/data
RUN cd proj && ./configure && make -j8 && make install

RUN wget http://www.gaia-gis.it/gaia-sins/freexl-1.0.5.tar.gz && tar zxvf freexl-1.0.5.tar.gz && cd freexl-1.0.5 && \
    ./configure && make -j8 && make install

RUN git clone "https://git.osgeo.org/gitea/rttopo/librttopo.git" && cd librttopo && ./autogen.sh && \
    ./configure && make -j8 && make install

ENV CPPFLAGS "-DACCEPT_USE_OF_DEPRECATED_PROJ_API_H"
RUN wget http://www.gaia-gis.it/gaia-sins/libspatialite-4.3.0a.tar.gz && \
    tar zxvf libspatialite-4.3.0a.tar.gz && cd libspatialite-4.3.0a && \
    ./configure --disable-dependency-tracking --enable-rttopo=yes --enable-proj=yes --enable-geos=yes --enable-gcp=yes --enable-libxml2=yes && \
    make -j8 && make install

RUN cp -r /usr/local/lib/* /usr/lib/
