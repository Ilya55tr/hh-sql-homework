/*
 Месяц с наибольшим количеством вакансий
*/
SELECT
    date_trunc('month', published_at) AS month,
    COUNT(*) AS total
FROM vacancies
GROUP BY month
ORDER BY total DESC
LIMIT 1;

/*
 Месяц с наибольшим количеством резюме
*/
SELECT
    date_trunc('month', created_at) AS month,
    COUNT(*) AS total
FROM resumes
GROUP BY month
ORDER BY total DESC
LIMIT 1;