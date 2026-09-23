-- CTEs (common table expressions)

-- Can reference within a SELECT, INSERT, UPDATE, or DELETE statement
-- DEFINED with WITH

WITH january_jobs AS ( -- CTE definition starts here
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
    -- CTE definition ends here
)


SELECT * FROM january_jobs;


-- Exercise

/* 
    Find the companies that have the most job openings.

    - get the total number of job postings per company id (job_postings_fact)

    - return the total number of jobs with the company name (company_dim)
 */

WITH company_job_count AS (
    SELECT 
        company_id,
        COUNT(*) AS total_jobs
    FROM 
        job_postings_fact
    GROUP BY
        company_id
)


SELECT 
    company_dim.company_id,
    company_dim.name as company_name,
    company_job_count.total_jobs
FROM company_dim
LEFT JOIN company_job_count ON company_job_count.company_id = company_dim.company_id
ORDER BY
    company_job_count.total_jobs DESC
;

/* Wtih no CTEs */
SELECT
    company_dim.name AS company_name,
    COUNT(*) as total_jobs
FROM company_dim
LEFT JOIN job_postings_fact ON job_postings_fact.company_id = company_dim.company_id
GROUP BY
    company_name
ORDER BY
    total_jobs DESC;



-- Exercise 2

/* 
    Find the count of the number of remote data analyst job postings per skill

    - Display the top 5 skills by their demand in remote jobs

    - Include skill ID, name, and count of postings requiring the skill
 */

WITH remote_job_skills AS (
    SELECT 
        skill_id,
        COUNT(*) AS job_count
    FROM skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact AS job_postings ON job_postings.job_id = skills_to_job.job_id
    WHERE
        job_postings.job_work_from_home = True AND job_title_short = 'Data Analyst'
    GROUP BY
        skill_id
)

SELECT
    remote_job_skills.skill_id,
    skills.skills ,
    remote_job_skills.job_count
FROM remote_job_skills
INNER JOIN skills_dim as skills ON skills.skill_id = remote_job_skills.skill_id
ORDER BY
    remote_job_skills.job_count DESC
LIMIT 5;

SELECT DISTINCT skill_id from skills_job_dim;
