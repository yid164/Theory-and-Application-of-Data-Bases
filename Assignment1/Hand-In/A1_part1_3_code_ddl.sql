-- Name: Yinsheng Dong
-- Student Number: 11148648
-- NSID: yid164
-- Lecture: CMPT 355


CREATE TABLE sections(
id INT,
section_code VARCHAR(10),
course_id INT NOT NULL REFERENCES courses,
lec_type VARCHAR(10) NOT NULL,
term_id INT NOT NULL REFERENCES terms,
max_enrollment INT NOT NULL,
num_enrolled INT DEFAULT 0 CHECK (num_enrolled <= max_enrollment),
instructor_id INT REFERENCES instructors,
days VARCHAR(3),
start_time TIME,
end_time TIME,
location_code VARCHAR(20),
PRIMARY KEY (id));
