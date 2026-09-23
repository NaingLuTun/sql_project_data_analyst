# Data Analyst Job Market Analysis
## Introduction

This project analyzes Data Analyst job postings to identify the skills, salaries, and opportunities associated with the role. The analysis focuses on understanding which skills are most in demand, which skills are associated with higher salaries, and which skills may provide a strong combination of demand and earning potential.

The project answers five main questions:

1. What are the top-paying jobs for Data Analysts?

2. What skills are required for these top-paying jobs?

3. What are the most in-demand skills for Data Analysts?

4. What are the top skills based on salary?

5. What are the most optimal skills to learn based on high demand and high salaries?

The goal of this project is to use SQL to explore the Data Analyst job market and gain practical insights that can help guide skill development and career planning.

SQL queries? Check them out here: [project_sql folder](/project_sql/)

## Background

As someone pursuing a career in data analytics, I wanted to better understand what employers are looking for in Data Analyst positions.

Rather than focusing only on general assumptions about the role, I used job posting data to investigate the market directly. I analyzed job titles, salaries, locations, and required skills to identify patterns in demand and compensation.

The analysis focuses primarily on Data Analyst positions and uses remote job postings with reported salaries when comparing demand and salary-related metrics.

## Tools I Used
- **PostgreSQL** — Used to query and analyze the job posting data.

- **SQL** — Used for filtering, joining, grouping, aggregating, sorting, and analyzing the data.

- **VS Code** — Used to write and organize the SQL queries.

- **Git & GitHub** — Used to version-control and host the project.

### SQL Concepts Used

Throughout the project, I practiced and applied:

- SELECT
- WHERE
- INNER JOIN
- LEFT JOIN
- GROUP BY
- HAVING
- ORDER BY
- LIMIT
- COUNT()
- AVG()
- ROUND()
- Common Table Expressions (CTEs)

## The Analysis
### 1. Top-Paying Data Analyst Jobs

The first analysis identifies the top 10 highest-paying Data Analyst positions that are available remotely and have a reported annual salary.

This provides an overview of the highest-paying opportunities in the dataset and includes company names to give additional context about the employers offering these positions.

```sql
 SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    company_dim.name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```

### 2. Skills Required for Top-Paying Jobs

The second analysis takes the top-paying jobs identified in the first query and joins them with their associated skills.

This shows which technologies and tools are required by some of the highest-paying Data Analyst positions.

The results indicate that high-paying positions can require a combination of traditional analytical skills and more technical skills, including Python-related technologies, data platforms, and software development tools.

```sql
WITH top_paying_jobs AS
(
    SELECT
    job_id,
    job_title,
    salary_year_avg,
    company_dim.name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT
    top_paying_jobs.*,
    skills_dim.skills
FROM 
    top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;
```

### 3. Most In-Demand Data Analyst Skills

The third analysis counts how frequently each skill appears across Data Analyst job postings.

The results highlight the skills that appear most frequently in the dataset, providing an indication of which skills are commonly requested by employers.

This helps identify core skills that are frequently associated with Data Analyst positions.

```sql
SELECT 
    skills_dim.skills,
    COUNT(job_postings_fact.job_id) demand_count
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst' AND
    job_postings_fact.job_work_from_home = True AND
    job_postings_fact.salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skills
ORDER BY
    demand_count DESC
LIMIT 5;
```

### 4. Top Skills Based on Salary

The fourth analysis calculates the average salary associated with each skill among Data Analyst positions with reported salaries.

The results show that some of the highest-paying skills are more technical, including technologies related to big data, cloud platforms, data engineering, and software development.

Python's data ecosystem also appears strongly among the higher-paying skills, with technologies such as PySpark, Pandas, NumPy, Jupyter, and Scikit-learn appearing in the results.

```sql
SELECT 
    skills_dim.skills,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst' AND
    job_postings_fact.salary_year_avg IS NOT NULL AND
    job_postings_fact.job_work_from_home = True
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;
```

### 5. Optimal Skills to Learn

The final analysis combines skill demand and salary to identify skills that have both relatively high demand and high average salaries.

I filtered the results to skills appearing in more than 10 job postings and then ordered them primarily by average salary, with demand used as a secondary sorting factor.

This approach helps identify skills that may provide a useful combination of employment demand and earning potential.

```sql
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(job_postings_fact.job_id) as demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
        job_postings_fact.job_title_short = 'Data Analyst' AND
        job_postings_fact.salary_year_avg IS NOT NULL AND
        job_postings_fact.job_work_from_home = True
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(job_postings_fact.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
```

## What I Learned

This project helped me strengthen my practical SQL skills and better understand how SQL can be used to answer real-world business questions.

### Some of the key things I learned include:

- How to join multiple related tables to combine job postings, companies, and skills.

- How GROUP BY and aggregate functions such as COUNT() and AVG() can be used to summarize data.

- The difference between WHERE and HAVING, particularly when filtering aggregated results.

- How Common Table Expressions (CTEs) can break a complex analysis into smaller and more understandable steps.

- How joining a job table with a skills table can produce multiple rows for a single job because one job can require multiple skills.

- How to use SQL to investigate relationships between skill demand and salary.

- The importance of checking the context behind salary averages rather than assuming that a skill directly causes higher salaries.

## Conclusions

The analysis shows that Data Analyst roles require a wide range of technical skills. While core analytical skills remain important, many higher-paying positions are associated with Python, big-data technologies, cloud platforms, and data engineering tools. The results also show that salary and demand can vary significantly between skills.

Overall, this project helped me use SQL to turn job market data into practical insights. It gave me a better understanding of which skills employers commonly request and which skills are associated with higher salaries, helping me make more informed decisions about my own career development.
