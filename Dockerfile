# This file is released under the CC0 1.0 Universal (CC0 1.0) Public Domain Dedication.
# See the LICENSE.txt file or https://creativecommons.org/publicdomain/zero/1.0/ for details.

ARG oracledb_repository=oracle/database
ARG oracledb_tag
ARG utplsql_version=latest
FROM ${oracledb_repository}:${oracledb_tag}
ARG utplsql_version

LABEL dev.telitas.project.repository="https://github.com/telitas/oracledb-with-utplsql.docker"
LABEL dev.telitas.base.repository="https://github.com/oracle/docker-images"

USER root

RUN yum install -y jq && \
    yum clean all && \
    rm -rf /var/cache/yum/*

USER oracle

RUN if [ "${utplsql_version}" = "latest" ]; then \
        URL=$(curl "https://api.github.com/repos/utplsql/utplsql/releases/latest" | jq --raw-output ".assets | map(select(.browser_download_url | endswith(\"zip\")))[].browser_download_url"); \
    else \
        URL=$(curl "https://api.github.com/repos/utplsql/utplsql/releases" | jq --raw-output "map(select(.tag_name == \"${utplsql_version}\"))[].assets | map(select(.browser_download_url | endswith(\"zip\")))[].browser_download_url"); \
    fi && \
    FILEBASENAME=$(basename $URL .zip) && \
    curl --location --output "/tmp/${FILEBASENAME}.zip" $URL && \
    unzip "/tmp/${FILEBASENAME}.zip" -d /tmp && \
    mkdir -p ~/utPLSQL && \
    mv /tmp/${FILEBASENAME}/LICENSE /tmp/${FILEBASENAME}/source/ ~/utPLSQL/ && \
    rm -rf /tmp/*
