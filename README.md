# oracledb-with-utplsql.docker

A docker container for testing Oracle Database.

## Description

[utPLSQL](https://www.utplsql.org/) is installed in [Oracle Database container](https://github.com/oracle/docker-images).

## Usage

Assume [Oracle Database container](https://github.com/oracle/docker-images) is already built.

First, build image

```sh
docker build . --tag oracledb-with-utplsql:latest \
    --build-arg oracledb_repository=oracle/database \
    --build-arg oracledb_tag=21.3.0-se2 \
    --build-arg utplsql_version=latest \
    --build-arg utplsql_cli_version=latest
```

```sh
export ORACLEDB_REPOSITORY=oracle/database
export ORACLEDB_TAG=21.3.0-se2
export UTPLSQL_VERSION=latest
export UTPLSQL_CLI_VERSION=latest

docker compose build
```

and run.

```sh
docker run --publish 1521:1521 --env ORACLE_PWD=mydatabasepassword --detach oracledb-with-utplsql
```

```sh
docker compose up -d
```

Next, connect to container via `docker exec` and run the following commands only once.

(If you use docker-compose.yml as default, this script will be run automatically.)

```sh
export SQLPATH=/home/oracle/utPLSQL
sqlplus "sys/${ORACLE_PWD}@localhost:1521/ORCLPDB1" as SYSDBA @"${SQLPATH}/install_headless.sql"
```

## License

CC0 1.0 Universal (CC0 1.0) Public Domain Dedication

See the LICENSE.txt file or https://creativecommons.org/publicdomain/zero/1.0/ for details.
