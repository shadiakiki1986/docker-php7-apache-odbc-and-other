# docker-php7-apache-odbc-and-other
Dockerfile for [php7:apache](https://hub.docker.com/_/php/) + odbc + other extensions

Published at [docker hub](https://hub.docker.com/r/shadiakiki1986/php7-apache-odbc-and-other/)

List of main php extensions included
* mongodb
* yaml
 * 2016-10
  * broken as of 2016-10-15 and has been a mess to get to work
  * e.g. resorting to `yaml-beta` and still not working
  * perhaps just use [symfony/yaml](https://github.com/symfony/yaml) instead?
 * 2016-11-14 using yaml-2.0.0 and is ok
* zip
* odbc
* redis
* [sockets](http://php.net/manual/en/book.sockets.php)

List of other installed tools
* tdsodbc
* curl
* git
* composer

# Usage
For odbc:
```
COPY odbc.ini /etc/
COPY odbcinst.ini /etc/
```

# Building the image

`docker build . --build-arg APT_PROXY="http://serveriprunningaptcacher:3142" -t shadiakiki1986/php7-apache-odbc-and-other:latest`

or pull from docker hub with

`docker pull shadiakiki1986/php7-apache-odbc-and-other:latest`

Optionally, build with apt cache as proxy

```
docker run -d -p 3142:3142 -v /var/cache/apt-cacher:/var/cache/apt-cacher clue/apt-cacher
docker build . --build-arg APT_PROXY="http://localhost:3142" -t shadiakiki1986/php7-apache-odbc-and-other:latest
```

To check the logs of `clue/apt-cacher` to verify that the cache is being hit

- `docker ps|grep cache` and copy the container ID
- `docker exec -it <container ID> tail -f /var/log/apt-cacher/access.log`
