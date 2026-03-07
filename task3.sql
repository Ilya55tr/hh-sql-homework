/*
 Поиск средних зарплат по регионам
*/
EXPLAIN ANALYZE
SELECT
    area_id,
    AVG(COALESCE(compensation_from, compensation_to)) AS avg_from,
    AVG(COALESCE(compensation_to, compensation_from)) AS avg_to,
    AVG(
            (
                COALESCE(compensation_from, compensation_to) +
                COALESCE(compensation_to, compensation_from)
                ) / 2.0
    ) AS avg_middle
FROM vacancies
GROUP BY area_id
ORDER BY area_id;



