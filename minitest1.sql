-- Tạo cơ sở dữ liệu và bảng
-- CREATE DATABASE minitest1;

USE minitest1;

CREATE TABLE Address (
    id INT PRIMARY KEY AUTO_INCREMENT,
    address VARCHAR(50) NOT NULL
);

CREATE TABLE Class (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    language VARCHAR(50) NOT NULL,
    description VARCHAR(50) NOT NULL
);

CREATE TABLE Course (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(50) NOT NULL
);

CREATE TABLE Students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    fullname VARCHAR(50) NOT NULL,
    address_id INT,
    age INT,
    phone VARCHAR(15) NOT NULL UNIQUE,
    class_id INT,
    FOREIGN KEY (address_id) REFERENCES Address(id),
    FOREIGN KEY (class_id) REFERENCES Class(id)
);

CREATE TABLE Points (
    id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT,
    student_id INT,
    point DECIMAL(5, 2),
    FOREIGN KEY (course_id) REFERENCES Course(id),
    FOREIGN KEY (student_id) REFERENCES Students(id)
);

-- Chèn dữ liệu vào các bảng
INSERT INTO Address (address) VALUES 
('Hà Nội'), 
('Đà Nẵng'), 
('Ninh Bình'), 
('Thanh Hóa'), 
('Quảng Bình');

INSERT INTO Class (name, language, description) VALUES
('A1', 'Việt', ''),
('A2', 'Việt', ''),
('B1', 'Anh', ''),
('A4', 'Việt', ''),
('B2', 'Anh', '');

INSERT INTO Students (fullname, address_id, age, phone, class_id) VALUES
('Huy', 1, 20, '234', 1),
('Toàn', 1, 21, '876', 2),
('An', 2, 20, '542', 2),
('Bình', 5, 22, '319', 2),
('Phúc', 3, 21, '765', 3),
('Linh', 2, 21, '482', 5),
('Trúc', 4, 20, '103', 4),
('Khánh', 5, 20, '657', 5),
('Hòa', 3, 19, '491', 3),
('Dũng', 1, 23, '208', 2);

INSERT INTO Course (name, description) VALUES
('Java', ''),
('C#', ''),
('C++', ''),
('Python', ''),
('PHP', '');

INSERT INTO Points (course_id, student_id, point) VALUES
(1, 1, 7), (1, 2, 8), (1, 3, 9), (1, 4, 10), (1, 5, 6),
(2, 1, 8), (2, 2, 7), (2, 3, 9), (2, 4, 5), (2, 5, 10),
(3, 1, 6), (3, 2, 9), (3, 3, 8), (3, 4, 7), (3, 5, 10),
(4, 1, 5), (4, 2, 10), (4, 3, 6), (4, 4, 9), (4, 5, 7),
(5, 1, 10), (5, 2, 8), (5, 3, 6), (5, 4, 7), (5, 5, 9),
(1, 1, 8), (2, 2, 6), (3, 3, 10), (4, 4, 7), (5, 5, 9);

-- Thống kê số lượng học viên các lớp
SELECT class.name AS "Tên lớp", COUNT(student.class_id) AS "Số lượng học viên"
FROM Class
LEFT JOIN Students AS student ON Class.id = student.class_id
GROUP BY Class.id
ORDER BY Class.id ASC;

-- Thống kê số lượng học viên tại các tỉnh
SELECT address.address AS "Tỉnh", COUNT(student.address_id) AS "Số lượng học viên"
FROM Address
LEFT JOIN Students AS student ON Address.id = student.address_id
GROUP BY Address.id
ORDER BY Address.id ASC;

-- Tính điểm trung bình của các khóa học
SELECT course.name AS "Khóa học", AVG(Points.point) AS "Điểm trung bình"
FROM Course AS course
LEFT JOIN Points ON course.id = Points.course_id
GROUP BY course.id
ORDER BY course.id ASC;

-- Đưa ra khóa học có điểm trung bình cao nhất
SELECT course.name AS "Khóa học", AVG(Points.point) AS "Điểm trung bình"
FROM Course AS course
LEFT JOIN Points ON course.id = Points.course_id
GROUP BY course.id
HAVING AVG(Points.point) = (
    SELECT MAX(avg_points)
    FROM (
        SELECT AVG(Points.point) AS avg_points
        FROM Course AS course
        LEFT JOIN Points ON course.id = Points.course_id
        GROUP BY course.id
    ) AS subquery
)
ORDER BY AVG(Points.point) DESC;
