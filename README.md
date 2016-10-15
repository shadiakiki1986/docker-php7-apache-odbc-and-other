# docker-php7-apache-odbc-and-other
Dockerfile for [php7:apache](https://hub.docker.com/_/php/) + odbc + other extensions

Published at [docker hub](https://hub.docker.com/r/shadiakiki1986/php7-apache-odbc-and-other/)

List of main php extensions included
* mongodb
* yaml
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

