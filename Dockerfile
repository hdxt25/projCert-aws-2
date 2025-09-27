FROM devopsedu/webapp

WORKDIR /var/www/html
RUN rm -rf ./*
COPY website/ .

EXPOSE 80
CMD ["apache2ctl", "-D", "FOREGROUND"]
