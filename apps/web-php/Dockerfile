FROM php:8.2-apache

# Copia toda la aplicación PHP
COPY web-php/home-clothing-tester/ /var/www/html/

# Configura Apache
RUN echo "ServerName localhost" > /etc/apache2/conf-available/servername.conf \
    && a2enconf servername \
    && a2enmod rewrite

EXPOSE 80
CMD ["apache2-foreground"]
