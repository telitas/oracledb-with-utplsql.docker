#!/usr/bin/env bash
# This file is released under the CC0 1.0 Universal (CC0 1.0) Public Domain Dedication.
# See the LICENSE.txt file or https://creativecommons.org/publicdomain/zero/1.0/ for details.

export SQLPATH=/home/oracle/utPLSQL/source
sqlplus -L -S "sys/${ORACLE_PWD}@localhost:1521/ORCLPDB1" as SYSDBA @"${SQLPATH}/install_headless.sql"
