/*
 Вакансии, получившие больше 5 откликов
 в первую неделю после публикации
*/
SELECT
    v.id,
    v.title
FROM vacancies v
         JOIN responses r ON r.vacancy_id = v.id
WHERE r.responded_at >= v.published_at
  AND r.responded_at <= v.published_at + interval '7 days'
GROUP BY v.id, v.title
HAVING COUNT(r.id) > 5;