/*
Заполнение базы данных тестовыми данными
*/

/*
 Заполнение регионов тестовыми данными
*/
INSERT INTO areas (name)
SELECT 'Area ' || g FROM generate_series(1, 20) g;

/*
 Заполнение специализаций
*/
INSERT INTO specializations (name)
SELECT 'Spec ' || g FROM generate_series(1, 10) g;

/*
 Заполнение работодателей
*/
INSERT INTO employers (name)
SELECT 'Employer ' || g FROM generate_series(1, 500) g;

/*
 Заполнение соискателей (100 000 записей)
*/
INSERT INTO applicants (full_name)
SELECT 'Applicant ' || g FROM generate_series(1, 100000) g;

/*
 Заполнение 10 000 вакансий
 случайные регионы, работодатели, зарплаты и даты
*/
INSERT INTO vacancies (
    title,
    description,
    area_id,
    employer_id,
    specialization_id,
    compensation_from,
    compensation_to,
    published_at
)
SELECT
    'Vacancy ' || g,
    'Description ' || g,
    (random()*19+1)::int,
    (random()*499+1)::int,
    (random()*9+1)::int,
    (random()*100000)::int,
    (random()*200000 + 100000)::int,
    now() - (random()*365 || ' days')::interval
FROM generate_series(1,10000) g;

/*
 Заполнение 100 000 резюме
*/
INSERT INTO resumes (
    applicant_id,
    specialization_id,
    area_id,
    salary_expectation,
    created_at
)
SELECT
    id,
    (random()*9+1)::int,
    (random()*19+1)::int,
    (random()*200000)::int,
    now() - (random()*365 || ' days')::interval
FROM applicants;

/*
 Генерация 200 000 откликов
*/
INSERT INTO responses (
    vacancy_id,
    resume_id,
    responded_at
)
SELECT
    (random()*9999+1)::int,
    (random()*99999+1)::int,
    now() - (random()*365 || ' days')::interval
FROM generate_series(1,200000)
ON CONFLICT (vacancy_id, resume_id) DO NOTHING;


UPDATE responses r
SET responded_at = GREATEST(v.published_at, res.created_at)
    + (random() * interval '30 days')
FROM vacancies v, resumes res
WHERE r.vacancy_id = v.id
  AND r.resume_id = res.id;