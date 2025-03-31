-- Задача 2
-- Условие

-- Определить автомобиль, который имеет наименьшую среднюю позицию в гонках среди всех автомобилей,
-- и вывести информацию об этом автомобиле, включая его класс, среднюю позицию, количество гонок, в которых он участвовал,
-- и страну производства класса автомобиля. Если несколько автомобилей имеют одинаковую наименьшую среднюю позицию, выбрать один из них по алфавиту (по имени автомобиля).

WITH avg_results AS (
	SELECT class AS car_class, name as car_name, AVG(position) AS average_position, count(*) AS race_count
	FROM results INNER JOIN cars ON (results.car = cars.name)
	GROUP BY name
)
SELECT car_name, car_class, average_position, race_count, country AS car_country
FROM avg_results INNER JOIN classes ON (avg_results.car_class = classes.class)
	INNER JOIN (SELECT min(average_position) as min_avg FROM avg_results) AS minimal 
	ON (minimal.min_avg = avg_results.average_position)
ORDER BY car_name 
LIMIT 1