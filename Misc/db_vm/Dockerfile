FROM ubuntu:24.04

ENV MARIADB_ROOT_PASSWORD=dbpassword
ENV MARIADB_DATABASE=machinerepairshop

RUN apt-get update && apt-get install -y mariadb-server

COPY data.sql /docker-entrypoint-initdb.d/data.sql
COPY db-setup.sh /db-setup.sh

RUN chmod +x /db-setup.sh

EXPOSE 3306

CMD ["/db-setup.sh"]
