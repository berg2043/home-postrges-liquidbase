FROM library/postgres

COPY ./postgres/init.sql /docker-entrypoint-initdb.d/