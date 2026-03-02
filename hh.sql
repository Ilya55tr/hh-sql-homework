/*
 Таблица регионов
 id региона
 название региона
*/
CREATE TABLE areas
(
    id   INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL
);

/*
 Таблица специализаций
 id специализации
 название специализации
*/
CREATE TABLE specializations
(
    id   INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL
);

/*
 Таблица работодателей
 id работодателя
 название компании
*/
CREATE TABLE employers
(
    id   INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL
);

/*
 Таблица соискателей
 id соискателя
 полное имя
*/
CREATE TABLE applicants
(
    id        INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name TEXT NOT NULL
);

/*
 Таблица вакансий
 id вакансии
 название
 описание
 регион
 работодатель
 специализация
 зарплата от
 зарплата до
 дата публикации
*/
CREATE TABLE vacancies
(
    id                BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title             TEXT      NOT NULL,
    description       TEXT,
    area_id           INT REFERENCES areas(id),
    employer_id       INT REFERENCES employers(id),
    specialization_id INT REFERENCES specializations(id),
    compensation_from NUMERIC,
    compensation_to   NUMERIC,
    published_at      TIMESTAMP NOT NULL DEFAULT now()
);

/*
 Таблица резюме
 id резюме
 id соискателя
 специализация
 регион
 ожидаемая зарплата
 дата создания
*/
CREATE TABLE resumes
(
    id                 BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    applicant_id       INT REFERENCES applicants(id),
    specialization_id  INT REFERENCES specializations(id),
    area_id            INT REFERENCES areas(id),
    salary_expectation NUMERIC,
    created_at         TIMESTAMP NOT NULL DEFAULT now()
);

/*
 Таблица откликов
 id отклика
 id вакансии
 id резюме
 дата отклика
*/
CREATE TABLE responses
(
    id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    vacancy_id   BIGINT REFERENCES vacancies(id) ON DELETE CASCADE,
    resume_id    BIGINT REFERENCES resumes(id) ON DELETE CASCADE,
    responded_at TIMESTAMP NOT NULL DEFAULT now()
);

/*
 Индекс по дате публикации
 ускоряет аналитику по месяцам
*/
CREATE INDEX idx_vacancies_published_at ON vacancies(published_at);

/*
 Индекс по дате создания резюме
 ускоряет аналитику по месяцам
*/
CREATE INDEX idx_resumes_created_at ON resumes(created_at);

/*
 Индекс для join по vacancy_id
*/
CREATE INDEX idx_responses_vacancy_id ON responses(vacancy_id);

/*
 Индекс по дате отклика
 ускоряет фильтрацию по первой неделе
*/
CREATE INDEX idx_responses_responded_at ON responses(responded_at);

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
FROM generate_series(1,200000);


/*
 Поиск средних зарплат по регионам
*/
SELECT
    area_id,
    AVG(compensation_from) AS avg_from,
    AVG(compensation_to) AS avg_to,
    AVG((compensation_from + compensation_to)/2.0) AS avg_middle
FROM vacancies
GROUP BY area_id
ORDER BY area_id;

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

/*
 Вакансии, получившие больше 5 откликов
 в первую неделю после публикации
*/
SELECT
    v.id,
    v.title
FROM vacancies v
         JOIN responses r ON r.vacancy_id = v.id
WHERE r.responded_at <= v.published_at + interval '7 days'
GROUP BY v.id, v.title
HAVING COUNT(r.id) > 5;