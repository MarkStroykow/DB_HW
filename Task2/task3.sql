-- Задача 3
-- Условие

-- Определить классы автомобилей, которые имеют наименьшую среднюю позицию в гонках, и вывести информацию о каждом автомобиле из этих классов, 
-- включая его имя, среднюю позицию, количество гонок, в которых он участвовал, страну производства класса автомобиля, а также общее количество гонок,
-- в которых участвовали автомобили этих классов. Если несколько классов имеют одинаковую среднюю позицию, выбрать все из них.

WITH avg_results AS (
	SELECT class AS car_class, name as car_name, AVG(position) AS average_position, count(*) AS race_count
	FROM results RIGHT JOIN cars ON (results.car = cars.name)
	GROUP BY name
),
classes_required AS (
	SELECT car_class, count(*) as total_races
	FROM (
		SELECT car_name, car_class, average_position, race_count, country AS car_country
		FROM avg_results INNER JOIN classes ON (avg_results.car_class = classes.class)
			INNER JOIN (SELECT min(average_position) as min_avg FROM avg_results) AS minimal 
			ON (minimal.min_avg = avg_results.average_position)
	)
	GROUP BY car_class
)


SELECT car_name, avg_results.car_class, average_position, race_count, country as car_country, total_races
FROM  classes_required 
	INNER JOIN avg_results ON (classes_required.car_class=avg_results.car_class)
	INNER JOIN classes ON (classes_required.car_class = classes.class)