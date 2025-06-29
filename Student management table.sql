-- Create Database
CREATE DATABASE studentmanagement;
USE studentmanagement;

-- Create Students Table
CREATE TABLE students
(student_id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
email VARCHAR(100) UNIQUE NOT NULL,
phone VARCHAR(15),
address TEXT,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);

-- Create Instructors Table
CREATE TABLE instructors
(instructor_id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
email VARCHAR(100) UNIQUE NOT NULL,
phone VARCHAR(15));

-- Create Courses Table
CREATE TABLE courses
(course_id INT PRIMARY KEY AUTO_INCREMENT,
course_name VARCHAR(100) NOT NULL,
course_code VARCHAR(20) UNIQUE NOT NULL,
credit_hours INT NOT NULL,
instructor_id INT,
FOREIGN KEY(instructor_id) REFERENCES instructors(instructor_id) ON DELETE SET NULL);

-- Create Enrollments Table
CREATE TABLE enrollments
(enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
student_id INT,
course_id INT,
enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY(student_id) REFERENCES students(student_id) ON DELETE CASCADE,
FOREIGN KEY(course_id) REFERENCES courses(course_id) ON DELETE CASCADE);

-- Create Grades Table
CREATE TABLE grades
(grade_id INT PRIMARY KEY AUTO_INCREMENT,
student_id INT,
course_id INT,
grade CHAR(1),
FOREIGN KEY(student_id) REFERENCES students(student_id) ON DELETE CASCADE,
FOREIGN KEY(course_id) REFERENCES courses(course_id) ON DELETE CASCADE);

-- Insert Sample Data into Students Table
INSERT INTO students (first_name, last_name, email, phone, address)
VALUES ('Alex', 'Gerard', 'alex.doe@email.com', '9876543210', '123 Main St, City, CHINA'),
('Charlie', 'Puth', 'charlie8765@email.com', '8765432109', '789 Pine St, Townsville, USA'),
('Bruno', 'Mars', 'bruno.mars@email.com', '9090909090', '456 Maple Ave, Toronto, Canada'),
('Justin', 'Bieber', 'junstin9898@email.com', '7654321233', '910 Oak St, Sydney, Australia');

-- Insert Sample Data into Instructors Table
INSERT INTO instructors (first_name, last_name, email, phone)
VALUES
('Prof. Prabhu', 'Deva', 'prabhu.deva@email.com', '1112223333'),
('Prof. Ajith', 'Kumar', 'ajith123@email.com', '4445556666'),
('Prof. Siva', 'Karthikeyan', 'siva98@email.com', '9898989898'),
('Prof. Vijay', 'Anthony', 'vijay.anthony@email.com', '5645642738');

-- Insert Sample Data into Courses Table
INSERT INTO courses (course_name, course_code, credit_hours, instructor_id)
VALUES
('Mathematics', 'MATH101', 3, 1),
('Computer Science', 'CS102', 4, 2),
('Physics', 'PHY002', 3, 3),
('Chemistry', 'CHE061', 3, 4);

-- Insert Sample Data into Enrollments Table
INSERT INTO enrollments (student_id, course_id)
VALUES
(1, 1),
(1, 2),
(2, 1),
(4, 3),
(3, 4);

-- Insert Sample Data into Grades Table
INSERT INTO grades (student_id, course_id, grade)
VALUES
(1, 1, 'A'),
(1, 2, 'B'),
(2, 1, 'A'),
(3, 4, 'D'),
(4, 3, 'C');


-- Using JOINS to Fetch Student-Course Details
SELECT s.student_id, s.first_name, s.last_name, c.course_name, c.course_code
FROM students s
INNER JOIN enrollments e ON s.student_id = e.student_id
INNER JOIN courses c ON e.course_id = c.course_id;

-- Creating a VIEW for Student Grades
CREATE VIEW student_grades AS
SELECT s.student_id, s.first_name, s.last_name, c.course_name, g.grade
FROM students s
INNER JOIN grades g ON s.student_id = g.student_id
INNER JOIN courses c ON g.course_id = c.course_id;

-- Using the VIEW
SELECT * FROM student_grades;

-- Using a SUBQUERY to Fetch the Students with the Highest Grade
SELECT s.student_id, s.first_name, s.last_name
FROM students s
JOIN grades g ON s.student_id = g.student_id
WHERE g.grade = (
    SELECT MAX(g1.grade)
    FROM grades g1
);

-- Creating a STORED PROCEDURE to Count Students per Course
DELIMITER //
CREATE PROCEDURE count_students_per_course()
BEGIN
    SELECT c.course_name, COUNT(e.student_id) AS total_students
    FROM courses c
    LEFT JOIN enrollments e ON c.course_id = e.course_id
    GROUP BY c.course_name;
END //
DELIMITER ;

-- Calling the STORED PROCEDURE
CALL count_students_per_course();

