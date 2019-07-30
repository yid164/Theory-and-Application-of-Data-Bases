-- Name: Yinsheng Dong
-- Student Number: 11148648
-- NSID: yid164
-- Lecture: CMPT 355


-- DOMAIN clause DDL:
CREATE DOMAIN genderTypes AS VARCHAR(1)
DEFAULT 'U'
CHECK (VALUE IN ('M', 'F', 'U', 'N'));

CREATE TABLE students(
id INT,
student_number INT,
first_name VARCHAR(100),
last_name VARCHAR(100),
email_address VARCHAR(100),
major_code VARCHAR(10),
gender genderTypes NOT NULL,
PRIMARY KEY (id));
