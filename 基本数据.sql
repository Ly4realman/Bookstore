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
                                                                ('红楼梦', '曹雪芹', 19.00, 50, '《红楼梦》是一部百科全书式的长篇小说。以宝黛爱情悲剧为主线，以四大家族的荣辱兴衰为背景，描绘出18世纪中国封建社会的方方面面，以及封建专制下新兴资本主义民主思想的萌动。结构宏大、情节委婉、细节精致，人物形象栩栩如生，声口毕现，堪称中国古代小说中的经典。'),
                                                                ('活着', '余华', 28.50, 30, '《活着(新版)》讲述了农村人福贵悲惨的人生遭遇。福贵本是个阔少爷，可他嗜赌如命，终于赌光了家业，一贫如洗。他的父亲被他活活气死，母亲则在穷困中患了重病，福贵前去求药，却在途中被国民党抓去当壮丁。经过几番波折回到家里，才知道母亲早已去世，妻子家珍含辛茹苦地养大两个儿女。此后更加悲惨的命运一次又一次降临到福贵身上，他的妻子、儿女和孙子相继死去，最后只剩福贵和一头老牛相依为命，但老人依旧活着，仿佛比往日更加洒脱与坚强。'),
                                                                ('哈利·波特', 'Harry Potter', 20.00, 20, '《哈利·波特(共7册)(精)》内容提要：2000年的一个深夜，在美国书店的烛光中，穿着黑斗篷，戴着小眼镜的店员开始销售“哈利o波特4”英文版，从此哈利·波特系列图书席卷全球，也是在这一年，简体中文版“哈利o波特”系列图书通过人民文学出版社引进版权登陆中国，作者J.K.罗琳用一种简单的魔法游戏将魔幻的故事传递给了中国乃至全球的青少年读者，与此同时商业电影的改编更是将这部魔幻题材的小说推向了巅峰。'),
                                                                ('1984', 'Nineteen Eighty-Four', 19.00, 40, '《1984》是一部杰出的政治寓言小说，也是一部幻想小说。作品刻画了人类在极权主义社会的生存状态，有若一个永不褪色的警示标签，警醒世人提防这种预想中的黑暗成为现实。历经几十年，其生命力益显强大，被誉为20世纪影响最为深远的文学经典之一。'),
                                                                ('三体全集', '刘慈欣', 75.00, 25, '文化大革命如火如荼进行的同时，军方探寻外星文明的绝秘计划“红岸工程”取得了突破性进展。但在按下发射键的那一刻，历经劫难的叶文洁没有意识到，她彻底改变了人类的命运。'),
                                                                ('百年孤独', 'Cien años de soledad', 25.00, 15, '《百年孤独》是魔幻现实主义文学的代表作，描写了布恩迪亚家族七代人的传奇故事，以及加勒比海沿岸小镇马孔多的百年兴衰，反映了拉丁美洲一个世纪以来风云变幻的历史。作品融入神话传说、民间故事、宗教典故等神秘因素，巧妙地糅合了现实与虚幻，展现出一个瑰丽的想象世界，成为20世纪最重要的经典文学巨著之一。1982年加西亚•马尔克斯获得诺贝尔文学奖，奠定世界级文学大师的地位，很大程度上乃是凭借《百年孤独》的巨大影响。'),
                                                                ('房思琪的初恋乐园', '林奕含', 15.00, 18, '令人心碎却无能为力的真实故事。向死而生的文学绝唱 打动万千读者的年度华语小说。李银河 戴锦华 骆以军 张悦然 詹宏志 蒋方舟 等多位学者作家社会名人郑重推荐。痛苦的际遇是如此难以分享，好险这个世界还有文学。'),
                                                                ('动物农场', 'Animal Farm', 17.00, 35, '《动物农场》是奥威尔最优秀的作品之一，是一则入木三分的反乌托的政治讽喻寓言。农场的一群动物成功地进行了一场“革命”，将压榨他们的人类东家赶出农场，建立起一个平等的动物社会。然而，动物领袖，那些聪明的猪们最终却篡夺了革命的果实，成为比人类东家更加独裁和极权的统治者。'),
                                                                ('呐喊', '鲁迅', 88.00, 22, '《呐喊》收录作者1918年至1922年所作小说十四篇。1923年8月由北京新潮社出版，原收十五篇，列为该社《文艺丛书》之一。1924年5月第三次印刷时起，改由北京北新书局出版，列为作者所编的《乌合丛书》之一。1930年1 月第十三次印刷时，由作者抽去其中的《不周山》一篇(后改名为《补天》，收入《故事新编》)。作者生前共印行二十二版次。'),
                                                                ('三国演义', '罗贯中', 92.00, 28, '《三国演义》又名《三国志演义》、《三国志通俗演义》，是我国小说史上最著名最杰出的长篇章回体历史小说。');

CREATE TABLE admin (
                       id INT PRIMARY KEY AUTO_INCREMENT,
                       username VARCHAR(50) NOT NULL UNIQUE,
                       password VARCHAR(100) NOT NULL
);
INSERT INTO admin (username, password) VALUES
    ('admin123', '$2a$10$Kn3tFLV/jQZKooY1BMfmwuw2RESkHIlFwvXmp9Teek4YpYFq/87zm'); -- 密码：admin123A

ALTER TABLE book
    ADD COLUMN cover_image VARCHAR(255),   -- 存封面图的路径"
    ADD COLUMN is_hot BOOLEAN DEFAULT 0,   -- 是否热门
    ADD COLUMN sales INT DEFAULT 0,        -- 销量
    ADD COLUMN recommendation TEXT;        -- 图书推荐内容


UPDATE book SET is_hot = 1, cover_image = '/images/covers/64d10f5d-89bd-4403-8b17-ba64806395da.jpg' WHERE id = 1;
UPDATE book SET is_hot = 1, cover_image = '/images/covers/e5f88d58-bfef-4688-ba24-20be21f7af99.jpg' WHERE id = 2;
UPDATE book SET is_hot = 0, cover_image = '/images/covers/70431743-941c-42fd-9ed7-17471b27ca8a.jpg' WHERE id = 3;
UPDATE book SET is_hot = 0, cover_image = '/images/covers/c3685b07-aa57-42e8-957e-b2fa3d5b9b62.jpg' WHERE id = 4;
UPDATE book SET is_hot = 0, cover_image = '/images/covers/dfcc48ff-a45b-4edd-922b-d608ff052ba5.jpg' WHERE id = 5;
UPDATE book SET is_hot = 0, cover_image = '/images/covers/6c3fc1c8-1632-4f5a-b090-ab921e4272b7.jpg' WHERE id = 6;
UPDATE book SET is_hot = 0, cover_image = '/images/covers/7f52cb39-8d87-4c6a-89ba-2e45f34e13bc.jpg' WHERE id = 7;
UPDATE book SET is_hot = 0, cover_image = '/images/covers/9a96fe28-9e27-4202-a9fc-d6cf72d2de80.jpg' WHERE id = 8;
UPDATE book SET is_hot = 0, cover_image = '/images/covers/51cbd0cb-b746-4439-8643-e6b82af16b8d.jpg' WHERE id = 9;
UPDATE book SET is_hot = 0, cover_image = '/images/covers/a729d093-b4fc-4bc4-9836-287725f43c94.jpg' WHERE id = 10;



-- 购物车项表
DROP TABLE IF EXISTS cart_item;
CREATE TABLE cart_item (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    book_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    FOREIGN KEY (user_id) REFERENCES user(id),
    FOREIGN KEY (book_id) REFERENCES book(id)
);

-- 订单表
CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING', -- PENDING, PAID, SHIPPED, COMPLETED, CANCELLED
    shipping_address VARCHAR(255) NOT NULL,
    receiver_name VARCHAR(50) NOT NULL,
    receiver_phone VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES user(id)
);

-- 订单项表
CREATE TABLE order_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    book_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (book_id) REFERENCES book(id)
);

