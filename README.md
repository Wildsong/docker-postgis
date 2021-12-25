wildsong/docker-postgis

I am excited to try out PostGIS 3,  I am not
excited enough to go through the complete build process (again), and I
found that Debian Experimental has a package with postgresql 11 +
postgis 3 in it so this docker builds on that.

I started with mdillon/postgis so a few files started out there. Including
the startup script and the Makefile.

In theory it should just drop in to replace the mdillon/postgis
in my geoserver docker-compose project. I am about to test the
theory...

