INSERT INTO listings(id, title, desc, price, search_corpus, category_id, created_by, created_at) VALUES('0f4d368e-3d23-496e-b10f-355e06c89f91', 'Replica de escopeta de Terminator 2', 'Replica Golden Eagle M1873 con accion de Pump y 5 shells', 3500, 'Replica de escopeta de Terminator 2 Replica Golden Eagle M1873 con accion de Pump y 5 shells', 'b0dddc66-4c0e-4fcc-b72a-75aaefc540ae', '74604fce-0953-4e87-93e5-e10e2b7389ff', CURRENT_TIMESTAMP) RETURNING id;
INSERT INTO imgs(id, name) VALUES('dfe35317-8bb3-401f-a2ea-6aae2d7014d7', 'https://airsoftzone.com.mx/wp-content/uploads/COBALT1-jpg-2-400x158.jpg');
INSERT INTO listings_imgs(img_id, listing_id) VALUES ('dfe35317-8bb3-401f-a2ea-6aae2d7014d7', '0f4d368e-3d23-496e-b10f-355e06c89f91');
INSERT INTO equipment(user_id, kind, name, url) VALUES
('74604fce-0953-4e87-93e5-e10e2b7389ff', 'hands', 'Guantes de combate Mechanix', 'http://aliexpress.com/1'),
('74604fce-0953-4e87-93e5-e10e2b7389ff', 'primary', 'BAMF Azul', 'http://aliexpress.com/1'),
('74604fce-0953-4e87-93e5-e10e2b7389ff', 'secondary', 'Krytac SilentCo', 'http://aliexpress.com/1'),
('74604fce-0953-4e87-93e5-e10e2b7389ff', 'jacket', 'Chaleco Tactico JPC', 'http://aliexpress.com/1'),
('74604fce-0953-4e87-93e5-e10e2b7389ff', 'shoes', 'Botas Norvit Tacticas', 'http://aliexpress.com/1'),
('74604fce-0953-4e87-93e5-e10e2b7389ff', 'chest', 'Conjunto IDOGEAR Multicam con coderas', 'http://aliexpress.com/1'),
('74604fce-0953-4e87-93e5-e10e2b7389ff', 'belt', 'Cinturon acolchado de combate', 'http://aliexpress.com/1'),
('74604fce-0953-4e87-93e5-e10e2b7389ff', 'pants', 'Conjunto IDOGEAR Multicam con rodileras', 'http://aliexpress.com/1'),
('74604fce-0953-4e87-93e5-e10e2b7389ff', 'helmet', 'Casco de Kevlar RIG-2', 'http://aliexpress.com/1'),
('74604fce-0953-4e87-93e5-e10e2b7389ff', 'face', 'Mascarilla de proteccion con orejas', 'http://aliexpress.com/1');
