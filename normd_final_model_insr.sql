-- Inserta los valores a cada conjunto de datos desde la tabla base 

-- Inserta las especificaciones de cada pais en la tabla COUNTRY_SPECIFICATIONS
INSERT INTO COUNTRY_SPECIFICATIONS(
    iso_code, 
    location, 
    continent, 
    population, 
    population_density, 
    median_age, 
    aged_65_older, 
    aged_70_older,
    gdp_per_capita,
    extreme_poverty,
    cardiovasc_death_rate,
    diabetes_prevalence,
    female_smokers,
    male_smokers,
    handwashing_facilities,
    hospital_beds_per_thousand,
    life_expectancy,
    human_development_index)
    (select 
    iso_code, 
    location, 
    continent, 
    population, 
    population_density, 
    median_age, 
    aged_65_older, 
    aged_70_older,
    gdp_per_capita,
    extreme_poverty,
    cardiovasc_death_rate,
    diabetes_prevalence,
    female_smokers,
    male_smokers,
    handwashing_facilities,
    hospital_beds_per_thousand,
    life_expectancy,
    human_development_index
    from BASE_TABLE group by 
    iso_code, 
    location, 
    continent, 
    population, 
    population_density, 
    median_age, 
    aged_65_older, 
    aged_70_older,
    gdp_per_capita,
    extreme_poverty,
    cardiovasc_death_rate,
    diabetes_prevalence,
    female_smokers,
    male_smokers,
    handwashing_facilities,
    hospital_beds_per_thousand,
    life_expectancy,
    human_development_index 
    order by iso_code);


-- Inserta las fechas de observaciones de los datos en la tabla DATE_OBSERVATION
INSERT INTO DATE_OBSERVATION (date) 
        (select distinct(date) from base_table order by date);


-- Inserta el conjunto de datos de los casos confirmados en la tabla
-- CONFIRMED_CASES
 INSERT INTO CONFIRMED_CASES(
     total_cases,
     new_cases,
     new_cases_smoothed,
     total_cases_per_million,
     new_cases_per_million,
     new_cases_smoothed_per_million,
     date_obs_id,
     country_id)
     (SELECT 
     total_cases,
     new_cases,
     new_cases_smoothed,
     total_cases_per_million,
     new_cases_per_million,
     new_cases_smoothed_per_million,
     DATE_OBSERVATION.date_obs_id, 
     COUNTRY_SPECIFICATIONS.country_id
     from BASE_TABLE
     JOIN DATE_OBSERVATION ON BASE_TABLE.date = DATE_OBSERVATION.date
     JOIN COUNTRY_SPECIFICATIONS ON BASE_TABLE.iso_code = COUNTRY_SPECIFICATIONS.iso_code
     order by COUNTRY_SPECIFICATIONS.iso_code);
 


-- Inserta el conjunto de datos de las muertes confirmadas en la tabla
-- CONFIRMED_DEATHS
INSERT INTO CONFIRMED_DEATHS(
     total_deaths,
     new_deaths,
     new_deaths_smoothed,
     total_deaths_per_million,
     new_deaths_per_million,
     new_deaths_smoothed_per_million,
     date_obs_id, 
     country_id)
     (SELECT 
     total_deaths,
     new_deaths,
     new_deaths_smoothed,
     total_deaths_per_million,
     new_deaths_per_million,
     new_deaths_smoothed_per_million,
     DATE_OBSERVATION.date_obs_id, 
     COUNTRY_SPECIFICATIONS.country_id
     from BASE_TABLE
     JOIN DATE_OBSERVATION ON BASE_TABLE.date = DATE_OBSERVATION.date
     JOIN COUNTRY_SPECIFICATIONS ON BASE_TABLE.iso_code = COUNTRY_SPECIFICATIONS.iso_code
     order by COUNTRY_SPECIFICATIONS.iso_code);


-- Inserta el conjunto de datos de excesos de mortalidad en la tabla
-- EXCESS_MORTALITY
INSERT INTO EXCESS_MORTALITY(
     excess_mortality,
     excess_mortality_cumulative,
     excess_mortality_cumulative_absolute,
     excess_mortality_cumulative_per_million,
     date_obs_id, 
     country_id)
     (SELECT 
     excess_mortality,
     excess_mortality_cumulative,
     excess_mortality_cumulative_absolute,
     excess_mortality_cumulative_per_million,
     DATE_OBSERVATION.date_obs_id, 
     COUNTRY_SPECIFICATIONS.country_id
     from BASE_TABLE
     JOIN DATE_OBSERVATION ON BASE_TABLE.date = DATE_OBSERVATION.date
     JOIN COUNTRY_SPECIFICATIONS ON BASE_TABLE.iso_code = COUNTRY_SPECIFICATIONS.iso_code
     order by COUNTRY_SPECIFICATIONS.iso_code);


-- Inserta el conjunto de datos de los hospitales & ICU en la tabla
-- HOSPITAL_ICU
INSERT INTO HOSPITAL_ICU(
    icu_patients,
    icu_patients_per_million,
    hosp_patients,
    hosp_patients_per_million,
    weekly_icu_admissions,
    weekly_icu_admissions_per_million,
    weekly_hosp_admissions,
    weekly_hosp_admissions_per_million,
    date_obs_id, 
    country_id)
    (SELECT 
    icu_patients,
    icu_patients_per_million,
    hosp_patients,
    hosp_patients_per_million,
    weekly_icu_admissions,
    weekly_icu_admissions_per_million,
    weekly_hosp_admissions,
    weekly_hosp_admissions_per_million,
    DATE_OBSERVATION.date_obs_id, 
    COUNTRY_SPECIFICATIONS.country_id
    from BASE_TABLE
    JOIN DATE_OBSERVATION ON BASE_TABLE.date = DATE_OBSERVATION.date
    JOIN COUNTRY_SPECIFICATIONS ON BASE_TABLE.iso_code = COUNTRY_SPECIFICATIONS.iso_code
    order by COUNTRY_SPECIFICATIONS.iso_code);


-- Inserta el conjunto de datos de las respuestas politicas en la tabla
-- POLICY_RESPONSES
INSERT INTO POLICY_RESPONSES(
     stringency_index,
     date_obs_id, 
     country_id)
     (SELECT 
     stringency_index,
     DATE_OBSERVATION.date_obs_id, 
     COUNTRY_SPECIFICATIONS.country_id
     from BASE_TABLE
     JOIN DATE_OBSERVATION ON BASE_TABLE.date = DATE_OBSERVATION.date
     JOIN COUNTRY_SPECIFICATIONS ON BASE_TABLE.iso_code = COUNTRY_SPECIFICATIONS.iso_code
     order by COUNTRY_SPECIFICATIONS.iso_code);


-- Inserta el conjunto de datos de las tasas de reproduccion en la tabla
-- REPRODUCTION_RATE
INSERT INTO REPRODUCTION_RATE(
     reproduction_rate,
     date_obs_id, 
     country_id)
     (SELECT 
     reproduction_rate,
     DATE_OBSERVATION.date_obs_id, 
     COUNTRY_SPECIFICATIONS.country_id
     from BASE_TABLE
     JOIN DATE_OBSERVATION ON BASE_TABLE.date = DATE_OBSERVATION.date
     JOIN COUNTRY_SPECIFICATIONS ON BASE_TABLE.iso_code = COUNTRY_SPECIFICATIONS.iso_code
     order by COUNTRY_SPECIFICATIONS.iso_code);


-- Inserta el conjunto de datos de las pruebas y positividad en la tabla
-- TEST_POSITIVY
INSERT INTO TESTS_POSITIVITY(
     total_tests,
     new_tests,
     total_tests_per_thousand,
     new_tests_per_thousand,
     new_tests_smoothed,
     new_tests_smoothed_per_thousand,
     positive_rate,
     tests_per_case,
     tests_units,
     date_obs_id, 
     country_id)
     (SELECT 
     total_tests,
     new_tests,
     total_tests_per_thousand,
     new_tests_per_thousand,
     new_tests_smoothed,
     new_tests_smoothed_per_thousand,
     positive_rate,
     tests_per_case,
     tests_units,
     DATE_OBSERVATION.date_obs_id, 
     COUNTRY_SPECIFICATIONS.country_id
     from BASE_TABLE
     JOIN DATE_OBSERVATION ON BASE_TABLE.date = DATE_OBSERVATION.date
     JOIN COUNTRY_SPECIFICATIONS ON BASE_TABLE.iso_code = COUNTRY_SPECIFICATIONS.iso_code
     order by COUNTRY_SPECIFICATIONS.iso_code);


-- Inserta el conjunto de datos de las vacunas en la tabla
-- VACCINATIONS
INSERT INTO VACCINATIONS(
     total_vaccinations,
     people_vaccinated,
     people_fully_vaccinated,
     total_boosters,
     new_vaccinations,
     new_vaccinations_smoothed,
     total_vaccinations_per_hundred,
     people_fully_vaccinated_per_hundred,
     total_boosters_per_hundred,
     new_vaccinations_smoothed_per_million,
     new_people_vaccinated_smoothed,
     new_people_vaccinated_smoothed_per_hundred,
     date_obs_id, 
     country_id)
     (SELECT 
     total_vaccinations,
     people_vaccinated,
     people_fully_vaccinated,
     total_boosters,
     new_vaccinations,
     new_vaccinations_smoothed,
     total_vaccinations_per_hundred,
     people_fully_vaccinated_per_hundred,
     total_boosters_per_hundred,
     new_vaccinations_smoothed_per_million,
     new_people_vaccinated_smoothed,
     new_people_vaccinated_smoothed_per_hundred,
     DATE_OBSERVATION.date_obs_id, 
     COUNTRY_SPECIFICATIONS.country_id
     from BASE_TABLE
     JOIN DATE_OBSERVATION ON BASE_TABLE.date = DATE_OBSERVATION.date
     JOIN COUNTRY_SPECIFICATIONS ON BASE_TABLE.iso_code = COUNTRY_SPECIFICATIONS.iso_code
     order by COUNTRY_SPECIFICATIONS.iso_code);
