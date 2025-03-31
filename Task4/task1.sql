-- Задача 1
-- Условие

-- Найти всех сотрудников, подчиняющихся Ивану Иванову (с EmployeeID = 1), включая их подчиненных и подчиненных подчиненных. Для каждого сотрудника вывести следующую информацию:

-- EmployeeID: идентификатор сотрудника.
-- Имя сотрудника.
-- ManagerID: Идентификатор менеджера.
-- Название отдела, к которому он принадлежит.
-- Название роли, которую он занимает.
-- Название проектов, к которым он относится (если есть, конкатенированные в одном столбце через запятую).
-- Название задач, назначенных этому сотруднику (если есть, конкатенированные в одном столбце через запятую).
-- Если у сотрудника нет назначенных проектов или задач, отобразить NULL.
-- Требования:

-- Рекурсивно извлечь всех подчиненных сотрудников Ивана Иванова и их подчиненных.
-- Для каждого сотрудника отобразить информацию из всех таблиц.
-- Результаты должны быть отсортированы по имени сотрудника.
-- Решение задачи должно представлять из себя один sql-запрос и задействовать ключевое слово RECURSIVE.

WITH RECURSIVE subordinates AS (
    SELECT EmployeeID, Name, ManagerID, DepartmentID, RoleID
    FROM 
        Employees
    WHERE 
        ManagerID = 1  
    UNION ALL
    SELECT e.EmployeeID, e.Name,  e.ManagerID, e.DepartmentID, e.RoleID
    FROM 
        Employees e
    INNER JOIN 
        subordinates s ON (e.ManagerID = s.EmployeeID)
)
SELECT 
    s.EmployeeID, s.Name, s.ManagerID,
    COALESCE(d.DepartmentName, 'NULL') AS Department, 
    COALESCE(r.RoleName, 'NULL') AS Role,              
    COALESCE((
        SELECT STRING_AGG(p.ProjectName, ', ') 
        FROM Projects p 
        WHERE p.DepartmentID = s.DepartmentID
    ), 'NULL') AS Projects,                             
    COALESCE((
        SELECT STRING_AGG(t.TaskName, ', ') 
        FROM Tasks t 
        WHERE t.AssignedTo = s.EmployeeID
    ), 'NULL') AS Tasks                                
FROM 
    subordinates s
	LEFT JOIN 
	    Departments d ON (s.DepartmentID = d.DepartmentID)
	LEFT JOIN 
	    Roles r ON (s.RoleID = r.RoleID)
ORDER BY 
    s.Name;