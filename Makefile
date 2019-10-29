all:	build

# Build an image that can be used in the geoserver project
build:
	docker build -t wildsong/postgis:latest .

# Normally I don't run postgis from here, this is just for looking around in a shell
run:
	docker run -it --name=pgis -e POSTGRES_PASSWORD=secret wildsong/postgis bash

daemon:
	docker run  -d --name=pgis -e POSTGRES_PASSWORD=secret wildsong/postgis

psql:
	docker exec -it pgis psql

clean:
	docker rm pgis && \
	docker rmi wildsong/postgis
