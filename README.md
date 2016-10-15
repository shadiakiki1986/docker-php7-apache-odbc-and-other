# docker-php7-apache-odbc-and-other
Dockerfile for [php7:apache](https://hub.docker.com/_/php/) + odbc + other extensions

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

