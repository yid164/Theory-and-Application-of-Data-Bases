-- Name: Yinsheng Dong
-- Student Number: 11148648
-- NSID: yid164
-- Lecture: CMPT 355

-- CHECK clause DDL:
CREATE TABLE students(
id INT,
student_number INT,
first_name VARCHAR(100),
last_name VARCHAR(100),
email_address VARCHAR(100),
major_code VARCHAR(10),
gender CHAR(1) CHECK (gender IN ('M','F','U','N')),
PRIMARY KEY (id));
