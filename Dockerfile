FROM postgis/postgis-build-env
MAINTAINER Brian Wilson <brian@wildsong.biz>

# The base image already installs recent versions of...
#   build tools
#   SFCGAL
#   PROJ
#   GDAL
#   GEOS
#   PostgreSQL
# ..so most of the work is done already
# That just leaves download, build, install for me

# released 18-Oct-2019 or so
ENV POSTGIS_VERSION 3.0.0

ARG BUILD_THREADS=8

USER root
RUN mkdir /home/postgres && chown postgres /home/postgres

USER postgres
WORKDIR /home/postgres

# Two ways to get code, either an official release or the git repo

ADD http://download.osgeo.org/postgis/source/postgis-${POSTGIS_VERSION}.tar.gz postgis.tar.gz
USER root
RUN chmod 644 postgis.tar.gz

USER postgres
RUN tar xzf postgis.tar.gz

# or go all the way with the git build since that's what the build image does with everything else!
#RUN git clone --depth 1 https://git.osgeo.org/gitea/postgis/postgis.git postgis-${POSTGIS_VERSION}

RUN cd postgis-${POSTGIS_VERSION} \
  && ./autogen.sh \
  && ./configure --with-raster \
  && make -j${BUILD_THREADS}

# Add plpython3
#RUN apt-get update \
#    && apt-get install -y postgresql-plpython3-$PG_MAJOR \
#    && rm -rf /var/lib/apt/lists/*

USER root
RUN cd /home/postgres/postgis-${POSTGIS_VERSION} \
  && make install

#RUN rm -rf postgis-${POSTGIS_VERSION}

# Copied from mdillon/postgis
RUN mkdir -p /docker-entrypoint-initdb.d
COPY ./initdb-postgis.sh /docker-entrypoint-initdb.d/postgis.sh
COPY ./update-postgis.sh /usr/local/bin

USER postgres
CMD postgres
