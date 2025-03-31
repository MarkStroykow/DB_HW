-- Задача 1
-- Условие

-- Определить, какие автомобили из каждого класса имеют наименьшую среднюю позицию в гонках, 
-- и вывести информацию о каждом таком автомобиле для данного класса, включая его класс, 
-- среднюю позицию и количество гонок, в которых он участвовал. Также отсортировать результаты по средней позиции.

WITH avg_results AS (
	SELECT class, name, AVG(position) AS average_position, count(*) AS race_count
	FROM results INNER JOIN cars ON (results.car = cars.name)
	GROUP BY name
)
SELECT name AS car_name, positons.class AS car_class, average_position, race_count
FROM (
	SELECT class, min(average_position) AS min_avg FROM avg_results
	GROUP BY class
	) AS positons
	INNER JOIN avg_results 
	ON (positons.class = avg_results.class AND positons.min_avg = avg_results.average_position)
ORDER BY average_position;