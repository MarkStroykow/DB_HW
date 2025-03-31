-- Задача 3
-- Условие

-- Вам необходимо провести анализ данных о бронированиях в отелях и определить предпочтения клиентов по типу отелей. Для этого выполните следующие шаги:

-- Категоризация отелей.
-- Определите категорию каждого отеля на основе средней стоимости номера:

-- «Дешевый»: средняя стоимость менее 175 долларов.
-- «Средний»: средняя стоимость от 175 до 300 долларов.
-- «Дорогой»: средняя стоимость более 300 долларов.
-- Анализ предпочтений клиентов.
-- Для каждого клиента определите предпочитаемый тип отеля на основании условия ниже:

-- Если у клиента есть хотя бы один «дорогой» отель, присвойте ему категорию «дорогой».
-- Если у клиента нет «дорогих» отелей, но есть хотя бы один «средний», присвойте ему категорию «средний».
-- Если у клиента нет «дорогих» и «средних» отелей, но есть «дешевые», присвойте ему категорию предпочитаемых отелей «дешевый».
-- Вывод информации.
-- Выведите для каждого клиента следующую информацию:

-- ID_customer: уникальный идентификатор клиента.
-- name: имя клиента.
-- preferred_hotel_type: предпочитаемый тип отеля.
-- visited_hotels: список уникальных отелей, которые посетил клиент.
-- Сортировка результатов.
-- Отсортируйте клиентов так, чтобы сначала шли клиенты с «дешевыми» отелями, затем со «средними» и в конце — с «дорогими».


WITH categories AS (
    SELECT hotel.ID_hotel,
        CASE
            WHEN AVG(room.price) < 175 THEN 'Дешевый'
            WHEN AVG(room.price) BETWEEN 175 AND 300 THEN 'Средний'
            WHEN AVG(room.price) > 300 THEN 'Дорогой'
        END AS hotel_category
    FROM 
		hotel
			INNER JOIN room ON (hotel.ID_hotel = room.ID_hotel)
    GROUP BY hotel.ID_hotel
),
preferences AS (
    SELECT 
        booking.ID_customer,
        MAX(CASE 
            WHEN categories.hotel_category = 'Дорогой' THEN 'Дорогой'
            WHEN categories.hotel_category = 'Средний' THEN 'Средний'
            WHEN categories.hotel_category = 'Дешевый' THEN 'Дешевый'
            ELSE NULL
        END) AS preferred_hotel_type,
        STRING_AGG(DISTINCT hotel.name, ', ') AS visited_hotels
    FROM booking 
    	INNER JOIN room ON (booking.ID_room = room.ID_room)
    	INNER JOIN hotel ON (room.ID_hotel = hotel.ID_hotel)
    	INNER JOIN categories ON (hotel.ID_hotel = categories.ID_hotel)
    GROUP BY booking.ID_customer
)

SELECT 
    preferences.ID_customer,
	customer.name,
    preferences.preferred_hotel_type,
    preferences.visited_hotels
FROM preferences
JOIN customer ON (preferences.ID_customer = customer.ID_customer)
ORDER BY 
    CASE preferences.preferred_hotel_type
        WHEN 'Дешевый' THEN 1
        WHEN 'Средний' THEN 2
        WHEN 'Дорогой' THEN 3
    END;