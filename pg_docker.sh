docker run --name test-pg --shm-size 256mb -p 5432:5432 -e POSTGRES_PASSWORD=password -e POSTGRES_USER=server_admin -e POSTGRES_DB=dev -v "$(pwd)/init-user-db.sql:/docker-entrypoint-initdb.d/init-user-db.sql" -d postgres

docker rm -f test-pg
docker volume prune -f  # This clears any existing volumes

docker exec -it test-pg psql -U server_admin -d dev -c "\du"

docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' test-pg

docker exec -it postgres psql -U server_dml -W -d dev -c "INSERT INTO watering.watering_date (watering_date) VALUES ('2025-06-01');"

docker exec -it postgres psql -U server_dml -W -d dev -c "INSERT INTO watering.watering_amount (watering_date_Id, watering_zone_id, watering_amount) VALUES (1,1,1),(1,2,1),(1,3,2);"

docker exec -it postgres psql -U server_dml -W -d dev -c "SELECT * FROM watering.watering_date wd INNER JOIN watering.watering_amount wa ON wd.watering_date_id = wa.watering_date_id INNER JOIN watering.watering_zone wz ON wz.watering_zone_id = wa.watering_zone_id;"
