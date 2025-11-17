INSERT INTO listings(id, title, desc, price, search_corpus, category_id, created_by, created_at) VALUES('0f4d368e-3d23-496e-b10f-355e06c89f91', 'Replica de escopeta de Terminator 2', 'Replica Golden Eagle M1873 con accion de Pump y 5 shells', 3500, 'Replica de escopeta de Terminator 2 Replica Golden Eagle M1873 con accion de Pump y 5 shells', 'b0dddc66-4c0e-4fcc-b72a-75aaefc540ae', '74604fce-0953-4e87-93e5-e10e2b7389ff', CURRENT_TIMESTAMP) RETURNING id;
INSERT INTO imgs(id, name) VALUES('dfe35317-8bb3-401f-a2ea-6aae2d7014d7', 'https://airsoftzone.com.mx/wp-content/uploads/COBALT1-jpg-2-400x158.jpg');
INSERT INTO listings_imgs(img_id, listing_id) VALUES ('dfe35317-8bb3-401f-a2ea-6aae2d7014d7', '0f4d368e-3d23-496e-b10f-355e06c89f91');
INSERT INTO equipment(id, user_id, kind, name, url) VALUES
('d276522f-860d-46cb-a110-1476c5db11e8', '74604fce-0953-4e87-93e5-e10e2b7389ff', 'hands', 'Guantes de combate Mechanix', 'http://aliexpress.com/1'),
('7667badb-865c-4240-a092-a30ad10fcb2e', '74604fce-0953-4e87-93e5-e10e2b7389ff', 'primary', 'BAMF Azul', 'http://aliexpress.com/1'),
('7738335a-f288-4c55-bdce-1c056d627a3d', '74604fce-0953-4e87-93e5-e10e2b7389ff', 'secondary', 'Krytac SilentCo', 'http://aliexpress.com/1'),
('1ffb03e1-5ea2-4ea6-b828-8d21af7a63a2', '74604fce-0953-4e87-93e5-e10e2b7389ff', 'jacket', 'Chaleco Tactico JPC', 'http://aliexpress.com/1'),
('a69a667f-fb26-4137-9d26-f29fd7f5aee4', '74604fce-0953-4e87-93e5-e10e2b7389ff', 'shoes', 'Botas Norvit Tacticas', 'http://aliexpress.com/1'),
('49c96ae3-d9ac-4486-933d-6966948bcca9', '74604fce-0953-4e87-93e5-e10e2b7389ff', 'chest', 'Conjunto IDOGEAR Multicam con coderas', 'http://aliexpress.com/1'),
('42656e02-0b2e-410a-9048-cb6db9838da9', '74604fce-0953-4e87-93e5-e10e2b7389ff', 'belt', 'Cinturon acolchado de combate', 'http://aliexpress.com/1'),
('c44a410b-b6a3-427e-9da5-e64a0847fb17', '74604fce-0953-4e87-93e5-e10e2b7389ff', 'pants', 'Conjunto IDOGEAR Multicam con rodileras', 'http://aliexpress.com/1'),
('8d46b8f5-31dd-496c-b840-ac676c4cd7bb', '74604fce-0953-4e87-93e5-e10e2b7389ff', 'helmet', 'Casco de Kevlar RIG-2', 'http://aliexpress.com/1'),
('06b03671-5c53-43b2-83fb-4621629c3494', '74604fce-0953-4e87-93e5-e10e2b7389ff', 'face', 'Mascarilla de proteccion con orejas', 'http://aliexpress.com/1');
INSERT INTO events(id, title, place_name, place_url, datetime, desc, created_by, created_at) VALUES 
('5d3bab4d-a914-4832-bf01-b88c4f9362d7', 'Tirada de aniversario', 'Gotcha osos', 'https://maps.app.goo.gl/ULgDJ8ZtvwY2LTdS7', '2025-11-30 10:00:00-0600', 'Ven a celebrar el aniversario de Gotcha Osos con una tirada', '74604fce-0953-4e87-93e5-e10e2b7389ff', CURRENT_TIMESTAMP);
