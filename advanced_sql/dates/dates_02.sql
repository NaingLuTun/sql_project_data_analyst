/* In these query context, AS is used to copy data from the select query's result. */

CREATE TABLE january_jobs AS
    SELECT * FROM job_postings_fact WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

CREATE TABLE february_jobs AS
    SELECT * FROM job_postings_fact WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

CREATE TABLE march_jobs AS
    SELECT * FROM job_postings_fact WHERE EXTRACT(MONTH FROM job_posted_date) = 3;