/*
создание индексов
 */
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
CREATE INDEX idx_responses_vacancy_responded_at ON responses(vacancy_id, responded_at);