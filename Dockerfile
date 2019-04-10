FROM php:7-apache
MAINTAINER Shadi Akiki

# For debugging: > docker run -it php:7-apache /bin/sh^C


# Use APT proxy, like clue/apt-cacher, if provided in the --build-args while building
# Check README.md for more info
ARG APT_PROXY=""
RUN echo "Using APT proxy: '${APT_PROXY}'"; 
RUN if [ ! -z "$APT_PROXY" ]; then echo "Acquire::http::Proxy \"${APT_PROXY}\";" | tee /etc/apt/apt.conf.d/01proxy; fi
RUN cat /etc/apt/apt.conf.d/01proxy

# install development packages
# To avoid prompt for new config: http://stackoverflow.com/a/23048987/4126114
# Note that for php7, replace
#  * libapache2-mod-php5 with php-mbstring
#  * php5-odbc with php-odbc
RUN apt-get update # apt-get -qq update > /dev/null
# RUN DEBIAN_FRONTEND=noninteractive apt-get -qq ...
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
      curl git libmcrypt-dev libyaml-dev \
      vim unixodbc unixodbc-dev tdsodbc \
      libssl-dev \
      zlib1g-dev \
      wget unzip \
      libzip-dev
      #< /dev/null > /dev/null

# 2016-11-14 move to yaml-2.0.0 after using yaml-beta from http://stackoverflow.com/questions/34169346/pecl-yaml
# 2019-04-10 move mcrypt from docker-php-ext-install mcrypt to pecl install ... https://www.techrepublic.com/article/how-to-install-mcrypt-for-php-7-2/
# 2019-04-10 update yaml-2.0.0 to yaml-2.0.4 (not 2.0.3) ... https://bugs.php.net/bug.php?id=76522 and http://bd808.com/pecl-file_formats-yaml/
RUN pecl channel-update pecl.php.net && \
    pecl install \
      mcrypt-1.0.2 zip yaml-2.0.4 mongodb \
      < /dev/null # > /dev/null

# install php extensions
RUN docker-php-ext-install mbstring bcmath # > /dev/null

# 2016-09-xx: no need for yaml since already installed with pecl. What about mongo and zip?
# 2016-11-14: despite the note above, the enable below is needed for yaml (as well as mongo and zip)
RUN docker-php-ext-enable zip mcrypt mongodb yaml

# install composer
RUN curl -sS https://getcomposer.org/installer | php && \
    chmod +x composer.phar && \
    mv composer.phar /usr/local/bin/composer

# cannot install odbc wihtout the below because of https://github.com/docker-library/php/issues/103#issuecomment-160772802
RUN ls /usr/src/php.*
RUN set -x \
    && cd /usr/src/ && tar -xf php.tar.xz && mv php-7* php \
    && cd /usr/src/php/ext/odbc \
    && phpize \
    && sed -ri 's@^ *test +"\$PHP_.*" *= *"no" *&& *PHP_.*=yes *$@#&@g' configure \
    && ./configure --with-unixODBC=shared,/usr  \
    && docker-php-ext-install odbc
# removed /dev/null after ./configure above and docker-php-ext-install

# install redis extension: note that this is php 7 but it's on debian:jessie, so cant just apt-get install php-redis
# Reference: https://anton.logvinenko.name/en/blog/how-to-install-redis-and-redis-php-client.html
#       scroll down to section on php 7
# also
# https://github.com/docker-library/php/issues/263#issuecomment-233280040
# 2019-04-10 available from pecl
#RUN cd /tmp && \
#    wget --quiet https://github.com/phpredis/phpredis/archive/php7.zip -O phpredis.zip && \
#    unzip -q -o /tmp/phpredis.zip && mv /tmp/phpredis-* /usr/src/php/ext/redis && \
#    cd /usr/src/php/ext/redis && \
#    phpize && ./configure && \
#    docker-php-ext-install redis
# removed /dev/null after ./configure above and docker-php-ext-install
RUN pecl install redis-4.3.0
RUN docker-php-ext-enable redis


# check that redis indeed got installed
RUN php -r "if (new Redis() == true){ echo \"OK \r\n\"; }" 

# Install php sockets extension
RUN docker-php-ext-install sockets > /dev/null

# check that all were indeed installed
RUN php -i|grep mongo \
  && php -i | grep zip \
  && php -i | grep odbc \
  && php -i | grep redis \
  && php -i | grep sockets \
  && php -i | grep yaml

# Fix timezone: http://serverfault.com/a/683651
ENV TZ=Asia/Beirut
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# make the composer cache into a shared volume for persistence and sharing among derived images
VOLUME /root/.composer/cache
