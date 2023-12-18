-- Create customer table
CREATE TABLE customer(
    id int PRIMARY KEY,
    firstname text NOT NULL,
    lastname text NOT NULL,
    gender text,
    address text,
    email text,
    phone text
);

-- insert value in customer table
INSERT INTO customer(id, firstname, lastname, gender, address, email, phone) VALUES
(1,'Ailyn','Petzold','Female','1 Londonderry Point','apetzold0@harvard.edu','274-379-1248'),
(2,'Maryanna','Laxen','Female','81932 Bunker Hill Pass','mlaxen1@earthlink.net','983-470-7935'),
(3,'Austin','Antoniou','Male','13 Menomonie Center','aantoniou2@eepurl.com','853-695-8643'),
(4,'Janine','Grimwad','Female','98093 Colorado Place','jgrimwad3@google.com.au','236-323-9007'),
(5,'Bond','Prantl','Polygender','87132 Arapahoe Drive','bprantl4@accuweather.com','731-523-6169'),
(6,'Ray','Ruzicka','Male','2639 Golf View Crossing','rruzicka5@yale.edu','663-817-9756'),
(7,'Xena','Lile','Female','871 Surrey Alley','xlile6@seattletimes.com','415-920-8155'),
(8,'Robbin','Grint','Female','144 Judy Point','rgrint7@dropbox.com','217-678-9674'),
(9,'Tyrone','Solland','Male','5 Dennis Lane','tsolland8@csmonitor.com','558-267-8103'),
(10,'Rosaline','Brookes','Female','265 Straubel Plaza','rbrookes9@cbsnews.com','301-938-5633');

-- Create officer table
CREATE TABLE officer(
    id int PRIMARY KEY,
    firstname text NOT NULL,
    lastname text NOT NULL,
    email text,
    phone text
);

-- insert value in officer table
INSERT INTO officer(id, firstname, lastname, email,phone) VALUES
(1,'Melly','Lowing','mlowing0@soundcloud.com','497-529-3986'),
(2,'Reyna','Dickins','rdickins1@deviantart.com','454-224-1012'),
(3,'Emmott','Cinelli','ecinelli2@bigcartel.com','924-996-0793'),
(4,'Effie','Wesker','eohallagan3@xrea.com','864-148-6904'),
(5,'Hollis','Otterwell','hotterwell4@irs.gov','585-717-4242'),
(6,'Any','Mandrake','amandrake5@altervista.org','906-531-3672'),
(7,'Dana','Erasmus','derasmus6@mail.ru','216-597-2766'),
(8,'Polly','Oseman','poseman7@umich.edu','257-463-6686'),
(9,'Madison','Marc','mmarc8@unicef.org','186-149-6034'),
(10,'Del','Kainz','dkainz9@yelp.com','258-936-2770');

-- Create payment_type table
CREATE TABLE payment_type (
    id int PRIMARY KEY,
    payment text
);

-- insert value in payment_table
INSERT INTO payment_type(id, payment) values
(1, "Cash"),
(2, "Credit/Debit"),
(3, "Cryptocurrency");

--  Create menu_head table
CREATE TABLE menu_head(
    id int PRIMARY KEY,
    menu_name text NOT NULL
);

--insert value in menu_head
INSERT INTO menu_head(id, menu_name) VALUES
(1, 'Risotto'),
(2, 'Pizza'),
(3, 'Steak'),
(4, 'Spaghetti'),
(5, 'Soup');

-- Create menu_detail
CREATE TABLE menu_detail(
    id int PRIMARY KEY,
    menu_id int,
    size_dish text,
    price real,

    FOREIGN KEY (menu_id) REFERENCES menu_head(id)
);

-- insert value in menu_detail
INSERT INTO menu_detail(id, menu_id, size_dish, price) VALUES
(1, 1, 'M', 150),
(2, 1, 'L', 200),
(3, 2, 'S', 200),
(4, 2, 'M', 350),
(5, 2, 'L', 400),
(6, 3, 'S', 280),
(7, 3, 'M', 360),
(8, 3, 'L', 450),
(9, 4, 'M', 150),
(10, 4, 'L', 230),
(11, 5, 'M', 80),
(12, 5, 'L', 120);

-- Create order_detail table
CREATE TABLE order_detail(
    id int PRIMARY KEY,
    order_id int,
    menu_detail_id int,
    quantity int,

    FOREIGN KEY (order_id) REFERENCES order_head(id),
    FOREIGN KEY (menu_detail_id) REFERENCES menu_detail(id)
);

--insert value in order_detail
INSERT INTO order_detail(id, order_id, menu_detail_id, quantity) VALUES
(1,1,5,7),
(2,7,9,7),
(3,1,11,1),
(4,7,7,4),
(5,4,4,8),
(6,1,6,5),
(7,1,9,8),
(8,4,12,2),
(9,1,4,8),
(10,7,2,2),
(11,8,4,3),
(12,8,1,4),
(13,4,6,2),
(14,4,9,6),
(15,10,11,5),
(16,4,8,4),
(17,8,1,5),
(18,6,9,9),
(19,10,9,7),
(20,5,11,6);

-- Create order_head table
CREATE TABLE order_head(
    id int PRIMARY KEY,
    order_date date,
    customer_id int,
    officer_id int,
    payment_id int,

    FOREIGN KEY (customer_id) REFERENCES customer(id),
    FOREIGN KEY (officer_id) REFERENCES officer(id),
    FOREIGN KEY (payment_id) REFERENCES payment_type(id)
);

-- insert value in order_head 
INSERT INTO order_head(id, order_date, customer_id, officer_id, payment_id) VALUES
(1,"2022-07-31",2,1,2),
(2,"2022-09-30",3,5,2),
(3,"2022-03-29",1,10,1),
(4,"2022-04-14",10,3,2),
(5,"2021-12-02",10,9,1),
(6,"2022-09-20",6,5,1),
(7,"2022-08-28",1,3,3),
(8,"2022-05-06",2,8,1),
(9,"2022-09-09",4,3,2),
(10,"2022-10-10",9,4,3),
(11,"2022-08-26",10,7,2),
(12,"2022-02-22",2,4,1),
(13,"2022-02-13",6,3,1),
(14,"2022-01-13",10,5,3),
(15,"2022-01-20",6,3,3),
(16,"2022-08-24",5,8,3),
(17,"2022-07-19",1,2,3),
(18,"2022-01-09",5,6,1),
(19,"2022-10-14",9,3,2),
(20,"2022-04-13",7,1,3);
