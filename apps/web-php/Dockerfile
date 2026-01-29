FROM php:8.2-apache

# Install MySQL extensions
RUN docker-php-ext-install mysqli pdo_mysql

# Enable required Apache modules
RUN a2enmod rewrite headers

# Apache configuration - Set ServerName and enable AllowOverride
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf \
    && sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf

# Ensure DirectoryIndex includes index.php (should be default, but explicit is safer)
RUN echo '<Directory /var/www/html>\n\
    DirectoryIndex index.php index.html\n\
    Options -Indexes +FollowSymLinks\n\
    AllowOverride All\n\
    Require all granted\n\
</Directory>' > /etc/apache2/conf-available/app-directory.conf \
    && a2enconf app-directory

# PHP configuration for development (show errors)
RUN echo "display_errors = On" >> /usr/local/etc/php/conf.d/app.ini \
    && echo "error_reporting = E_ALL" >> /usr/local/etc/php/conf.d/app.ini \
    && echo "log_errors = On" >> /usr/local/etc/php/conf.d/app.ini

# Copy app directly to document root
COPY ./home-clothing-tester/ /var/www/html/

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html \
    && find /var/www/html -type d -exec chmod 755 {} \; \
    && find /var/www/html -type f -exec chmod 644 {} \;

EXPOSE 80
CMD ["apache2-foreground"]
