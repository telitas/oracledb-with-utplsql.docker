# This file is released under the CC0 1.0 Universal (CC0 1.0) Public Domain Dedication.
# See the LICENSE.txt file or https://creativecommons.org/publicdomain/zero/1.0/ for details.

ARG oracledb_repository=oracle/database
ARG oracledb_tag
ARG utplsql_version=latest
ARG utplsql_cli_version=latest
FROM ${oracledb_repository}:${oracledb_tag}
ARG utplsql_version
ARG utplsql_cli_version

LABEL dev.telitas.project.repository="https://github.com/telitas/oracledb-with-utplsql.docker"
LABEL dev.telitas.base.repository="https://github.com/oracle/docker-images"

USER root

RUN yum install -y jq which java-1.8.0-openjdk && \
    yum clean all && \
    rm -rf /var/cache/yum/*

USER oracle

RUN if [ "${utplsql_version}" = "latest" ]; then \
        URL=$(curl "https://api.github.com/repos/utplsql/utplsql/releases/latest" | jq --raw-output ".assets | map(select(.browser_download_url | endswith(\"zip\")))[].browser_download_url"); \
    else \
        URL=$(curl "https://api.github.com/repos/utplsql/utplsql/releases" | jq --raw-output "map(select(.tag_name == \"${utplsql_version}\"))[].assets | map(select(.browser_download_url | endswith(\"zip\")))[].browser_download_url"); \
    fi && \
    FILEBASENAME=$(basename $URL .zip) && \
    curl --location --output "/usr/tmp/${FILEBASENAME}.zip" $URL && \
    unzip "/usr/tmp/${FILEBASENAME}.zip" -d /usr/tmp && \
    mkdir -p $HOME/utPLSQL && \
    mv /usr/tmp/${FILEBASENAME}/LICENSE /usr/tmp/${FILEBASENAME}/source/ $HOME/utPLSQL/ && \
    rm -rf /usr/tmp/*
RUN if [ "${utplsql_cli_version}" = "latest" ]; then \
        URL=$(curl "https://api.github.com/repos/utplsql/utplsql-cli/releases/latest" | jq --raw-output ".assets | map(select(.browser_download_url | endswith(\"zip\")))[].browser_download_url"); \
    else \
        URL=$(curl "https://api.github.com/repos/utplsql/utplsql-cli/releases" | jq --raw-output "map(select(.tag_name == \"${utplsql_cli_version}\"))[].assets | map(select(.browser_download_url | endswith(\"zip\")))[].browser_download_url"); \
    fi && \
    FILEBASENAME=$(basename $URL .zip) && \
    curl --location --output "/usr/tmp/${FILEBASENAME}.zip" $URL && \
    unzip "/usr/tmp/${FILEBASENAME}.zip" -d /usr/tmp && \
    mkdir -p $HOME/utPLSQL-cli && \
    mv /usr/tmp/${FILEBASENAME}/* $HOME/utPLSQL-cli && \
    rm $HOME/utPLSQL-cli/bin/utplsql.bat && \
    echo export PATH=\$PATH:$HOME/utPLSQL-cli/bin/ >> $HOME/.bashrc && \
    rm -rf /usr/tmp/*
