/* The original job_posted_date column is in timestamp datatype (date/time). */


/* To select only the date */
SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date::DATE AS date_time
FROM job_postings_fact
LIMIT 5;

/* To add the time zone as well */
SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time
FROM job_postings_fact
LIMIT 5;

/* EXTRACT - gets fields (e.g., year, month, day) from a date/time value */
SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time,
    EXTRACT(MONTH FROM job_posted_date) AS date_month,
    EXTRACT(YEAR FROM job_posted_date) AS date_year
FROM job_postings_fact
LIMIT 5;

/* Finding the number of jobs for each month */
SELECT 
    COUNT(job_id) AS number_of_jobs,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM 
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    month
ORDER BY
    number_of_jobs DESC;


/* Practice exercises */

/* Find the average salary both yearly (salary_year_avg) and hourly (salary_hour_avg) for job postings that were posted after June 1, 2023. Group the results by job schedule type */

SELECT 
    job_schedule_type,
    AVG(salary_year_avg) AS average_yearly_salary,
    AVG(salary_hour_avg) AS average_hourly_salary
FROM job_postings_fact
WHERE
    job_posted_date > '2023-06-01'
GROUP BY
    job_schedule_type;


/* Count the number of job postings for each month in 2023, adjusting the job_posted_date to be in 'America/New_York' time zone before extracting (hint) the month. Assume the job_posted_date is stored in UTC. Group by and order by the month. */

SELECT 
    COUNT(job_id) AS number_of_job_postings,
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') AS months_in_2023
FROM 
    job_postings_fact
WHERE 
    job_posted_date > '2022-12-31' AND job_posted_date < '2024-01-01'
GROUP BY
    months_in_2023
ORDER BY
    months_in_2023;


/* Find the companies (include company names) that have posted jobs offering health insurance, where these postings were made in the second quarter of 2023. Use date extraction to filter by quartar */

SELECT DISTINCT 
    company.name AS companies_that_offer_health_insurance_2023,
    -- job_health_insurance AS health_insurance,
    -- job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York' AS date
FROM 
    job_postings_fact AS job_postings
LEFT JOIN 
    company_dim AS company ON job_postings.company_id = company.company_id
WHERE
    job_postings.job_health_insurance = TRUE AND
    EXTRACT(YEAR FROM job_posted_date) = 2023 AND 
    EXTRACT(QUARTER FROM job_posted_date) = 2;
