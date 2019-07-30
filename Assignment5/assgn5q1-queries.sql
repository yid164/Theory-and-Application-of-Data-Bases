-- Query 1
SELECT *
FROM employee_histories eh 
WHERE eh.first_name LIKE 'Cla%'; 

-- Query 2
SELECT *
FROM employee_histories eh
WHERE eh.first_name NOT LIKE 'Cla%';

-- Query 3                   
SELECT 
  e.first_name, 
  e.last_name, 
  e.gender, 
  e.birth_date, 
  es.name employment_status
FROM employees e
JOIN employment_statuses es ON es.id = e.employment_status_id
WHERE COALESCE(termination_date,CURRENT_DATE+1) >= CURRENT_DATE 
  AND e.birth_date > CURRENT_DATE - INTERVAL '30 years'
  AND es.name IN ('Active','Paid Leave');

-- Query 4
SELECT 
  e.first_name, 
  e.last_name, 
  ej.pay_amount,
  ej.effective_date, 
  ej.expiry_date, 
  j.name job_name, 
  d.name department_name, 
  l.name location_name,
  es.name employment_status
FROM employees e
JOIN employee_jobs ej ON e.id = ej.employee_id
JOIN jobs j ON ej.job_id = j.id
JOIN departments d on j.department_id = d.id
JOIN locations l on d.location_id = l.id
JOIN employment_statuses es ON es.id = e.employment_status_id
WHERE l.code = 'SKTN-MT'
  AND es.name IN ('Active','Paid Leave')
  AND ej.effective_date = (SELECT MAX(ej2.effective_date)
                           FROM employee_jobs ej2
                           WHERE ej2.employee_id = e.id);
