-- Subquries: query nested inside a larger query

-- it can be used in SELECT, FROM, and WHERE clauses.

SELECT * 
FROM (
    SELECT * 
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) AS january_jobs;

-- Exercises
-- get a list of company names that are offering jobs that don't have any requirements for a degree

SELECT
    company_id,
    name AS company_name
FROM 
    company_dim
WHERE 
    company_id IN ( -- subquery starts here
        SELECT 
            company_id
        FROM
            job_postings_fact
        WHERE
            job_no_degree_mention = true
        ORDER BY
            company_id
        -- subquery ends here
    );


/* 
    Find job postings from the first quarter that have a salary greater than $70K
    - Combine job posting tables from the first quarter of 2023 (Jan-Mar)
    - Gets job postings with an average yearly salary > $70,000
 */

SELECT 
    job_title_short,
    job_location,
    job_via,
    job_posted_date::date,
    salary_year_avg
FROM (
    SELECT * 
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
    ) AS quarter1_job_postings
WHERE salary_year_avg > 70000 AND job_title_short = 'Data Analyst'
ORDER BY salary_year_avg DESC;