# ExploringRelationalMigrator

### Load SQL Database Files from Pagila Dataset

I'm using the Pagila Dataset from the github repo: https://github.com/devrimgunduz/pagila

```
curl -O https://raw.githubusercontent.com/devrimgunduz/pagila/master/pagila-schema.sql

curl -O https://raw.githubusercontent.com/devrimgunduz/pagila/master/pagila-data.sql
```

Now run with docker compose

```
docker-compose up
```

Connect to postgres database:

![Relational Migrator](database_connection.png)

Connect to mongodb database:

Use connection string:
``` 
mongodb://host.docker.internal:27017/mongodb 
```

Postgres Shell pagila:
``` 
docker exec -it pg_test psql -U postgres -d pagila 
```
MongoDB Shell:
```
docker exec -it mongo_test mongosh
```
local MongoDB shell:
```
mongosh "mongodb://localhost:27017"
```

### Larger TPCH Dataset

Since Data files are big, generate data when running for the first time:

```
cd dbgen
make
./dbgen -s 1
```
The one represents a scale factor of 1 (~1 GB of data)

Now move .tbl files to data directory

```
mv tpch-dbgen/*.tbl data/
```

Now start docker containers and run the migrator!

```
docker compose up -d
```

Postgres Shell tpch:
```
docker exec -it tpch_pg psql -U postgres -d tpch
```