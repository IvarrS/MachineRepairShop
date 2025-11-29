FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    libssl-dev \
    libpcre3-dev \
    zlib1g-dev \
    libexpat1-dev \
    php8.1 \
    php8.1-cli \
    php8.1-mysql \
    php8.1-mysqli \
    && rm -rf /var/lib/apt/lists/*

COPY ./apache2_install.sh /tmp/apache2_install.sh
RUN chmod +x /tmp/apache2_install.sh && \
    /tmp/apache2_install.sh && \
    rm /tmp/apache2_install.sh

COPY ./Web/ /usr/local/apache2/htdocs/

RUN echo "LoadModule php_module /usr/lib/apache2/modules/libphp8.1.so" >> /usr/local/apache2/conf/httpd.conf && \
    echo "AddType application/x-httpd-php .php" >> /usr/local/apache2/conf/httpd.conf && \
    echo "<FilesMatch \.php$>" >> /usr/local/apache2/conf/httpd.conf && \
    echo "    SetHandler application/x-httpd-php" >> /usr/local/apache2/conf/httpd.conf && \
    echo "</FilesMatch>" >> /usr/local/apache2/conf/httpd.conf

EXPOSE 80

CMD ["/usr/local/apache2/bin/httpd", "-D", "FOREGROUND"]
