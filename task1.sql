/*
Создание таблиц
*/

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
    compensation_from INT,
    compensation_to   INT,
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
    salary_expectation INT,
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
    responded_at TIMESTAMP NOT NULL DEFAULT now(),
    UNIQUE (vacancy_id, resume_id)
);