FROM debian:experimental
MAINTAINER Brian Wilson <brian@wildsong.biz>

# This is the latest available in the repository for experimental.
# Check the output of the search command when building to see if that's still true.
# PG 12 should be coming soon
ENV PG_MAJOR 11
ENV POSTGIS_MAJOR 3
ENV POSTGIS_VERSION 3.0

RUN apt-get update \
      && apt-cache search postgis \
      && apt-get install -y --no-install-recommends \
      	   postgresql-${PG_MAJOR}-postgis-${POSTGIS_MAJOR} \
	   postgresql-${PG_MAJOR}-postgis-${POSTGIS_MAJOR}-scripts \
      	   postgresql-${PG_MAJOR}-pgrouting \
      && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /docker-entrypoint-initdb.d
COPY ./initdb-postgis.sh /docker-entrypoint-initdb.d/postgis.sh
COPY ./update-postgis.sh /usr/local/bin
