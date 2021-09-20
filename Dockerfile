FROM debian:buster

RUN apt-get update && \
    apt-get upgrade -y && \
    # packages installation
    apt-get -y install \
    wget \
    nginx \
    mariadb-server \
    openssl \
    php-fpm php-common php-mysql php-gmp php-curl php-intl php-mbstring php-xmlrpc php-gd php-xml php-cli php-zip php-soap php-imap && \
    # phpmyadmin installation
    mkdir /var/www/html/phpmyadmin && \
    wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz && \
    tar -xvf phpMyAdmin-5.0.4-all-languages.tar.gz --strip-components 1 -C /var/www/html/phpmyadmin && \
    # wp installation
    wget https://wordpress.org/latest.tar.gz && \
    tar -xvzf latest.tar.gz -C /var/www/html

COPY /srcs /tmp

RUN mv /tmp/phpmyadmin.inc.php /var/www/html/phpmyadmin/config.inc.php && \
    mv /tmp/wp-config.php /var/www/html/wordpress && \
    mv /tmp/autoindex.sh . && \
    mv /tmp/nginx.conf /etc/nginx/sites-available && \
    ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/nginx.conf && \
    rm -rf /etc/nginx/sites-enabled/default && \
    # key generation
    openssl req -newkey rsa:4096 -x509 -sha256 -days 147 -nodes \
    -out /etc/nginx/certificate.crt -keyout /etc/nginx/certificate_key.key \
    -subj "/C=RU/ST=Moscow/L=Moscow/O=School42/OU=School21/CN=localhost"

ENTRYPOINT bash ./tmp/start_conf.sh && bash