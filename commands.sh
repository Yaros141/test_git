# Create volumes for db
docker volume create postgres_vol_1
docker volume create postgres_vol_2 # нужен ли он нам?
docker volume create clickhouse_vol

# Create network
docker network create app_net


# Postgres
docker run --rm -d \
	--name postgres_1 \
	-e POSTGRES_USER=postgres \
	-e POSTGRES_PASSWORD=postgres \
	-e POSTGRES_DB=local_test \
	-v postgres_vol_1:/var/lib/postgresql/data \
	--net=app_net \
	-p 5432:5432 \
	postgres:latest


# Superset
docker run --rm -d \
	--net=app_net \
	-p 80:8088 \
	--name superset \
	apache/superset


docker exec -it superset superset fab create-admin \
	--username admin \
	--firstname admin \
	--lastname admin \
	--email admin@admin.com \
	--password admin
	
docker exec -it superset superset db upgrade
docker exec -it superset superset init


# Clickhouse
docker run --rm -d \
	--name clickhouse \
	--net=app_net
	-v clickhouse_vol:/var/lib/clickhouse \
	clickhouse/clickhouse-server


# Sqlalchemy for superset -> to connect clickhouse
docker exec superset pip install clickhouse-sqlachemy

