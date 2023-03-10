#!/bin/bash

# Verifica la linea de comandos
if [ $# -ne 0 -a $# -ne 1 ]; 
then
    echo 'Usage: $0 [wait]'
    exit 127
fi

#!/bin/bash

# Pedimos al usuario el nombre del usuario de PostgreSQL
echo "Introduce el nombre del usuario de PostgreSQL:"
read username

# Pedimos al usuario el puerto (por defecto es 5432)
echo "Introduce el puerto (por defecto es 5432):"
read port

read -p "Server [localhost]: " host

if [ -z "$host" ];
then
    host="localhost"
fi

# Si el usuario no especifica un puerto, usamos el puerto por defecto (5432)
if [ -z "$port" ]; then
  port=5432
fi

# Verificamos si el usuario existe en PostgreSQL
if PGPASSWORD=$PGPASSWORD psql -U postgres -h localhost -p $port -tAc "SELECT 1 FROM pg_roles WHERE rolname='$username'" postgres | grep -q 1; then
    echo "El usuario ya existe en PostgreSQL"
    # Verificamos si el usuario puede crear bases de datos
    if PGPASSWORD=$PGPASSWORD psql -U postgres -h localhost -p $port -c "CREATE DATABASE test;" postgres; then
        echo "El usuario tiene permisos para crear bases de datos"
        PGPASSWORD=$PGPASSWORD psql -U postgres -h localhost -p $port -c "GRANT CREATE, CONNECT ON DATABASE test TO $username;" postgres
    else
        echo "El usuario no tiene permisos para crear bases de datos"
    fi
else
    echo "El usuario no existe en PostgreSQL. Creando el usuario..."
    # Pedimos al usuario la contraseña para el nuevo usuario
    echo "Introduce la contraseña para el nuevo usuario:"
    read -s password

    # Creamos el nuevo usuario con los permisos necesarios
    PGPASSWORD=$PGPASSWORD psql -U postgres -h localhost -p $port -c "CREATE ROLE $username WITH LOGIN PASSWORD '$password' CREATEDB CREATEROLE;" postgres

    # Otorgamos permisos para crear bases de datos
    PGPASSWORD=$PGPASSWORD psql -U postgres -h localhost -p $port -c "GRANT CREATE, CONNECT ON DATABASE test TO $username;" postgres

    # Otorgamos permisos para crear tablas
    PGPASSWORD=$PGPASSWORD psql -U postgres -h localhost -p $port -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO $username;" postgres

    # Otorgamos permisos para logearse
    PGPASSWORD=$PGPASSWORD psql -U postgres -h localhost -p $port -c "ALTER ROLE $username WITH LOGIN;" postgres

    echo "El usuario $username ha sido creado en PostgreSQL con los permisos necesarios"
fi

# Eliminamos la base de datos de prueba
PGPASSWORD=$PGPASSWORD psql -U postgres -h localhost -p $port -c "DROP DATABASE IF EXISTS test;" postgres

if [ ! -f "owid-covid-data.csv" ]
then
echo "El archivo 'owid-covid-data.csv' no existe. Descargando el archivo..."
    wget -v "https://covid.ourworldindata.org/data/owid-covid-data.csv"
else
    echo "El archivo 'owid-covid-data.csv' ya existe."
fi

# Creamos la base de datos covid_base con el usuario $username
#createdb -h $host -p $port -U $username covid_base

# Desloguear usuario si está conectado a la base de datos

# Creamos la base de datos covid_base con el usuario especificado
dropdb -h $host -p $port -U $username covid_base

createdb -h $host -p $port covid_base

echo "La base de datos covid_base ha sido creada."


# Cargamos los datos del archivo owid-covid-data.csv en la tabla covid_data
psql -h $host -p $port -U $username -d covid_base -c "DROP TABLE IF EXISTS public.covid_table; CREATE TABLE public.covid_table (
    iso_code varchar(100), 
    continent varchar(220), 
    location varchar(220), 
    date Date, 
    total_cases DECIMAL, 
    new_cases DECIMAL, 
    new_cases_smoothed DECIMAL, 
    total_deaths DECIMAL, 
    new_deaths DECIMAL, 
    new_deaths_smoothed DECIMAL, 
    total_cases_per_million DECIMAL, 
    new_cases_per_million DECIMAL, 
    new_cases_smoothed_per_million DECIMAL, 
    total_deaths_per_million DECIMAL, 
    new_deaths_per_million DECIMAL, 
    new_deaths_smoothed_per_million DECIMAL, 
    reproduction_rate DECIMAL,
    icu_patients DECIMAL, 
    icu_patients_per_million DECIMAL, 
    hosp_patients DECIMAL, 
    hosp_patients_per_million DECIMAL, 
    weekly_icu_admissions DECIMAL, 
    weekly_icu_admissions_per_million DECIMAL, 
    weekly_hosp_admissions DECIMAL, 
    weekly_hosp_admissions_per_million DECIMAL, 
    total_tests DECIMAL,
    new_tests DECIMAL, 
    total_tests_per_thousand DECIMAL, 
    new_tests_per_thousand DECIMAL, 
    new_tests_smoothed DECIMAL, 
    new_tests_smoothed_per_thousand DECIMAL, 
    positive_rate DECIMAl, 
    tests_per_case DECIMAL, 
    tests_units varchar(30), 
    total_vaccinations DECIMAL, 
    people_vaccinated DECIMAL, 
    people_fully_vaccinated DECIMAL, 
    total_boosters DECIMAL, 
    new_vaccinations DECIMAL, 
    new_vaccinations_smoothed DECIMAL, 
    total_vaccinations_per_hundred DECIMAL, 
    people_vaccinated_per_hundred DECIMAL, 
    people_fully_vaccinated_per_hundred DECIMAL, 
    total_boosters_per_hundred DECIMAL, 
    new_vaccinations_smoothed_per_million DECIMAL, 
    new_people_vaccinated_smoothed DECIMAL, 
    new_people_vaccinated_smoothed_per_hundred DECIMAL, 
    stringency_index DECIMAL, 
    population_density DECIMAL, 
    median_age DECIMAL, 
    aged_65_older DECIMAL, 
    aged_70_older DECIMAL, 
    gdp_per_capita DECIMAL,  
    extreme_poverty DECIMAL, 
    cardiovasc_death_rate DECIMAl, 
    diabetes_prevalence DECIMAL, 
    female_smokers DECIMAL, 
    male_smokers DECIMAL, 
    handwashing_facilities DECIMAL, 
    hospital_beds_per_thousand DECIMAL, 
    life_expectancy DECIMAL, 
    human_development_index DECIMAL, 
    population DECIMAL, 
    excess_mortality_cumulative_absolute DECIMAL, 
    excess_mortality_cumulative DECIMAL, 
    excess_mortality DECIMAL, 
    excess_mortality_cumulative_per_million DECIMAL 
);"


psql -h $host -p $port -U $username -d covid_base -c "\copy public.covid_table FROM 'owid-covid-data.csv' DELIMITER ',' CSV HEADER;"
