-- Tablas para cada conjunto de datos relacionados


-- Si las tablas existen se eliminan
DROP TABLE IF EXISTS CONFIRMED_CASES;
DROP TABLE IF EXISTS CONFIRMED_DEATHS;
DROP TABLE IF EXISTS EXCESS_MORTALITY;
DROP TABLE IF EXISTS HOSPITAL_ICU;
DROP TABLE IF EXISTS POLICY_RESPONSES(;
DROP TABLE IF EXISTS REPRODUCTION_RATE;
DROP TABLE IF EXISTS TESTS_POSITIVITY;
DROP TABLE IF EXISTS VACCINATIONS;
DROP TABLE IF EXISTS DATE_OBSERVATION;
DROP TABLE IF EXISTS COUNTRY_SPECIFICATIONS;


-- Casos confirmados
CREATE TABLE CONFIRMED_CASES(
        conf_case_id SERIAL PRIMARY KEY,
        total_cases DECIMAL,
        new_cases DECIMAL,
        new_cases_smoothed DECIMAL,
        total_cases_per_million DECIMAL,
        new_cases_per_million DECIMAL,
        new_cases_smoothed_per_million DECIMAL
);


-- Muertes confirmadas
CREATE TABLE CONFIRMED_DEATHS(
        conf_death_id SERIAL PRIMARY KEY,
        total_deaths DECIMAL,
        new_deaths DECIMAL,
        new_deaths_smoothed DECIMAL,
        total_deaths_per_million DECIMAL,
        new_deaths_per_million DECIMAL,
        new_deaths_smoothed_per_million DECIMAL,
);


-- Exceso de mortalidad
CREATE TABLE EXCESS_MORTALITY(
        xs_mort_id SERIAL PRIMARY KEY,
        excess_mortality DECIMAL,
        excess_mortality_cumulative DECIMAL,
        excess_mortality_absolute DECIMAL,
        excess_motality_cumulative_per_million DECIMAL
);


-- Hospital y Unidad de Cuidados Intensivos
CREATE TABLE HOSPITAL_ICU(
        hosp_icu_id SERIAL PRIMARY KEY,
        icu_patients DECIMAL,
        icu_patients_per_million DECIMAL,
        hosp_patients DECIMAL,
        hosp_patients_per_million DECIMAL,
        weekly_icu_admissions DECIMAL,
        weekly_icu_admissions_per_million DECIMAL,
        weekly_hosp_admissions DECIMAL,
        weekly_hosp_admissions_per_million DECIMAL
);


-- Respuestas políticas
CREATE TABLE POLICY_RESPONSES(
        policy_resp_id SERIAL PRIMARY KEY,
        strindency_index DECIMAL
);


-- Tasa de reproduccion
CREATE TABLE REPRODUCTION_RATE(
        reprod_rate_id SERIAL PRIMARY KEY,
        reproduction_rate DECIMAL
);


-- Pruebas y positividad
CREATE TABLE TESTS_POSITIVITY(
        test_post_id SERIAL PRIMARY KEY,
        total_tests DECIMAL,
        new_tests DECIMAL,
        total_tests_per_thousand DECIMAL,
        new_tests_per_thousand DECIMAL,
        new_tests_smoothed DECIMAL,
        new_tests_smoothed_per_thousand DECIMAL,
        positive_rate DECIMAL,
        tests_per_case DECIMAL,
        tests_units varchar(30) 
);


-- Vacunas
CREATE TABLE VACCINATIONS(
        vaccine_id SERIAL PRIMARY KEY,
        total_vaccinations DECIMAL,
        people_vaccinated DECIMAL,
        people_fully_vaccinated DECIMAL,
        total_boosters DECIMAL,
        new_vaccinations DECIMAL,
        new_vaccinations_smoothed DECIMAL,
        total_vaccinations_smoothed DECIMAL,
        total_vaccinations_per_hundred DECIMAL,
        people_fully_vaccinated_per_hundred DECIMAL,
        total_boosters_per_hundred DECIMAL,
        new_vaccinations_smoothed_per_million DECIMAL,
        new_people_vaccinated_smoothed DECIMAL,
        new_people_vaccinated_smoothed_per_hundred DECIMAL
);


-- Tabla intermediara entre el p-enesimo pais y su conjuntos de datos
-- en la f-enesima fecha de observacion 
CREATE DATE_OBSERVATION(
        date_obs_id SERIAL PRIMARY KEY,
        date DATE
);


-- Carecteristicas/especificaciones de los paises
CREATE COUNTRY_SPECIFICATIONS(
        country_id SERIAL PRIMARY KEY,
        iso_code varchar(15),
        continent varchar(150),
        location varchar(150),
        population DECIMAL,
        population_density DECIMAL,
        median_age DECIMAL,
        aged_65_older DECIMAL,
        aged_70_older DECIMAL,
        gdp_per_capita DECIMAL,
        extreme_poverty DECIMAL,
        cardiovasc_death_rate DECIMAL,
        diabetes_prevalence DECIMAL,
        female_smokers DECIMAL,
        male_smokers DECIMAL,
        handwashing_facilities DECIMAL,
        hospital_beds_per_thousand DECIMAL,
        life_expectancy DECIMAL,
        human_development_index DECIMAL
);        


-- Anade las relaciones de cada conjunto de datos con su
-- fecha de observacion


-- Relación entre DATE_OBSERVATION y CONFIRMED_CASES
ALTER TABLE CONFIRMED_CASES 
        ADD COLUMN date_obs_id INTEGER;

ALTER TABLE CONFIRMED_CASES 
        ADD CONSTRAINT fk_confirmed_cases_date_obs 
        FOREIGN KEY (date_obs_id) 
        REFERENCES DATE_OBSERVATION (date_obs_id);


-- Relación entre DATE_OBSERVATION y CONFIRMED_DEATHS
ALTER TABLE CONFIRMED_DEATHS
        ADD COLUMN date_obs_id INTEGER;

ALTER TABLE CONFIRMED_DEATHS
        ADD CONSTRAINT fk_confirmed_deaths_date_obs
        FOREIGN KEY (date_obs_id) 
        REFERENCES DATE_OBSERVATION (date_obs_id);


-- Relación entre DATE_OBSERVATION y EXCESS_MORTALITY
ALTER TABLE EXCESS_MORTALITY
        ADD COLUMN date_obs_id INTEGER;

ALTER TABLE EXCESS_MORTALITY
        ADD CONSTRAINT fk_excess_mortality_date_obs
        FOREIGN KEY (date_obs_id) 
        REFERENCES DATE_OBSERVATION (date_obs_id);


-- Relación entre DATE_OBSERVATION y HOSPITAL_ICU
ALTER TABLE HOSPITAL_ICU
        ADD COLUMN date_obs_id INTEGER;

ALTER TABLE HOSPITAL_ICU 
        ADD CONSTRAINT fk_hospital_icu_date_obs
        FOREIGN KEY (date_obs_id) 
        REFERENCES DATE_OBSERVATION (date_obs_id);


-- Relación entre DATE_OBSERVATION y POLICY_RESPONSES
ALTER TABLE POLICY_RESPONSES
        ADD COLUMN date_obs_id INTEGER;

ALTER TABLE POLICY_RESPONSES
        ADD CONSTRAINT fk_policy_responses_date_obs
        FOREIGN KEY (date_obs_id) 
        REFERENCES DATE_OBSERVATION (date_obs_id);


-- Relación entre DATE_OBSERVATION y REPRODUCTION_RATE
ALTER TABLE REPRODUCTION_RATE
        ADD COLUMN date_obs_id INTEGER;

ALTER TABLE REPRODUCTION_RATE 
        ADD CONSTRAINT fk_reproduction_rate_date_obs
        FOREIGN KEY (date_obs_id) 
        REFERENCES DATE_OBSERVATION (date_obs_id);


-- Relación entre DATE_OBSERVATION y TESTS_POSITIVITY
ALTER TABLE TESTS_POSITIVITY
        ADD COLUMN date_obs_id INTEGER;

ALTER TABLE TESTS_POSITIVITY 
        ADD CONSTRAINT fk_tests_positivity_date_obs
        FOREIGN KEY (date_obs_id) 
        REFERENCES DATE_OBSERVATION (date_obs_id);


-- Relación entre DATE_OBSERVATION y VACCINATIONS
ALTER TABLE VACCINATIONS 
        ADD COLUMN date_id INTEGER;

ALTER TABLE VACCINATIONS 
        ADD CONSTRAINT fk_vaccinations_date_obs
        FOREIGN KEY (date_obs_id) REFERENCES
        DATE_OBSERVATION (date_obs_id);


-- Anade las relaciones de cada pais con cada conjunto de datos


-- Relacion entre COUNTRY_SPECIFICATION y CONFIRMED_CASES
ALTER TABLE CONFIRMED_CASES ADD COLUMN country_id INTEGER;
ALTER TABLE CONFIRMED_CASES 
        ADD CONSTRAINT fk_confirmed_cases_country_id 
        FOREIGN KEY (country_id) 
        REFERENCES COUNTRY_SPECIFICATIONS (country_id);


-- Relacion entre COUNTRY_SPECIFICATION y CONFIRMED_DEATHS
ALTER TABLE CONFIRMED_DEATHS ADD COLUMN country_id INTEGER;
ALTER TABLE CONFIRMED_DEATHS 
        ADD CONSTRAINT fk_confirmed_deaths_country_id 
        FOREIGN KEY (country_id) 
        REFERENCES COUNTRY_SPECIFICATIONS (country_id);


-- Relacion entre COUNTRY_SPECIFICATION y EXCESS_MORTALITY
ALTER TABLE EXCESS_MORTALITY ADD COLUMN country_id INTEGER;
ALTER TABLE EXCESS_MORTALITY 
        ADD CONSTRAINT fk_excess_mortality_country_id 
        FOREIGN KEY (country_id) 
        REFERENCES COUNTRY_SPECIFICATIONS (country_id);


-- Relacion entre COUNTRY_SPECIFICATION y HOSPITAL_ICU
ALTER TABLE HOSPITAL_ICU ADD COLUMN country_id INTEGER;
ALTER TABLE HOSPITAL_ICU 
        ADD CONSTRAINT fk_hospital_icu_country_id 
        FOREIGN KEY (country_id) 
        REFERENCES COUNTRY_SPECIFICATIONS (country_id);


-- Relacion entre COUNTRY_SPECIFICATION y POLICY_RESPONSES
ALTER TABLE POLICY_RESPONSES ADD COLUMN country_id INTEGER;
ALTER TABLE POLICY_RESPONSES 
        ADD CONSTRAINT fk_policy_responses_country_id 
        FOREIGN KEY (country_id) 
        REFERENCES COUNTRY_SPECIFICATIONS (country_id);


-- Relacion entre COUNTRY_SPECIFICATION y REPRODUCTION_RATE
ALTER TABLE REPRODUCTION_RATE ADD COLUMN country_id INTEGER;
ALTER TABLE REPRODUCTION_RATE 
        ADD CONSTRAINT fk_reproduction_rate_country_id 
        FOREIGN KEY (country_id) 
        REFERENCES COUNTRY_SPECIFICATIONS (country_id);


-- Relacion entre COUNTRY_SPECIFICATION y TEST_POSITIVITY
ALTER TABLE TESTS_POSITIVITY ADD COLUMN country_id INTEGER;
        ALTER TABLE TESTS_POSITIVITY 
        ADD CONSTRAINT fk_tests_positivity_country_id 
        FOREIGN KEY (country_id) 
        REFERENCES COUNTRY_SPECIFICATIONS (country_id);
        

-- Relacion entre COUNTRY_SPECIFICATION y VACCINATIONS
ALTER TABLE VACCINATIONS ADD COLUMN country_id INTEGER;
        ALTER TABLE VACCINATIONS 
        ADD CONSTRAINT fk_vaccinations_country_id
        FOREIGN KEY (country_id) 
        REFERENCES COUNTRY_SPECIFICATIONS (country_id);
