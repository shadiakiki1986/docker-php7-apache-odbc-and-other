# docker-php7-apache-odbc-and-other
Dockerfile that wraps [php7:apache](https://hub.docker.com/_/php/) and installs

* odbc
* php extensions
    * mongodb
    * yaml
        * 2016-10
            * broken as of 2016-10-15 and has been a mess to get to work
            * e.g. resorting to `yaml-beta` and still not working
            * perhaps just use [symfony/yaml](https://github.com/symfony/yaml) instead?
        * 2016-11-14 using yaml-2.0.0 and is ok
        * 2019-04-10 updgraded to yaml-2.0.4
    * zip
    * odbc
    * redis
    * [sockets](http://php.net/manual/en/book.sockets.php)
* other tools
    * tdsodbc
    * curl
    * git
    * composer

It is published at [docker hub](https://hub.docker.com/r/shadiakiki1986/php7-apache-odbc-and-other/)


# Getting the image

There are several ways to get this image

* build it locally without an APT cache
    * `docker build . -t shadiakiki1986/php7-apache-odbc-and-other:latest`

* build it locally with apt cache as proxy
    * `docker run -d -p 3142:3142 -v /var/cache/apt-cacher:/var/cache/apt-cacher clue/apt-cacher`
    * `docker build . --build-arg APT_PROXY="http://localhost:3142" -t shadiakiki1986/php7-apache-odbc-and-other:latest`
    * To check the logs of `clue/apt-cacher` to verify that the cache is being hit
        - `docker ps|grep cache` and copy the container ID
        - `docker exec -it <container ID> sh -c "tail -f /var/log/apt-cacher/access.log"`

* pull from docker hub with
    * `docker pull shadiakiki1986/php7-apache-odbc-and-other:latest`


# Usage

To test with the provided `index.php` file in this repository
    * Run the image: `docker run -v $PWD/index_hello.php:/var/www/html/index.php shadiakiki1986/php7-apache-odbc-and-other:latest`
    * Get the container's ID `docker ps|grep php7`
    * Get the container's IP Address `docker inspect <container ID here>|grep IPAddress
    * Fetch the page `curl http://<ip address>`
        * should show the contents
    * To just test the HTTP code returned by the curl call
        * `curl -s -o /dev/null -w "%{http_code}"  http://<ip address>`


Build another docker image based on this

```
FROM shadiakiki1986/php7-apache-odbc-and-other:latest

COPY myphpapp /var/www/html
COPY odbc.ini /etc/
COPY odbcinst.ini /etc/
```
