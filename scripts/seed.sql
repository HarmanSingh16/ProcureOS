-- ============================================================
-- ProcureOS Seller-Side — Seed Data
-- Real brands, real products, real buyer companies
-- ============================================================

-- ============================================================
-- BRANDS (15 real manufacturers)
-- ============================================================
INSERT INTO brands (id, name, country, website) VALUES
('a0000000-0000-0000-0000-000000000001', 'Apple',         'United States', 'https://www.apple.com'),
('a0000000-0000-0000-0000-000000000002', 'Samsung',       'South Korea',   'https://www.samsung.com'),
('a0000000-0000-0000-0000-000000000003', 'Sony',          'Japan',         'https://www.sony.com'),
('a0000000-0000-0000-0000-000000000004', 'Dell',          'United States', 'https://www.dell.com'),
('a0000000-0000-0000-0000-000000000005', 'Lenovo',        'China',         'https://www.lenovo.com'),
('a0000000-0000-0000-0000-000000000006', 'LG',            'South Korea',   'https://www.lg.com'),
('a0000000-0000-0000-0000-000000000007', 'Bose',          'United States', 'https://www.bose.com'),
('a0000000-0000-0000-0000-000000000008', 'Microsoft',     'United States', 'https://www.microsoft.com'),
('a0000000-0000-0000-0000-000000000009', 'Google',        'United States', 'https://store.google.com'),
('a0000000-0000-0000-0000-000000000010', 'HP',            'United States', 'https://www.hp.com'),
('a0000000-0000-0000-0000-000000000011', 'Asus',          'Taiwan',        'https://www.asus.com'),
('a0000000-0000-0000-0000-000000000012', 'JBL',           'United States', 'https://www.jbl.com'),
('a0000000-0000-0000-0000-000000000013', 'Logitech',      'Switzerland',   'https://www.logitech.com'),
('a0000000-0000-0000-0000-000000000014', 'Canon',         'Japan',         'https://www.canon.com'),
('a0000000-0000-0000-0000-000000000015', 'Dyson',         'United Kingdom','https://www.dyson.com');

-- ============================================================
-- CATEGORIES (8)
-- ============================================================
INSERT INTO categories (id, name, description) VALUES
('c0000000-0000-0000-0000-000000000001', 'Smartphones',       'Mobile phones and accessories'),
('c0000000-0000-0000-0000-000000000002', 'Laptops',           'Notebooks, ultrabooks, and workstations'),
('c0000000-0000-0000-0000-000000000003', 'Tablets',           'Tablets and 2-in-1 devices'),
('c0000000-0000-0000-0000-000000000004', 'Televisions',       'Smart TVs, OLED, QLED, and LED displays'),
('c0000000-0000-0000-0000-000000000005', 'Audio',             'Headphones, speakers, and soundbars'),
('c0000000-0000-0000-0000-000000000006', 'Monitors',          'Computer monitors and displays'),
('c0000000-0000-0000-0000-000000000007', 'Peripherals',       'Keyboards, mice, webcams, and accessories'),
('c0000000-0000-0000-0000-000000000008', 'Smart Home',        'Smart speakers, cameras, and home automation');

-- ============================================================
-- PRODUCT_CATALOG (80 real products)
-- ============================================================

-- Smartphones (10)
INSERT INTO product_catalog (id, sku, name, brand_id, category_id, unit_price, stock_quantity, moq, specs) VALUES
('d0000000-0000-0000-0000-000000000001', 'APL-IPH15PM-256',  'iPhone 15 Pro Max 256GB',           'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001', 1199.00, 500, 5,  '{"storage":"256GB","ram":"8GB","display":"6.7 inch","chip":"A17 Pro","color":"Natural Titanium"}'),
('d0000000-0000-0000-0000-000000000002', 'APL-IPH15P-128',   'iPhone 15 Pro 128GB',               'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001',  999.00, 750, 5,  '{"storage":"128GB","ram":"8GB","display":"6.1 inch","chip":"A17 Pro","color":"Blue Titanium"}'),
('d0000000-0000-0000-0000-000000000003', 'APL-IPH15-128',    'iPhone 15 128GB',                   'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001',  799.00, 1200, 10, '{"storage":"128GB","ram":"6GB","display":"6.1 inch","chip":"A16 Bionic","color":"Blue"}'),
('d0000000-0000-0000-0000-000000000004', 'SAM-S24U-256',     'Samsung Galaxy S24 Ultra 256GB',    'a0000000-0000-0000-0000-000000000002', 'c0000000-0000-0000-0000-000000000001', 1299.99, 400, 5,  '{"storage":"256GB","ram":"12GB","display":"6.8 inch","chip":"Snapdragon 8 Gen 3","color":"Titanium Gray"}'),
('d0000000-0000-0000-0000-000000000005', 'SAM-S24P-256',     'Samsung Galaxy S24+ 256GB',         'a0000000-0000-0000-0000-000000000002', 'c0000000-0000-0000-0000-000000000001',  999.99, 600, 5,  '{"storage":"256GB","ram":"12GB","display":"6.7 inch","chip":"Snapdragon 8 Gen 3","color":"Cobalt Violet"}'),
('d0000000-0000-0000-0000-000000000006', 'SAM-S24-128',      'Samsung Galaxy S24 128GB',          'a0000000-0000-0000-0000-000000000002', 'c0000000-0000-0000-0000-000000000001',  799.99, 900, 10, '{"storage":"128GB","ram":"8GB","display":"6.2 inch","chip":"Exynos 2400","color":"Onyx Black"}'),
('d0000000-0000-0000-0000-000000000007', 'GOO-PX8P-128',     'Google Pixel 8 Pro 128GB',          'a0000000-0000-0000-0000-000000000009', 'c0000000-0000-0000-0000-000000000001',  999.00, 350, 5,  '{"storage":"128GB","ram":"12GB","display":"6.7 inch","chip":"Tensor G3","color":"Bay"}'),
('d0000000-0000-0000-0000-000000000008', 'GOO-PX8-128',      'Google Pixel 8 128GB',              'a0000000-0000-0000-0000-000000000009', 'c0000000-0000-0000-0000-000000000001',  699.00, 500, 10, '{"storage":"128GB","ram":"8GB","display":"6.2 inch","chip":"Tensor G3","color":"Obsidian"}'),
('d0000000-0000-0000-0000-000000000009', 'SAM-ZFL5-256',     'Samsung Galaxy Z Flip5 256GB',      'a0000000-0000-0000-0000-000000000002', 'c0000000-0000-0000-0000-000000000001',  999.99, 200, 3,  '{"storage":"256GB","ram":"8GB","display":"6.7 inch foldable","chip":"Snapdragon 8 Gen 2","color":"Mint"}'),
('d0000000-0000-0000-0000-000000000010', 'SAM-ZFD5-256',     'Samsung Galaxy Z Fold5 256GB',      'a0000000-0000-0000-0000-000000000002', 'c0000000-0000-0000-0000-000000000001', 1799.99, 150, 3,  '{"storage":"256GB","ram":"12GB","display":"7.6 inch foldable","chip":"Snapdragon 8 Gen 2","color":"Phantom Black"}');

-- Laptops (15)
INSERT INTO product_catalog (id, sku, name, brand_id, category_id, unit_price, stock_quantity, moq, specs) VALUES
('d0000000-0000-0000-0000-000000000011', 'APL-MBP14-M3P',    'MacBook Pro 14-inch M3 Pro',        'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000002', 1999.00, 300, 3,  '{"cpu":"M3 Pro","ram":"18GB","storage":"512GB SSD","display":"14.2 inch Liquid Retina XDR"}'),
('d0000000-0000-0000-0000-000000000012', 'APL-MBP16-M3M',    'MacBook Pro 16-inch M3 Max',        'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000002', 3499.00, 150, 2,  '{"cpu":"M3 Max","ram":"36GB","storage":"1TB SSD","display":"16.2 inch Liquid Retina XDR"}'),
('d0000000-0000-0000-0000-000000000013', 'APL-MBA15-M3',     'MacBook Air 15-inch M3',            'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000002', 1299.00, 500, 5,  '{"cpu":"M3","ram":"8GB","storage":"256GB SSD","display":"15.3 inch Liquid Retina"}'),
('d0000000-0000-0000-0000-000000000014', 'DEL-XPS15-I7',     'Dell XPS 15 9530',                  'a0000000-0000-0000-0000-000000000004', 'c0000000-0000-0000-0000-000000000002', 1799.99, 250, 3,  '{"cpu":"Intel Core i7-13700H","ram":"16GB","storage":"512GB SSD","display":"15.6 inch OLED 3.5K"}'),
('d0000000-0000-0000-0000-000000000015', 'DEL-XPS13-I7',     'Dell XPS 13 Plus 9320',             'a0000000-0000-0000-0000-000000000004', 'c0000000-0000-0000-0000-000000000002', 1399.99, 300, 5,  '{"cpu":"Intel Core i7-1360P","ram":"16GB","storage":"512GB SSD","display":"13.4 inch FHD+"}'),
('d0000000-0000-0000-0000-000000000016', 'LEN-TP-X1C',       'Lenovo ThinkPad X1 Carbon Gen 11',  'a0000000-0000-0000-0000-000000000005', 'c0000000-0000-0000-0000-000000000002', 1649.00, 400, 5,  '{"cpu":"Intel Core i7-1365U","ram":"16GB","storage":"512GB SSD","display":"14 inch 2.8K OLED"}'),
('d0000000-0000-0000-0000-000000000017', 'LEN-YG9I-14',      'Lenovo Yoga 9i 14-inch',            'a0000000-0000-0000-0000-000000000005', 'c0000000-0000-0000-0000-000000000002', 1499.99, 200, 3,  '{"cpu":"Intel Core i7-1360P","ram":"16GB","storage":"1TB SSD","display":"14 inch 4K OLED"}'),
('d0000000-0000-0000-0000-000000000018', 'HP-SPEC-X360',     'HP Spectre x360 16-inch',           'a0000000-0000-0000-0000-000000000010', 'c0000000-0000-0000-0000-000000000002', 1699.99, 180, 3,  '{"cpu":"Intel Core i7-13700H","ram":"16GB","storage":"1TB SSD","display":"16 inch 3K+ OLED"}'),
('d0000000-0000-0000-0000-000000000019', 'HP-ENVY-16',       'HP Envy 16-inch',                   'a0000000-0000-0000-0000-000000000010', 'c0000000-0000-0000-0000-000000000002', 1249.99, 350, 5,  '{"cpu":"Intel Core i7-13700H","ram":"16GB","storage":"512GB SSD","display":"16 inch 2.5K IPS"}'),
('d0000000-0000-0000-0000-000000000020', 'ASUS-ROG-Z16',     'ASUS ROG Zephyrus G16',             'a0000000-0000-0000-0000-000000000011', 'c0000000-0000-0000-0000-000000000002', 1999.99, 120, 2,  '{"cpu":"Intel Core i9-13900H","ram":"16GB","storage":"1TB SSD","gpu":"RTX 4070","display":"16 inch QHD+ 240Hz"}'),
('d0000000-0000-0000-0000-000000000021', 'ASUS-ZEN-14',      'ASUS Zenbook 14 OLED',              'a0000000-0000-0000-0000-000000000011', 'c0000000-0000-0000-0000-000000000002', 1099.99, 400, 5,  '{"cpu":"Intel Core i7-1360P","ram":"16GB","storage":"512GB SSD","display":"14 inch 2.8K OLED"}'),
('d0000000-0000-0000-0000-000000000022', 'MS-SFLP5-I7',      'Microsoft Surface Laptop 5 15-inch','a0000000-0000-0000-0000-000000000008', 'c0000000-0000-0000-0000-000000000002', 1499.99, 250, 3,  '{"cpu":"Intel Core i7-1255U","ram":"16GB","storage":"512GB SSD","display":"15 inch PixelSense"}'),
('d0000000-0000-0000-0000-000000000023', 'DEL-LAT-5540',     'Dell Latitude 5540',                'a0000000-0000-0000-0000-000000000004', 'c0000000-0000-0000-0000-000000000002',  1149.00, 600, 10, '{"cpu":"Intel Core i5-1345U","ram":"16GB","storage":"256GB SSD","display":"15.6 inch FHD"}'),
('d0000000-0000-0000-0000-000000000024', 'LEN-TP-T14',       'Lenovo ThinkPad T14 Gen 4',         'a0000000-0000-0000-0000-000000000005', 'c0000000-0000-0000-0000-000000000002',  1249.00, 500, 10, '{"cpu":"Intel Core i7-1365U","ram":"16GB","storage":"512GB SSD","display":"14 inch WUXGA"}'),
('d0000000-0000-0000-0000-000000000025', 'HP-PRBK-450',      'HP ProBook 450 G10',                'a0000000-0000-0000-0000-000000000010', 'c0000000-0000-0000-0000-000000000002',   899.00, 800, 10, '{"cpu":"Intel Core i5-1335U","ram":"8GB","storage":"256GB SSD","display":"15.6 inch FHD"}');

-- Tablets (10)
INSERT INTO product_catalog (id, sku, name, brand_id, category_id, unit_price, stock_quantity, moq, specs) VALUES
('d0000000-0000-0000-0000-000000000026', 'APL-IPDP-M2',     'iPad Pro 12.9-inch M2',             'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000003', 1099.00, 400, 5,  '{"chip":"M2","storage":"256GB","display":"12.9 inch Liquid Retina XDR","connectivity":"Wi-Fi + Cellular"}'),
('d0000000-0000-0000-0000-000000000027', 'APL-IPDP11-M2',   'iPad Pro 11-inch M2',               'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000003',  799.00, 600, 5,  '{"chip":"M2","storage":"256GB","display":"11 inch Liquid Retina","connectivity":"Wi-Fi"}'),
('d0000000-0000-0000-0000-000000000028', 'APL-IPDA-M1',     'iPad Air M1',                       'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000003',  599.00, 800, 10, '{"chip":"M1","storage":"64GB","display":"10.9 inch Liquid Retina","connectivity":"Wi-Fi"}'),
('d0000000-0000-0000-0000-000000000029', 'APL-IPD10-A14',   'iPad 10th Generation',              'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000003',  449.00, 1000, 10, '{"chip":"A14 Bionic","storage":"64GB","display":"10.9 inch Liquid Retina","connectivity":"Wi-Fi"}'),
('d0000000-0000-0000-0000-000000000030', 'SAM-TABS9U',      'Samsung Galaxy Tab S9 Ultra',       'a0000000-0000-0000-0000-000000000002', 'c0000000-0000-0000-0000-000000000003', 1199.99, 200, 3,  '{"chip":"Snapdragon 8 Gen 2","storage":"256GB","ram":"12GB","display":"14.6 inch Dynamic AMOLED 2X"}'),
('d0000000-0000-0000-0000-000000000031', 'SAM-TABS9P',      'Samsung Galaxy Tab S9+',            'a0000000-0000-0000-0000-000000000002', 'c0000000-0000-0000-0000-000000000003',  999.99, 300, 5,  '{"chip":"Snapdragon 8 Gen 2","storage":"256GB","ram":"12GB","display":"12.4 inch Dynamic AMOLED 2X"}'),
('d0000000-0000-0000-0000-000000000032', 'SAM-TABS9',       'Samsung Galaxy Tab S9',             'a0000000-0000-0000-0000-000000000002', 'c0000000-0000-0000-0000-000000000003',  799.99, 450, 5,  '{"chip":"Snapdragon 8 Gen 2","storage":"128GB","ram":"8GB","display":"11 inch Dynamic AMOLED 2X"}'),
('d0000000-0000-0000-0000-000000000033', 'MS-SFP9-I7',      'Microsoft Surface Pro 9',           'a0000000-0000-0000-0000-000000000008', 'c0000000-0000-0000-0000-000000000003', 1599.99, 250, 3,  '{"cpu":"Intel Core i7-1255U","storage":"256GB","ram":"16GB","display":"13 inch PixelSense Flow"}'),
('d0000000-0000-0000-0000-000000000034', 'MS-SFGO3',        'Microsoft Surface Go 3',            'a0000000-0000-0000-0000-000000000008', 'c0000000-0000-0000-0000-000000000003',  399.99, 500, 10, '{"cpu":"Intel Pentium Gold","storage":"64GB","ram":"4GB","display":"10.5 inch PixelSense"}'),
('d0000000-0000-0000-0000-000000000035', 'LEN-TABP12',      'Lenovo Tab P12 Pro',                'a0000000-0000-0000-0000-000000000005', 'c0000000-0000-0000-0000-000000000003',  699.99, 300, 5,  '{"chip":"Snapdragon 870","storage":"256GB","ram":"8GB","display":"12.6 inch AMOLED 2K"}');

-- Televisions (10)
INSERT INTO product_catalog (id, sku, name, brand_id, category_id, unit_price, stock_quantity, moq, specs) VALUES
('d0000000-0000-0000-0000-000000000036', 'SAM-QN85-65',     'Samsung QN85B 65-inch Neo QLED 4K', 'a0000000-0000-0000-0000-000000000002', 'c0000000-0000-0000-0000-000000000004', 1597.99, 100, 2,  '{"display":"65 inch","resolution":"4K","panel":"Neo QLED","smart_tv":true,"hdr":"Quantum HDR 24x"}'),
('d0000000-0000-0000-0000-000000000037', 'SAM-S95C-55',     'Samsung S95C 55-inch OLED 4K',      'a0000000-0000-0000-0000-000000000002', 'c0000000-0000-0000-0000-000000000004', 2299.99,  80, 2,  '{"display":"55 inch","resolution":"4K","panel":"QD-OLED","smart_tv":true,"hdr":"Neural Quantum 4K"}'),
('d0000000-0000-0000-0000-000000000038', 'LG-C3-65',        'LG C3 65-inch OLED evo 4K',         'a0000000-0000-0000-0000-000000000006', 'c0000000-0000-0000-0000-000000000004', 1799.99,  90, 2,  '{"display":"65 inch","resolution":"4K","panel":"OLED evo","smart_tv":true,"processor":"a9 Gen6 AI"}'),
('d0000000-0000-0000-0000-000000000039', 'LG-G3-77',        'LG G3 77-inch OLED evo 4K',         'a0000000-0000-0000-0000-000000000006', 'c0000000-0000-0000-0000-000000000004', 3299.99,  40, 1,  '{"display":"77 inch","resolution":"4K","panel":"OLED evo MLA","smart_tv":true,"processor":"a9 Gen6 AI"}'),
('d0000000-0000-0000-0000-000000000040', 'SONY-A95K-65',    'Sony A95K 65-inch QD-OLED 4K',      'a0000000-0000-0000-0000-000000000003', 'c0000000-0000-0000-0000-000000000004', 2799.99,  50, 1,  '{"display":"65 inch","resolution":"4K","panel":"QD-OLED","smart_tv":true,"processor":"Cognitive XR"}'),
('d0000000-0000-0000-0000-000000000041', 'SONY-X90L-75',    'Sony X90L 75-inch Full Array LED',  'a0000000-0000-0000-0000-000000000003', 'c0000000-0000-0000-0000-000000000004', 1499.99,  70, 2,  '{"display":"75 inch","resolution":"4K","panel":"Full Array LED","smart_tv":true,"processor":"XR"}'),
('d0000000-0000-0000-0000-000000000042', 'SAM-TU7000-50',   'Samsung TU7000 50-inch Crystal UHD','a0000000-0000-0000-0000-000000000002', 'c0000000-0000-0000-0000-000000000004',  347.99, 300, 5,  '{"display":"50 inch","resolution":"4K","panel":"Crystal UHD","smart_tv":true,"hdr":"HDR"}'),
('d0000000-0000-0000-0000-000000000043', 'LG-UR8000-55',    'LG UR8000 55-inch 4K UHD',          'a0000000-0000-0000-0000-000000000006', 'c0000000-0000-0000-0000-000000000004',  449.99, 250, 5,  '{"display":"55 inch","resolution":"4K","panel":"LED","smart_tv":true,"processor":"a5 Gen6 AI"}'),
('d0000000-0000-0000-0000-000000000044', 'SONY-X80L-55',    'Sony X80L 55-inch 4K',              'a0000000-0000-0000-0000-000000000003', 'c0000000-0000-0000-0000-000000000004',  699.99, 150, 3,  '{"display":"55 inch","resolution":"4K","panel":"LED","smart_tv":true,"processor":"X1"}'),
('d0000000-0000-0000-0000-000000000045', 'SAM-LS03B-55',    'Samsung The Frame 55-inch QLED',    'a0000000-0000-0000-0000-000000000002', 'c0000000-0000-0000-0000-000000000004', 1299.99, 100, 2,  '{"display":"55 inch","resolution":"4K","panel":"QLED","smart_tv":true,"feature":"Art Mode"}');

-- Audio (10)
INSERT INTO product_catalog (id, sku, name, brand_id, category_id, unit_price, stock_quantity, moq, specs) VALUES
('d0000000-0000-0000-0000-000000000046', 'APL-APPMX-2',     'AirPods Max',                       'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000005',  549.00, 400, 5,  '{"type":"over-ear","anc":true,"driver":"40mm","battery":"20 hours","connectivity":"Bluetooth 5.0"}'),
('d0000000-0000-0000-0000-000000000047', 'APL-APP2-USB',     'AirPods Pro 2nd Gen USB-C',         'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000005',  249.00, 1500, 10, '{"type":"in-ear","anc":true,"chip":"H2","battery":"6 hours","connectivity":"Bluetooth 5.3"}'),
('d0000000-0000-0000-0000-000000000048', 'SONY-WH1KXM5',    'Sony WH-1000XM5',                   'a0000000-0000-0000-0000-000000000003', 'c0000000-0000-0000-0000-000000000005',  349.99, 600, 5,  '{"type":"over-ear","anc":true,"driver":"30mm","battery":"30 hours","connectivity":"Bluetooth 5.2"}'),
('d0000000-0000-0000-0000-000000000049', 'SONY-WF1KXM5',    'Sony WF-1000XM5',                   'a0000000-0000-0000-0000-000000000003', 'c0000000-0000-0000-0000-000000000005',  299.99, 500, 5,  '{"type":"in-ear","anc":true,"driver":"8.4mm","battery":"8 hours","connectivity":"Bluetooth 5.3"}'),
('d0000000-0000-0000-0000-000000000050', 'BOSE-QC45',       'Bose QuietComfort 45',              'a0000000-0000-0000-0000-000000000007', 'c0000000-0000-0000-0000-000000000005',  329.00, 400, 5,  '{"type":"over-ear","anc":true,"battery":"24 hours","connectivity":"Bluetooth 5.1"}'),
('d0000000-0000-0000-0000-000000000051', 'BOSE-QCUB2',      'Bose QuietComfort Ultra Earbuds',   'a0000000-0000-0000-0000-000000000007', 'c0000000-0000-0000-0000-000000000005',  299.00, 350, 5,  '{"type":"in-ear","anc":true,"battery":"6 hours","spatial_audio":true,"connectivity":"Bluetooth 5.3"}'),
('d0000000-0000-0000-0000-000000000052', 'JBL-FL2',         'JBL Flip 6',                        'a0000000-0000-0000-0000-000000000012', 'c0000000-0000-0000-0000-000000000005',  129.95, 1000, 10, '{"type":"portable speaker","waterproof":"IP67","battery":"12 hours","connectivity":"Bluetooth 5.1"}'),
('d0000000-0000-0000-0000-000000000053', 'JBL-CHG5',        'JBL Charge 5',                      'a0000000-0000-0000-0000-000000000012', 'c0000000-0000-0000-0000-000000000005',  179.95, 700, 10, '{"type":"portable speaker","waterproof":"IP67","battery":"20 hours","powerbank":true}'),
('d0000000-0000-0000-0000-000000000054', 'SONY-SRS-XB43',   'Sony SRS-XB43 Portable Speaker',    'a0000000-0000-0000-0000-000000000003', 'c0000000-0000-0000-0000-000000000005',  249.99, 300, 5,  '{"type":"portable speaker","waterproof":"IP67","battery":"24 hours","extra_bass":true}'),
('d0000000-0000-0000-0000-000000000055', 'BOSE-SB900',      'Bose Smart Soundbar 900',           'a0000000-0000-0000-0000-000000000007', 'c0000000-0000-0000-0000-000000000005',  899.00, 150, 2,  '{"type":"soundbar","dolby_atmos":true,"channels":"5.0.2","voice_assistant":"Alexa + Google"}');

-- Monitors (10)
INSERT INTO product_catalog (id, sku, name, brand_id, category_id, unit_price, stock_quantity, moq, specs) VALUES
('d0000000-0000-0000-0000-000000000056', 'APL-SD27-5K',     'Apple Studio Display 27-inch 5K',   'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000006', 1599.00, 200, 2,  '{"display":"27 inch","resolution":"5K","panel":"IPS","brightness":"600 nits","camera":"12MP Ultra Wide"}'),
('d0000000-0000-0000-0000-000000000057', 'APL-PXD-32',      'Apple Pro Display XDR 32-inch',     'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000006', 4999.00,  50, 1,  '{"display":"32 inch","resolution":"6K","panel":"IPS","brightness":"1600 nits HDR","hdr":"XDR"}'),
('d0000000-0000-0000-0000-000000000058', 'DEL-U2723QE',     'Dell UltraSharp U2723QE 27-inch',   'a0000000-0000-0000-0000-000000000004', 'c0000000-0000-0000-0000-000000000006',  619.99, 400, 5,  '{"display":"27 inch","resolution":"4K","panel":"IPS Black","usb_c":"90W PD","color_accuracy":"98% DCI-P3"}'),
('d0000000-0000-0000-0000-000000000059', 'DEL-U3423WE',     'Dell UltraSharp U3423WE 34-inch',   'a0000000-0000-0000-0000-000000000004', 'c0000000-0000-0000-0000-000000000006', 1099.99, 200, 3,  '{"display":"34 inch","resolution":"WQHD","panel":"IPS","curved":true,"usb_c":"90W PD"}'),
('d0000000-0000-0000-0000-000000000060', 'LG-27UK850',      'LG 27UK850-W 27-inch 4K',           'a0000000-0000-0000-0000-000000000006', 'c0000000-0000-0000-0000-000000000006',  449.99, 500, 5,  '{"display":"27 inch","resolution":"4K","panel":"IPS","hdr":"HDR10","usb_c":"true"}'),
('d0000000-0000-0000-0000-000000000061', 'SAM-OD-G9',       'Samsung Odyssey G9 49-inch',        'a0000000-0000-0000-0000-000000000002', 'c0000000-0000-0000-0000-000000000006', 1299.99, 100, 2,  '{"display":"49 inch","resolution":"5120x1440","panel":"VA","curved":"1000R","refresh_rate":"240Hz"}'),
('d0000000-0000-0000-0000-000000000062', 'LG-34WN80C',      'LG 34WN80C-B 34-inch UltraWide',   'a0000000-0000-0000-0000-000000000006', 'c0000000-0000-0000-0000-000000000006',  599.99, 300, 3,  '{"display":"34 inch","resolution":"3440x1440","panel":"IPS","curved":false,"usb_c":"60W PD"}'),
('d0000000-0000-0000-0000-000000000063', 'ASUS-PG279QM',    'ASUS ROG Swift PG279QM 27-inch',    'a0000000-0000-0000-0000-000000000011', 'c0000000-0000-0000-0000-000000000006', 849.99,  150, 2,  '{"display":"27 inch","resolution":"QHD","panel":"IPS","refresh_rate":"240Hz","g_sync":true}'),
('d0000000-0000-0000-0000-000000000064', 'HP-Z27K-G3',      'HP Z27k G3 27-inch 4K USB-C',       'a0000000-0000-0000-0000-000000000010', 'c0000000-0000-0000-0000-000000000006',  539.00, 350, 5,  '{"display":"27 inch","resolution":"4K","panel":"IPS","usb_c":"100W PD","color_accuracy":"98% DCI-P3"}'),
('d0000000-0000-0000-0000-000000000065', 'SAM-S80UA-32',    'Samsung ViewFinity S80UA 32-inch',  'a0000000-0000-0000-0000-000000000002', 'c0000000-0000-0000-0000-000000000006',  449.99, 400, 5,  '{"display":"32 inch","resolution":"4K","panel":"VA","hdr":"HDR10","usb_c":"65W PD"}');

-- Peripherals (10)
INSERT INTO product_catalog (id, sku, name, brand_id, category_id, unit_price, stock_quantity, moq, specs) VALUES
('d0000000-0000-0000-0000-000000000066', 'LOG-MXMSTR3S',    'Logitech MX Master 3S',             'a0000000-0000-0000-0000-000000000013', 'c0000000-0000-0000-0000-000000000007',   99.99, 1000, 10, '{"type":"mouse","sensor":"8000 DPI","connectivity":"Bluetooth + USB-C","battery":"70 days"}'),
('d0000000-0000-0000-0000-000000000067', 'LOG-MXKEYS-S',    'Logitech MX Keys S',                'a0000000-0000-0000-0000-000000000013', 'c0000000-0000-0000-0000-000000000007',  109.99, 800, 10, '{"type":"keyboard","layout":"full-size","backlit":true,"connectivity":"Bluetooth + USB-C"}'),
('d0000000-0000-0000-0000-000000000068', 'APL-MGKB-TID',    'Apple Magic Keyboard with Touch ID', 'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000007',  199.00, 600, 5,  '{"type":"keyboard","layout":"compact","touch_id":true,"connectivity":"Bluetooth + Lightning"}'),
('d0000000-0000-0000-0000-000000000069', 'APL-MGMS-BLK',    'Apple Magic Mouse Black',           'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000007',   99.00, 700, 5,  '{"type":"mouse","multi_touch":true,"connectivity":"Bluetooth + Lightning"}'),
('d0000000-0000-0000-0000-000000000070', 'LOG-BRIO4K',      'Logitech Brio 4K Webcam',           'a0000000-0000-0000-0000-000000000013', 'c0000000-0000-0000-0000-000000000007',  199.99, 500, 5,  '{"type":"webcam","resolution":"4K","hdr":true,"autofocus":true,"fov":"90 degrees"}'),
('d0000000-0000-0000-0000-000000000071', 'LOG-C920S',       'Logitech C920s HD Pro Webcam',      'a0000000-0000-0000-0000-000000000013', 'c0000000-0000-0000-0000-000000000007',   69.99, 1200, 20, '{"type":"webcam","resolution":"1080p","autofocus":true,"privacy_shutter":true}'),
('d0000000-0000-0000-0000-000000000072', 'MS-ERGO-KB',      'Microsoft Sculpt Ergonomic Keyboard','a0000000-0000-0000-0000-000000000008', 'c0000000-0000-0000-0000-000000000007',   59.99, 600, 10, '{"type":"keyboard","layout":"split ergonomic","connectivity":"USB wireless","palm_rest":true}'),
('d0000000-0000-0000-0000-000000000073', 'LOG-MXANY-3',     'Logitech MX Anywhere 3S',           'a0000000-0000-0000-0000-000000000013', 'c0000000-0000-0000-0000-000000000007',   79.99, 900, 10, '{"type":"mouse","sensor":"8000 DPI","compact":true,"connectivity":"Bluetooth + USB-C"}'),
('d0000000-0000-0000-0000-000000000074', 'CAN-PXMA-TR150',  'Canon PIXMA TR150 Portable Printer','a0000000-0000-0000-0000-000000000014', 'c0000000-0000-0000-0000-000000000007',  199.99, 200, 5,  '{"type":"printer","portable":true,"connectivity":"Wi-Fi + USB","battery":"optional"}'),
('d0000000-0000-0000-0000-000000000075', 'LOG-RALLY-BAR',   'Logitech Rally Bar',                'a0000000-0000-0000-0000-000000000013', 'c0000000-0000-0000-0000-000000000007', 2999.00, 80,  1,  '{"type":"video conferencing","camera":"4K","microphones":"AI-based beamforming","speakers":"built-in"}');

-- Smart Home (5)
INSERT INTO product_catalog (id, sku, name, brand_id, category_id, unit_price, stock_quantity, moq, specs) VALUES
('d0000000-0000-0000-0000-000000000076', 'GOO-NEST-HUB2',   'Google Nest Hub 2nd Gen',           'a0000000-0000-0000-0000-000000000009', 'c0000000-0000-0000-0000-000000000008',   99.99, 800, 10, '{"display":"7 inch","assistant":"Google Assistant","camera":"Soli sensor","speaker":"43.5mm"}'),
('d0000000-0000-0000-0000-000000000077', 'GOO-NEST-HUBMX',  'Google Nest Hub Max',               'a0000000-0000-0000-0000-000000000009', 'c0000000-0000-0000-0000-000000000008',  229.99, 400, 5,  '{"display":"10 inch","assistant":"Google Assistant","camera":"6.5MP","speaker":"stereo 30W"}'),
('d0000000-0000-0000-0000-000000000078', 'DYS-V15-DETECT',  'Dyson V15 Detect',                  'a0000000-0000-0000-0000-000000000015', 'c0000000-0000-0000-0000-000000000008',  749.99, 200, 3,  '{"type":"cordless vacuum","suction":"230 AW","battery":"60 min","laser_detect":true}'),
('d0000000-0000-0000-0000-000000000079', 'DYS-PURECOOL',    'Dyson Purifier Cool TP07',          'a0000000-0000-0000-0000-000000000015', 'c0000000-0000-0000-0000-000000000008',  569.99, 150, 3,  '{"type":"air purifier + fan","hepa":"H13","coverage":"800 sq ft","smart":true}'),
('d0000000-0000-0000-0000-000000000080', 'GOO-NEST-CAM',    'Google Nest Cam (Battery)',          'a0000000-0000-0000-0000-000000000009', 'c0000000-0000-0000-0000-000000000008',  179.99, 600, 10, '{"type":"security camera","resolution":"1080p","battery":true,"night_vision":true,"ai_alerts":true}');

-- ============================================================
-- BUYERS (10 real companies, various statuses)
-- ============================================================
INSERT INTO buyers (id, company_name, industry, billing_address, tax_id, status, credit_limit, net_payment_days, allowed_categories) VALUES
('b0000000-0000-0000-0000-000000000001', 'Accenture',              'Consulting',       '1 North Wacker Drive, Chicago, IL 60606',      'US-ACN-001',  'active',    500000.00, 30, '{}'),
('b0000000-0000-0000-0000-000000000002', 'JPMorgan Chase',         'Financial Services','383 Madison Avenue, New York, NY 10179',        'US-JPM-002',  'active',   1000000.00, 45, '{}'),
('b0000000-0000-0000-0000-000000000003', 'Mayo Clinic',            'Healthcare',       '200 First Street SW, Rochester, MN 55905',      'US-MAYO-003', 'active',    750000.00, 30, '{}'),
('b0000000-0000-0000-0000-000000000004', 'Stanford University',    'Education',        '450 Serra Mall, Stanford, CA 94305',            'US-STAN-004', 'active',    300000.00, 60, ARRAY['c0000000-0000-0000-0000-000000000002','c0000000-0000-0000-0000-000000000003','c0000000-0000-0000-0000-000000000006','c0000000-0000-0000-0000-000000000007']::UUID[]),
('b0000000-0000-0000-0000-000000000005', 'Marriott International', 'Hospitality',      '7750 Wisconsin Ave, Bethesda, MD 20814',        'US-MAR-005',  'active',    200000.00, 30, ARRAY['c0000000-0000-0000-0000-000000000004','c0000000-0000-0000-0000-000000000008']::UUID[]),
('b0000000-0000-0000-0000-000000000006', 'WeWork',                 'Real Estate',      '75 Rockefeller Plaza, New York, NY 10019',      'US-WW-006',   'suspended', 100000.00, 30, '{}'),
('b0000000-0000-0000-0000-000000000007', 'Stripe',                 'Fintech',          '354 Oyster Point Blvd, South San Francisco, CA','US-STR-007',  'active',    400000.00, 30, '{}'),
('b0000000-0000-0000-0000-000000000008', 'Deloitte',               'Consulting',       '30 Rockefeller Plaza, New York, NY 10112',      'US-DEL-008',  'active',    600000.00, 45, '{}'),
('b0000000-0000-0000-0000-000000000009', 'TechStartup Inc.',       'Technology',       '100 Main St, Austin, TX 78701',                 'US-TSI-009',  'pending',        0.00, 30, '{}'),
('b0000000-0000-0000-0000-000000000010', 'BlockFi',                'Cryptocurrency',   '201 Montgomery St, Jersey City, NJ 07302',      'US-BFI-010',  'revoked',       0.00, 30, '{}');

-- ============================================================
-- BUYER_CONTACTS (20 contacts across buyers)
-- ============================================================
INSERT INTO buyer_contacts (id, buyer_id, full_name, email, role, is_active) VALUES
-- Accenture
('e0000000-0000-0000-0000-000000000001', 'b0000000-0000-0000-0000-000000000001', 'Sarah Chen',        'sarah.chen@accenture.com',       'admin',  true),
('e0000000-0000-0000-0000-000000000002', 'b0000000-0000-0000-0000-000000000001', 'Mike Rodriguez',    'mike.rodriguez@accenture.com',   'buyer',  true),
-- JPMorgan Chase
('e0000000-0000-0000-0000-000000000003', 'b0000000-0000-0000-0000-000000000002', 'David Kim',         'david.kim@jpmorgan.com',         'admin',  true),
('e0000000-0000-0000-0000-000000000004', 'b0000000-0000-0000-0000-000000000002', 'Lisa Wang',         'lisa.wang@jpmorgan.com',          'buyer',  true),
('e0000000-0000-0000-0000-000000000005', 'b0000000-0000-0000-0000-000000000002', 'Tom Bradley',       'tom.bradley@jpmorgan.com',        'viewer', true),
-- Mayo Clinic
('e0000000-0000-0000-0000-000000000006', 'b0000000-0000-0000-0000-000000000003', 'Dr. Emily Foster',  'emily.foster@mayo.edu',          'admin',  true),
('e0000000-0000-0000-0000-000000000007', 'b0000000-0000-0000-0000-000000000003', 'James Park',        'james.park@mayo.edu',            'buyer',  true),
-- Stanford University
('e0000000-0000-0000-0000-000000000008', 'b0000000-0000-0000-0000-000000000004', 'Prof. Alan Turing', 'alan.turing@stanford.edu',       'admin',  true),
('e0000000-0000-0000-0000-000000000009', 'b0000000-0000-0000-0000-000000000004', 'Rachel Green',      'rachel.green@stanford.edu',      'buyer',  true),
-- Marriott
('e0000000-0000-0000-0000-000000000010', 'b0000000-0000-0000-0000-000000000005', 'Carlos Mendez',     'carlos.mendez@marriott.com',     'admin',  true),
-- WeWork (suspended)
('e0000000-0000-0000-0000-000000000011', 'b0000000-0000-0000-0000-000000000006', 'Alex Johnson',      'alex.johnson@wework.com',        'admin',  false),
-- Stripe
('e0000000-0000-0000-0000-000000000012', 'b0000000-0000-0000-0000-000000000007', 'Priya Sharma',      'priya.sharma@stripe.com',        'admin',  true),
('e0000000-0000-0000-0000-000000000013', 'b0000000-0000-0000-0000-000000000007', 'Kevin O''Brien',    'kevin.obrien@stripe.com',        'buyer',  true),
-- Deloitte
('e0000000-0000-0000-0000-000000000014', 'b0000000-0000-0000-0000-000000000008', 'Maria Garcia',      'maria.garcia@deloitte.com',      'admin',  true),
('e0000000-0000-0000-0000-000000000015', 'b0000000-0000-0000-0000-000000000008', 'Robert Taylor',     'robert.taylor@deloitte.com',     'buyer',  true),
('e0000000-0000-0000-0000-000000000016', 'b0000000-0000-0000-0000-000000000008', 'Jennifer Lee',      'jennifer.lee@deloitte.com',      'viewer', true),
-- TechStartup (pending)
('e0000000-0000-0000-0000-000000000017', 'b0000000-0000-0000-0000-000000000009', 'Jake Wilson',       'jake.wilson@techstartup.io',     'admin',  true),
-- BlockFi (revoked)
('e0000000-0000-0000-0000-000000000018', 'b0000000-0000-0000-0000-000000000010', 'Sam Bankman',       'sam.bankman@blockfi.com',        'admin',  false),
-- Extra contacts
('e0000000-0000-0000-0000-000000000019', 'b0000000-0000-0000-0000-000000000001', 'Nina Patel',        'nina.patel@accenture.com',       'viewer', true),
('e0000000-0000-0000-0000-000000000020', 'b0000000-0000-0000-0000-000000000003', 'Dr. Mark Stevens',  'mark.stevens@mayo.edu',          'viewer', true);

-- ============================================================
-- API_KEYS (one per active admin/buyer contact)
-- key_hash values are SHA-256 of fictional keys; key_prefix is first 8 chars
-- ============================================================
INSERT INTO api_keys (id, contact_id, key_hash, key_prefix, label, scopes, is_active, expires_at) VALUES
('f0000000-0000-0000-0000-000000000001', 'e0000000-0000-0000-0000-000000000001', 'a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2', 'pk_acn01', 'Accenture Production',   '{catalog:read,catalog:search,orders:create,orders:read}',           true,  '2027-12-31 23:59:59+00'),
('f0000000-0000-0000-0000-000000000002', 'e0000000-0000-0000-0000-000000000002', 'b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3', 'pk_acn02', 'Accenture Buyer',        '{catalog:read,catalog:search,orders:create,orders:read}',           true,  '2027-12-31 23:59:59+00'),
('f0000000-0000-0000-0000-000000000003', 'e0000000-0000-0000-0000-000000000003', 'c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4', 'pk_jpm01', 'JPMorgan Admin',         '{catalog:read,catalog:search,orders:create,orders:read,orders:cancel}', true,  '2027-06-30 23:59:59+00'),
('f0000000-0000-0000-0000-000000000004', 'e0000000-0000-0000-0000-000000000004', 'd4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5', 'pk_jpm02', 'JPMorgan Buyer',         '{catalog:read,catalog:search,orders:create,orders:read}',           true,  '2027-06-30 23:59:59+00'),
('f0000000-0000-0000-0000-000000000005', 'e0000000-0000-0000-0000-000000000005', 'e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6', 'pk_jpm03', 'JPMorgan Viewer',        '{catalog:read}',                                                    true,  '2027-06-30 23:59:59+00'),
('f0000000-0000-0000-0000-000000000006', 'e0000000-0000-0000-0000-000000000006', 'f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7', 'pk_may01', 'Mayo Clinic Admin',      '{catalog:read,catalog:search,orders:create,orders:read,orders:cancel}', true,  '2027-12-31 23:59:59+00'),
('f0000000-0000-0000-0000-000000000007', 'e0000000-0000-0000-0000-000000000007', 'a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8', 'pk_may02', 'Mayo Clinic Buyer',      '{catalog:read,catalog:search,orders:create,orders:read}',           true,  '2027-12-31 23:59:59+00'),
('f0000000-0000-0000-0000-000000000008', 'e0000000-0000-0000-0000-000000000008', 'b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9', 'pk_stn01', 'Stanford Admin',         '{catalog:read,catalog:search,orders:create,orders:read}',           true,  '2027-12-31 23:59:59+00'),
('f0000000-0000-0000-0000-000000000009', 'e0000000-0000-0000-0000-000000000010', 'c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0', 'pk_mar01', 'Marriott Admin',         '{catalog:read,catalog:search,orders:create,orders:read}',           true,  '2027-12-31 23:59:59+00'),
('f0000000-0000-0000-0000-000000000010', 'e0000000-0000-0000-0000-000000000012', 'd0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1', 'pk_str01', 'Stripe Admin',           '{catalog:read,catalog:search,orders:create,orders:read,orders:cancel}', true,  '2027-12-31 23:59:59+00'),
('f0000000-0000-0000-0000-000000000011', 'e0000000-0000-0000-0000-000000000014', 'e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2', 'pk_del01', 'Deloitte Admin',         '{catalog:read,catalog:search,orders:create,orders:read,orders:cancel}', true,  '2027-12-31 23:59:59+00'),
('f0000000-0000-0000-0000-000000000012', 'e0000000-0000-0000-0000-000000000011', 'f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3', 'pk_ww_01', 'WeWork (disabled)',      '{catalog:read}',                                                    false, '2025-01-01 00:00:00+00'),
('f0000000-0000-0000-0000-000000000013', 'e0000000-0000-0000-0000-000000000018', 'a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4', 'pk_bfi01', 'BlockFi (revoked)',      '{catalog:read}',                                                    false, '2024-06-01 00:00:00+00');

-- ============================================================
-- ORDERS (15 orders across active buyers, various statuses)
-- ============================================================
INSERT INTO orders (id, order_number, buyer_id, contact_id, status, total_amount, notes, shipping_address, created_at) VALUES
-- Accenture orders
('00010000-0000-0000-0000-000000000001', 'ORD-20250101-000001', 'b0000000-0000-0000-0000-000000000001', 'e0000000-0000-0000-0000-000000000001', 'delivered',  89940.00, 'Q1 laptop refresh for consulting team',    '1 North Wacker Drive, Chicago, IL 60606',      '2025-01-15 10:30:00+00'),
('00010000-0000-0000-0000-000000000002', 'ORD-20250301-000002', 'b0000000-0000-0000-0000-000000000001', 'e0000000-0000-0000-0000-000000000002', 'shipped',    24997.50, 'Conference room AV equipment',              '1 North Wacker Drive, Chicago, IL 60606',      '2025-03-01 14:00:00+00'),
('00010000-0000-0000-0000-000000000003', 'ORD-20250510-000003', 'b0000000-0000-0000-0000-000000000001', 'e0000000-0000-0000-0000-000000000001', 'pending',    15998.00, 'New hire onboarding kit',                   '1 North Wacker Drive, Chicago, IL 60606',      '2025-05-10 09:00:00+00'),
-- JPMorgan orders
('00010000-0000-0000-0000-000000000004', 'ORD-20250115-000004', 'b0000000-0000-0000-0000-000000000002', 'e0000000-0000-0000-0000-000000000003', 'delivered', 159900.00, 'Trading floor monitor upgrade',             '383 Madison Avenue, New York, NY 10179',       '2025-01-15 08:00:00+00'),
('00010000-0000-0000-0000-000000000005', 'ORD-20250401-000005', 'b0000000-0000-0000-0000-000000000002', 'e0000000-0000-0000-0000-000000000004', 'processing', 49995.00, 'Executive phone upgrade',                   '383 Madison Avenue, New York, NY 10179',       '2025-04-01 11:00:00+00'),
-- Mayo Clinic orders
('00010000-0000-0000-0000-000000000006', 'ORD-20250201-000006', 'b0000000-0000-0000-0000-000000000003', 'e0000000-0000-0000-0000-000000000006', 'delivered',  43960.00, 'Patient room tablets',                      '200 First Street SW, Rochester, MN 55905',     '2025-02-01 13:00:00+00'),
('00010000-0000-0000-0000-000000000007', 'ORD-20250415-000007', 'b0000000-0000-0000-0000-000000000003', 'e0000000-0000-0000-0000-000000000007', 'confirmed',  32970.00, 'Research lab workstations',                 '200 First Street SW, Rochester, MN 55905',     '2025-04-15 10:00:00+00'),
-- Stanford orders
('00010000-0000-0000-0000-000000000008', 'ORD-20250301-000008', 'b0000000-0000-0000-0000-000000000004', 'e0000000-0000-0000-0000-000000000008', 'delivered',  57475.00, 'CS department lab equipment',               '450 Serra Mall, Stanford, CA 94305',           '2025-03-01 09:30:00+00'),
('00010000-0000-0000-0000-000000000009', 'ORD-20250505-000009', 'b0000000-0000-0000-0000-000000000004', 'e0000000-0000-0000-0000-000000000009', 'pending',     5499.50, 'Library peripherals',                       '450 Serra Mall, Stanford, CA 94305',           '2025-05-05 15:00:00+00'),
-- Marriott orders
('00010000-0000-0000-0000-000000000010', 'ORD-20250220-000010', 'b0000000-0000-0000-0000-000000000005', 'e0000000-0000-0000-0000-000000000010', 'delivered',  34799.00, 'Lobby smart displays for 10 properties',    '7750 Wisconsin Ave, Bethesda, MD 20814',       '2025-02-20 12:00:00+00'),
-- Stripe orders
('00010000-0000-0000-0000-000000000011', 'ORD-20250310-000011', 'b0000000-0000-0000-0000-000000000007', 'e0000000-0000-0000-0000-000000000012', 'delivered',  99950.00, 'Engineering team MacBook refresh',          '354 Oyster Point Blvd, South San Francisco',   '2025-03-10 10:00:00+00'),
('00010000-0000-0000-0000-000000000012', 'ORD-20250501-000012', 'b0000000-0000-0000-0000-000000000007', 'e0000000-0000-0000-0000-000000000013', 'confirmed',  14999.00, 'Office peripherals restock',                '354 Oyster Point Blvd, South San Francisco',   '2025-05-01 16:00:00+00'),
-- Deloitte orders
('00010000-0000-0000-0000-000000000013', 'ORD-20250115-000013', 'b0000000-0000-0000-0000-000000000008', 'e0000000-0000-0000-0000-000000000014', 'delivered', 164900.00, 'Firm-wide ThinkPad deployment',             '30 Rockefeller Plaza, New York, NY 10112',     '2025-01-15 09:00:00+00'),
('00010000-0000-0000-0000-000000000014', 'ORD-20250420-000014', 'b0000000-0000-0000-0000-000000000008', 'e0000000-0000-0000-0000-000000000015', 'processing', 17499.50, 'Video conferencing upgrade',                '30 Rockefeller Plaza, New York, NY 10112',     '2025-04-20 14:30:00+00'),
-- Cancelled order
('00010000-0000-0000-0000-000000000015', 'ORD-20250401-000015', 'b0000000-0000-0000-0000-000000000001', 'e0000000-0000-0000-0000-000000000002', 'cancelled',      0.00, 'Cancelled — budget freeze',                 '1 North Wacker Drive, Chicago, IL 60606',      '2025-04-01 08:00:00+00');

-- ============================================================
-- ORDER_ITEMS
-- ============================================================
-- ORD-1: Accenture laptop refresh (45 x MacBook Pro 14 M3 Pro = $89,955 — adjusted to match)
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price) VALUES
('11000000-0000-0000-0000-000000000001', '00010000-0000-0000-0000-000000000001', 'd0000000-0000-0000-0000-000000000011', 45, 1999.00);

-- ORD-2: Accenture AV (5 x Bose Soundbar 900 = $4,495 + 10 x Google Nest Hub Max = $2,299.90 ... simplified)
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price) VALUES
('11000000-0000-0000-0000-000000000002', '00010000-0000-0000-0000-000000000002', 'd0000000-0000-0000-0000-000000000055', 5, 899.00),
('11000000-0000-0000-0000-000000000003', '00010000-0000-0000-0000-000000000002', 'd0000000-0000-0000-0000-000000000077', 10, 229.99),
('11000000-0000-0000-0000-000000000004', '00010000-0000-0000-0000-000000000002', 'd0000000-0000-0000-0000-000000000075', 5, 2999.00);

-- ORD-3: Accenture new hire kit (10 x MacBook Air 15 M3)
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price) VALUES
('11000000-0000-0000-0000-000000000005', '00010000-0000-0000-0000-000000000003', 'd0000000-0000-0000-0000-000000000013', 10, 1299.00),
('11000000-0000-0000-0000-000000000006', '00010000-0000-0000-0000-000000000003', 'd0000000-0000-0000-0000-000000000066', 10, 99.99),
('11000000-0000-0000-0000-000000000007', '00010000-0000-0000-0000-000000000003', 'd0000000-0000-0000-0000-000000000067', 10, 109.99);

-- ORD-4: JPMorgan monitors (100 x Dell UltraSharp 27 + 50 x Samsung Odyssey G9)
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price) VALUES
('11000000-0000-0000-0000-000000000008', '00010000-0000-0000-0000-000000000004', 'd0000000-0000-0000-0000-000000000058', 100, 619.99),
('11000000-0000-0000-0000-000000000009', '00010000-0000-0000-0000-000000000004', 'd0000000-0000-0000-0000-000000000061', 50, 1299.99);

-- ORD-5: JPMorgan phones (50 x iPhone 15 Pro)
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price) VALUES
('11000000-0000-0000-0000-000000000010', '00010000-0000-0000-0000-000000000005', 'd0000000-0000-0000-0000-000000000002', 50, 999.00);

-- ORD-6: Mayo Clinic tablets (80 x iPad 10th Gen + 20 x iPad Air M1)
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price) VALUES
('11000000-0000-0000-0000-000000000011', '00010000-0000-0000-0000-000000000006', 'd0000000-0000-0000-0000-000000000029', 80, 449.00),
('11000000-0000-0000-0000-000000000012', '00010000-0000-0000-0000-000000000006', 'd0000000-0000-0000-0000-000000000028', 20, 599.00);

-- ORD-7: Mayo Clinic workstations (20 x Lenovo ThinkPad X1 Carbon)
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price) VALUES
('11000000-0000-0000-0000-000000000013', '00010000-0000-0000-0000-000000000007', 'd0000000-0000-0000-0000-000000000016', 20, 1649.00);

-- ORD-8: Stanford CS lab (25 x Dell XPS 15 + 25 x Dell UltraSharp 27)
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price) VALUES
('11000000-0000-0000-0000-000000000014', '00010000-0000-0000-0000-000000000008', 'd0000000-0000-0000-0000-000000000014', 25, 1799.99),
('11000000-0000-0000-0000-000000000015', '00010000-0000-0000-0000-000000000008', 'd0000000-0000-0000-0000-000000000058', 25, 619.99);

-- ORD-9: Stanford library peripherals (50 x Logitech MX Master 3S + 50 x MX Keys S)
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price) VALUES
('11000000-0000-0000-0000-000000000016', '00010000-0000-0000-0000-000000000009', 'd0000000-0000-0000-0000-000000000066', 50, 99.99),
('11000000-0000-0000-0000-000000000017', '00010000-0000-0000-0000-000000000009', 'd0000000-0000-0000-0000-000000000067', 50, 109.99);

-- ORD-10: Marriott smart displays (50 x Google Nest Hub 2nd Gen + 20 x Samsung TU7000 50)
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price) VALUES
('11000000-0000-0000-0000-000000000018', '00010000-0000-0000-0000-000000000010', 'd0000000-0000-0000-0000-000000000076', 50, 99.99),
('11000000-0000-0000-0000-000000000019', '00010000-0000-0000-0000-000000000010', 'd0000000-0000-0000-0000-000000000042', 20, 347.99);

-- ORD-11: Stripe MacBook refresh (50 x MacBook Pro 14 M3 Pro)
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price) VALUES
('11000000-0000-0000-0000-000000000020', '00010000-0000-0000-0000-000000000011', 'd0000000-0000-0000-0000-000000000011', 50, 1999.00);

-- ORD-12: Stripe peripherals (50 x MX Master 3S + 50 x MX Keys S + 50 x Brio 4K)
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price) VALUES
('11000000-0000-0000-0000-000000000021', '00010000-0000-0000-0000-000000000012', 'd0000000-0000-0000-0000-000000000066', 50, 99.99),
('11000000-0000-0000-0000-000000000022', '00010000-0000-0000-0000-000000000012', 'd0000000-0000-0000-0000-000000000067', 50, 109.99),
('11000000-0000-0000-0000-000000000023', '00010000-0000-0000-0000-000000000012', 'd0000000-0000-0000-0000-000000000070', 50, 199.99);

-- ORD-13: Deloitte ThinkPad deployment (100 x ThinkPad X1 Carbon)
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price) VALUES
('11000000-0000-0000-0000-000000000024', '00010000-0000-0000-0000-000000000013', 'd0000000-0000-0000-0000-000000000016', 100, 1649.00);

-- ORD-14: Deloitte video conferencing (5 x Rally Bar + 10 x Brio 4K)
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price) VALUES
('11000000-0000-0000-0000-000000000025', '00010000-0000-0000-0000-000000000014', 'd0000000-0000-0000-0000-000000000075', 5, 2999.00),
('11000000-0000-0000-0000-000000000026', '00010000-0000-0000-0000-000000000014', 'd0000000-0000-0000-0000-000000000070', 10, 199.99);

-- ORD-15: Cancelled — no items

-- ============================================================
-- AUDIT_LOG (sample entries)
-- ============================================================
INSERT INTO audit_log (id, contact_id, buyer_id, action, resource, resource_id, details, created_at) VALUES
('12000000-0000-0000-0000-000000000001', 'e0000000-0000-0000-0000-000000000001', 'b0000000-0000-0000-0000-000000000001', 'order:create',  'orders', '00010000-0000-0000-0000-000000000001', '{"total": 89940.00, "items": 1}',  '2025-01-15 10:30:00+00'),
('12000000-0000-0000-0000-000000000002', 'e0000000-0000-0000-0000-000000000003', 'b0000000-0000-0000-0000-000000000002', 'order:create',  'orders', '00010000-0000-0000-0000-000000000004', '{"total": 159900.00, "items": 2}', '2025-01-15 08:00:00+00'),
('12000000-0000-0000-0000-000000000003', 'e0000000-0000-0000-0000-000000000012', 'b0000000-0000-0000-0000-000000000007', 'catalog:search','product_catalog', NULL,                              '{"query": "macbook", "results": 3}','2025-03-10 09:55:00+00'),
('12000000-0000-0000-0000-000000000004', 'e0000000-0000-0000-0000-000000000012', 'b0000000-0000-0000-0000-000000000007', 'order:create',  'orders', '00010000-0000-0000-0000-000000000011', '{"total": 99950.00, "items": 1}',  '2025-03-10 10:00:00+00'),
('12000000-0000-0000-0000-000000000005', 'e0000000-0000-0000-0000-000000000011', 'b0000000-0000-0000-0000-000000000006', 'auth:denied',   'orders', NULL,                                    '{"reason": "buyer suspended"}',    '2025-04-05 11:00:00+00'),
('12000000-0000-0000-0000-000000000006', 'e0000000-0000-0000-0000-000000000002', 'b0000000-0000-0000-0000-000000000001', 'order:cancel',  'orders', '00010000-0000-0000-0000-000000000015', '{"reason": "budget freeze"}',      '2025-04-01 08:05:00+00'),
('12000000-0000-0000-0000-000000000007', 'e0000000-0000-0000-0000-000000000014', 'b0000000-0000-0000-0000-000000000008', 'order:create',  'orders', '00010000-0000-0000-0000-000000000013', '{"total": 164900.00, "items": 1}', '2025-01-15 09:00:00+00'),
('12000000-0000-0000-0000-000000000008', 'e0000000-0000-0000-0000-000000000018', 'b0000000-0000-0000-0000-000000000010', 'auth:denied',   'catalog', NULL,                                   '{"reason": "buyer revoked"}',      '2025-05-01 10:00:00+00');