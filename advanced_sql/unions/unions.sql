/* 
    UNION - combines result from two or more SELECT statements
          - they need to have the same amount of columns, and the data type must match
          - gets rid of duplicate rows (unlike UNIONS ALL)
 */

 /* 
    UNION ALL - combines result from two or more SELECT statements
              - they need to have the same amount of columns, and the data type must match
              - returns all rows, even duplicates (unlike UNION)
  */

-- Exercise

/* 
    Find job postings from the first quarter that have a salary greater than $70k
    
    - Combine job posting tables from the first quarter of 2023 (Jan - Mar)
    - Gets job postings with an average yearly salary > $70,000
 */

SELECT 
    job_title_short,
    job_location,
    job_via,
    job_posted_date
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
WHERE 
    salary_year_avg > 70000 AND job_title_short = 'Data Analyst';