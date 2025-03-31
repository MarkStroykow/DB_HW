-- Задача 1
-- Условие

-- Найдите производителей (maker) и модели всех мотоциклов, 
-- которые имеют мощность более 150 лошадиных сил, стоят менее 20 тысяч долларов и являются спортивными (тип Sport). 
-- Также отсортируйте результаты по мощности в порядке убывания.

SELECT maker, vehicle.model
FROM vehicle INNER JOIN  (
	SELECT model, horsepower 
	FROM motorcycle
	WHERE horsepower > 150
		AND price < 20000
		AND type = 'Sport'
	)  AS h ON (vehicle.model=h.model)
ORDER BY horsepower;