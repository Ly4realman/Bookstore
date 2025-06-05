CREATE DATABASE IF NOT EXISTS bookstore CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

USE bookstore;

-- 用户表
CREATE TABLE user (
                      id INT PRIMARY KEY AUTO_INCREMENT,
                      username VARCHAR(50) NOT NULL UNIQUE,
                      password VARCHAR(255) NOT NULL,
                      phone VARCHAR(20),
                      email VARCHAR(100),
                      realname VARCHAR(50),
                      address VARCHAR(255),
                      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);



-- 图书表
CREATE TABLE book (
                      id INT PRIMARY KEY AUTO_INCREMENT,
                      title VARCHAR(100) NOT NULL,
                      author VARCHAR(100),
                      price DECIMAL(10, 2),
                      stock INT,
                      description TEXT
);

INSERT INTO book (title, author, price, stock, description) VALUES
                                                                ('Java核心技术卷I', 'Cay S. Horstmann', 89.00, 50, 'Java 编程语言经典教材，适合初学者和进阶者'),
                                                                ('深入理解Java虚拟机', '周志明', 68.50, 30, '全面讲解JVM原理与调优技巧'),
                                                                ('算法导论', 'Thomas H. Cormen', 120.00, 20, '权威的算法教材，涵盖各种经典算法与数据结构'),
                                                                ('设计模式：可复用面向对象软件的基础', 'Erich Gamma', 99.00, 40, '23种经典设计模式详解'),
                                                                ('Python编程：从入门到实践', 'Eric Matthes', 75.00, 25, '适合零基础入门的Python教程'),
                                                                ('数据库系统概念', 'Abraham Silberschatz', 110.00, 15, '系统讲解数据库基础与高级概念'),
                                                                ('计算机网络：自顶向下方法', 'James F. Kurose', 105.00, 18, '现代计算机网络基础教材'),
                                                                ('Effective Java', 'Joshua Bloch', 98.00, 35, 'Java最佳实践和规范的权威指南'),
                                                                ('Spring实战', 'Craig Walls', 88.00, 22, '全面介绍Spring框架的实用指南'),
                                                                ('机器学习实战', 'Peter Harrington', 92.00, 28, '用Python实现机器学习算法的实用指南');

CREATE TABLE admin (
                       id INT PRIMARY KEY AUTO_INCREMENT,
                       username VARCHAR(50) NOT NULL UNIQUE,
                       password VARCHAR(100) NOT NULL
);
INSERT INTO admin (username, password) VALUES
    ('admin123', '$2a$10$Kn3tFLV/jQZKooY1BMfmwuw2RESkHIlFwvXmp9Teek4YpYFq/87zm'); -- 密码：admin123A

ALTER TABLE book
    ADD COLUMN cover_image VARCHAR(255),   -- 存封面图的路径，如 "/images/book1.jpg"
    ADD COLUMN is_hot BOOLEAN DEFAULT 0,   -- 是否热门
    ADD COLUMN sales INT DEFAULT 0,        -- 销量
    ADD COLUMN recommendation TEXT;        -- 图书推荐内容


UPDATE book SET is_hot = 1, cover_image = 'images/book1.jpg' WHERE id = 1;
UPDATE book SET is_hot = 1, cover_image = 'images/book2.jpg' WHERE id = 2;

-- 购物车表
CREATE TABLE cart (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES user(id)
);

-- 购物车项表
CREATE TABLE cart_item (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cart_id INT NOT NULL,
    book_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    FOREIGN KEY (cart_id) REFERENCES cart(id),
    FOREIGN KEY (book_id) REFERENCES book(id)
);

