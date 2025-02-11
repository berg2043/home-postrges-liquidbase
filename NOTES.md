# Postgres
## Deploy
1. Update init-user-db.sql
    - Rename file
    - Parameterize the password for the ddl user
2. Convert the following to a docker compose.
    ```sh
    docker run --name test-pg --shm-size 256mb -p 5432:5432 -e POSTGRES_PASSWORD=password -e POSTGRES_USER=server_admin -e POSTGRES_DB=dev -v "$(pwd)/init-user-db.sql:/docker-entrypoint-initdb.d/init-user-db.sql" -d postgres
    ```
    - Update it to grab the password from a ring or something more secure
    - Decide what port you actually want it exposed on, and setup nginx to point to it
    - Update the volume to point to the actual setup sql file

# Liquibase
## Workflow
- Use a release based organization
  - <a href="https://docs.liquibase.com/start/design-liquibase-project.html">https://docs.liquibase.com/start/design-liquibase-project.html</a>
- When doing initial development, create an unstable xml  `unstable-changelog.xml`
  - Only make additive changes
  - When satisfied, rollback `liquibase rollback --changelog-file=changelog/unstable-changelog.xml --tag=before-unstable`
    - Use the `--rm` flag to make docker delete the container after it finishes
    - `docker run --rm --name liquibase-rollback -v "$(pwd)/liquidbase_changelog:/liquibase/changelog" liquibase rollback-count --count=4 --driver=org.postgresql.Driver --url="jdbc:postgresql://172.17.0.2:5432/dev" --changeLogFile=changelog/root_changelog.xml --username=server_ddl --password=testing --liquibase-schema-name=liquibase`
  - Remove rows from the changelog tables `DELETE FROM liquibase.databasechangelog WHERE filename LIKE '%unstable-changelog.xml%';`
  - Consolidate the changes into a release changelog and use that to deploy dev. `docker run --name liquibase -v "$(pwd)/liquidbase_changelog:/liquibase/changelog" liquibase update --driver=org.postgresql.Driver --url="jdbc:postgresql://172.17.0.2:5432/dev" --changeLogFile=changelog/root_changelog.xml --username=server_ddl --password=testing --liquibase-schema-name=liquibase`

  docker run --rm --name liquibase-rollback  -v "$(pwd)/liquidbase_changelog/changelog.xml:/liquibase/changelog/changelog.xml" liquibase 