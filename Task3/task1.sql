-- Задача 1
-- Условие

-- Определить, какие клиенты сделали более двух бронирований в разных отелях, и вывести информацию о каждом таком клиенте,
-- включая его имя, электронную почту, телефон, общее количество бронирований, а также список отелей,
-- в которых они бронировали номера (объединенные в одно поле через запятую с помощью CONCAT).
-- Также подсчитать среднюю длительность их пребывания (в днях) по всем бронированиям. Отсортировать результаты по количеству бронирований в порядке убывания.

SELECT customer.name, customer.email, customer.phone, count(*), STRING_AGG(DISTINCT hotel.name, ', '), AVG(check_out_date - check_in_date)
FROM customer
	INNER JOIN booking ON (customer.id_customer = booking.id_customer)
	INNER JOIN room ON (booking.id_room = room.id_room)
	INNER JOIN hotel ON (hotel.id_hotel = room.id_hotel)
	GROUP BY customer.name, customer.email, customer.phone
	HAVING count(hotel.id_hotel) > 2 AND count(DISTINCT hotel.id_hotel) > 1
	ORDER BY count(*) DESC
;