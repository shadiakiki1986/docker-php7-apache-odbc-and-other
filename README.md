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
