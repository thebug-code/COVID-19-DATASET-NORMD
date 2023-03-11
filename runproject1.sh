#!/bin/bash
# Copyright (c) 2012-2022, EnterpriseDB Corporation.  All rights reserved

# PostgreSQL psql runner script for Linux

# Verifica la linea de comandos
if [ $# -ne 0 -a $# -ne 1 ]; 
then
    echo 'Usage: $0 [wait]'
    exit 127
fi

# Lee el nombre de usuario de PostgreSQL para conectarse
read -p "Username [postgres]: " USER

if [ -z "$USER" ];
then
    echo "Por favor ingrese el nombre de usuario de PostgreSQL"
    exit 1
fi

# Lee la contraseña que se utilizará si el servidor exige la autenticación de contraseña
read -sp "Password: " PASSWORD

if [ -z "$PASSWORD" ];
then
    echo "Por favor ingrese la contrasena del usuario de PostgreSQL"
    exit 1
fi

# Verifica si hay que descargar el dataset
if [ -f owid-covid-data.csv ] 
then
    echo "Ya se encuentra descargado el archivo owid-covid-data.cvs"
else 
    wget -v "https://covid.ourworldindata.org/data/owid-covid-data.csv"
fi

# USER='admeneses'
# PASSWORD='Realmadrid'

# Configura las variables del entorno
PGUSER="${USER}"
PGPASSWORD="${PASSWORD}"
PGPORT='5432'
PGHOST='localhost'
PGDATABASE='BDP1_1810536_1610109'

# Elimina la base de datos si existe
dropdb \
      -U "${PGUSER}" \
      --if-exists \
      "${PGDATABASE}"

# Crea la base de datos
createdb \
        -O "${PGUSER}" \
        -U "${PGUSER}" \
        "${PGDATABASE}"

# Importa y lee los *.sql
psql \
      -U "${PGUSER}" \
      -d "${PGDATABASE}" \
      -a -f "base_table.sql"

psql \
      -U "${PGUSER}" \
      -d "${PGDATABASE}" \
      -a -f "normd_final_model.sql"

# filename="$( dirname -- "$( readlink -f -- "$0"; )"; )"/owid-covid-data.csv""

# Copiar el conjunto de datos COVID-19 a la tabla base
psql \
      -U "${PGUSER}" \
      -d "${PGDATABASE}" \
      -c "\\copy base_table from 'owid-covid-data.csv' (format 'csv', header, quote '\"')"

# Inserta los valores de la tabla base a cada conjunto de datos
psql \
      -U "${PGUSER}" \
      -d "${PGDATABASE}" \
      -a -f "normd_final_model_insr.sql"

# Inicia el servidor
psql \
    -X \
    -h "${PGHOST}" \
    -p "${PGPORT}" \
    -U "${PGUSER}" "${PGDATABASE}"

psql_exit_status=$? 

if [ $psql_exit_status != 0 ]; 
then
    echo "psql failed while trying to run this sql script" 1>&2
    exit $psql_exit_status
fi

echo "sql script successful"
exit 0
