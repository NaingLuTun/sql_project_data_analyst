/* CASE expression is a way to apply conditinal logic within your SQL quries */

SELECT 
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact
WHERE 
    job_title_short = 'Data Analyst'
GROUP BY
    location_category;

-- Practice problem

/* I want to categorize the salaries from each job postings. To see if it fits in my desire salary range.

- Put salary into different buckets
- Define what's a high, standard, or low salary with our own conditions
- Why? It is easy to determine which job postings are worth looking at based on salary. Bucketing is a common practice in data analysis when viewing categories.
- I only want to look at data analyst roles
- Order from highest to lowest
 */

SELECT
    CASE
        WHEN salary_year_avg < 54000 THEN 'low_salary'
        WHEN salary_year_avg >= 54000 AND salary_year_avg <= 87000 THEN 'standard_salary'
        ELSE 'high_salary'
    END AS salary_range,
    COUNT(job_id) AS number_of_data_analyst_jobs
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    salary_range
ORDER BY
    number_of_data_analyst_jobs DESC;
    
-- ORDER BY salary_range
/* 
ORDER BY
    CASE
        WHEN salary_range = 'high_salary' THEN 1
        WHEN salary_range = 'standard_salary' THEN 2
        WHEN salary_range = 'low_salary' THEN 3
    END DESC;
 */

