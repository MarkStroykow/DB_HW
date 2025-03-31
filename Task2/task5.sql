
-- Задача 5
-- Условие

-- Определить, какие классы автомобилей имеют наибольшее количество автомобилей с низкой средней позицией (больше 3.0)
-- и вывести информацию о каждом автомобиле из этих классов, включая его имя, класс, среднюю позицию, количество гонок,
-- в которых он участвовал, страну производства класса автомобиля, а также общее количество гонок для каждого класса.
-- Отсортировать результаты по количеству автомобилей с низкой средней позицией.

WITH avg_results AS (
	SELECT class AS car_class, name as car_name, AVG(position) AS average_position, count(*) AS race_count
	FROM results INNER JOIN cars ON (results.car = cars.name)
	GROUP BY cars.name
),

classes_required AS (
	SELECT car_class, COUNT(*) as low_position_count
	FROM (
		SELECT * FROM avg_results
		WHERE average_position > 3 
	)
	GROUP BY car_class
	ORDER BY COUNT(*)
),

races_count_for_class AS (
	SELECT car_class, COUNT(*) as total_races
	FROM avg_results
	GROUP BY car_class
)

select car_name, cwlap.car_class, average_position, race_count, country as car_country, total_races, low_position_count
from classes_required as cr
	INNER JOIN avg_results as cwlap ON (cr.car_class = cwlap.car_class)
	INNER JOIN classes ON (cr.car_class = classes.class)
	INNER JOIN races_count_for_class as rcfc ON (cr.car_class = rcfc.car_class)
ORDER BY low_position_count
