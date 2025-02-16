
docker run  -e LIQUIBASE_URL=jdbc:postgresql://172.17.0.2:5432/dev -e LIQUIBASE_USER=server_ddl -e LIQUIBASE_PASSWORD=testing -v "$(pwd)/liquidbase_changelog:/liquibase/changelog" -d liquibase/liquibase:latest 

docker run --name liquibase -v "$(pwd)/liquidbase_changelog/changelog.xml:/liquibase/changelog/changelog.xml" liquibase update --driver=org.postgresql.Driver --url="jdbc:postgresql://172.17.0.2:5432/dev" --changeLogFile=changelog/changelog.xml --username=server_ddl --password=testing --liquibase-schema-name=liquibase

# From history
docker run --name liquibase -v "$(pwd)/liquidbase_changelog:/liquibase/changelog" liquibase update --driver=org.postgresql.Driver --url="jdbc:postgresql://172.17.0.2:5432/dev" --changeLogFile=changelog/root_changelog.xml --username=server_ddl --password=testing --liquibase-schema-name=liquibase

# Taken from docker
docker run --hostname=9b7cf5d580c1 --user=liquibase:liquibase --env=PATH=/opt/java/openjdk/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin --env=JAVA_HOME=/opt/java/openjdk --env=LANG=en_US.UTF-8 --env=LANGUAGE=en_US:en --env=LC_ALL=en_US.UTF-8 --env=JAVA_VERSION=jdk-17.0.14+7 --env=LIQUIBASE_HOME=/liquibase --env=DOCKER_LIQUIBASE=true --volume=C:\Users\phill\Documents\Coding\pg_docker_test/liquidbase_changelog:/liquibase/changelog --network=bridge --workdir=/liquibase --restart=no --label='org.opencontainers.image.ref.name=ubuntu' --label='org.opencontainers.image.version=22.04' --runtime=runc -d liquibase

# Rollback
docker run --rm --name liquibase-rollback --network database-dev_database -v "$(pwd)/liquidbase/changelog:/liquibase/changelog" liquibase rollback-count --count=7 --driver=org.postgresql.Driver --url="jdbc:postgresql://postgres:5432/dev" --changeLogFile=changelog/root_changelog.xml --username=server_ddl --password=testing --liquibase-schema-name=liquibase/