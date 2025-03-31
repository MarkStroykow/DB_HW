-- Задача 2
-- Условие

-- Необходимо провести анализ клиентов, которые сделали более двух бронирований в разных отелях и потратили более 500 долларов на свои бронирования. Для этого:

-- Определить клиентов, которые сделали более двух бронирований и забронировали номера в более чем одном отеле. 
-- Вывести для каждого такого клиента следующие данные: 
-- ID_customer, имя, общее количество бронирований, общее количество уникальных отелей, в которых они бронировали номера, и общую сумму, потраченную на бронирования.

-- Также определить клиентов, которые потратили более 500 долларов на бронирования, и вывести для них ID_customer, имя, общую сумму,
-- потраченную на бронирования,и общее количество бронирований.

-- В результате объединить данные из первых двух пунктов, чтобы получить список клиентов, которые соответствуют условиям обоих запросов. 
-- Отобразить поля: ID_customer, имя, общее количество бронирований, общую сумму, потраченную на бронирования, и общее количество уникальных отелей.

-- Результаты отсортировать по общей сумме, потраченной клиентами, в порядке возрастания.

WITH all_data AS (
	SELECT customer.id_customer, customer.name, check_in_date, check_out_date, price, hotel.id_hotel
	FROM customer
		INNER JOIN booking on (customer.id_customer = booking.id_customer)
		INNER JOIN room on (booking.id_room = room.id_room)
		INNER JOIN hotel on (hotel.id_hotel = room.id_hotel)
)

SELECT id_customer, name, count(*) AS total_bookings,
	SUM((check_out_date - check_in_date) * price) AS total_spent,
	COUNT(DISTINCT id_hotel) AS unique_hotels
FROM all_data
GROUP BY all_data.id_customer, all_data.name
HAVING count(id_hotel) > 2 AND count(DISTINCT id_hotel) > 1
UNION ALL
SELECT id_customer, name,
	count(*) AS total_bookings,
	SUM((check_out_date - check_in_date) * price) AS total_spent,
	COUNT(DISTINCT id_hotel) AS unique_hotels
FROM all_data
	GROUP BY all_data.id_customer, all_data.name 
	HAVING SUM((check_out_date - check_in_date) * price) > 500
ORDER BY total_spent