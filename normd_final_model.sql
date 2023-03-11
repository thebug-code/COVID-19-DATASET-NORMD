-- Tablas para cada conjunto de datos relacionados

-- Casos confirmados
CREATE TABLE CONFIRMED_CASES(
        total_cases DECIMAL,
        new_cases DECIMAL,
        new_cases_smoothed DECIMAL,
        total_cases_per_million DECIMAL,
        new_cases_per_million DECIMAL,
        new_cases_smoothed_per_million DECIMAL
);


-- Muertes confirmadas
CREATE TABLE CONFIRMED_DEATHS(
        total_deaths DECIMAL,
        new_deaths DECIMAL,
        new_deaths_smoothed DECIMAL,
        total_deaths_per_million DECIMAL,
        new_deaths_per_million DECIMAL,
        new_deaths_smoothed_per_million DECIMAL
);


-- Exceso de mortalidad
CREATE TABLE EXCESS_MORTALITY(
        excess_mortality DECIMAL,
        excess_mortality_cumulative DECIMAL,
        excess_mortality_absolute DECIMAL,
        excess_motality_cumulative_per_million DECIMAL,
);


-- Hospital y Unidad de Cuidados Intensivos
CREATE TABLE HOSPITAL_ICU(
        icu_patients DECIMAL,
        icu_patients_per_million DECIMAL,
        hosp_patients DECIMAL,
        hosp_patients_per_million DECIMAL,
        weekly_icu_admissions DECIMAL,
        weekly_icu_admissions_per_million DECIMAL,
        weekly_hosp_admissions DECIMAL,
        weekly_hosp_admissions_per_million DECIMAL,
);


-- Respuestas políticas
CREATE TABLE POLICY_RESPONSES(
        strindency_index DECIMAL
);


-- Tasa de reproduccion
CREATE TABLE REPRODUCTION_RATE(
        reproduction_rate DECIMAL
);

-- Pruebas y positividad
CREATE TABLE TESTS_POSITIVITY(
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
        date DATE
);


-- Carecteristicas/especificaciones de los paises
CREATE COUNTRY_SPECIFICATIONS(
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
