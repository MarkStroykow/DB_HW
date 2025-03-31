-- Задача 4
-- Условие

-- Определить, какие автомобили имеют среднюю позицию лучше (меньше) средней позиции всех автомобилей в своем классе
-- (то есть автомобилей в классе должно быть минимум два, чтобы выбрать один из них). Вывести информацию об этих автомобилях,
-- включая их имя, класс, среднюю позицию, количество гонок, в которых они участвовали, и страну производства класса автомобиля. 
-- Также отсортировать результаты по классу и затем по средней позиции в порядке возрастания.

WITH avg_results_for_car AS (
	SELECT class AS car_class, name as car_name, AVG(position) AS average_position, count(*) AS race_count
	FROM results INNER JOIN cars ON (results.car = cars.name)
	GROUP BY cars.name
),

avg_results_for_class AS (
	SELECT cars.class AS car_class, AVG(position) AS average_position
	FROM results INNER JOIN cars ON (results.car = cars.name)
	GROUP BY cars.class
	HAVING COUNT(DISTINCT cars.name) > 1
)

SELECT car_name, cars.car_class, cars.average_position, cars.race_count, country as car_country
FROM avg_results_for_class AS arfc
	INNER JOIN avg_results_for_car as cars ON (arfc.car_class = cars.car_class)
	INNER JOIN classes ON (cars.car_class = classes.class)
	WHERE arfc.average_position > cars.average_position