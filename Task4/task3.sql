-- Задача 3
-- Условие

-- Найти всех сотрудников, которые занимают роль менеджера и имеют подчиненных (то есть число подчиненных больше 0). Для каждого такого сотрудника вывести следующую информацию:

-- EmployeeID: идентификатор сотрудника.
-- Имя сотрудника.
-- Идентификатор менеджера.
-- Название отдела, к которому он принадлежит.
-- Название роли, которую он занимает.
-- Название проектов, к которым он относится (если есть, конкатенированные в одном столбце).
-- Название задач, назначенных этому сотруднику (если есть, конкатенированные в одном столбце).
-- Общее количество подчиненных у каждого сотрудника (включая их подчиненных).
-- Если у сотрудника нет назначенных проектов или задач, отобразить NULL.

WITH RECURSIVE manager_hierarchy AS (
    SELECT e.EmployeeID, e.Name, e.ManagerID, e.DepartmentID, e.RoleID, e.EmployeeID AS RootManagerID
    FROM 
        Employees e
    	INNER JOIN Roles r ON (e.RoleID = r.RoleID)
    WHERE 
        r.RoleName = 'Менеджер'
        AND EXISTS (
	            SELECT 1 
	            FROM Employees sub 
	            WHERE sub.ManagerID = e.EmployeeID
        )
    
    UNION ALL
    
    SELECT sub.EmployeeID, sub.Name, sub.ManagerID, sub.DepartmentID, sub.RoleID, mh.RootManagerID
    FROM 
        Employees sub INNER JOIN manager_hierarchy mh ON (sub.ManagerID = mh.EmployeeID)
)
SELECT 
    m.RootManagerID AS EmployeeID,
    emp.Name AS EmployeeName,
    emp.ManagerID,
    d.DepartmentName,
    r.RoleName,
    (
		 SELECT STRING_AGG(p.ProjectName, ', ') 
	     FROM Projects p 
	     WHERE p.DepartmentID = emp.DepartmentID
	) AS ProjectNames,
    (
		 SELECT STRING_AGG(t.TaskName, ', ') 
	     FROM Tasks t 
	     WHERE t.AssignedTo = emp.EmployeeID
	) AS TaskNames,
    (
		 SELECT COUNT(*) - 1 
	     FROM manager_hierarchy mh_count 
	     WHERE mh_count.RootManagerID = emp.EmployeeID
	) AS TotalSubordinates
FROM 
    (SELECT DISTINCT RootManagerID FROM manager_hierarchy) m
	INNER JOIN Employees emp 
    	ON m.RootManagerID = emp.EmployeeID
	LEFT JOIN Departments d 
    	ON emp.DepartmentID = d.DepartmentID
	LEFT JOIN Roles r 
    	ON emp.RoleID = r.RoleID
WHERE 
    r.RoleName = 'Менеджер'  
ORDER BY 
    emp.Name;