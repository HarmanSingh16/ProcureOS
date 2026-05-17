-- =============================================================================
-- ProcureOS – B2B Consumer Electronics Procurement Database
-- Seed data script – deterministic UUIDs for FK integrity
-- =============================================================================

-- Clean tables before reseeding
TRUNCATE TABLE review_queue, po_line_items, purchase_orders, vendor_products,
               vendors, product_catalog, categories, users, organizations
    RESTART IDENTITY CASCADE;

-- =============================================================================
-- ORGANIZATIONS  (3 rows)
-- =============================================================================
INSERT INTO organizations (id, name, domain, industry) VALUES
('a0000000-0000-0000-0000-000000000001'::uuid, 'TechMart Global',         'techmart-global.com', 'Consumer Electronics'),
('a0000000-0000-0000-0000-000000000002'::uuid, 'ElectraHub Distribution', 'electrahub.com',      'IT & Enterprise'),
('a0000000-0000-0000-0000-000000000003'::uuid, 'PrimeGadget Corp',        'primegadget.com',     'Retail Electronics');

-- =============================================================================
-- USERS  (30 rows – 10 per org)
-- =============================================================================
INSERT INTO users (id, org_id, first_name, last_name, email, role) VALUES
-- TechMart Global (org 1)
('b0000000-0000-0000-0000-000000000001'::uuid, 'a0000000-0000-0000-0000-000000000001'::uuid, 'James',    'Mitchell',   'james.mitchell@techmart-global.com',   'admin'),
('b0000000-0000-0000-0000-000000000002'::uuid, 'a0000000-0000-0000-0000-000000000001'::uuid, 'Sarah',    'Chen',       'sarah.chen@techmart-global.com',       'admin'),
('b0000000-0000-0000-0000-000000000003'::uuid, 'a0000000-0000-0000-0000-000000000001'::uuid, 'Michael',  'Rodriguez',  'michael.rodriguez@techmart-global.com','buyer'),
('b0000000-0000-0000-0000-000000000004'::uuid, 'a0000000-0000-0000-0000-000000000001'::uuid, 'Emily',    'Thompson',   'emily.thompson@techmart-global.com',   'buyer'),
('b0000000-0000-0000-0000-000000000005'::uuid, 'a0000000-0000-0000-0000-000000000001'::uuid, 'David',    'Kim',        'david.kim@techmart-global.com',        'buyer'),
('b0000000-0000-0000-0000-000000000006'::uuid, 'a0000000-0000-0000-0000-000000000001'::uuid, 'Jessica',  'Patel',      'jessica.patel@techmart-global.com',    'buyer'),
('b0000000-0000-0000-0000-000000000007'::uuid, 'a0000000-0000-0000-0000-000000000001'::uuid, 'Robert',   'Williams',   'robert.williams@techmart-global.com',  'approver'),
('b0000000-0000-0000-0000-000000000008'::uuid, 'a0000000-0000-0000-0000-000000000001'::uuid, 'Amanda',   'Garcia',     'amanda.garcia@techmart-global.com',    'approver'),
('b0000000-0000-0000-0000-000000000009'::uuid, 'a0000000-0000-0000-0000-000000000001'::uuid, 'Daniel',   'Lee',        'daniel.lee@techmart-global.com',       'viewer'),
('b0000000-0000-0000-0000-000000000010'::uuid, 'a0000000-0000-0000-0000-000000000001'::uuid, 'Lauren',   'Martinez',   'lauren.martinez@techmart-global.com',  'viewer'),
-- ElectraHub Distribution (org 2)
('b0000000-0000-0000-0000-000000000011'::uuid, 'a0000000-0000-0000-0000-000000000002'::uuid, 'Chris',    'Anderson',   'chris.anderson@electrahub.com',        'admin'),
('b0000000-0000-0000-0000-000000000012'::uuid, 'a0000000-0000-0000-0000-000000000002'::uuid, 'Megan',    'Taylor',     'megan.taylor@electrahub.com',          'admin'),
('b0000000-0000-0000-0000-000000000013'::uuid, 'a0000000-0000-0000-0000-000000000002'::uuid, 'Kevin',    'Brown',      'kevin.brown@electrahub.com',           'buyer'),
('b0000000-0000-0000-0000-000000000014'::uuid, 'a0000000-0000-0000-0000-000000000002'::uuid, 'Rachel',   'Wilson',     'rachel.wilson@electrahub.com',         'buyer'),
('b0000000-0000-0000-0000-000000000015'::uuid, 'a0000000-0000-0000-0000-000000000002'::uuid, 'Brian',    'Davis',      'brian.davis@electrahub.com',           'buyer'),
('b0000000-0000-0000-0000-000000000016'::uuid, 'a0000000-0000-0000-0000-000000000002'::uuid, 'Nicole',   'Jackson',    'nicole.jackson@electrahub.com',        'buyer'),
('b0000000-0000-0000-0000-000000000017'::uuid, 'a0000000-0000-0000-0000-000000000002'::uuid, 'Andrew',   'White',      'andrew.white@electrahub.com',          'approver'),
('b0000000-0000-0000-0000-000000000018'::uuid, 'a0000000-0000-0000-0000-000000000002'::uuid, 'Stephanie','Harris',     'stephanie.harris@electrahub.com',      'approver'),
('b0000000-0000-0000-0000-000000000019'::uuid, 'a0000000-0000-0000-0000-000000000002'::uuid, 'Jason',    'Clark',      'jason.clark@electrahub.com',           'viewer'),
('b0000000-0000-0000-0000-000000000020'::uuid, 'a0000000-0000-0000-0000-000000000002'::uuid, 'Ashley',   'Lewis',      'ashley.lewis@electrahub.com',          'viewer'),
-- PrimeGadget Corp (org 3)
('b0000000-0000-0000-0000-000000000021'::uuid, 'a0000000-0000-0000-0000-000000000003'::uuid, 'Marcus',   'Robinson',   'marcus.robinson@primegadget.com',      'admin'),
('b0000000-0000-0000-0000-000000000022'::uuid, 'a0000000-0000-0000-0000-000000000003'::uuid, 'Olivia',   'Walker',     'olivia.walker@primegadget.com',        'admin'),
('b0000000-0000-0000-0000-000000000023'::uuid, 'a0000000-0000-0000-0000-000000000003'::uuid, 'Tyler',    'Young',      'tyler.young@primegadget.com',          'buyer'),
('b0000000-0000-0000-0000-000000000024'::uuid, 'a0000000-0000-0000-0000-000000000003'::uuid, 'Samantha', 'King',       'samantha.king@primegadget.com',        'buyer'),
('b0000000-0000-0000-0000-000000000025'::uuid, 'a0000000-0000-0000-0000-000000000003'::uuid, 'Nathan',   'Wright',     'nathan.wright@primegadget.com',        'buyer'),
('b0000000-0000-0000-0000-000000000026'::uuid, 'a0000000-0000-0000-0000-000000000003'::uuid, 'Brittany', 'Scott',      'brittany.scott@primegadget.com',       'buyer'),
('b0000000-0000-0000-0000-000000000027'::uuid, 'a0000000-0000-0000-0000-000000000003'::uuid, 'Patrick',  'Adams',      'patrick.adams@primegadget.com',        'approver'),
('b0000000-0000-0000-0000-000000000028'::uuid, 'a0000000-0000-0000-0000-000000000003'::uuid, 'Heather',  'Nelson',     'heather.nelson@primegadget.com',       'approver'),
('b0000000-0000-0000-0000-000000000029'::uuid, 'a0000000-0000-0000-0000-000000000003'::uuid, 'Scott',    'Hill',       'scott.hill@primegadget.com',           'viewer'),
('b0000000-0000-0000-0000-000000000030'::uuid, 'a0000000-0000-0000-0000-000000000003'::uuid, 'Kayla',    'Green',      'kayla.green@primegadget.com',          'viewer');

-- =============================================================================
-- CATEGORIES  (10 rows)
-- =============================================================================
INSERT INTO categories (id, name, slug, description) VALUES
('c0000000-0000-0000-0000-000000000001'::uuid, 'Smartphones',              'smartphones',            'Mobile phones and phablets from all major manufacturers.'),
('c0000000-0000-0000-0000-000000000002'::uuid, 'Laptops',                  'laptops',                'Notebook computers, ultrabooks, and mobile workstations.'),
('c0000000-0000-0000-0000-000000000003'::uuid, 'Televisions',              'televisions',            'LED, OLED, QLED, and smart TVs in all screen sizes.'),
('c0000000-0000-0000-0000-000000000004'::uuid, 'Tablets',                  'tablets',                'Tablet computers and 2-in-1 detachable devices.'),
('c0000000-0000-0000-0000-000000000005'::uuid, 'Audio & Headphones',       'audio-headphones',       'Headphones, earbuds, speakers, and soundbars.'),
('c0000000-0000-0000-0000-000000000006'::uuid, 'Wearables & Smartwatches', 'wearables-smartwatches', 'Smartwatches, fitness trackers, and wearable health devices.'),
('c0000000-0000-0000-0000-000000000007'::uuid, 'Gaming Consoles',          'gaming-consoles',        'Home and portable gaming consoles and accessories.'),
('c0000000-0000-0000-0000-000000000008'::uuid, 'Networking Equipment',     'networking-equipment',   'Routers, switches, access points, and mesh systems.'),
('c0000000-0000-0000-0000-000000000009'::uuid, 'Computer Peripherals',     'computer-peripherals',   'Monitors, keyboards, mice, webcams, and docking stations.'),
('c0000000-0000-0000-0000-000000000010'::uuid, 'Smart Home Devices',       'smart-home',             'Smart speakers, displays, doorbells, cameras, and home automation.');

-- =============================================================================
-- PRODUCT CATALOG  (200 rows – 20 per category)
-- =============================================================================

-- ── Smartphones (20) ──
INSERT INTO product_catalog (id, category_id, name, sku, description) VALUES
('d0000000-0000-0000-0000-000000000001'::uuid, 'c0000000-0000-0000-0000-000000000001'::uuid, 'Samsung Galaxy S24 Ultra 256GB',       'PHONE-SAM-S24U-256',      'Flagship Samsung smartphone with S Pen, 200MP camera, Snapdragon 8 Gen 3, 6.8" Dynamic AMOLED 2X display.'),
('d0000000-0000-0000-0000-000000000002'::uuid, 'c0000000-0000-0000-0000-000000000001'::uuid, 'Samsung Galaxy S24 Ultra 512GB',       'PHONE-SAM-S24U-512',      'Samsung Galaxy S24 Ultra with 512GB storage, titanium frame, and AI-powered camera features.'),
('d0000000-0000-0000-0000-000000000003'::uuid, 'c0000000-0000-0000-0000-000000000001'::uuid, 'Apple iPhone 15 Pro Max 256GB',        'PHONE-APL-IP15PM-256',    'Apple flagship with A17 Pro chip, 48MP main camera, titanium design, and USB-C connectivity.'),
('d0000000-0000-0000-0000-000000000004'::uuid, 'c0000000-0000-0000-0000-000000000001'::uuid, 'Apple iPhone 15 Pro Max 512GB',        'PHONE-APL-IP15PM-512',    'iPhone 15 Pro Max with 512GB storage, 5x optical zoom, and ProRes video recording.'),
('d0000000-0000-0000-0000-000000000005'::uuid, 'c0000000-0000-0000-0000-000000000001'::uuid, 'Apple iPhone 15 128GB',                'PHONE-APL-IP15-128',      'iPhone 15 with Dynamic Island, 48MP camera, A16 Bionic chip, and USB-C port.'),
('d0000000-0000-0000-0000-000000000006'::uuid, 'c0000000-0000-0000-0000-000000000001'::uuid, 'Google Pixel 8 Pro',                   'PHONE-GOO-PIX8PRO',       'Google Pixel 8 Pro with Tensor G3 chip, 50MP camera with AI editing, and 7 years of updates.'),
('d0000000-0000-0000-0000-000000000007'::uuid, 'c0000000-0000-0000-0000-000000000001'::uuid, 'Google Pixel 8',                       'PHONE-GOO-PIX8',          'Google Pixel 8 with Tensor G3, 6.2" Actua display, advanced photo and video capabilities.'),
('d0000000-0000-0000-0000-000000000008'::uuid, 'c0000000-0000-0000-0000-000000000001'::uuid, 'OnePlus 12 256GB',                     'PHONE-ONE-12-256',        'OnePlus 12 with Snapdragon 8 Gen 3, 50MP Hasselblad camera, 100W SUPERVOOC charging.'),
('d0000000-0000-0000-0000-000000000009'::uuid, 'c0000000-0000-0000-0000-000000000001'::uuid, 'Samsung Galaxy Z Fold 5 256GB',        'PHONE-SAM-ZFOLD5-256',    'Samsung foldable with 7.6" main display, Snapdragon 8 Gen 2, Flex Mode multitasking.'),
('d0000000-0000-0000-0000-000000000010'::uuid, 'c0000000-0000-0000-0000-000000000001'::uuid, 'Samsung Galaxy Z Flip 5 256GB',        'PHONE-SAM-ZFLIP5-256',    'Compact clamshell foldable with 3.4" Flex Window and 6.7" FHD+ main display.'),
('d0000000-0000-0000-0000-000000000011'::uuid, 'c0000000-0000-0000-0000-000000000001'::uuid, 'Samsung Galaxy A54 5G 128GB',          'PHONE-SAM-A54-128',       'Mid-range Samsung with 6.4" Super AMOLED, 50MP OIS camera, and IP67 water resistance.'),
('d0000000-0000-0000-0000-000000000012'::uuid, 'c0000000-0000-0000-0000-000000000001'::uuid, 'Apple iPhone SE (3rd Gen) 64GB',       'PHONE-APL-IPSE3-64',      'Compact iPhone with A15 Bionic chip, Touch ID, 4.7" Retina HD display, and 5G support.'),
('d0000000-0000-0000-0000-000000000013'::uuid, 'c0000000-0000-0000-0000-000000000001'::uuid, 'Motorola Edge 40 Pro',                 'PHONE-MOT-EDGE40P',       'Motorola flagship with Snapdragon 8 Gen 2, 165Hz pOLED display, and 125W TurboPower charging.'),
('d0000000-0000-0000-0000-000000000014'::uuid, 'c0000000-0000-0000-0000-000000000001'::uuid, 'Sony Xperia 1 V',                      'PHONE-SONY-X1V',          'Sony Xperia 1 V with 4K HDR OLED display, Exmor T sensor, and cinematography-grade video.'),
('d0000000-0000-0000-0000-000000000015'::uuid, 'c0000000-0000-0000-0000-000000000001'::uuid, 'Xiaomi 14 Ultra',                      'PHONE-XIA-14ULTRA',       'Xiaomi flagship with Leica Summilux lens system, Snapdragon 8 Gen 3, 90W HyperCharge.'),
('d0000000-0000-0000-0000-000000000016'::uuid, 'c0000000-0000-0000-0000-000000000001'::uuid, 'Nothing Phone (2)',                     'PHONE-NTH-PHONE2',        'Nothing Phone (2) with Glyph Interface LED lighting, Snapdragon 8+ Gen 1, clean OS.'),
('d0000000-0000-0000-0000-000000000017'::uuid, 'c0000000-0000-0000-0000-000000000001'::uuid, 'Samsung Galaxy S23 FE',                'PHONE-SAM-S23FE',         'Fan Edition Galaxy with 6.4" Dynamic AMOLED, Exynos 2200, and triple camera system.'),
('d0000000-0000-0000-0000-000000000018'::uuid, 'c0000000-0000-0000-0000-000000000001'::uuid, 'Google Pixel 7a',                      'PHONE-GOO-PIX7A',         'Affordable Pixel with Tensor G2, 64MP camera, 90Hz OLED display, and wireless charging.'),
('d0000000-0000-0000-0000-000000000019'::uuid, 'c0000000-0000-0000-0000-000000000001'::uuid, 'OnePlus Nord CE 3 Lite',               'PHONE-ONE-NORDCE3L',      'Budget-friendly OnePlus with 108MP camera, 67W SUPERVOOC, and 5000mAh battery.'),
('d0000000-0000-0000-0000-000000000020'::uuid, 'c0000000-0000-0000-0000-000000000001'::uuid, 'Asus ROG Phone 7 Ultimate',            'PHONE-ASUS-ROG7U',        'Gaming smartphone with Snapdragon 8 Gen 2, AeroActive Cooler 7, 165Hz AMOLED display.');

-- ── Laptops (20) ──
INSERT INTO product_catalog (id, category_id, name, sku, description) VALUES
('d0000000-0000-0000-0000-000000000021'::uuid, 'c0000000-0000-0000-0000-000000000002'::uuid, 'Dell XPS 15 (2024)',                   'LAPTOP-DELL-XPS15',       'Dell XPS 15 with Intel Core Ultra 7, 15.6" 3.5K OLED, 32GB RAM, 1TB SSD.'),
('d0000000-0000-0000-0000-000000000022'::uuid, 'c0000000-0000-0000-0000-000000000002'::uuid, 'Dell XPS 13 (2024)',                   'LAPTOP-DELL-XPS13',       'Ultra-thin Dell XPS 13 with Intel Core Ultra 5, 13.4" FHD+, 16GB RAM, 512GB SSD.'),
('d0000000-0000-0000-0000-000000000023'::uuid, 'c0000000-0000-0000-0000-000000000002'::uuid, 'Apple MacBook Pro 14" M3 Pro',         'LAPTOP-APL-MBP14-M3',     'MacBook Pro 14-inch with M3 Pro chip, 18GB unified memory, Liquid Retina XDR display.'),
('d0000000-0000-0000-0000-000000000024'::uuid, 'c0000000-0000-0000-0000-000000000002'::uuid, 'Apple MacBook Pro 16" M3 Max',         'LAPTOP-APL-MBP16-M3MAX',  'MacBook Pro 16-inch with M3 Max chip, 36GB unified memory, 1TB SSD, 22-hour battery.'),
('d0000000-0000-0000-0000-000000000025'::uuid, 'c0000000-0000-0000-0000-000000000002'::uuid, 'Apple MacBook Air 15" M3',             'LAPTOP-APL-MBA15-M3',     'MacBook Air 15.3-inch with M3 chip, 16GB unified memory, fanless design, 18-hour battery.'),
('d0000000-0000-0000-0000-000000000026'::uuid, 'c0000000-0000-0000-0000-000000000002'::uuid, 'Lenovo ThinkPad X1 Carbon Gen 11',     'LAPTOP-LEN-X1CARBON',     'Business ultrabook with Intel 13th Gen vPro, 14" 2.8K OLED, MIL-STD-810H durability.'),
('d0000000-0000-0000-0000-000000000027'::uuid, 'c0000000-0000-0000-0000-000000000002'::uuid, 'Lenovo ThinkPad T14s Gen 4',           'LAPTOP-LEN-T14S',         'Enterprise laptop with AMD Ryzen 7 PRO 7840U, 14" WUXGA, 32GB RAM, smart security.'),
('d0000000-0000-0000-0000-000000000028'::uuid, 'c0000000-0000-0000-0000-000000000002'::uuid, 'HP Spectre x360 14',                   'LAPTOP-HP-SPECTRE14',     'Premium 2-in-1 convertible with Intel Core Ultra 7, 14" 2.8K OLED touchscreen, Thunderbolt 4.'),
('d0000000-0000-0000-0000-000000000029'::uuid, 'c0000000-0000-0000-0000-000000000002'::uuid, 'HP EliteBook 840 G10',                 'LAPTOP-HP-EB840G10',      'Enterprise HP laptop with Intel 13th Gen vPro, 14" WUXGA, SureView privacy screen, 5G option.'),
('d0000000-0000-0000-0000-000000000030'::uuid, 'c0000000-0000-0000-0000-000000000002'::uuid, 'ASUS ZenBook 14 OLED',                 'LAPTOP-ASUS-ZB14OLED',    'Ultra-slim ASUS with Intel Core Ultra 7, 14" 2.8K OLED, 75Wh battery, NumberPad 2.0.'),
('d0000000-0000-0000-0000-000000000031'::uuid, 'c0000000-0000-0000-0000-000000000002'::uuid, 'ASUS ROG Zephyrus G14 (2024)',         'LAPTOP-ASUS-ROGG14',      'Gaming laptop with AMD Ryzen 9 8945HS, RTX 4070, 14" ROG Nebula OLED, 2.5K 120Hz.'),
('d0000000-0000-0000-0000-000000000032'::uuid, 'c0000000-0000-0000-0000-000000000002'::uuid, 'Acer Swift Go 14',                     'LAPTOP-ACER-SWIFTGO14',   'Thin and light Acer with Intel Core Ultra 7, 14" 2.8K OLED, Thunderbolt 4, AI features.'),
('d0000000-0000-0000-0000-000000000033'::uuid, 'c0000000-0000-0000-0000-000000000002'::uuid, 'Microsoft Surface Laptop 5 13.5"',     'LAPTOP-MS-SL5-13',        'Microsoft Surface Laptop 5 with 12th Gen Intel Core i7, 13.5" PixelSense touchscreen.'),
('d0000000-0000-0000-0000-000000000034'::uuid, 'c0000000-0000-0000-0000-000000000002'::uuid, 'Razer Blade 15 (2024)',                'LAPTOP-RAZER-BLADE15',    'Premium gaming laptop with Intel Core i9-14900HX, RTX 4080, 15.6" QHD 240Hz display.'),
('d0000000-0000-0000-0000-000000000035'::uuid, 'c0000000-0000-0000-0000-000000000002'::uuid, 'MSI Creator Z16 HX Studio',            'LAPTOP-MSI-CREATORZ16',   'Content creation laptop with Intel Core i9, RTX 4070, 16" QHD+ mini-LED, ISV certified.'),
('d0000000-0000-0000-0000-000000000036'::uuid, 'c0000000-0000-0000-0000-000000000002'::uuid, 'Framework Laptop 16',                  'LAPTOP-FRMWK-16',         'Modular 16-inch laptop with swappable GPU, user-upgradeable components, AMD Ryzen 7 7840HS.'),
('d0000000-0000-0000-0000-000000000037'::uuid, 'c0000000-0000-0000-0000-000000000002'::uuid, 'LG gram 17 (2024)',                    'LAPTOP-LG-GRAM17',        'Ultra-light 17-inch laptop at 1.35kg with Intel Core Ultra 7, 80Wh battery, MIL-STD-810H.'),
('d0000000-0000-0000-0000-000000000038'::uuid, 'c0000000-0000-0000-0000-000000000002'::uuid, 'Dell Latitude 5540',                   'LAPTOP-DELL-LAT5540',     'Business Dell laptop with Intel 13th Gen vPro, 15.6" FHD, Smart Card reader, TPM 2.0.'),
('d0000000-0000-0000-0000-000000000039'::uuid, 'c0000000-0000-0000-0000-000000000002'::uuid, 'HP Pavilion Plus 14',                  'LAPTOP-HP-PAV14PLUS',     'Mainstream laptop with Intel Core Ultra 5, 14" 2.8K OLED, Intel Arc graphics, Wi-Fi 7.'),
('d0000000-0000-0000-0000-000000000040'::uuid, 'c0000000-0000-0000-0000-000000000002'::uuid, 'Lenovo IdeaPad Pro 5 16',              'LAPTOP-LEN-IDEAPAD16',    'Productivity laptop with AMD Ryzen 7 8845HS, 16" 2.5K IPS, 84Wh battery, Copilot key.');

-- ── Televisions (20) ──
INSERT INTO product_catalog (id, category_id, name, sku, description) VALUES
('d0000000-0000-0000-0000-000000000041'::uuid, 'c0000000-0000-0000-0000-000000000003'::uuid, 'LG OLED evo C4 65"',                  'TV-LG-OLED-65C4',         'LG 65-inch OLED evo with α9 AI Processor Gen 7, 4K 120Hz, Dolby Vision, webOS 24.'),
('d0000000-0000-0000-0000-000000000042'::uuid, 'c0000000-0000-0000-0000-000000000003'::uuid, 'LG OLED evo G4 77"',                  'TV-LG-OLED-77G4',         'Gallery-series 77-inch OLED evo with MLA technology, flush wall-mount design, 4K 144Hz.'),
('d0000000-0000-0000-0000-000000000043'::uuid, 'c0000000-0000-0000-0000-000000000003'::uuid, 'Samsung QN90C Neo QLED 55"',           'TV-SAM-QLED-55Q90',       'Samsung 55-inch Neo QLED 4K with Neural Quantum Processor, Dolby Atmos, Object Tracking Sound+.'),
('d0000000-0000-0000-0000-000000000044'::uuid, 'c0000000-0000-0000-0000-000000000003'::uuid, 'Samsung QN85C Neo QLED 75"',           'TV-SAM-QLED-75Q85',       'Samsung 75-inch Neo QLED 4K with 120Hz, anti-glare coating, Gaming Hub, SmartThings.'),
('d0000000-0000-0000-0000-000000000045'::uuid, 'c0000000-0000-0000-0000-000000000003'::uuid, 'Samsung The Frame 55" (2024)',         'TV-SAM-FRAME-55',         'Art-style TV with customizable bezels, matte anti-reflection display, Art Store subscription.'),
('d0000000-0000-0000-0000-000000000046'::uuid, 'c0000000-0000-0000-0000-000000000003'::uuid, 'Sony Bravia XR X90L 75"',              'TV-SONY-BRAVIA-75X90',    'Sony 75-inch Full Array LED with Cognitive Processor XR, 4K 120Hz, Google TV, HDMI 2.1.'),
('d0000000-0000-0000-0000-000000000047'::uuid, 'c0000000-0000-0000-0000-000000000003'::uuid, 'Sony Bravia XR A95L QD-OLED 65"',      'TV-SONY-A95L-65',         'Premium QD-OLED 4K with XR Processor, XR Triluminos Max, Acoustic Surface Audio+.'),
('d0000000-0000-0000-0000-000000000048'::uuid, 'c0000000-0000-0000-0000-000000000003'::uuid, 'TCL QM8 98" Mini-LED',                 'TV-TCL-QM8-98',           'Massive 98-inch Mini-LED QLED with 2000+ dimming zones, 4K 120Hz, Google TV.'),
('d0000000-0000-0000-0000-000000000049'::uuid, 'c0000000-0000-0000-0000-000000000003'::uuid, 'TCL S4 55" 4K LED',                    'TV-TCL-S4-55',            'Budget-friendly 55-inch 4K LED with Google TV, HDR Pro, Voice Remote, Chromecast built-in.'),
('d0000000-0000-0000-0000-000000000050'::uuid, 'c0000000-0000-0000-0000-000000000003'::uuid, 'Hisense U8K 65" Mini-LED',             'TV-HIS-U8K-65',           'Hisense 65-inch Mini-LED ULED X with 144Hz, Dolby Vision IQ, IMAX Enhanced, Hi-View Engine X.'),
('d0000000-0000-0000-0000-000000000051'::uuid, 'c0000000-0000-0000-0000-000000000003'::uuid, 'Hisense U7K 55" ULED',                 'TV-HIS-U7K-55',           'Hisense 55-inch ULED 4K with 144Hz Game Mode PRO, Quantum Dot color, VIDAA smart TV OS.'),
('d0000000-0000-0000-0000-000000000052'::uuid, 'c0000000-0000-0000-0000-000000000003'::uuid, 'Vizio M-Series Quantum 65"',           'TV-VIZ-MSERIES-65',       'Vizio 65-inch Quantum Color 4K with IQ Active Processor, 120Hz, SmartCast, AirPlay 2.'),
('d0000000-0000-0000-0000-000000000053'::uuid, 'c0000000-0000-0000-0000-000000000003'::uuid, 'LG NanoCell 75" NANO80',               'TV-LG-NANO-75N80',        'LG 75-inch NanoCell 4K with α5 AI Processor Gen 7, NanoCell Color Technology, webOS 24.'),
('d0000000-0000-0000-0000-000000000054'::uuid, 'c0000000-0000-0000-0000-000000000003'::uuid, 'Samsung Crystal UHD 50" DU8000',       'TV-SAM-CRYSTAL-50DU8',    'Samsung 50-inch Crystal UHD 4K with Crystal Processor 4K, PurColor, Samsung TV Plus.'),
('d0000000-0000-0000-0000-000000000055'::uuid, 'c0000000-0000-0000-0000-000000000003'::uuid, 'Sony Bravia 43" X80L',                 'TV-SONY-43X80L',          'Sony 43-inch 4K LED with X1 processor, Triluminos Pro, Motionflow XR 240, Google TV.'),
('d0000000-0000-0000-0000-000000000056'::uuid, 'c0000000-0000-0000-0000-000000000003'::uuid, 'LG OLED B4 55"',                       'TV-LG-OLED-55B4',         'Entry OLED with α8 AI Processor, 4K 120Hz, Dolby Vision and Atmos, webOS 24, HDMI 2.1.'),
('d0000000-0000-0000-0000-000000000057'::uuid, 'c0000000-0000-0000-0000-000000000003'::uuid, 'Samsung S90C OLED 65"',                'TV-SAM-S90C-65',          'Samsung 65-inch OLED with Neural Quantum Processor 4K, LaserSlim design, One Connect Box.'),
('d0000000-0000-0000-0000-000000000058'::uuid, 'c0000000-0000-0000-0000-000000000003'::uuid, 'TCL Q7 65" QLED',                      'TV-TCL-Q7-65',            'TCL 65-inch QLED 4K with HDR Pro+, 120Hz Game Accelerator, Google TV, Dolby Atmos.'),
('d0000000-0000-0000-0000-000000000059'::uuid, 'c0000000-0000-0000-0000-000000000003'::uuid, 'Vizio V-Series 50" V505-J',            'TV-VIZ-VSERIES-50',       'Vizio 50-inch 4K UHD with V-Gaming Engine, IQ Active Processor, Chromecast built-in.'),
('d0000000-0000-0000-0000-000000000060'::uuid, 'c0000000-0000-0000-0000-000000000003'::uuid, 'Hisense A6 Series 70" 4K',             'TV-HIS-A6-70',            'Hisense 70-inch 4K UHD with DTS Virtual:X, Game Mode Plus, Google TV, Voice Remote.');

-- ── Tablets (20) ──
INSERT INTO product_catalog (id, category_id, name, sku, description) VALUES
('d0000000-0000-0000-0000-000000000061'::uuid, 'c0000000-0000-0000-0000-000000000004'::uuid, 'Apple iPad Pro 11" M4',                'TAB-APL-IPADPRO-11',      'iPad Pro 11-inch with M4 chip, Ultra Retina XDR tandem OLED, Apple Pencil Pro support.'),
('d0000000-0000-0000-0000-000000000062'::uuid, 'c0000000-0000-0000-0000-000000000004'::uuid, 'Apple iPad Pro 13" M4',                'TAB-APL-IPADPRO-13',      'iPad Pro 13-inch with M4 chip, Liquid Retina XDR, Thunderbolt / USB 4, Face ID.'),
('d0000000-0000-0000-0000-000000000063'::uuid, 'c0000000-0000-0000-0000-000000000004'::uuid, 'Apple iPad Air 11" M2',                'TAB-APL-IPADAIR-11',      'iPad Air 11-inch with M2 chip, Liquid Retina display, USB-C, Center Stage camera.'),
('d0000000-0000-0000-0000-000000000064'::uuid, 'c0000000-0000-0000-0000-000000000004'::uuid, 'Apple iPad 10th Gen 64GB',             'TAB-APL-IPAD10-64',       'iPad 10th generation with A14 Bionic, 10.9" Liquid Retina, USB-C, 12MP front camera.'),
('d0000000-0000-0000-0000-000000000065'::uuid, 'c0000000-0000-0000-0000-000000000004'::uuid, 'Apple iPad mini 6th Gen',              'TAB-APL-IPADMINI6',       'Compact iPad mini with A15 Bionic, 8.3" Liquid Retina, USB-C, Apple Pencil 2 support.'),
('d0000000-0000-0000-0000-000000000066'::uuid, 'c0000000-0000-0000-0000-000000000004'::uuid, 'Samsung Galaxy Tab S9 Ultra',           'TAB-SAM-TABS9U',          'Samsung 14.6" Dynamic AMOLED 2X tablet with Snapdragon 8 Gen 2, S Pen, IP68 rating.'),
('d0000000-0000-0000-0000-000000000067'::uuid, 'c0000000-0000-0000-0000-000000000004'::uuid, 'Samsung Galaxy Tab S9+ 256GB',         'TAB-SAM-TABS9P-256',      'Samsung 12.4" AMOLED tablet with Snapdragon 8 Gen 2, 256GB storage, DeX mode.'),
('d0000000-0000-0000-0000-000000000068'::uuid, 'c0000000-0000-0000-0000-000000000004'::uuid, 'Samsung Galaxy Tab S9 FE',             'TAB-SAM-TABS9FE',         'Fan edition 10.9" tablet with Exynos 1380, S Pen included, IP68 water resistance.'),
('d0000000-0000-0000-0000-000000000069'::uuid, 'c0000000-0000-0000-0000-000000000004'::uuid, 'Microsoft Surface Pro 9',              'TAB-MS-SURFACE-PRO9',     'Microsoft Surface Pro 9 with Intel 12th Gen Core i7, 13" PixelSense, Windows 11 Pro.'),
('d0000000-0000-0000-0000-000000000070'::uuid, 'c0000000-0000-0000-0000-000000000004'::uuid, 'Microsoft Surface Go 3',               'TAB-MS-SURFACE-GO3',      'Compact Windows tablet with Intel Core i3, 10.5" PixelSense, USB-C, Surface Pen support.'),
('d0000000-0000-0000-0000-000000000071'::uuid, 'c0000000-0000-0000-0000-000000000004'::uuid, 'Lenovo Tab P12 Pro',                   'TAB-LEN-P12PRO',          'Lenovo 12.6" AMOLED tablet with Snapdragon 870, JBL quad speakers, Precision Pen 3.'),
('d0000000-0000-0000-0000-000000000072'::uuid, 'c0000000-0000-0000-0000-000000000004'::uuid, 'Lenovo Tab M10 Plus Gen 3',            'TAB-LEN-M10PLUS3',        'Affordable 10.6" 2K IPS tablet with MediaTek Helio G80, dual speakers, kid-friendly mode.'),
('d0000000-0000-0000-0000-000000000073'::uuid, 'c0000000-0000-0000-0000-000000000004'::uuid, 'Amazon Fire HD 10 (2023)',              'TAB-AMZN-FIREHD10',       'Amazon 10.1" Fire HD tablet with 3GB RAM, octa-core processor, Alexa hands-free, USB-C.'),
('d0000000-0000-0000-0000-000000000074'::uuid, 'c0000000-0000-0000-0000-000000000004'::uuid, 'Amazon Fire HD 8 (2022)',               'TAB-AMZN-FIREHD8',        'Compact 8-inch Amazon tablet with 2GB RAM, hexa-core processor, 13-hour battery life.'),
('d0000000-0000-0000-0000-000000000075'::uuid, 'c0000000-0000-0000-0000-000000000004'::uuid, 'OnePlus Pad',                          'TAB-ONE-PAD',             'OnePlus 11.6" 2.8K IPS tablet with MediaTek Dimensity 9000, 67W SUPERVOOC, Dolby Vision.'),
('d0000000-0000-0000-0000-000000000076'::uuid, 'c0000000-0000-0000-0000-000000000004'::uuid, 'Xiaomi Pad 6 Pro',                     'TAB-XIA-PAD6PRO',         'Xiaomi 11-inch 2.8K IPS tablet with Snapdragon 8+ Gen 1, quad speakers, 8600mAh battery.'),
('d0000000-0000-0000-0000-000000000077'::uuid, 'c0000000-0000-0000-0000-000000000004'::uuid, 'Google Pixel Tablet 128GB',            'TAB-GOO-PIXTAB-128',      'Google Pixel Tablet with Tensor G2, 10.95" display, included Charging Speaker Dock.'),
('d0000000-0000-0000-0000-000000000078'::uuid, 'c0000000-0000-0000-0000-000000000004'::uuid, 'Huawei MatePad Pro 13.2"',             'TAB-HUA-MATEPADPRO13',    'Huawei 13.2" OLED tablet with Kirin 9000S, M-Pencil 2, HarmonyOS, 10050mAh battery.'),
('d0000000-0000-0000-0000-000000000079'::uuid, 'c0000000-0000-0000-0000-000000000004'::uuid, 'Nokia T21',                            'TAB-NOK-T21',             'Nokia 10.36" 2K tablet with Unisoc T612, 8200mAh battery, OZO Playback spatial audio.'),
('d0000000-0000-0000-0000-000000000080'::uuid, 'c0000000-0000-0000-0000-000000000004'::uuid, 'Samsung Galaxy Tab A9+',               'TAB-SAM-TABA9P',          'Budget Samsung 11" tablet with Snapdragon 695, One UI 5.1, expandable storage up to 1TB.');

-- ── Audio & Headphones (20) ──
INSERT INTO product_catalog (id, category_id, name, sku, description) VALUES
('d0000000-0000-0000-0000-000000000081'::uuid, 'c0000000-0000-0000-0000-000000000005'::uuid, 'Sony WH-1000XM5',                     'AUDIO-SONY-WH1000XM5',    'Premium wireless noise-cancelling headphones with 30-hour battery, LDAC, Speak-to-Chat.'),
('d0000000-0000-0000-0000-000000000082'::uuid, 'c0000000-0000-0000-0000-000000000005'::uuid, 'Sony WF-1000XM5',                     'AUDIO-SONY-WF1000XM5',    'Compact true wireless earbuds with industry-leading ANC, LDAC, 24-hour total battery.'),
('d0000000-0000-0000-0000-000000000083'::uuid, 'c0000000-0000-0000-0000-000000000005'::uuid, 'Apple AirPods Pro 2 (USB-C)',          'AUDIO-APL-AIRPODSPRO2',   'AirPods Pro 2nd gen with H2 chip, Adaptive Audio, USB-C MagSafe case, lossless audio.'),
('d0000000-0000-0000-0000-000000000084'::uuid, 'c0000000-0000-0000-0000-000000000005'::uuid, 'Apple AirPods Max',                    'AUDIO-APL-AIRPODSMAX',    'Over-ear headphones with H1 chip, Active Noise Cancellation, spatial audio, Digital Crown.'),
('d0000000-0000-0000-0000-000000000085'::uuid, 'c0000000-0000-0000-0000-000000000005'::uuid, 'Apple AirPods 3rd Gen',                'AUDIO-APL-AIRPODS3',      'Open-ear design with spatial audio, Adaptive EQ, MagSafe wireless charging case.'),
('d0000000-0000-0000-0000-000000000086'::uuid, 'c0000000-0000-0000-0000-000000000005'::uuid, 'Bose QuietComfort 45',                 'AUDIO-BOSE-QC45',         'Bose wireless noise-cancelling headphones with 24-hour battery, TriPort acoustic design.'),
('d0000000-0000-0000-0000-000000000087'::uuid, 'c0000000-0000-0000-0000-000000000005'::uuid, 'Bose QuietComfort Ultra Earbuds',      'AUDIO-BOSE-QCUE',         'Premium Bose earbuds with CustomTune, Immersive Audio, 6-hour battery, IPX4 rating.'),
('d0000000-0000-0000-0000-000000000088'::uuid, 'c0000000-0000-0000-0000-000000000005'::uuid, 'JBL Flip 6',                           'AUDIO-JBL-FLIP6',         'Portable Bluetooth speaker with IP67 waterproof, PartyBoost, 12-hour playtime, JBL Pro Sound.'),
('d0000000-0000-0000-0000-000000000089'::uuid, 'c0000000-0000-0000-0000-000000000005'::uuid, 'JBL Charge 5',                         'AUDIO-JBL-CHARGE5',       'Powerful portable speaker with built-in powerbank, IP67, 20-hour playtime, dual bass radiators.'),
('d0000000-0000-0000-0000-000000000090'::uuid, 'c0000000-0000-0000-0000-000000000005'::uuid, 'Sonos Era 300',                        'AUDIO-SONOS-ERA300',      'Spatial audio smart speaker with Dolby Atmos, Wi-Fi 6, Bluetooth 5.0, Trueplay tuning.'),
('d0000000-0000-0000-0000-000000000091'::uuid, 'c0000000-0000-0000-0000-000000000005'::uuid, 'Sonos Beam Gen 2',                     'AUDIO-SONOS-BEAM2',       'Compact soundbar with Dolby Atmos, eARC, speech enhancement, Amazon Alexa, Google Assistant.'),
('d0000000-0000-0000-0000-000000000092'::uuid, 'c0000000-0000-0000-0000-000000000005'::uuid, 'Sennheiser Momentum 4 Wireless',       'AUDIO-SENN-MTM4',         'Audiophile wireless headphones with 60-hour battery, Adaptive ANC, aptX Adaptive codec.'),
('d0000000-0000-0000-0000-000000000093'::uuid, 'c0000000-0000-0000-0000-000000000005'::uuid, 'Samsung Galaxy Buds2 Pro',             'AUDIO-SAM-BUDS2PRO',      'Samsung TWS earbuds with 360 Audio, ANC, 24-bit Hi-Fi sound, IPX7 water resistance.'),
('d0000000-0000-0000-0000-000000000094'::uuid, 'c0000000-0000-0000-0000-000000000005'::uuid, 'Beats Studio Pro',                     'AUDIO-BEATS-STUDIOPRO',   'Beats over-ear headphones with custom acoustic platform, Spatial Audio, USB-C, 40-hour battery.'),
('d0000000-0000-0000-0000-000000000095'::uuid, 'c0000000-0000-0000-0000-000000000005'::uuid, 'JBL PartyBox 310',                     'AUDIO-JBL-PARTYBOX310',   'Powerful party speaker with 240W output, IPX4 splash-proof, light show, guitar/mic inputs.'),
('d0000000-0000-0000-0000-000000000096'::uuid, 'c0000000-0000-0000-0000-000000000005'::uuid, 'Bose SoundLink Flex',                  'AUDIO-BOSE-SLINKFLEX',    'Bose portable Bluetooth speaker with IP67 waterproof, PositionIQ, 12-hour battery life.'),
('d0000000-0000-0000-0000-000000000097'::uuid, 'c0000000-0000-0000-0000-000000000005'::uuid, 'Sony ULT WEAR',                        'AUDIO-SONY-ULTWEAR',      'Sony over-ear headphones with ULT POWER SOUND, 30-hour battery, multipoint connection.'),
('d0000000-0000-0000-0000-000000000098'::uuid, 'c0000000-0000-0000-0000-000000000005'::uuid, 'Jabra Elite 85t',                      'AUDIO-JABRA-ELITE85T',    'Jabra premium TWS earbuds with adjustable ANC, HearThrough, Jabra MySound, IPX4 rating.'),
('d0000000-0000-0000-0000-000000000099'::uuid, 'c0000000-0000-0000-0000-000000000005'::uuid, 'Marshall Stanmore III',                 'AUDIO-MARSH-STANMORE3',   'Iconic Marshall home speaker with Bluetooth 5.2, HDMI, dynamic loudness, Placement Compensation.'),
('d0000000-0000-0000-0000-000000000100'::uuid, 'c0000000-0000-0000-0000-000000000005'::uuid, 'Audio-Technica ATH-M50xBT2',           'AUDIO-AT-M50XBT2',        'Studio monitor headphones with Bluetooth 5.0, 50-hour battery, 45mm large-aperture drivers.');

-- ── Wearables & Smartwatches (20) ──
INSERT INTO product_catalog (id, category_id, name, sku, description) VALUES
('d0000000-0000-0000-0000-000000000101'::uuid, 'c0000000-0000-0000-0000-000000000006'::uuid, 'Apple Watch Ultra 2',                  'WATCH-APL-ULTRA2',        'Rugged Apple Watch with S9 chip, 49mm titanium case, 72-hour battery, Precision Dual-Frequency GPS.'),
('d0000000-0000-0000-0000-000000000102'::uuid, 'c0000000-0000-0000-0000-000000000006'::uuid, 'Apple Watch Series 9 45mm',            'WATCH-APL-S9-45',         'Apple Watch Series 9 with S9 SiP, Double Tap gesture, always-on Retina display, 45mm case.'),
('d0000000-0000-0000-0000-000000000103'::uuid, 'c0000000-0000-0000-0000-000000000006'::uuid, 'Apple Watch SE 2nd Gen 44mm',          'WATCH-APL-SE2-44',        'Affordable Apple Watch with S8 chip, crash detection, 44mm case, Workout app.'),
('d0000000-0000-0000-0000-000000000104'::uuid, 'c0000000-0000-0000-0000-000000000006'::uuid, 'Samsung Galaxy Watch 6 Classic 47mm',  'WATCH-SAM-GW6C-47',       'Samsung smartwatch with rotating bezel, Exynos W930, sapphire crystal, BioActive Sensor.'),
('d0000000-0000-0000-0000-000000000105'::uuid, 'c0000000-0000-0000-0000-000000000006'::uuid, 'Samsung Galaxy Watch 6 44mm',          'WATCH-SAM-GW6-44',        'Samsung Galaxy Watch 6 with 1.5" Super AMOLED, Exynos W930, sleep coaching, Wear OS.'),
('d0000000-0000-0000-0000-000000000106'::uuid, 'c0000000-0000-0000-0000-000000000006'::uuid, 'Garmin Fenix 7X Solar',                'WATCH-GARMIN-FENIX7',     'Multi-sport GPS watch with solar charging, 37-day battery, TopoActive maps, PacePro.'),
('d0000000-0000-0000-0000-000000000107'::uuid, 'c0000000-0000-0000-0000-000000000006'::uuid, 'Garmin Venu 3',                        'WATCH-GARMIN-VENU3',      'Garmin AMOLED smartwatch with Body Battery, sleep coach, wheelchair mode, 14-day battery.'),
('d0000000-0000-0000-0000-000000000108'::uuid, 'c0000000-0000-0000-0000-000000000006'::uuid, 'Garmin Forerunner 965',                'WATCH-GARMIN-FR965',      'Premium running watch with 1.4" AMOLED, training readiness, race widget, 23-day battery.'),
('d0000000-0000-0000-0000-000000000109'::uuid, 'c0000000-0000-0000-0000-000000000006'::uuid, 'Fitbit Sense 2',                       'WATCH-FIT-SENSE2',        'Advanced health smartwatch with cEDA sensor, ECG, skin temperature, 6-day battery, Google Wallet.'),
('d0000000-0000-0000-0000-000000000110'::uuid, 'c0000000-0000-0000-0000-000000000006'::uuid, 'Fitbit Versa 4',                       'WATCH-FIT-VERSA4',        'Fitness smartwatch with 40+ exercise modes, GPS, 6-day battery, Amazon Alexa built-in.'),
('d0000000-0000-0000-0000-000000000111'::uuid, 'c0000000-0000-0000-0000-000000000006'::uuid, 'Google Pixel Watch 2',                 'WATCH-GOO-PIXW2',         'Google smartwatch with Tensor G2 coprocessor, Fitbit integration, heart rate, Safety Signal.'),
('d0000000-0000-0000-0000-000000000112'::uuid, 'c0000000-0000-0000-0000-000000000006'::uuid, 'Amazfit T-Rex Ultra',                  'WATCH-AMZF-TREXU',        'Rugged outdoor GPS watch with dual-band positioning, 20-day battery, 100m free diving.'),
('d0000000-0000-0000-0000-000000000113'::uuid, 'c0000000-0000-0000-0000-000000000006'::uuid, 'Amazfit GTS 4 Mini',                   'WATCH-AMZF-GTS4MINI',     'Slim fitness watch with 1.65" AMOLED, 120+ sports modes, 15-day battery, Zepp OS.'),
('d0000000-0000-0000-0000-000000000114'::uuid, 'c0000000-0000-0000-0000-000000000006'::uuid, 'Suunto Race',                          'WATCH-SUUN-RACE',         'Premium multisport watch with 1.43" AMOLED, dual-band GNSS, offline maps, 26-day battery.'),
('d0000000-0000-0000-0000-000000000115'::uuid, 'c0000000-0000-0000-0000-000000000006'::uuid, 'COROS PACE 3',                         'WATCH-COROS-PACE3',       'Lightweight GPS sport watch at 39g, 38-hour GPS, dual-frequency GNSS, nylon/silicone band.'),
('d0000000-0000-0000-0000-000000000116'::uuid, 'c0000000-0000-0000-0000-000000000006'::uuid, 'Withings ScanWatch 2 42mm',            'WATCH-WITH-SCANW2',       'Hybrid smartwatch with ECG, SpO2, temperature, 30-day battery, clinical-grade health sensors.'),
('d0000000-0000-0000-0000-000000000117'::uuid, 'c0000000-0000-0000-0000-000000000006'::uuid, 'Xiaomi Smart Band 8 Pro',              'WATCH-XIA-BAND8PRO',      'Premium fitness band with 1.74" AMOLED, 150+ sports, dual-band GNSS, 14-day battery.'),
('d0000000-0000-0000-0000-000000000118'::uuid, 'c0000000-0000-0000-0000-000000000006'::uuid, 'Oura Ring Gen 3',                      'WATCH-OURA-RING3',        'Smart ring with sleep tracking, readiness score, heart rate, temperature trend, titanium build.'),
('d0000000-0000-0000-0000-000000000119'::uuid, 'c0000000-0000-0000-0000-000000000006'::uuid, 'Whoop 4.0',                            'WATCH-WHOOP-4',           'Screenless fitness wearable with strain coach, recovery metrics, sleep performance, HRV.'),
('d0000000-0000-0000-0000-000000000120'::uuid, 'c0000000-0000-0000-0000-000000000006'::uuid, 'Garmin Instinct 2X Solar',             'WATCH-GARMIN-INST2XS',    'Rugged GPS watch with solar charging, unlimited battery life in smartwatch mode, MIL-STD-810.');

-- ── Gaming Consoles (20) ──
INSERT INTO product_catalog (id, category_id, name, sku, description) VALUES
('d0000000-0000-0000-0000-000000000121'::uuid, 'c0000000-0000-0000-0000-000000000007'::uuid, 'Sony PlayStation 5 Slim',              'CONSOLE-SONY-PS5-SLIM',   'Slim PS5 with custom AMD Zen 2, RDNA 2 GPU, 1TB SSD, 4K gaming up to 120fps, DualSense controller.'),
('d0000000-0000-0000-0000-000000000122'::uuid, 'c0000000-0000-0000-0000-000000000007'::uuid, 'Sony PlayStation 5 Digital Edition',    'CONSOLE-SONY-PS5-DE',     'Digital-only PS5 with same specs, no disc drive, lighter and thinner design, 1TB SSD.'),
('d0000000-0000-0000-0000-000000000123'::uuid, 'c0000000-0000-0000-0000-000000000007'::uuid, 'Microsoft Xbox Series X',              'CONSOLE-MS-XBOXSX',       'Xbox flagship with custom AMD Zen 2, 12 TFLOPS RDNA 2 GPU, 1TB NVMe SSD, 4K 120fps.'),
('d0000000-0000-0000-0000-000000000124'::uuid, 'c0000000-0000-0000-0000-000000000007'::uuid, 'Microsoft Xbox Series S',              'CONSOLE-MS-XBOXSS',       'Compact digital Xbox with 4 TFLOPS, 512GB SSD, 1440p gaming, Xbox Game Pass ready.'),
('d0000000-0000-0000-0000-000000000125'::uuid, 'c0000000-0000-0000-0000-000000000007'::uuid, 'Nintendo Switch OLED Model',            'CONSOLE-NIN-SWITCH-OLED', 'Nintendo Switch with 7" OLED screen, enhanced audio, 64GB storage, wide adjustable stand.'),
('d0000000-0000-0000-0000-000000000126'::uuid, 'c0000000-0000-0000-0000-000000000007'::uuid, 'Nintendo Switch Lite',                  'CONSOLE-NIN-SWITCH-LITE', 'Handheld-only Nintendo Switch with 5.5" LCD, built-in controls, lightweight and portable.'),
('d0000000-0000-0000-0000-000000000127'::uuid, 'c0000000-0000-0000-0000-000000000007'::uuid, 'Valve Steam Deck OLED 512GB',          'CONSOLE-VALVE-SDOLED-512','Portable PC gaming with 7.4" HDR OLED, AMD APU, SteamOS, hall-effect joysticks, Wi-Fi 6E.'),
('d0000000-0000-0000-0000-000000000128'::uuid, 'c0000000-0000-0000-0000-000000000007'::uuid, 'Valve Steam Deck OLED 1TB',            'CONSOLE-VALVE-SDOLED-1TB','Steam Deck OLED 1TB with premium anti-glare etched glass, exclusive carrying case, 90Hz.'),
('d0000000-0000-0000-0000-000000000129'::uuid, 'c0000000-0000-0000-0000-000000000007'::uuid, 'ASUS ROG Ally',                        'CONSOLE-ASUS-ROGALLY',    'Windows handheld gaming PC with AMD Ryzen Z1 Extreme, 7" FHD 120Hz, 512GB SSD, Xbox integration.'),
('d0000000-0000-0000-0000-000000000130'::uuid, 'c0000000-0000-0000-0000-000000000007'::uuid, 'Lenovo Legion Go',                     'CONSOLE-LEN-LEGGO',       'Windows handheld with detachable controllers, AMD Ryzen Z1 Extreme, 8.8" QHD+, 144Hz.'),
('d0000000-0000-0000-0000-000000000131'::uuid, 'c0000000-0000-0000-0000-000000000007'::uuid, 'Sony PlayStation VR2',                  'CONSOLE-SONY-PSVR2',      'PS5 VR headset with OLED display, 110° FOV, eye tracking, haptic feedback, 4K HDR.'),
('d0000000-0000-0000-0000-000000000132'::uuid, 'c0000000-0000-0000-0000-000000000007'::uuid, 'Meta Quest 3 128GB',                   'CONSOLE-META-QUEST3-128', 'Mixed reality headset with Snapdragon XR2 Gen 2, full-color passthrough, 128GB storage.'),
('d0000000-0000-0000-0000-000000000133'::uuid, 'c0000000-0000-0000-0000-000000000007'::uuid, 'Meta Quest 3 512GB',                   'CONSOLE-META-QUEST3-512', 'Meta Quest 3 premium with 512GB storage, Asgard''s Wrath 2 bundle, enhanced mixed reality.'),
('d0000000-0000-0000-0000-000000000134'::uuid, 'c0000000-0000-0000-0000-000000000007'::uuid, 'Sony DualSense Edge Controller',       'CONSOLE-SONY-DSEDGE',     'Pro PS5 controller with customizable buttons, adjustable triggers, swappable stick caps.'),
('d0000000-0000-0000-0000-000000000135'::uuid, 'c0000000-0000-0000-0000-000000000007'::uuid, 'Xbox Elite Wireless Controller Series 2','CONSOLE-MS-ELITE2',     'Premium Xbox controller with adjustable tension thumbsticks, shorter hair trigger locks, 40-hour battery.'),
('d0000000-0000-0000-0000-000000000136'::uuid, 'c0000000-0000-0000-0000-000000000007'::uuid, 'Nintendo Switch Pro Controller',        'CONSOLE-NIN-PROCTL',      'Wireless Nintendo Switch controller with amiibo support, motion controls, 40-hour battery.'),
('d0000000-0000-0000-0000-000000000137'::uuid, 'c0000000-0000-0000-0000-000000000007'::uuid, 'MSI Claw A1M',                         'CONSOLE-MSI-CLAW',        'Windows handheld with Intel Core Ultra 7, 7" FHD touchscreen, Thunderbolt 4, MSI Center M.'),
('d0000000-0000-0000-0000-000000000138'::uuid, 'c0000000-0000-0000-0000-000000000007'::uuid, 'Razer Kishi Ultra',                    'CONSOLE-RAZER-KISHIU',    'Universal mobile gaming controller with HyperSense haptics, Razer Nexus app, USB-C passthrough.'),
('d0000000-0000-0000-0000-000000000139'::uuid, 'c0000000-0000-0000-0000-000000000007'::uuid, 'Backbone One (USB-C) 2nd Gen',         'CONSOLE-BKBN-ONE2',       'Mobile gaming controller with low-latency USB-C, Backbone app, universal fit for phones.'),
('d0000000-0000-0000-0000-000000000140'::uuid, 'c0000000-0000-0000-0000-000000000007'::uuid, 'SteelSeries Arctis Nova Pro Wireless',  'CONSOLE-SS-ARCTISNOVAPW', 'Premium gaming headset with Active ANC, hot-swappable batteries, Hi-Res audio, dual wireless.');

-- ── Networking Equipment (20) ──
INSERT INTO product_catalog (id, category_id, name, sku, description) VALUES
('d0000000-0000-0000-0000-000000000141'::uuid, 'c0000000-0000-0000-0000-000000000008'::uuid, 'ASUS RT-AX86U Pro',                    'NET-ASUS-RT-AX86U',       'Wi-Fi 6 gaming router with AiMesh, WTFast, adaptive QoS, AiProtection Pro, 2.5G port.'),
('d0000000-0000-0000-0000-000000000142'::uuid, 'c0000000-0000-0000-0000-000000000008'::uuid, 'ASUS ROG Rapture GT-AX11000 Pro',      'NET-ASUS-ROGAX11K',       'Tri-band Wi-Fi 6 gaming router with 10G port, quad-core CPU, Triple-level Game Acceleration.'),
('d0000000-0000-0000-0000-000000000143'::uuid, 'c0000000-0000-0000-0000-000000000008'::uuid, 'TP-Link Deco XE75 (3-pack)',           'NET-TP-DECO-XE75',        'Wi-Fi 6E mesh system covering up to 7200 sq ft, tri-band AXE5400, AI-Driven Mesh technology.'),
('d0000000-0000-0000-0000-000000000144'::uuid, 'c0000000-0000-0000-0000-000000000008'::uuid, 'TP-Link Archer AX6000',                'NET-TP-ARCHER-AX6K',      'Dual-band Wi-Fi 6 router with 8 high-performance antennas, 2.5G WAN, 8 LAN ports, USB 3.0.'),
('d0000000-0000-0000-0000-000000000145'::uuid, 'c0000000-0000-0000-0000-000000000008'::uuid, 'Ubiquiti UniFi Dream Machine Pro',     'NET-UBNT-UDM-PRO',        'Enterprise gateway with UniFi OS, IPS/IDS, 10G SFP+, PoE support, integrated controller.'),
('d0000000-0000-0000-0000-000000000146'::uuid, 'c0000000-0000-0000-0000-000000000008'::uuid, 'Ubiquiti UniFi AP U6 Enterprise',      'NET-UBNT-U6ENT',          'Wi-Fi 6E access point with 2.5GbE uplink, 4x4 MIMO, 140m range, PoE powered, IP54.'),
('d0000000-0000-0000-0000-000000000147'::uuid, 'c0000000-0000-0000-0000-000000000008'::uuid, 'Netgear Nighthawk RAXE500',            'NET-NG-RAXE500',          'Tri-band Wi-Fi 6E router with 12-stream, 10G Ethernet, 2500 sq ft coverage, NETGEAR Armor.'),
('d0000000-0000-0000-0000-000000000148'::uuid, 'c0000000-0000-0000-0000-000000000008'::uuid, 'Netgear Orbi RBK863S (3-pack)',        'NET-NG-ORBI863S',         'Wi-Fi 6E mesh system with 10G Ethernet backhaul, 10000 sq ft coverage, NETGEAR Armor.'),
('d0000000-0000-0000-0000-000000000149'::uuid, 'c0000000-0000-0000-0000-000000000008'::uuid, 'Google Nest WiFi Pro (3-pack)',         'NET-GOO-NESTWIFIPRO',     'Wi-Fi 6E mesh system with Google Home integration, 6600 sq ft coverage, built-in Thread border router.'),
('d0000000-0000-0000-0000-000000000150'::uuid, 'c0000000-0000-0000-0000-000000000008'::uuid, 'Linksys Velop MX5300 (3-pack)',         'NET-LINK-VELOPMX5300',    'Tri-band Wi-Fi 6 mesh with Intelligent Mesh technology, 8100 sq ft, 4 Ethernet ports per node.'),
('d0000000-0000-0000-0000-000000000151'::uuid, 'c0000000-0000-0000-0000-000000000008'::uuid, 'Cisco Meraki MR46',                    'NET-CISCO-MR46',          'Cloud-managed Wi-Fi 6 access point with analytics, 802.3at PoE, dedicated security radio.'),
('d0000000-0000-0000-0000-000000000152'::uuid, 'c0000000-0000-0000-0000-000000000008'::uuid, 'Cisco Catalyst 1000 24-port PoE+',     'NET-CISCO-C1000-24P',     'Enterprise 24-port PoE+ managed switch with 4x1G SFP, fanless design, limited lifetime warranty.'),
('d0000000-0000-0000-0000-000000000153'::uuid, 'c0000000-0000-0000-0000-000000000008'::uuid, 'Aruba Instant On AP25',                'NET-ARUBA-AP25',          'Wi-Fi 6 access point for SMB with 4x4 MIMO, cloud management, Bluetooth 5.0, PoE powered.'),
('d0000000-0000-0000-0000-000000000154'::uuid, 'c0000000-0000-0000-0000-000000000008'::uuid, 'TP-Link Omada EAP670',                 'NET-TP-OMADA-EAP670',     'Wi-Fi 6 ceiling-mount AP with AX5400, 2.5G uplink, SDN cloud management, band steering.'),
('d0000000-0000-0000-0000-000000000155'::uuid, 'c0000000-0000-0000-0000-000000000008'::uuid, 'Ubiquiti EdgeRouter 4',                'NET-UBNT-ER4',            'Enterprise wired router with 3x GbE RJ45, 1x SFP, hardware offloading, EdgeOS, rackmountable.'),
('d0000000-0000-0000-0000-000000000156'::uuid, 'c0000000-0000-0000-0000-000000000008'::uuid, 'Netgear 48-Port PoE+ Smart Switch',    'NET-NG-GS748TPv3',        '48-port Gigabit PoE+ smart managed switch with 380W PoE budget, VLAN, QoS, IGMP snooping.'),
('d0000000-0000-0000-0000-000000000157'::uuid, 'c0000000-0000-0000-0000-000000000008'::uuid, 'MikroTik hAP ax3',                     'NET-MKTK-HAPAX3',         'Dual-band Wi-Fi 6 router with quad-core ARM CPU, 1x 2.5G and 4x 1G Ethernet, RouterOS 7.'),
('d0000000-0000-0000-0000-000000000158'::uuid, 'c0000000-0000-0000-0000-000000000008'::uuid, 'Eero Pro 6E (3-pack)',                  'NET-EERO-PRO6E',          'Amazon Eero tri-band Wi-Fi 6E mesh with TrueMesh, 2x 2.5G ports, Thread border router, 6000 sq ft.'),
('d0000000-0000-0000-0000-000000000159'::uuid, 'c0000000-0000-0000-0000-000000000008'::uuid, 'Synology RT6600ax',                     'NET-SYN-RT6600AX',        'Tri-band Wi-Fi 6 router with 2.5G WAN, SRM operating system, VPN Plus, Safe Access.'),
('d0000000-0000-0000-0000-000000000160'::uuid, 'c0000000-0000-0000-0000-000000000008'::uuid, 'TP-Link Deco BE65 Pro (3-pack)',        'NET-TP-DECO-BE65PRO',     'Wi-Fi 7 mesh system with BE9300 tri-band, 10G port, 7200 sq ft coverage, EasyMesh compatible.');

-- ── Computer Peripherals (20) ──
INSERT INTO product_catalog (id, category_id, name, sku, description) VALUES
('d0000000-0000-0000-0000-000000000161'::uuid, 'c0000000-0000-0000-0000-000000000009'::uuid, 'LG UltraGear 27GP850-B 27" QHD',      'PERIPH-LG-27GP850',       '27-inch Nano IPS gaming monitor with 1ms GTG, 165Hz, HDR 400, NVIDIA G-Sync, AMD FreeSync.'),
('d0000000-0000-0000-0000-000000000162'::uuid, 'c0000000-0000-0000-0000-000000000009'::uuid, 'Samsung Odyssey G9 49" DQHD',          'PERIPH-SAM-ODYSSEYG9',    '49-inch super ultra-wide curved monitor with DQHD 5120x1440, 240Hz, Quantum Mini-LED, 1ms.'),
('d0000000-0000-0000-0000-000000000163'::uuid, 'c0000000-0000-0000-0000-000000000009'::uuid, 'Dell UltraSharp U2723QE 27" 4K',       'PERIPH-DELL-U2723QE',     '27-inch 4K USB-C Hub monitor with IPS Black, 98% DCI-P3, 90W PD, KVM switch, VESA HDR 400.'),
('d0000000-0000-0000-0000-000000000164'::uuid, 'c0000000-0000-0000-0000-000000000009'::uuid, 'ASUS ProArt PA32UCG-K 32" 4K HDR',     'PERIPH-ASUS-PA32UCG',     '32-inch Mini-LED 4K HDR monitor with 120Hz, Dolby Vision, Thunderbolt 3, hardware calibration.'),
('d0000000-0000-0000-0000-000000000165'::uuid, 'c0000000-0000-0000-0000-000000000009'::uuid, 'Logitech MX Master 3S',                'PERIPH-LOGI-MX-MASTER3',  'Advanced wireless mouse with 8K DPI, MagSpeed scroll wheel, USB-C, Flow cross-computer control.'),
('d0000000-0000-0000-0000-000000000166'::uuid, 'c0000000-0000-0000-0000-000000000009'::uuid, 'Logitech MX Keys S',                   'PERIPH-LOGI-MX-KEYS-S',   'Wireless illuminated keyboard with smart backlighting, Easy-Switch, USB-C, Smart Actions.'),
('d0000000-0000-0000-0000-000000000167'::uuid, 'c0000000-0000-0000-0000-000000000009'::uuid, 'Corsair K100 RGB Mechanical',          'PERIPH-CORSAIR-K100',     'Flagship mechanical keyboard with OPX optical switches, iCUE control wheel, per-key RGB, PBT keycaps.'),
('d0000000-0000-0000-0000-000000000168'::uuid, 'c0000000-0000-0000-0000-000000000009'::uuid, 'Razer DeathAdder V3 Pro',              'PERIPH-RAZER-DAV3PRO',    'Ultra-light wireless gaming mouse at 63g with Focus Pro 30K sensor, 90-hour battery, HyperSpeed.'),
('d0000000-0000-0000-0000-000000000169'::uuid, 'c0000000-0000-0000-0000-000000000009'::uuid, 'Razer Huntsman V3 Pro TKL',            'PERIPH-RAZER-HUNTV3TKL',  'Analog optical gaming keyboard with adjustable actuation, rapid trigger, magnetic wrist rest.'),
('d0000000-0000-0000-0000-000000000170'::uuid, 'c0000000-0000-0000-0000-000000000009'::uuid, 'Logitech C920x Pro HD Webcam',         'PERIPH-LOGI-C920X',       'Full HD 1080p webcam with dual mics, auto light correction, 78° FOV, universal clip mount.'),
('d0000000-0000-0000-0000-000000000171'::uuid, 'c0000000-0000-0000-0000-000000000009'::uuid, 'Elgato Facecam Pro',                   'PERIPH-ELGATO-FACECAMPRO','4K60 webcam with Sony STARVIS sensor, f/2.0 prime lens, uncompressed HDMI out, Camera Hub.'),
('d0000000-0000-0000-0000-000000000172'::uuid, 'c0000000-0000-0000-0000-000000000009'::uuid, 'CalDigit TS4 Thunderbolt 4 Dock',      'PERIPH-CALDIG-TS4',       '18-port Thunderbolt 4 docking station with 98W PD, 2.5G Ethernet, SD/microSD, triple display.'),
('d0000000-0000-0000-0000-000000000173'::uuid, 'c0000000-0000-0000-0000-000000000009'::uuid, 'Samsung T7 Shield 2TB Portable SSD',   'PERIPH-SAM-T7SHIELD-2TB', 'Rugged portable SSD with 1050MB/s read, IP65 rating, USB 3.2, AES 256-bit encryption.'),
('d0000000-0000-0000-0000-000000000174'::uuid, 'c0000000-0000-0000-0000-000000000009'::uuid, 'WD Black SN850X 2TB NVMe SSD',         'PERIPH-WD-SN850X-2TB',    'PCIe Gen4 NVMe SSD with 7300MB/s read, Game Mode 2.0, RGB heatsink option, DirectStorage.'),
('d0000000-0000-0000-0000-000000000175'::uuid, 'c0000000-0000-0000-0000-000000000009'::uuid, 'BenQ ScreenBar Halo',                  'PERIPH-BENQ-SCREENBARHALO','Monitor light bar with wireless controller, asymmetric optics, back-glow ambient lighting.'),
('d0000000-0000-0000-0000-000000000176'::uuid, 'c0000000-0000-0000-0000-000000000009'::uuid, 'SteelSeries QcK Heavy XXL Mousepad',   'PERIPH-SS-QCKHEAVYXXL',   'Extra-large gaming mousepad with micro-woven cloth, non-slip rubber base, 900x400x6mm.'),
('d0000000-0000-0000-0000-000000000177'::uuid, 'c0000000-0000-0000-0000-000000000009'::uuid, 'Keychron Q1 Pro Mechanical Keyboard',  'PERIPH-KEYCH-Q1PRO',      'Wireless custom mechanical keyboard with QMK/VIA, gasket mount, aluminum CNC body, hot-swap.'),
('d0000000-0000-0000-0000-000000000178'::uuid, 'c0000000-0000-0000-0000-000000000009'::uuid, 'Apple Magic Keyboard with Touch ID',   'PERIPH-APL-MAGICKB-TID',  'Wireless keyboard with Touch ID sensor, aluminum design, Lightning charging, macOS integration.'),
('d0000000-0000-0000-0000-000000000179'::uuid, 'c0000000-0000-0000-0000-000000000009'::uuid, 'Elgato Stream Deck MK.2',              'PERIPH-ELGATO-SDMK2',     '15 customizable LCD keys for streaming, productivity, and smart home control, USB-C, detachable stand.'),
('d0000000-0000-0000-0000-000000000180'::uuid, 'c0000000-0000-0000-0000-000000000009'::uuid, 'HP Thunderbolt Dock G4',               'PERIPH-HP-TBDOCKG4',      'Universal Thunderbolt 4 dock with 120W PD, dual 4K display, 2.5G Ethernet, 4x USB-A, combo audio.');

-- ── Smart Home Devices (20) ──
INSERT INTO product_catalog (id, category_id, name, sku, description) VALUES
('d0000000-0000-0000-0000-000000000181'::uuid, 'c0000000-0000-0000-0000-000000000010'::uuid, 'Amazon Echo Show 5 (3rd Gen)',         'HOME-AMZN-ECHO-5',        '5.5-inch smart display with Alexa, 2MP camera, built-in smart home hub, improved speaker.'),
('d0000000-0000-0000-0000-000000000182'::uuid, 'c0000000-0000-0000-0000-000000000010'::uuid, 'Amazon Echo Dot 5th Gen',              'HOME-AMZN-ECHODOT5',      'Compact smart speaker with improved audio, temperature sensor, eero mesh Wi-Fi support.'),
('d0000000-0000-0000-0000-000000000183'::uuid, 'c0000000-0000-0000-0000-000000000010'::uuid, 'Amazon Echo Show 15',                  'HOME-AMZN-ECHOSHOW15',    '15.6-inch Full HD smart display with visual ID, smart home dashboard, Fire TV built-in.'),
('d0000000-0000-0000-0000-000000000184'::uuid, 'c0000000-0000-0000-0000-000000000010'::uuid, 'Google Nest Hub 2nd Gen',              'HOME-GOOGLE-NEST-HUB',    '7-inch smart display with sleep sensing, Google Assistant, Thread, smart home control panel.'),
('d0000000-0000-0000-0000-000000000185'::uuid, 'c0000000-0000-0000-0000-000000000010'::uuid, 'Google Nest Hub Max',                  'HOME-GOOGLE-NESTHUBMAX',  '10-inch HD smart display with 6.5MP Nest Cam, stereo speakers, Google Assistant, video calling.'),
('d0000000-0000-0000-0000-000000000186'::uuid, 'c0000000-0000-0000-0000-000000000010'::uuid, 'Google Nest Mini 2nd Gen',             'HOME-GOOGLE-NESTMINI2',   'Compact smart speaker with Google Assistant, 40mm driver, recycled materials, wall-mount ready.'),
('d0000000-0000-0000-0000-000000000187'::uuid, 'c0000000-0000-0000-0000-000000000010'::uuid, 'Ring Video Doorbell 4',                'HOME-RING-DOORBELL4',     'Wi-Fi video doorbell with 1080p HDR, Pre-Roll Video, Quick Replies, motion detection zones.'),
('d0000000-0000-0000-0000-000000000188'::uuid, 'c0000000-0000-0000-0000-000000000010'::uuid, 'Ring Floodlight Cam Wired Pro',        'HOME-RING-FLOODCAMPRO',   'Outdoor security camera with 1080p HDR, 3D Motion Detection, Bird''s Eye View, dual LED floodlights.'),
('d0000000-0000-0000-0000-000000000189'::uuid, 'c0000000-0000-0000-0000-000000000010'::uuid, 'Ring Indoor Cam 2nd Gen',              'HOME-RING-INDOORCAM2',    'Compact indoor security camera with 1080p HD, color night vision, two-way talk, privacy cover.'),
('d0000000-0000-0000-0000-000000000190'::uuid, 'c0000000-0000-0000-0000-000000000010'::uuid, 'Philips Hue Starter Kit (3 bulbs)',    'HOME-PHILIPS-HUE-SK3',    'Smart lighting starter kit with 3 color-capable A19 bulbs, Hue Bridge, Bluetooth and Zigbee.'),
('d0000000-0000-0000-0000-000000000191'::uuid, 'c0000000-0000-0000-0000-000000000010'::uuid, 'Philips Hue Gradient Lightstrip 2m',   'HOME-PHILIPS-GRADIENT2M', 'Smart LED lightstrip with multi-color gradient, Bluetooth, sync with entertainment, 2 meters.'),
('d0000000-0000-0000-0000-000000000192'::uuid, 'c0000000-0000-0000-0000-000000000010'::uuid, 'Nest Learning Thermostat 4th Gen',     'HOME-NEST-THERMO4',       'Smart thermostat with dynamic farsight, energy history, home/away assist, works with Alexa/Google.'),
('d0000000-0000-0000-0000-000000000193'::uuid, 'c0000000-0000-0000-0000-000000000010'::uuid, 'ecobee SmartThermostat Premium',       'HOME-ECOBEE-SMARTPREM',   'Smart thermostat with built-in Alexa, SmartSensor, air quality monitor, Siri, energy reports.'),
('d0000000-0000-0000-0000-000000000194'::uuid, 'c0000000-0000-0000-0000-000000000010'::uuid, 'August Wi-Fi Smart Lock 4th Gen',      'HOME-AUGUST-LOCK4',       'Retrofit smart lock with auto-lock/unlock, DoorSense, Wi-Fi built-in, works with Alexa/Google/Siri.'),
('d0000000-0000-0000-0000-000000000195'::uuid, 'c0000000-0000-0000-0000-000000000010'::uuid, 'Arlo Pro 5S 2K Spotlight Camera',      'HOME-ARLO-PRO5S',         'Wire-free security camera with 2K HDR, color night vision, 160° FOV, integrated spotlight, siren.'),
('d0000000-0000-0000-0000-000000000196'::uuid, 'c0000000-0000-0000-0000-000000000010'::uuid, 'TP-Link Kasa Smart Plug KP125',        'HOME-TPLINK-KP125',       'Wi-Fi smart plug with energy monitoring, scheduling, voice control, compact design, no hub required.'),
('d0000000-0000-0000-0000-000000000197'::uuid, 'c0000000-0000-0000-0000-000000000010'::uuid, 'iRobot Roomba j9+ Combo',              'HOME-IROBOT-J9PLUS',      'Robot vacuum and mop combo with PrecisionVision Navigation, auto-empty, smart mapping.'),
('d0000000-0000-0000-0000-000000000198'::uuid, 'c0000000-0000-0000-0000-000000000010'::uuid, 'Dyson Purifier Hot+Cool HP07',         'HOME-DYSON-HP07',         'Air purifier, heater, and fan with HEPA H13 filter, formaldehyde sensor, Dyson Link app.'),
('d0000000-0000-0000-0000-000000000199'::uuid, 'c0000000-0000-0000-0000-000000000010'::uuid, 'Samsung SmartThings Station',           'HOME-SAM-SMARTTHINGS-ST', 'Smart home hub with Matter/Thread, wireless charger, NFC tap automation, SmartThings Find.'),
('d0000000-0000-0000-0000-000000000200'::uuid, 'c0000000-0000-0000-0000-000000000010'::uuid, 'Apple HomePod 2nd Gen',                'HOME-APL-HOMEPOD2',       'Smart speaker with S7 chip, room-sensing, U1 chip for Handoff, temperature/humidity sensor, Siri.');

-- =============================================================================
-- VENDORS  (25 rows – ~8-9 per org)
-- =============================================================================
INSERT INTO vendors (id, org_id, name, contact_email, city, state, country, certifications, reliability_score, avg_response_time_hours) VALUES
-- TechMart Global vendors (9)
('e0000000-0000-0000-0000-000000000001'::uuid, 'a0000000-0000-0000-0000-000000000001'::uuid, 'GlobalTech Wholesale',       'sales@globaltechwholesale.com',   'Chicago',        'IL', 'US', '["ISO_9001","ISO_14001"]',                          0.95, 8),
('e0000000-0000-0000-0000-000000000002'::uuid, 'a0000000-0000-0000-0000-000000000001'::uuid, 'PrimeLine Distribution',     'orders@primelinedist.com',        'Los Angeles',    'CA', 'US', '["ISO_9001","AUTHORIZED_RESELLER"]',                0.92, 12),
('e0000000-0000-0000-0000-000000000003'::uuid, 'a0000000-0000-0000-0000-000000000001'::uuid, 'TechSource Direct',          'procurement@techsourcedirect.com','Dallas',         'TX', 'US', '["ISO_9001"]',                                      0.88, 16),
('e0000000-0000-0000-0000-000000000004'::uuid, 'a0000000-0000-0000-0000-000000000001'::uuid, 'ElectroParts Hub',           'info@electropartshub.com',        'New York',       'NY', 'US', '["ISO_9001","ISO_14001","ENERGY_STAR_PARTNER"]',    0.97, 6),
('e0000000-0000-0000-0000-000000000005'::uuid, 'a0000000-0000-0000-0000-000000000001'::uuid, 'Pacific Coast Electronics',  'sales@paccoastelec.com',          'San Jose',       'CA', 'US', '["ISO_9001","ISO_14001"]',                          0.91, 10),
('e0000000-0000-0000-0000-000000000006'::uuid, 'a0000000-0000-0000-0000-000000000001'::uuid, 'Midwest Supply Co',          'orders@midwestsupplyco.com',      'Columbus',       'OH', 'US', '["ISO_9001"]',                                      0.78, 24),
('e0000000-0000-0000-0000-000000000007'::uuid, 'a0000000-0000-0000-0000-000000000001'::uuid, 'SouthTech Partners',         'supply@southtechpartners.com',    'Atlanta',        'GA', 'US', '["ISO_9001","AUTHORIZED_RESELLER"]',                0.85, 18),
('e0000000-0000-0000-0000-000000000008'::uuid, 'a0000000-0000-0000-0000-000000000001'::uuid, 'Northeast Digital Supply',   'contact@nedigitalsupply.com',     'Newark',         'NJ', 'US', '["ISO_9001","ISO_14001"]',                          0.90, 14),
('e0000000-0000-0000-0000-000000000009'::uuid, 'a0000000-0000-0000-0000-000000000001'::uuid, 'Lone Star Components',       'sales@lonestarcomponents.com',    'Houston',        'TX', 'US', '["ISO_9001"]',                                      0.72, 36),
-- ElectraHub Distribution vendors (8)
('e0000000-0000-0000-0000-000000000010'::uuid, 'a0000000-0000-0000-0000-000000000002'::uuid, 'Pinnacle Electronics',       'sales@pinnacleelec.com',          'Seattle',        'WA', 'US', '["ISO_9001","ISO_14001","ENERGY_STAR_PARTNER"]',    0.96, 4),
('e0000000-0000-0000-0000-000000000011'::uuid, 'a0000000-0000-0000-0000-000000000002'::uuid, 'CloudBridge Supply',         'orders@cloudbridgesupply.com',    'San Francisco',  'CA', 'US', '["ISO_9001","AUTHORIZED_RESELLER"]',                0.93, 8),
('e0000000-0000-0000-0000-000000000012'::uuid, 'a0000000-0000-0000-0000-000000000002'::uuid, 'Metro Digital Distributors', 'info@metrodigitaldist.com',       'Philadelphia',   'PA', 'US', '["ISO_9001"]',                                      0.82, 20),
('e0000000-0000-0000-0000-000000000013'::uuid, 'a0000000-0000-0000-0000-000000000002'::uuid, 'Summit Tech Wholesale',      'sales@summittechwholesale.com',   'Denver',         'CO', 'US', '["ISO_9001","ISO_14001"]',                          0.89, 12),
('e0000000-0000-0000-0000-000000000014'::uuid, 'a0000000-0000-0000-0000-000000000002'::uuid, 'TriState Electronics',       'procurement@tristateelec.com',    'Edison',         'NJ', 'US', '["ISO_9001","AUTHORIZED_RESELLER"]',                0.87, 14),
('e0000000-0000-0000-0000-000000000015'::uuid, 'a0000000-0000-0000-0000-000000000002'::uuid, 'Great Lakes Tech Supply',    'orders@greatlakestech.com',       'Detroit',        'MI', 'US', '["ISO_9001"]',                                      0.75, 48),
('e0000000-0000-0000-0000-000000000016'::uuid, 'a0000000-0000-0000-0000-000000000002'::uuid, 'Digital Frontier Inc',       'sales@digitalfrontier.com',       'Austin',         'TX', 'US', '["ISO_9001","ISO_14001"]',                          0.94, 6),
('e0000000-0000-0000-0000-000000000017'::uuid, 'a0000000-0000-0000-0000-000000000002'::uuid, 'Harbor Electronics Group',   'supply@harborelecgroup.com',      'Miami',          'FL', 'US', '["ISO_9001"]',                                      0.80, 30),
-- PrimeGadget Corp vendors (8)
('e0000000-0000-0000-0000-000000000018'::uuid, 'a0000000-0000-0000-0000-000000000003'::uuid, 'Vertex Distribution LLC',    'sales@vertexdist.com',            'Phoenix',        'AZ', 'US', '["ISO_9001","ISO_14001","ENERGY_STAR_PARTNER"]',    0.98, 4),
('e0000000-0000-0000-0000-000000000019'::uuid, 'a0000000-0000-0000-0000-000000000003'::uuid, 'Cascade Supply Network',     'orders@cascadesupply.com',        'Portland',       'OR', 'US', '["ISO_9001","AUTHORIZED_RESELLER"]',                0.91, 10),
('e0000000-0000-0000-0000-000000000020'::uuid, 'a0000000-0000-0000-0000-000000000003'::uuid, 'SunBelt Components',         'info@sunbeltcomponents.com',      'Tampa',          'FL', 'US', '["ISO_9001"]',                                      0.83, 22),
('e0000000-0000-0000-0000-000000000021'::uuid, 'a0000000-0000-0000-0000-000000000003'::uuid, 'Heritage Tech Partners',     'sales@heritagetechpartners.com',  'Charlotte',      'NC', 'US', '["ISO_9001","ISO_14001"]',                          0.86, 16),
('e0000000-0000-0000-0000-000000000022'::uuid, 'a0000000-0000-0000-0000-000000000003'::uuid, 'Bayshore Wholesale Tech',    'procurement@bayshorewt.com',      'San Diego',      'CA', 'US', '["ISO_9001","AUTHORIZED_RESELLER"]',                0.93, 8),
('e0000000-0000-0000-0000-000000000023'::uuid, 'a0000000-0000-0000-0000-000000000003'::uuid, 'Central Valley Electronics', 'orders@centralvalleyelec.com',    'Fresno',         'CA', 'US', '["ISO_9001"]',                                      0.70, 48),
('e0000000-0000-0000-0000-000000000024'::uuid, 'a0000000-0000-0000-0000-000000000003'::uuid, 'Empire State Digital',       'sales@empirestatedigital.com',    'Buffalo',        'NY', 'US', '["ISO_9001","ISO_14001"]',                          0.88, 14),
('e0000000-0000-0000-0000-000000000025'::uuid, 'a0000000-0000-0000-0000-000000000003'::uuid, 'Keystone Supply Group',      'info@keystonesupply.com',         'Pittsburgh',     'PA', 'US', '["ISO_9001","ISO_14001","ENERGY_STAR_PARTNER"]',    0.99, 4);

-- =============================================================================
-- VENDOR PRODUCTS  (500 rows – 20 products per vendor)
-- =============================================================================
-- Vendor 1: GlobalTech Wholesale (Chicago IL) – products 1-20 (smartphones)
INSERT INTO vendor_products (id, vendor_id, product_id, unit_price, moq, lead_time_days, in_stock, stock_quantity) VALUES
('f0000000-0000-0000-0000-000000000001'::uuid, 'e0000000-0000-0000-0000-000000000001'::uuid, 'd0000000-0000-0000-0000-000000000001'::uuid, 899.99, 10, 5, TRUE, 450),
('f0000000-0000-0000-0000-000000000002'::uuid, 'e0000000-0000-0000-0000-000000000001'::uuid, 'd0000000-0000-0000-0000-000000000002'::uuid, 1049.99, 10, 5, TRUE, 280),
('f0000000-0000-0000-0000-000000000003'::uuid, 'e0000000-0000-0000-0000-000000000001'::uuid, 'd0000000-0000-0000-0000-000000000003'::uuid, 949.99, 10, 7, TRUE, 520),
('f0000000-0000-0000-0000-000000000004'::uuid, 'e0000000-0000-0000-0000-000000000001'::uuid, 'd0000000-0000-0000-0000-000000000004'::uuid, 1149.99, 5, 7, TRUE, 180),
('f0000000-0000-0000-0000-000000000005'::uuid, 'e0000000-0000-0000-0000-000000000001'::uuid, 'd0000000-0000-0000-0000-000000000005'::uuid, 629.99, 15, 5, TRUE, 800),
('f0000000-0000-0000-0000-000000000006'::uuid, 'e0000000-0000-0000-0000-000000000001'::uuid, 'd0000000-0000-0000-0000-000000000006'::uuid, 749.99, 10, 7, TRUE, 350),
('f0000000-0000-0000-0000-000000000007'::uuid, 'e0000000-0000-0000-0000-000000000001'::uuid, 'd0000000-0000-0000-0000-000000000007'::uuid, 549.99, 15, 5, TRUE, 600),
('f0000000-0000-0000-0000-000000000008'::uuid, 'e0000000-0000-0000-0000-000000000001'::uuid, 'd0000000-0000-0000-0000-000000000008'::uuid, 599.99, 10, 7, TRUE, 420),
('f0000000-0000-0000-0000-000000000009'::uuid, 'e0000000-0000-0000-0000-000000000001'::uuid, 'd0000000-0000-0000-0000-000000000009'::uuid, 1399.99, 5, 10, TRUE, 120),
('f0000000-0000-0000-0000-000000000010'::uuid, 'e0000000-0000-0000-0000-000000000001'::uuid, 'd0000000-0000-0000-0000-000000000010'::uuid, 799.99, 10, 7, FALSE, 0),
('f0000000-0000-0000-0000-000000000011'::uuid, 'e0000000-0000-0000-0000-000000000001'::uuid, 'd0000000-0000-0000-0000-000000000011'::uuid, 329.99, 20, 5, TRUE, 1200),
('f0000000-0000-0000-0000-000000000012'::uuid, 'e0000000-0000-0000-0000-000000000001'::uuid, 'd0000000-0000-0000-0000-000000000012'::uuid, 349.99, 20, 5, TRUE, 900),
('f0000000-0000-0000-0000-000000000013'::uuid, 'e0000000-0000-0000-0000-000000000001'::uuid, 'd0000000-0000-0000-0000-000000000013'::uuid, 549.99, 10, 10, TRUE, 250),
('f0000000-0000-0000-0000-000000000014'::uuid, 'e0000000-0000-0000-0000-000000000001'::uuid, 'd0000000-0000-0000-0000-000000000014'::uuid, 899.99, 5, 14, TRUE, 100),
('f0000000-0000-0000-0000-000000000015'::uuid, 'e0000000-0000-0000-0000-000000000001'::uuid, 'd0000000-0000-0000-0000-000000000015'::uuid, 999.99, 5, 14, FALSE, 0),
('f0000000-0000-0000-0000-000000000016'::uuid, 'e0000000-0000-0000-0000-000000000001'::uuid, 'd0000000-0000-0000-0000-000000000016'::uuid, 449.99, 15, 7, TRUE, 380),
('f0000000-0000-0000-0000-000000000017'::uuid, 'e0000000-0000-0000-0000-000000000001'::uuid, 'd0000000-0000-0000-0000-000000000017'::uuid, 449.99, 15, 5, TRUE, 550),
('f0000000-0000-0000-0000-000000000018'::uuid, 'e0000000-0000-0000-0000-000000000001'::uuid, 'd0000000-0000-0000-0000-000000000018'::uuid, 379.99, 20, 5, TRUE, 700),
('f0000000-0000-0000-0000-000000000019'::uuid, 'e0000000-0000-0000-0000-000000000001'::uuid, 'd0000000-0000-0000-0000-000000000019'::uuid, 249.99, 25, 5, TRUE, 1500),
('f0000000-0000-0000-0000-000000000020'::uuid, 'e0000000-0000-0000-0000-000000000001'::uuid, 'd0000000-0000-0000-0000-000000000020'::uuid, 899.99, 5, 14, TRUE, 80);

-- Vendor 2: PrimeLine Distribution (LA CA) – products 21-40 (laptops)
INSERT INTO vendor_products (id, vendor_id, product_id, unit_price, moq, lead_time_days, in_stock, stock_quantity) VALUES
('f0000000-0000-0000-0000-000000000021'::uuid, 'e0000000-0000-0000-0000-000000000002'::uuid, 'd0000000-0000-0000-0000-000000000021'::uuid, 1449.99, 5, 7, TRUE, 200),
('f0000000-0000-0000-0000-000000000022'::uuid, 'e0000000-0000-0000-0000-000000000002'::uuid, 'd0000000-0000-0000-0000-000000000022'::uuid, 1099.99, 10, 5, TRUE, 350),
('f0000000-0000-0000-0000-000000000023'::uuid, 'e0000000-0000-0000-0000-000000000002'::uuid, 'd0000000-0000-0000-0000-000000000023'::uuid, 1699.99, 5, 7, TRUE, 180),
('f0000000-0000-0000-0000-000000000024'::uuid, 'e0000000-0000-0000-0000-000000000002'::uuid, 'd0000000-0000-0000-0000-000000000024'::uuid, 2799.99, 3, 10, TRUE, 60),
('f0000000-0000-0000-0000-000000000025'::uuid, 'e0000000-0000-0000-0000-000000000002'::uuid, 'd0000000-0000-0000-0000-000000000025'::uuid, 1099.99, 10, 5, TRUE, 400),
('f0000000-0000-0000-0000-000000000026'::uuid, 'e0000000-0000-0000-0000-000000000002'::uuid, 'd0000000-0000-0000-0000-000000000026'::uuid, 1549.99, 5, 7, TRUE, 220),
('f0000000-0000-0000-0000-000000000027'::uuid, 'e0000000-0000-0000-0000-000000000002'::uuid, 'd0000000-0000-0000-0000-000000000027'::uuid, 1349.99, 5, 7, TRUE, 280),
('f0000000-0000-0000-0000-000000000028'::uuid, 'e0000000-0000-0000-0000-000000000002'::uuid, 'd0000000-0000-0000-0000-000000000028'::uuid, 1299.99, 5, 7, TRUE, 160),
('f0000000-0000-0000-0000-000000000029'::uuid, 'e0000000-0000-0000-0000-000000000002'::uuid, 'd0000000-0000-0000-0000-000000000029'::uuid, 1449.99, 5, 7, TRUE, 300),
('f0000000-0000-0000-0000-000000000030'::uuid, 'e0000000-0000-0000-0000-000000000002'::uuid, 'd0000000-0000-0000-0000-000000000030'::uuid, 999.99, 10, 5, TRUE, 450),
('f0000000-0000-0000-0000-000000000031'::uuid, 'e0000000-0000-0000-0000-000000000002'::uuid, 'd0000000-0000-0000-0000-000000000031'::uuid, 1599.99, 5, 10, FALSE, 0),
('f0000000-0000-0000-0000-000000000032'::uuid, 'e0000000-0000-0000-0000-000000000002'::uuid, 'd0000000-0000-0000-0000-000000000032'::uuid, 849.99, 10, 5, TRUE, 380),
('f0000000-0000-0000-0000-000000000033'::uuid, 'e0000000-0000-0000-0000-000000000002'::uuid, 'd0000000-0000-0000-0000-000000000033'::uuid, 1199.99, 5, 7, TRUE, 240),
('f0000000-0000-0000-0000-000000000034'::uuid, 'e0000000-0000-0000-0000-000000000002'::uuid, 'd0000000-0000-0000-0000-000000000034'::uuid, 2299.99, 3, 14, TRUE, 45),
('f0000000-0000-0000-0000-000000000035'::uuid, 'e0000000-0000-0000-0000-000000000002'::uuid, 'd0000000-0000-0000-0000-000000000035'::uuid, 2149.99, 3, 14, TRUE, 55),
('f0000000-0000-0000-0000-000000000036'::uuid, 'e0000000-0000-0000-0000-000000000002'::uuid, 'd0000000-0000-0000-0000-000000000036'::uuid, 1299.99, 5, 10, TRUE, 150),
('f0000000-0000-0000-0000-000000000037'::uuid, 'e0000000-0000-0000-0000-000000000002'::uuid, 'd0000000-0000-0000-0000-000000000037'::uuid, 1399.99, 5, 7, TRUE, 190),
('f0000000-0000-0000-0000-000000000038'::uuid, 'e0000000-0000-0000-0000-000000000002'::uuid, 'd0000000-0000-0000-0000-000000000038'::uuid, 1099.99, 10, 5, TRUE, 500),
('f0000000-0000-0000-0000-000000000039'::uuid, 'e0000000-0000-0000-0000-000000000002'::uuid, 'd0000000-0000-0000-0000-000000000039'::uuid, 799.99, 10, 5, TRUE, 420),
('f0000000-0000-0000-0000-000000000040'::uuid, 'e0000000-0000-0000-0000-000000000002'::uuid, 'd0000000-0000-0000-0000-000000000040'::uuid, 849.99, 10, 7, TRUE, 340);

-- Vendor 3: TechSource Direct (Dallas TX) – products 41-60 (TVs)
INSERT INTO vendor_products (id, vendor_id, product_id, unit_price, moq, lead_time_days, in_stock, stock_quantity) VALUES
('f0000000-0000-0000-0000-000000000041'::uuid, 'e0000000-0000-0000-0000-000000000003'::uuid, 'd0000000-0000-0000-0000-000000000041'::uuid, 1599.99, 3, 10, TRUE, 120),
('f0000000-0000-0000-0000-000000000042'::uuid, 'e0000000-0000-0000-0000-000000000003'::uuid, 'd0000000-0000-0000-0000-000000000042'::uuid, 2499.99, 2, 14, TRUE, 40),
('f0000000-0000-0000-0000-000000000043'::uuid, 'e0000000-0000-0000-0000-000000000003'::uuid, 'd0000000-0000-0000-0000-000000000043'::uuid, 899.99, 5, 7, TRUE, 280),
('f0000000-0000-0000-0000-000000000044'::uuid, 'e0000000-0000-0000-0000-000000000003'::uuid, 'd0000000-0000-0000-0000-000000000044'::uuid, 1299.99, 3, 10, TRUE, 150),
('f0000000-0000-0000-0000-000000000045'::uuid, 'e0000000-0000-0000-0000-000000000003'::uuid, 'd0000000-0000-0000-0000-000000000045'::uuid, 999.99, 5, 7, TRUE, 200),
('f0000000-0000-0000-0000-000000000046'::uuid, 'e0000000-0000-0000-0000-000000000003'::uuid, 'd0000000-0000-0000-0000-000000000046'::uuid, 1099.99, 3, 10, TRUE, 170),
('f0000000-0000-0000-0000-000000000047'::uuid, 'e0000000-0000-0000-0000-000000000003'::uuid, 'd0000000-0000-0000-0000-000000000047'::uuid, 2199.99, 2, 14, TRUE, 35),
('f0000000-0000-0000-0000-000000000048'::uuid, 'e0000000-0000-0000-0000-000000000003'::uuid, 'd0000000-0000-0000-0000-000000000048'::uuid, 2999.99, 1, 21, FALSE, 0),
('f0000000-0000-0000-0000-000000000049'::uuid, 'e0000000-0000-0000-0000-000000000003'::uuid, 'd0000000-0000-0000-0000-000000000049'::uuid, 299.99, 10, 5, TRUE, 800),
('f0000000-0000-0000-0000-000000000050'::uuid, 'e0000000-0000-0000-0000-000000000003'::uuid, 'd0000000-0000-0000-0000-000000000050'::uuid, 799.99, 5, 7, TRUE, 250),
('f0000000-0000-0000-0000-000000000051'::uuid, 'e0000000-0000-0000-0000-000000000003'::uuid, 'd0000000-0000-0000-0000-000000000051'::uuid, 549.99, 5, 7, TRUE, 320),
('f0000000-0000-0000-0000-000000000052'::uuid, 'e0000000-0000-0000-0000-000000000003'::uuid, 'd0000000-0000-0000-0000-000000000052'::uuid, 649.99, 5, 7, TRUE, 280),
('f0000000-0000-0000-0000-000000000053'::uuid, 'e0000000-0000-0000-0000-000000000003'::uuid, 'd0000000-0000-0000-0000-000000000053'::uuid, 899.99, 3, 10, TRUE, 110),
('f0000000-0000-0000-0000-000000000054'::uuid, 'e0000000-0000-0000-0000-000000000003'::uuid, 'd0000000-0000-0000-0000-000000000054'::uuid, 379.99, 10, 5, TRUE, 600),
('f0000000-0000-0000-0000-000000000055'::uuid, 'e0000000-0000-0000-0000-000000000003'::uuid, 'd0000000-0000-0000-0000-000000000055'::uuid, 449.99, 5, 7, TRUE, 350),
('f0000000-0000-0000-0000-000000000056'::uuid, 'e0000000-0000-0000-0000-000000000003'::uuid, 'd0000000-0000-0000-0000-000000000056'::uuid, 1099.99, 3, 10, TRUE, 180),
('f0000000-0000-0000-0000-000000000057'::uuid, 'e0000000-0000-0000-0000-000000000003'::uuid, 'd0000000-0000-0000-0000-000000000057'::uuid, 1499.99, 3, 10, FALSE, 0),
('f0000000-0000-0000-0000-000000000058'::uuid, 'e0000000-0000-0000-0000-000000000003'::uuid, 'd0000000-0000-0000-0000-000000000058'::uuid, 599.99, 5, 7, TRUE, 340),
('f0000000-0000-0000-0000-000000000059'::uuid, 'e0000000-0000-0000-0000-000000000003'::uuid, 'd0000000-0000-0000-0000-000000000059'::uuid, 329.99, 10, 5, TRUE, 500),
('f0000000-0000-0000-0000-000000000060'::uuid, 'e0000000-0000-0000-0000-000000000003'::uuid, 'd0000000-0000-0000-0000-000000000060'::uuid, 449.99, 10, 7, TRUE, 420);

-- Vendor 4: ElectroParts Hub (New York NY) – products 61-80 (tablets)
INSERT INTO vendor_products (id, vendor_id, product_id, unit_price, moq, lead_time_days, in_stock, stock_quantity) VALUES
('f0000000-0000-0000-0000-000000000061'::uuid, 'e0000000-0000-0000-0000-000000000004'::uuid, 'd0000000-0000-0000-0000-000000000061'::uuid, 899.99, 5, 5, TRUE, 400),
('f0000000-0000-0000-0000-000000000062'::uuid, 'e0000000-0000-0000-0000-000000000004'::uuid, 'd0000000-0000-0000-0000-000000000062'::uuid, 1099.99, 5, 5, TRUE, 250),
('f0000000-0000-0000-0000-000000000063'::uuid, 'e0000000-0000-0000-0000-000000000004'::uuid, 'd0000000-0000-0000-0000-000000000063'::uuid, 549.99, 10, 5, TRUE, 600),
('f0000000-0000-0000-0000-000000000064'::uuid, 'e0000000-0000-0000-0000-000000000004'::uuid, 'd0000000-0000-0000-0000-000000000064'::uuid, 379.99, 15, 3, TRUE, 900),
('f0000000-0000-0000-0000-000000000065'::uuid, 'e0000000-0000-0000-0000-000000000004'::uuid, 'd0000000-0000-0000-0000-000000000065'::uuid, 429.99, 10, 5, TRUE, 500),
('f0000000-0000-0000-0000-000000000066'::uuid, 'e0000000-0000-0000-0000-000000000004'::uuid, 'd0000000-0000-0000-0000-000000000066'::uuid, 899.99, 5, 7, TRUE, 200),
('f0000000-0000-0000-0000-000000000067'::uuid, 'e0000000-0000-0000-0000-000000000004'::uuid, 'd0000000-0000-0000-0000-000000000067'::uuid, 749.99, 5, 7, TRUE, 280),
('f0000000-0000-0000-0000-000000000068'::uuid, 'e0000000-0000-0000-0000-000000000004'::uuid, 'd0000000-0000-0000-0000-000000000068'::uuid, 399.99, 15, 5, TRUE, 650),
('f0000000-0000-0000-0000-000000000069'::uuid, 'e0000000-0000-0000-0000-000000000004'::uuid, 'd0000000-0000-0000-0000-000000000069'::uuid, 1299.99, 5, 7, TRUE, 180),
('f0000000-0000-0000-0000-000000000070'::uuid, 'e0000000-0000-0000-0000-000000000004'::uuid, 'd0000000-0000-0000-0000-000000000070'::uuid, 499.99, 10, 7, TRUE, 350),
('f0000000-0000-0000-0000-000000000071'::uuid, 'e0000000-0000-0000-0000-000000000004'::uuid, 'd0000000-0000-0000-0000-000000000071'::uuid, 549.99, 10, 7, FALSE, 0),
('f0000000-0000-0000-0000-000000000072'::uuid, 'e0000000-0000-0000-0000-000000000004'::uuid, 'd0000000-0000-0000-0000-000000000072'::uuid, 179.99, 25, 3, TRUE, 2000),
('f0000000-0000-0000-0000-000000000073'::uuid, 'e0000000-0000-0000-0000-000000000004'::uuid, 'd0000000-0000-0000-0000-000000000073'::uuid, 119.99, 25, 3, TRUE, 3000),
('f0000000-0000-0000-0000-000000000074'::uuid, 'e0000000-0000-0000-0000-000000000004'::uuid, 'd0000000-0000-0000-0000-000000000074'::uuid, 79.99, 50, 3, TRUE, 4000),
('f0000000-0000-0000-0000-000000000075'::uuid, 'e0000000-0000-0000-0000-000000000004'::uuid, 'd0000000-0000-0000-0000-000000000075'::uuid, 399.99, 10, 10, TRUE, 200),
('f0000000-0000-0000-0000-000000000076'::uuid, 'e0000000-0000-0000-0000-000000000004'::uuid, 'd0000000-0000-0000-0000-000000000076'::uuid, 379.99, 10, 14, TRUE, 150),
('f0000000-0000-0000-0000-000000000077'::uuid, 'e0000000-0000-0000-0000-000000000004'::uuid, 'd0000000-0000-0000-0000-000000000077'::uuid, 429.99, 10, 7, TRUE, 300),
('f0000000-0000-0000-0000-000000000078'::uuid, 'e0000000-0000-0000-0000-000000000004'::uuid, 'd0000000-0000-0000-0000-000000000078'::uuid, 549.99, 5, 14, FALSE, 0),
('f0000000-0000-0000-0000-000000000079'::uuid, 'e0000000-0000-0000-0000-000000000004'::uuid, 'd0000000-0000-0000-0000-000000000079'::uuid, 179.99, 20, 7, TRUE, 800),
('f0000000-0000-0000-0000-000000000080'::uuid, 'e0000000-0000-0000-0000-000000000004'::uuid, 'd0000000-0000-0000-0000-000000000080'::uuid, 249.99, 15, 5, TRUE, 750);

-- Vendor 5: Pacific Coast Electronics (San Jose CA) – products 81-100 (audio)
INSERT INTO vendor_products (id, vendor_id, product_id, unit_price, moq, lead_time_days, in_stock, stock_quantity) VALUES
('f0000000-0000-0000-0000-000000000081'::uuid, 'e0000000-0000-0000-0000-000000000005'::uuid, 'd0000000-0000-0000-0000-000000000081'::uuid, 279.99, 10, 5, TRUE, 500),
('f0000000-0000-0000-0000-000000000082'::uuid, 'e0000000-0000-0000-0000-000000000005'::uuid, 'd0000000-0000-0000-0000-000000000082'::uuid, 229.99, 15, 5, TRUE, 600),
('f0000000-0000-0000-0000-000000000083'::uuid, 'e0000000-0000-0000-0000-000000000005'::uuid, 'd0000000-0000-0000-0000-000000000083'::uuid, 199.99, 20, 5, TRUE, 1200),
('f0000000-0000-0000-0000-000000000084'::uuid, 'e0000000-0000-0000-0000-000000000005'::uuid, 'd0000000-0000-0000-0000-000000000084'::uuid, 449.99, 5, 7, TRUE, 180),
('f0000000-0000-0000-0000-000000000085'::uuid, 'e0000000-0000-0000-0000-000000000005'::uuid, 'd0000000-0000-0000-0000-000000000085'::uuid, 149.99, 25, 3, TRUE, 2000),
('f0000000-0000-0000-0000-000000000086'::uuid, 'e0000000-0000-0000-0000-000000000005'::uuid, 'd0000000-0000-0000-0000-000000000086'::uuid, 249.99, 10, 5, TRUE, 550),
('f0000000-0000-0000-0000-000000000087'::uuid, 'e0000000-0000-0000-0000-000000000005'::uuid, 'd0000000-0000-0000-0000-000000000087'::uuid, 249.99, 10, 7, TRUE, 400),
('f0000000-0000-0000-0000-000000000088'::uuid, 'e0000000-0000-0000-0000-000000000005'::uuid, 'd0000000-0000-0000-0000-000000000088'::uuid, 99.99, 30, 3, TRUE, 3000),
('f0000000-0000-0000-0000-000000000089'::uuid, 'e0000000-0000-0000-0000-000000000005'::uuid, 'd0000000-0000-0000-0000-000000000089'::uuid, 139.99, 20, 3, TRUE, 1800),
('f0000000-0000-0000-0000-000000000090'::uuid, 'e0000000-0000-0000-0000-000000000005'::uuid, 'd0000000-0000-0000-0000-000000000090'::uuid, 379.99, 5, 7, TRUE, 250),
('f0000000-0000-0000-0000-000000000091'::uuid, 'e0000000-0000-0000-0000-000000000005'::uuid, 'd0000000-0000-0000-0000-000000000091'::uuid, 349.99, 5, 7, TRUE, 300),
('f0000000-0000-0000-0000-000000000092'::uuid, 'e0000000-0000-0000-0000-000000000005'::uuid, 'd0000000-0000-0000-0000-000000000092'::uuid, 279.99, 10, 10, FALSE, 0),
('f0000000-0000-0000-0000-000000000093'::uuid, 'e0000000-0000-0000-0000-000000000005'::uuid, 'd0000000-0000-0000-0000-000000000093'::uuid, 169.99, 20, 5, TRUE, 900),
('f0000000-0000-0000-0000-000000000094'::uuid, 'e0000000-0000-0000-0000-000000000005'::uuid, 'd0000000-0000-0000-0000-000000000094'::uuid, 279.99, 10, 7, TRUE, 350),
('f0000000-0000-0000-0000-000000000095'::uuid, 'e0000000-0000-0000-0000-000000000005'::uuid, 'd0000000-0000-0000-0000-000000000095'::uuid, 399.99, 5, 10, TRUE, 100),
('f0000000-0000-0000-0000-000000000096'::uuid, 'e0000000-0000-0000-0000-000000000005'::uuid, 'd0000000-0000-0000-0000-000000000096'::uuid, 119.99, 25, 3, TRUE, 1500),
('f0000000-0000-0000-0000-000000000097'::uuid, 'e0000000-0000-0000-0000-000000000005'::uuid, 'd0000000-0000-0000-0000-000000000097'::uuid, 159.99, 15, 5, TRUE, 700),
('f0000000-0000-0000-0000-000000000098'::uuid, 'e0000000-0000-0000-0000-000000000005'::uuid, 'd0000000-0000-0000-0000-000000000098'::uuid, 129.99, 15, 7, TRUE, 450),
('f0000000-0000-0000-0000-000000000099'::uuid, 'e0000000-0000-0000-0000-000000000005'::uuid, 'd0000000-0000-0000-0000-000000000099'::uuid, 329.99, 5, 10, TRUE, 200),
('f0000000-0000-0000-0000-000000000100'::uuid, 'e0000000-0000-0000-0000-000000000005'::uuid, 'd0000000-0000-0000-0000-000000000100'::uuid, 149.99, 15, 7, TRUE, 600);

-- Vendor 6: Midwest Supply Co (Columbus OH) – products 101-120 (wearables)
INSERT INTO vendor_products (id, vendor_id, product_id, unit_price, moq, lead_time_days, in_stock, stock_quantity) VALUES
('f0000000-0000-0000-0000-000000000101'::uuid, 'e0000000-0000-0000-0000-000000000006'::uuid, 'd0000000-0000-0000-0000-000000000101'::uuid, 699.99, 5, 10, TRUE, 150),
('f0000000-0000-0000-0000-000000000102'::uuid, 'e0000000-0000-0000-0000-000000000006'::uuid, 'd0000000-0000-0000-0000-000000000102'::uuid, 349.99, 10, 7, TRUE, 400),
('f0000000-0000-0000-0000-000000000103'::uuid, 'e0000000-0000-0000-0000-000000000006'::uuid, 'd0000000-0000-0000-0000-000000000103'::uuid, 219.99, 15, 5, TRUE, 800),
('f0000000-0000-0000-0000-000000000104'::uuid, 'e0000000-0000-0000-0000-000000000006'::uuid, 'd0000000-0000-0000-0000-000000000104'::uuid, 349.99, 10, 7, TRUE, 350),
('f0000000-0000-0000-0000-000000000105'::uuid, 'e0000000-0000-0000-0000-000000000006'::uuid, 'd0000000-0000-0000-0000-000000000105'::uuid, 279.99, 10, 7, TRUE, 500),
('f0000000-0000-0000-0000-000000000106'::uuid, 'e0000000-0000-0000-0000-000000000006'::uuid, 'd0000000-0000-0000-0000-000000000106'::uuid, 599.99, 5, 14, TRUE, 100),
('f0000000-0000-0000-0000-000000000107'::uuid, 'e0000000-0000-0000-0000-000000000006'::uuid, 'd0000000-0000-0000-0000-000000000107'::uuid, 379.99, 10, 7, TRUE, 250),
('f0000000-0000-0000-0000-000000000108'::uuid, 'e0000000-0000-0000-0000-000000000006'::uuid, 'd0000000-0000-0000-0000-000000000108'::uuid, 449.99, 5, 10, FALSE, 0),
('f0000000-0000-0000-0000-000000000109'::uuid, 'e0000000-0000-0000-0000-000000000006'::uuid, 'd0000000-0000-0000-0000-000000000109'::uuid, 229.99, 15, 7, TRUE, 600),
('f0000000-0000-0000-0000-000000000110'::uuid, 'e0000000-0000-0000-0000-000000000006'::uuid, 'd0000000-0000-0000-0000-000000000110'::uuid, 179.99, 15, 5, TRUE, 700),
('f0000000-0000-0000-0000-000000000111'::uuid, 'e0000000-0000-0000-0000-000000000006'::uuid, 'd0000000-0000-0000-0000-000000000111'::uuid, 299.99, 10, 7, TRUE, 350),
('f0000000-0000-0000-0000-000000000112'::uuid, 'e0000000-0000-0000-0000-000000000006'::uuid, 'd0000000-0000-0000-0000-000000000112'::uuid, 349.99, 5, 14, TRUE, 120),
('f0000000-0000-0000-0000-000000000113'::uuid, 'e0000000-0000-0000-0000-000000000006'::uuid, 'd0000000-0000-0000-0000-000000000113'::uuid, 89.99, 25, 5, TRUE, 2000),
('f0000000-0000-0000-0000-000000000114'::uuid, 'e0000000-0000-0000-0000-000000000006'::uuid, 'd0000000-0000-0000-0000-000000000114'::uuid, 399.99, 5, 14, TRUE, 80),
('f0000000-0000-0000-0000-000000000115'::uuid, 'e0000000-0000-0000-0000-000000000006'::uuid, 'd0000000-0000-0000-0000-000000000115'::uuid, 219.99, 10, 10, TRUE, 300),
('f0000000-0000-0000-0000-000000000116'::uuid, 'e0000000-0000-0000-0000-000000000006'::uuid, 'd0000000-0000-0000-0000-000000000116'::uuid, 279.99, 10, 10, TRUE, 200),
('f0000000-0000-0000-0000-000000000117'::uuid, 'e0000000-0000-0000-0000-000000000006'::uuid, 'd0000000-0000-0000-0000-000000000117'::uuid, 59.99, 50, 5, TRUE, 5000),
('f0000000-0000-0000-0000-000000000118'::uuid, 'e0000000-0000-0000-0000-000000000006'::uuid, 'd0000000-0000-0000-0000-000000000118'::uuid, 249.99, 10, 14, FALSE, 0),
('f0000000-0000-0000-0000-000000000119'::uuid, 'e0000000-0000-0000-0000-000000000006'::uuid, 'd0000000-0000-0000-0000-000000000119'::uuid, 239.99, 10, 10, TRUE, 250),
('f0000000-0000-0000-0000-000000000120'::uuid, 'e0000000-0000-0000-0000-000000000006'::uuid, 'd0000000-0000-0000-0000-000000000120'::uuid, 349.99, 5, 10, TRUE, 180);

-- Vendor 7: SouthTech Partners (Atlanta GA) – products 121-140 (gaming)
INSERT INTO vendor_products (id, vendor_id, product_id, unit_price, moq, lead_time_days, in_stock, stock_quantity) VALUES
('f0000000-0000-0000-0000-000000000121'::uuid, 'e0000000-0000-0000-0000-000000000007'::uuid, 'd0000000-0000-0000-0000-000000000121'::uuid, 449.99, 5, 7, TRUE, 300),
('f0000000-0000-0000-0000-000000000122'::uuid, 'e0000000-0000-0000-0000-000000000007'::uuid, 'd0000000-0000-0000-0000-000000000122'::uuid, 399.99, 5, 7, TRUE, 350),
('f0000000-0000-0000-0000-000000000123'::uuid, 'e0000000-0000-0000-0000-000000000007'::uuid, 'd0000000-0000-0000-0000-000000000123'::uuid, 449.99, 5, 7, TRUE, 280),
('f0000000-0000-0000-0000-000000000124'::uuid, 'e0000000-0000-0000-0000-000000000007'::uuid, 'd0000000-0000-0000-0000-000000000124'::uuid, 269.99, 10, 5, TRUE, 600),
('f0000000-0000-0000-0000-000000000125'::uuid, 'e0000000-0000-0000-0000-000000000007'::uuid, 'd0000000-0000-0000-0000-000000000125'::uuid, 299.99, 10, 5, TRUE, 500),
('f0000000-0000-0000-0000-000000000126'::uuid, 'e0000000-0000-0000-0000-000000000007'::uuid, 'd0000000-0000-0000-0000-000000000126'::uuid, 179.99, 15, 5, TRUE, 900),
('f0000000-0000-0000-0000-000000000127'::uuid, 'e0000000-0000-0000-0000-000000000007'::uuid, 'd0000000-0000-0000-0000-000000000127'::uuid, 449.99, 5, 10, TRUE, 200),
('f0000000-0000-0000-0000-000000000128'::uuid, 'e0000000-0000-0000-0000-000000000007'::uuid, 'd0000000-0000-0000-0000-000000000128'::uuid, 549.99, 3, 10, FALSE, 0),
('f0000000-0000-0000-0000-000000000129'::uuid, 'e0000000-0000-0000-0000-000000000007'::uuid, 'd0000000-0000-0000-0000-000000000129'::uuid, 549.99, 5, 7, TRUE, 250),
('f0000000-0000-0000-0000-000000000130'::uuid, 'e0000000-0000-0000-0000-000000000007'::uuid, 'd0000000-0000-0000-0000-000000000130'::uuid, 599.99, 5, 10, TRUE, 150),
('f0000000-0000-0000-0000-000000000131'::uuid, 'e0000000-0000-0000-0000-000000000007'::uuid, 'd0000000-0000-0000-0000-000000000131'::uuid, 449.99, 5, 10, TRUE, 120),
('f0000000-0000-0000-0000-000000000132'::uuid, 'e0000000-0000-0000-0000-000000000007'::uuid, 'd0000000-0000-0000-0000-000000000132'::uuid, 429.99, 5, 7, TRUE, 400),
('f0000000-0000-0000-0000-000000000133'::uuid, 'e0000000-0000-0000-0000-000000000007'::uuid, 'd0000000-0000-0000-0000-000000000133'::uuid, 499.99, 3, 10, TRUE, 180),
('f0000000-0000-0000-0000-000000000134'::uuid, 'e0000000-0000-0000-0000-000000000007'::uuid, 'd0000000-0000-0000-0000-000000000134'::uuid, 179.99, 10, 5, TRUE, 500),
('f0000000-0000-0000-0000-000000000135'::uuid, 'e0000000-0000-0000-0000-000000000007'::uuid, 'd0000000-0000-0000-0000-000000000135'::uuid, 149.99, 10, 5, TRUE, 600),
('f0000000-0000-0000-0000-000000000136'::uuid, 'e0000000-0000-0000-0000-000000000007'::uuid, 'd0000000-0000-0000-0000-000000000136'::uuid, 59.99, 20, 3, TRUE, 1500),
('f0000000-0000-0000-0000-000000000137'::uuid, 'e0000000-0000-0000-0000-000000000007'::uuid, 'd0000000-0000-0000-0000-000000000137'::uuid, 649.99, 3, 14, TRUE, 60),
('f0000000-0000-0000-0000-000000000138'::uuid, 'e0000000-0000-0000-0000-000000000007'::uuid, 'd0000000-0000-0000-0000-000000000138'::uuid, 99.99, 20, 5, TRUE, 800),
('f0000000-0000-0000-0000-000000000139'::uuid, 'e0000000-0000-0000-0000-000000000007'::uuid, 'd0000000-0000-0000-0000-000000000139'::uuid, 89.99, 25, 5, TRUE, 1000),
('f0000000-0000-0000-0000-000000000140'::uuid, 'e0000000-0000-0000-0000-000000000007'::uuid, 'd0000000-0000-0000-0000-000000000140'::uuid, 299.99, 5, 7, TRUE, 250);

-- Vendor 8: Northeast Digital Supply (Newark NJ) – products 141-160 (networking)
INSERT INTO vendor_products (id, vendor_id, product_id, unit_price, moq, lead_time_days, in_stock, stock_quantity) VALUES
('f0000000-0000-0000-0000-000000000141'::uuid, 'e0000000-0000-0000-0000-000000000008'::uuid, 'd0000000-0000-0000-0000-000000000141'::uuid, 229.99, 10, 5, TRUE, 600),
('f0000000-0000-0000-0000-000000000142'::uuid, 'e0000000-0000-0000-0000-000000000008'::uuid, 'd0000000-0000-0000-0000-000000000142'::uuid, 399.99, 5, 7, TRUE, 200),
('f0000000-0000-0000-0000-000000000143'::uuid, 'e0000000-0000-0000-0000-000000000008'::uuid, 'd0000000-0000-0000-0000-000000000143'::uuid, 299.99, 5, 5, TRUE, 400),
('f0000000-0000-0000-0000-000000000144'::uuid, 'e0000000-0000-0000-0000-000000000008'::uuid, 'd0000000-0000-0000-0000-000000000144'::uuid, 279.99, 10, 5, TRUE, 450),
('f0000000-0000-0000-0000-000000000145'::uuid, 'e0000000-0000-0000-0000-000000000008'::uuid, 'd0000000-0000-0000-0000-000000000145'::uuid, 379.99, 3, 7, TRUE, 150),
('f0000000-0000-0000-0000-000000000146'::uuid, 'e0000000-0000-0000-0000-000000000008'::uuid, 'd0000000-0000-0000-0000-000000000146'::uuid, 299.99, 5, 7, TRUE, 300),
('f0000000-0000-0000-0000-000000000147'::uuid, 'e0000000-0000-0000-0000-000000000008'::uuid, 'd0000000-0000-0000-0000-000000000147'::uuid, 549.99, 3, 10, TRUE, 100),
('f0000000-0000-0000-0000-000000000148'::uuid, 'e0000000-0000-0000-0000-000000000008'::uuid, 'd0000000-0000-0000-0000-000000000148'::uuid, 1099.99, 2, 14, FALSE, 0),
('f0000000-0000-0000-0000-000000000149'::uuid, 'e0000000-0000-0000-0000-000000000008'::uuid, 'd0000000-0000-0000-0000-000000000149'::uuid, 349.99, 5, 5, TRUE, 350),
('f0000000-0000-0000-0000-000000000150'::uuid, 'e0000000-0000-0000-0000-000000000008'::uuid, 'd0000000-0000-0000-0000-000000000150'::uuid, 649.99, 3, 10, TRUE, 120),
('f0000000-0000-0000-0000-000000000151'::uuid, 'e0000000-0000-0000-0000-000000000008'::uuid, 'd0000000-0000-0000-0000-000000000151'::uuid, 999.99, 2, 14, TRUE, 50),
('f0000000-0000-0000-0000-000000000152'::uuid, 'e0000000-0000-0000-0000-000000000008'::uuid, 'd0000000-0000-0000-0000-000000000152'::uuid, 1799.99, 1, 14, TRUE, 30),
('f0000000-0000-0000-0000-000000000153'::uuid, 'e0000000-0000-0000-0000-000000000008'::uuid, 'd0000000-0000-0000-0000-000000000153'::uuid, 249.99, 10, 5, TRUE, 500),
('f0000000-0000-0000-0000-000000000154'::uuid, 'e0000000-0000-0000-0000-000000000008'::uuid, 'd0000000-0000-0000-0000-000000000154'::uuid, 179.99, 10, 5, TRUE, 450),
('f0000000-0000-0000-0000-000000000155'::uuid, 'e0000000-0000-0000-0000-000000000008'::uuid, 'd0000000-0000-0000-0000-000000000155'::uuid, 199.99, 5, 7, TRUE, 200),
('f0000000-0000-0000-0000-000000000156'::uuid, 'e0000000-0000-0000-0000-000000000008'::uuid, 'd0000000-0000-0000-0000-000000000156'::uuid, 599.99, 2, 10, TRUE, 80),
('f0000000-0000-0000-0000-000000000157'::uuid, 'e0000000-0000-0000-0000-000000000008'::uuid, 'd0000000-0000-0000-0000-000000000157'::uuid, 69.99, 25, 3, TRUE, 2000),
('f0000000-0000-0000-0000-000000000158'::uuid, 'e0000000-0000-0000-0000-000000000008'::uuid, 'd0000000-0000-0000-0000-000000000158'::uuid, 499.99, 3, 7, TRUE, 200),
('f0000000-0000-0000-0000-000000000159'::uuid, 'e0000000-0000-0000-0000-000000000008'::uuid, 'd0000000-0000-0000-0000-000000000159'::uuid, 299.99, 5, 7, TRUE, 250),
('f0000000-0000-0000-0000-000000000160'::uuid, 'e0000000-0000-0000-0000-000000000008'::uuid, 'd0000000-0000-0000-0000-000000000160'::uuid, 449.99, 3, 7, TRUE, 180);

-- Vendor 9: Lone Star Components (Houston TX) – products 161-180 (peripherals)
INSERT INTO vendor_products (id, vendor_id, product_id, unit_price, moq, lead_time_days, in_stock, stock_quantity) VALUES
('f0000000-0000-0000-0000-000000000161'::uuid, 'e0000000-0000-0000-0000-000000000009'::uuid, 'd0000000-0000-0000-0000-000000000161'::uuid, 399.99, 5, 10, TRUE, 200),
('f0000000-0000-0000-0000-000000000162'::uuid, 'e0000000-0000-0000-0000-000000000009'::uuid, 'd0000000-0000-0000-0000-000000000162'::uuid, 999.99, 2, 14, TRUE, 40),
('f0000000-0000-0000-0000-000000000163'::uuid, 'e0000000-0000-0000-0000-000000000009'::uuid, 'd0000000-0000-0000-0000-000000000163'::uuid, 549.99, 5, 7, TRUE, 180),
('f0000000-0000-0000-0000-000000000164'::uuid, 'e0000000-0000-0000-0000-000000000009'::uuid, 'd0000000-0000-0000-0000-000000000164'::uuid, 2499.99, 1, 21, FALSE, 0),
('f0000000-0000-0000-0000-000000000165'::uuid, 'e0000000-0000-0000-0000-000000000009'::uuid, 'd0000000-0000-0000-0000-000000000165'::uuid, 79.99, 25, 3, TRUE, 3000),
('f0000000-0000-0000-0000-000000000166'::uuid, 'e0000000-0000-0000-0000-000000000009'::uuid, 'd0000000-0000-0000-0000-000000000166'::uuid, 89.99, 25, 3, TRUE, 2500),
('f0000000-0000-0000-0000-000000000167'::uuid, 'e0000000-0000-0000-0000-000000000009'::uuid, 'd0000000-0000-0000-0000-000000000167'::uuid, 179.99, 10, 5, TRUE, 600),
('f0000000-0000-0000-0000-000000000168'::uuid, 'e0000000-0000-0000-0000-000000000009'::uuid, 'd0000000-0000-0000-0000-000000000168'::uuid, 129.99, 15, 5, TRUE, 800),
('f0000000-0000-0000-0000-000000000169'::uuid, 'e0000000-0000-0000-0000-000000000009'::uuid, 'd0000000-0000-0000-0000-000000000169'::uuid, 169.99, 10, 7, TRUE, 400),
('f0000000-0000-0000-0000-000000000170'::uuid, 'e0000000-0000-0000-0000-000000000009'::uuid, 'd0000000-0000-0000-0000-000000000170'::uuid, 69.99, 30, 3, TRUE, 4000),
('f0000000-0000-0000-0000-000000000171'::uuid, 'e0000000-0000-0000-0000-000000000009'::uuid, 'd0000000-0000-0000-0000-000000000171'::uuid, 249.99, 5, 7, TRUE, 150),
('f0000000-0000-0000-0000-000000000172'::uuid, 'e0000000-0000-0000-0000-000000000009'::uuid, 'd0000000-0000-0000-0000-000000000172'::uuid, 349.99, 3, 10, TRUE, 100),
('f0000000-0000-0000-0000-000000000173'::uuid, 'e0000000-0000-0000-0000-000000000009'::uuid, 'd0000000-0000-0000-0000-000000000173'::uuid, 159.99, 10, 5, TRUE, 500),
('f0000000-0000-0000-0000-000000000174'::uuid, 'e0000000-0000-0000-0000-000000000009'::uuid, 'd0000000-0000-0000-0000-000000000174'::uuid, 139.99, 15, 5, TRUE, 700),
('f0000000-0000-0000-0000-000000000175'::uuid, 'e0000000-0000-0000-0000-000000000009'::uuid, 'd0000000-0000-0000-0000-000000000175'::uuid, 99.99, 20, 3, TRUE, 1200),
('f0000000-0000-0000-0000-000000000176'::uuid, 'e0000000-0000-0000-0000-000000000009'::uuid, 'd0000000-0000-0000-0000-000000000176'::uuid, 29.99, 50, 3, TRUE, 5000),
('f0000000-0000-0000-0000-000000000177'::uuid, 'e0000000-0000-0000-0000-000000000009'::uuid, 'd0000000-0000-0000-0000-000000000177'::uuid, 149.99, 10, 7, TRUE, 350),
('f0000000-0000-0000-0000-000000000178'::uuid, 'e0000000-0000-0000-0000-000000000009'::uuid, 'd0000000-0000-0000-0000-000000000178'::uuid, 169.99, 10, 5, TRUE, 450),
('f0000000-0000-0000-0000-000000000179'::uuid, 'e0000000-0000-0000-0000-000000000009'::uuid, 'd0000000-0000-0000-0000-000000000179'::uuid, 119.99, 15, 5, TRUE, 600),
('f0000000-0000-0000-0000-000000000180'::uuid, 'e0000000-0000-0000-0000-000000000009'::uuid, 'd0000000-0000-0000-0000-000000000180'::uuid, 299.99, 5, 7, TRUE, 250);

-- Vendor 10: Pinnacle Electronics (Seattle WA) – products 181-200 (smart home)
INSERT INTO vendor_products (id, vendor_id, product_id, unit_price, moq, lead_time_days, in_stock, stock_quantity) VALUES
('f0000000-0000-0000-0000-000000000181'::uuid, 'e0000000-0000-0000-0000-000000000010'::uuid, 'd0000000-0000-0000-0000-000000000181'::uuid, 69.99, 25, 3, TRUE, 3000),
('f0000000-0000-0000-0000-000000000182'::uuid, 'e0000000-0000-0000-0000-000000000010'::uuid, 'd0000000-0000-0000-0000-000000000182'::uuid, 39.99, 50, 3, TRUE, 5000),
('f0000000-0000-0000-0000-000000000183'::uuid, 'e0000000-0000-0000-0000-000000000010'::uuid, 'd0000000-0000-0000-0000-000000000183'::uuid, 199.99, 10, 5, TRUE, 400),
('f0000000-0000-0000-0000-000000000184'::uuid, 'e0000000-0000-0000-0000-000000000010'::uuid, 'd0000000-0000-0000-0000-000000000184'::uuid, 79.99, 25, 3, TRUE, 2500),
('f0000000-0000-0000-0000-000000000185'::uuid, 'e0000000-0000-0000-0000-000000000010'::uuid, 'd0000000-0000-0000-0000-000000000185'::uuid, 179.99, 10, 5, TRUE, 500),
('f0000000-0000-0000-0000-000000000186'::uuid, 'e0000000-0000-0000-0000-000000000010'::uuid, 'd0000000-0000-0000-0000-000000000186'::uuid, 39.99, 50, 3, TRUE, 4000),
('f0000000-0000-0000-0000-000000000187'::uuid, 'e0000000-0000-0000-0000-000000000010'::uuid, 'd0000000-0000-0000-0000-000000000187'::uuid, 159.99, 10, 5, TRUE, 800),
('f0000000-0000-0000-0000-000000000188'::uuid, 'e0000000-0000-0000-0000-000000000010'::uuid, 'd0000000-0000-0000-0000-000000000188'::uuid, 199.99, 5, 7, TRUE, 300),
('f0000000-0000-0000-0000-000000000189'::uuid, 'e0000000-0000-0000-0000-000000000010'::uuid, 'd0000000-0000-0000-0000-000000000189'::uuid, 49.99, 30, 3, TRUE, 3500),
('f0000000-0000-0000-0000-000000000190'::uuid, 'e0000000-0000-0000-0000-000000000010'::uuid, 'd0000000-0000-0000-0000-000000000190'::uuid, 149.99, 10, 5, TRUE, 600),
('f0000000-0000-0000-0000-000000000191'::uuid, 'e0000000-0000-0000-0000-000000000010'::uuid, 'd0000000-0000-0000-0000-000000000191'::uuid, 129.99, 15, 5, TRUE, 700),
('f0000000-0000-0000-0000-000000000192'::uuid, 'e0000000-0000-0000-0000-000000000010'::uuid, 'd0000000-0000-0000-0000-000000000192'::uuid, 219.99, 10, 7, TRUE, 350),
('f0000000-0000-0000-0000-000000000193'::uuid, 'e0000000-0000-0000-0000-000000000010'::uuid, 'd0000000-0000-0000-0000-000000000193'::uuid, 199.99, 10, 7, FALSE, 0),
('f0000000-0000-0000-0000-000000000194'::uuid, 'e0000000-0000-0000-0000-000000000010'::uuid, 'd0000000-0000-0000-0000-000000000194'::uuid, 199.99, 10, 5, TRUE, 450),
('f0000000-0000-0000-0000-000000000195'::uuid, 'e0000000-0000-0000-0000-000000000010'::uuid, 'd0000000-0000-0000-0000-000000000195'::uuid, 179.99, 10, 7, TRUE, 300),
('f0000000-0000-0000-0000-000000000196'::uuid, 'e0000000-0000-0000-0000-000000000010'::uuid, 'd0000000-0000-0000-0000-000000000196'::uuid, 14.99, 100, 3, TRUE, 5000),
('f0000000-0000-0000-0000-000000000197'::uuid, 'e0000000-0000-0000-0000-000000000010'::uuid, 'd0000000-0000-0000-0000-000000000197'::uuid, 699.99, 3, 10, TRUE, 80),
('f0000000-0000-0000-0000-000000000198'::uuid, 'e0000000-0000-0000-0000-000000000010'::uuid, 'd0000000-0000-0000-0000-000000000198'::uuid, 499.99, 3, 10, TRUE, 100),
('f0000000-0000-0000-0000-000000000199'::uuid, 'e0000000-0000-0000-0000-000000000010'::uuid, 'd0000000-0000-0000-0000-000000000199'::uuid, 34.99, 50, 3, TRUE, 2000),
('f0000000-0000-0000-0000-000000000200'::uuid, 'e0000000-0000-0000-0000-000000000010'::uuid, 'd0000000-0000-0000-0000-000000000200'::uuid, 249.99, 10, 7, TRUE, 350);

-- Vendor 11: CloudBridge Supply (San Francisco CA) – mixed: smartphones + laptops
INSERT INTO vendor_products (id, vendor_id, product_id, unit_price, moq, lead_time_days, in_stock, stock_quantity) VALUES
('f0000000-0000-0000-0000-000000000201'::uuid, 'e0000000-0000-0000-0000-000000000011'::uuid, 'd0000000-0000-0000-0000-000000000001'::uuid, 879.99, 10, 5, TRUE, 500),
('f0000000-0000-0000-0000-000000000202'::uuid, 'e0000000-0000-0000-0000-000000000011'::uuid, 'd0000000-0000-0000-0000-000000000003'::uuid, 929.99, 10, 7, TRUE, 400),
('f0000000-0000-0000-0000-000000000203'::uuid, 'e0000000-0000-0000-0000-000000000011'::uuid, 'd0000000-0000-0000-0000-000000000005'::uuid, 619.99, 15, 5, TRUE, 700),
('f0000000-0000-0000-0000-000000000204'::uuid, 'e0000000-0000-0000-0000-000000000011'::uuid, 'd0000000-0000-0000-0000-000000000006'::uuid, 729.99, 10, 7, TRUE, 350),
('f0000000-0000-0000-0000-000000000205'::uuid, 'e0000000-0000-0000-0000-000000000011'::uuid, 'd0000000-0000-0000-0000-000000000008'::uuid, 579.99, 10, 5, TRUE, 450),
('f0000000-0000-0000-0000-000000000206'::uuid, 'e0000000-0000-0000-0000-000000000011'::uuid, 'd0000000-0000-0000-0000-000000000021'::uuid, 1399.99, 5, 7, TRUE, 220),
('f0000000-0000-0000-0000-000000000207'::uuid, 'e0000000-0000-0000-0000-000000000011'::uuid, 'd0000000-0000-0000-0000-000000000023'::uuid, 1649.99, 5, 7, TRUE, 160),
('f0000000-0000-0000-0000-000000000208'::uuid, 'e0000000-0000-0000-0000-000000000011'::uuid, 'd0000000-0000-0000-0000-000000000025'::uuid, 1079.99, 10, 5, TRUE, 380),
('f0000000-0000-0000-0000-000000000209'::uuid, 'e0000000-0000-0000-0000-000000000011'::uuid, 'd0000000-0000-0000-0000-000000000026'::uuid, 1499.99, 5, 7, TRUE, 200),
('f0000000-0000-0000-0000-000000000210'::uuid, 'e0000000-0000-0000-0000-000000000011'::uuid, 'd0000000-0000-0000-0000-000000000028'::uuid, 1249.99, 5, 7, TRUE, 180),
('f0000000-0000-0000-0000-000000000211'::uuid, 'e0000000-0000-0000-0000-000000000011'::uuid, 'd0000000-0000-0000-0000-000000000030'::uuid, 979.99, 10, 5, TRUE, 420),
('f0000000-0000-0000-0000-000000000212'::uuid, 'e0000000-0000-0000-0000-000000000011'::uuid, 'd0000000-0000-0000-0000-000000000033'::uuid, 1149.99, 5, 7, TRUE, 250),
('f0000000-0000-0000-0000-000000000213'::uuid, 'e0000000-0000-0000-0000-000000000011'::uuid, 'd0000000-0000-0000-0000-000000000036'::uuid, 1279.99, 5, 10, FALSE, 0),
('f0000000-0000-0000-0000-000000000214'::uuid, 'e0000000-0000-0000-0000-000000000011'::uuid, 'd0000000-0000-0000-0000-000000000011'::uuid, 319.99, 20, 5, TRUE, 1100),
('f0000000-0000-0000-0000-000000000215'::uuid, 'e0000000-0000-0000-0000-000000000011'::uuid, 'd0000000-0000-0000-0000-000000000012'::uuid, 339.99, 20, 5, TRUE, 850),
('f0000000-0000-0000-0000-000000000216'::uuid, 'e0000000-0000-0000-0000-000000000011'::uuid, 'd0000000-0000-0000-0000-000000000038'::uuid, 1079.99, 10, 5, TRUE, 480),
('f0000000-0000-0000-0000-000000000217'::uuid, 'e0000000-0000-0000-0000-000000000011'::uuid, 'd0000000-0000-0000-0000-000000000040'::uuid, 829.99, 10, 7, TRUE, 320),
('f0000000-0000-0000-0000-000000000218'::uuid, 'e0000000-0000-0000-0000-000000000011'::uuid, 'd0000000-0000-0000-0000-000000000016'::uuid, 429.99, 15, 7, TRUE, 400),
('f0000000-0000-0000-0000-000000000219'::uuid, 'e0000000-0000-0000-0000-000000000011'::uuid, 'd0000000-0000-0000-0000-000000000018'::uuid, 369.99, 20, 5, TRUE, 650),
('f0000000-0000-0000-0000-000000000220'::uuid, 'e0000000-0000-0000-0000-000000000011'::uuid, 'd0000000-0000-0000-0000-000000000020'::uuid, 879.99, 5, 14, TRUE, 90);

-- Vendor 12: Metro Digital Distributors (Philadelphia PA) – TVs + audio
INSERT INTO vendor_products (id, vendor_id, product_id, unit_price, moq, lead_time_days, in_stock, stock_quantity) VALUES
('f0000000-0000-0000-0000-000000000221'::uuid, 'e0000000-0000-0000-0000-000000000012'::uuid, 'd0000000-0000-0000-0000-000000000041'::uuid, 1649.99, 3, 10, TRUE, 100),
('f0000000-0000-0000-0000-000000000222'::uuid, 'e0000000-0000-0000-0000-000000000012'::uuid, 'd0000000-0000-0000-0000-000000000043'::uuid, 929.99, 5, 7, TRUE, 250),
('f0000000-0000-0000-0000-000000000223'::uuid, 'e0000000-0000-0000-0000-000000000012'::uuid, 'd0000000-0000-0000-0000-000000000046'::uuid, 1129.99, 3, 10, TRUE, 150),
('f0000000-0000-0000-0000-000000000224'::uuid, 'e0000000-0000-0000-0000-000000000012'::uuid, 'd0000000-0000-0000-0000-000000000047'::uuid, 2249.99, 2, 14, TRUE, 30),
('f0000000-0000-0000-0000-000000000225'::uuid, 'e0000000-0000-0000-0000-000000000012'::uuid, 'd0000000-0000-0000-0000-000000000049'::uuid, 319.99, 10, 5, TRUE, 700),
('f0000000-0000-0000-0000-000000000226'::uuid, 'e0000000-0000-0000-0000-000000000012'::uuid, 'd0000000-0000-0000-0000-000000000050'::uuid, 829.99, 5, 7, TRUE, 220),
('f0000000-0000-0000-0000-000000000227'::uuid, 'e0000000-0000-0000-0000-000000000012'::uuid, 'd0000000-0000-0000-0000-000000000054'::uuid, 399.99, 10, 5, TRUE, 550),
('f0000000-0000-0000-0000-000000000228'::uuid, 'e0000000-0000-0000-0000-000000000012'::uuid, 'd0000000-0000-0000-0000-000000000056'::uuid, 1129.99, 3, 10, FALSE, 0),
('f0000000-0000-0000-0000-000000000229'::uuid, 'e0000000-0000-0000-0000-000000000012'::uuid, 'd0000000-0000-0000-0000-000000000058'::uuid, 619.99, 5, 7, TRUE, 300),
('f0000000-0000-0000-0000-000000000230'::uuid, 'e0000000-0000-0000-0000-000000000012'::uuid, 'd0000000-0000-0000-0000-000000000081'::uuid, 289.99, 10, 5, TRUE, 450),
('f0000000-0000-0000-0000-000000000231'::uuid, 'e0000000-0000-0000-0000-000000000012'::uuid, 'd0000000-0000-0000-0000-000000000083'::uuid, 209.99, 20, 5, TRUE, 1100),
('f0000000-0000-0000-0000-000000000232'::uuid, 'e0000000-0000-0000-0000-000000000012'::uuid, 'd0000000-0000-0000-0000-000000000086'::uuid, 259.99, 10, 5, TRUE, 500),
('f0000000-0000-0000-0000-000000000233'::uuid, 'e0000000-0000-0000-0000-000000000012'::uuid, 'd0000000-0000-0000-0000-000000000088'::uuid, 109.99, 30, 3, TRUE, 2800),
('f0000000-0000-0000-0000-000000000234'::uuid, 'e0000000-0000-0000-0000-000000000012'::uuid, 'd0000000-0000-0000-0000-000000000090'::uuid, 389.99, 5, 7, TRUE, 220),
('f0000000-0000-0000-0000-000000000235'::uuid, 'e0000000-0000-0000-0000-000000000012'::uuid, 'd0000000-0000-0000-0000-000000000091'::uuid, 359.99, 5, 7, TRUE, 280),
('f0000000-0000-0000-0000-000000000236'::uuid, 'e0000000-0000-0000-0000-000000000012'::uuid, 'd0000000-0000-0000-0000-000000000093'::uuid, 179.99, 20, 5, TRUE, 800),
('f0000000-0000-0000-0000-000000000237'::uuid, 'e0000000-0000-0000-0000-000000000012'::uuid, 'd0000000-0000-0000-0000-000000000095'::uuid, 419.99, 5, 10, TRUE, 80),
('f0000000-0000-0000-0000-000000000238'::uuid, 'e0000000-0000-0000-0000-000000000012'::uuid, 'd0000000-0000-0000-0000-000000000097'::uuid, 169.99, 15, 5, TRUE, 650),
('f0000000-0000-0000-0000-000000000239'::uuid, 'e0000000-0000-0000-0000-000000000012'::uuid, 'd0000000-0000-0000-0000-000000000099'::uuid, 339.99, 5, 10, TRUE, 180),
('f0000000-0000-0000-0000-000000000240'::uuid, 'e0000000-0000-0000-0000-000000000012'::uuid, 'd0000000-0000-0000-0000-000000000100'::uuid, 159.99, 15, 7, TRUE, 550);

-- Vendor 13: Summit Tech Wholesale (Denver CO) – tablets + wearables
INSERT INTO vendor_products (id, vendor_id, product_id, unit_price, moq, lead_time_days, in_stock, stock_quantity) VALUES
('f0000000-0000-0000-0000-000000000241'::uuid, 'e0000000-0000-0000-0000-000000000013'::uuid, 'd0000000-0000-0000-0000-000000000061'::uuid, 879.99, 5, 7, TRUE, 350),
('f0000000-0000-0000-0000-000000000242'::uuid, 'e0000000-0000-0000-0000-000000000013'::uuid, 'd0000000-0000-0000-0000-000000000063'::uuid, 539.99, 10, 5, TRUE, 550),
('f0000000-0000-0000-0000-000000000243'::uuid, 'e0000000-0000-0000-0000-000000000013'::uuid, 'd0000000-0000-0000-0000-000000000066'::uuid, 879.99, 5, 7, TRUE, 180),
('f0000000-0000-0000-0000-000000000244'::uuid, 'e0000000-0000-0000-0000-000000000013'::uuid, 'd0000000-0000-0000-0000-000000000069'::uuid, 1269.99, 5, 7, TRUE, 200),
('f0000000-0000-0000-0000-000000000245'::uuid, 'e0000000-0000-0000-0000-000000000013'::uuid, 'd0000000-0000-0000-0000-000000000072'::uuid, 189.99, 25, 3, TRUE, 1800),
('f0000000-0000-0000-0000-000000000246'::uuid, 'e0000000-0000-0000-0000-000000000013'::uuid, 'd0000000-0000-0000-0000-000000000075'::uuid, 389.99, 10, 10, TRUE, 220),
('f0000000-0000-0000-0000-000000000247'::uuid, 'e0000000-0000-0000-0000-000000000013'::uuid, 'd0000000-0000-0000-0000-000000000077'::uuid, 419.99, 10, 7, FALSE, 0),
('f0000000-0000-0000-0000-000000000248'::uuid, 'e0000000-0000-0000-0000-000000000013'::uuid, 'd0000000-0000-0000-0000-000000000080'::uuid, 239.99, 15, 5, TRUE, 700),
('f0000000-0000-0000-0000-000000000249'::uuid, 'e0000000-0000-0000-0000-000000000013'::uuid, 'd0000000-0000-0000-0000-000000000101'::uuid, 679.99, 5, 10, TRUE, 120),
('f0000000-0000-0000-0000-000000000250'::uuid, 'e0000000-0000-0000-0000-000000000013'::uuid, 'd0000000-0000-0000-0000-000000000102'::uuid, 339.99, 10, 7, TRUE, 380),
('f0000000-0000-0000-0000-000000000251'::uuid, 'e0000000-0000-0000-0000-000000000013'::uuid, 'd0000000-0000-0000-0000-000000000104'::uuid, 339.99, 10, 7, TRUE, 300),
('f0000000-0000-0000-0000-000000000252'::uuid, 'e0000000-0000-0000-0000-000000000013'::uuid, 'd0000000-0000-0000-0000-000000000106'::uuid, 579.99, 5, 14, TRUE, 90),
('f0000000-0000-0000-0000-000000000253'::uuid, 'e0000000-0000-0000-0000-000000000013'::uuid, 'd0000000-0000-0000-0000-000000000107'::uuid, 369.99, 10, 7, TRUE, 230),
('f0000000-0000-0000-0000-000000000254'::uuid, 'e0000000-0000-0000-0000-000000000013'::uuid, 'd0000000-0000-0000-0000-000000000109'::uuid, 219.99, 15, 7, TRUE, 550),
('f0000000-0000-0000-0000-000000000255'::uuid, 'e0000000-0000-0000-0000-000000000013'::uuid, 'd0000000-0000-0000-0000-000000000111'::uuid, 289.99, 10, 7, TRUE, 320),
('f0000000-0000-0000-0000-000000000256'::uuid, 'e0000000-0000-0000-0000-000000000013'::uuid, 'd0000000-0000-0000-0000-000000000113'::uuid, 84.99, 25, 5, TRUE, 1800),
('f0000000-0000-0000-0000-000000000257'::uuid, 'e0000000-0000-0000-0000-000000000013'::uuid, 'd0000000-0000-0000-0000-000000000115'::uuid, 209.99, 10, 10, TRUE, 280),
('f0000000-0000-0000-0000-000000000258'::uuid, 'e0000000-0000-0000-0000-000000000013'::uuid, 'd0000000-0000-0000-0000-000000000117'::uuid, 54.99, 50, 5, TRUE, 4500),
('f0000000-0000-0000-0000-000000000259'::uuid, 'e0000000-0000-0000-0000-000000000013'::uuid, 'd0000000-0000-0000-0000-000000000119'::uuid, 229.99, 10, 10, TRUE, 230),
('f0000000-0000-0000-0000-000000000260'::uuid, 'e0000000-0000-0000-0000-000000000013'::uuid, 'd0000000-0000-0000-0000-000000000120'::uuid, 339.99, 5, 10, TRUE, 160);

-- Vendor 14: TriState Electronics (Edison NJ) – gaming + networking
INSERT INTO vendor_products (id, vendor_id, product_id, unit_price, moq, lead_time_days, in_stock, stock_quantity) VALUES
('f0000000-0000-0000-0000-000000000261'::uuid, 'e0000000-0000-0000-0000-000000000014'::uuid, 'd0000000-0000-0000-0000-000000000121'::uuid, 439.99, 5, 7, TRUE, 320),
('f0000000-0000-0000-0000-000000000262'::uuid, 'e0000000-0000-0000-0000-000000000014'::uuid, 'd0000000-0000-0000-0000-000000000123'::uuid, 439.99, 5, 7, TRUE, 300),
('f0000000-0000-0000-0000-000000000263'::uuid, 'e0000000-0000-0000-0000-000000000014'::uuid, 'd0000000-0000-0000-0000-000000000125'::uuid, 289.99, 10, 5, TRUE, 480),
('f0000000-0000-0000-0000-000000000264'::uuid, 'e0000000-0000-0000-0000-000000000014'::uuid, 'd0000000-0000-0000-0000-000000000127'::uuid, 439.99, 5, 10, TRUE, 180),
('f0000000-0000-0000-0000-000000000265'::uuid, 'e0000000-0000-0000-0000-000000000014'::uuid, 'd0000000-0000-0000-0000-000000000129'::uuid, 539.99, 5, 7, FALSE, 0),
('f0000000-0000-0000-0000-000000000266'::uuid, 'e0000000-0000-0000-0000-000000000014'::uuid, 'd0000000-0000-0000-0000-000000000131'::uuid, 439.99, 5, 10, TRUE, 100),
('f0000000-0000-0000-0000-000000000267'::uuid, 'e0000000-0000-0000-0000-000000000014'::uuid, 'd0000000-0000-0000-0000-000000000132'::uuid, 419.99, 5, 7, TRUE, 380),
('f0000000-0000-0000-0000-000000000268'::uuid, 'e0000000-0000-0000-0000-000000000014'::uuid, 'd0000000-0000-0000-0000-000000000134'::uuid, 169.99, 10, 5, TRUE, 550),
('f0000000-0000-0000-0000-000000000269'::uuid, 'e0000000-0000-0000-0000-000000000014'::uuid, 'd0000000-0000-0000-0000-000000000135'::uuid, 139.99, 10, 5, TRUE, 650),
('f0000000-0000-0000-0000-000000000270'::uuid, 'e0000000-0000-0000-0000-000000000014'::uuid, 'd0000000-0000-0000-0000-000000000140'::uuid, 289.99, 5, 7, TRUE, 280),
('f0000000-0000-0000-0000-000000000271'::uuid, 'e0000000-0000-0000-0000-000000000014'::uuid, 'd0000000-0000-0000-0000-000000000141'::uuid, 219.99, 10, 5, TRUE, 550),
('f0000000-0000-0000-0000-000000000272'::uuid, 'e0000000-0000-0000-0000-000000000014'::uuid, 'd0000000-0000-0000-0000-000000000143'::uuid, 289.99, 5, 5, TRUE, 380),
('f0000000-0000-0000-0000-000000000273'::uuid, 'e0000000-0000-0000-0000-000000000014'::uuid, 'd0000000-0000-0000-0000-000000000145'::uuid, 369.99, 3, 7, TRUE, 140),
('f0000000-0000-0000-0000-000000000274'::uuid, 'e0000000-0000-0000-0000-000000000014'::uuid, 'd0000000-0000-0000-0000-000000000147'::uuid, 529.99, 3, 10, TRUE, 110),
('f0000000-0000-0000-0000-000000000275'::uuid, 'e0000000-0000-0000-0000-000000000014'::uuid, 'd0000000-0000-0000-0000-000000000149'::uuid, 339.99, 5, 5, TRUE, 330),
('f0000000-0000-0000-0000-000000000276'::uuid, 'e0000000-0000-0000-0000-000000000014'::uuid, 'd0000000-0000-0000-0000-000000000151'::uuid, 979.99, 2, 14, TRUE, 45),
('f0000000-0000-0000-0000-000000000277'::uuid, 'e0000000-0000-0000-0000-000000000014'::uuid, 'd0000000-0000-0000-0000-000000000153'::uuid, 239.99, 10, 5, TRUE, 480),
('f0000000-0000-0000-0000-000000000278'::uuid, 'e0000000-0000-0000-0000-000000000014'::uuid, 'd0000000-0000-0000-0000-000000000155'::uuid, 189.99, 5, 7, TRUE, 190),
('f0000000-0000-0000-0000-000000000279'::uuid, 'e0000000-0000-0000-0000-000000000014'::uuid, 'd0000000-0000-0000-0000-000000000157'::uuid, 64.99, 25, 3, TRUE, 1900),
('f0000000-0000-0000-0000-000000000280'::uuid, 'e0000000-0000-0000-0000-000000000014'::uuid, 'd0000000-0000-0000-0000-000000000159'::uuid, 289.99, 5, 7, TRUE, 240);

-- Vendor 15: Great Lakes Tech Supply (Detroit MI) – peripherals + smart home
INSERT INTO vendor_products (id, vendor_id, product_id, unit_price, moq, lead_time_days, in_stock, stock_quantity) VALUES
('f0000000-0000-0000-0000-000000000281'::uuid, 'e0000000-0000-0000-0000-000000000015'::uuid, 'd0000000-0000-0000-0000-000000000161'::uuid, 419.99, 5, 14, TRUE, 150),
('f0000000-0000-0000-0000-000000000282'::uuid, 'e0000000-0000-0000-0000-000000000015'::uuid, 'd0000000-0000-0000-0000-000000000163'::uuid, 569.99, 5, 10, TRUE, 140),
('f0000000-0000-0000-0000-000000000283'::uuid, 'e0000000-0000-0000-0000-000000000015'::uuid, 'd0000000-0000-0000-0000-000000000165'::uuid, 84.99, 25, 5, TRUE, 2800),
('f0000000-0000-0000-0000-000000000284'::uuid, 'e0000000-0000-0000-0000-000000000015'::uuid, 'd0000000-0000-0000-0000-000000000166'::uuid, 94.99, 25, 5, TRUE, 2300),
('f0000000-0000-0000-0000-000000000285'::uuid, 'e0000000-0000-0000-0000-000000000015'::uuid, 'd0000000-0000-0000-0000-000000000167'::uuid, 189.99, 10, 7, TRUE, 500),
('f0000000-0000-0000-0000-000000000286'::uuid, 'e0000000-0000-0000-0000-000000000015'::uuid, 'd0000000-0000-0000-0000-000000000170'::uuid, 74.99, 30, 3, TRUE, 3500),
('f0000000-0000-0000-0000-000000000287'::uuid, 'e0000000-0000-0000-0000-000000000015'::uuid, 'd0000000-0000-0000-0000-000000000173'::uuid, 169.99, 10, 7, FALSE, 0),
('f0000000-0000-0000-0000-000000000288'::uuid, 'e0000000-0000-0000-0000-000000000015'::uuid, 'd0000000-0000-0000-0000-000000000175'::uuid, 109.99, 20, 5, TRUE, 1000),
('f0000000-0000-0000-0000-000000000289'::uuid, 'e0000000-0000-0000-0000-000000000015'::uuid, 'd0000000-0000-0000-0000-000000000177'::uuid, 159.99, 10, 7, TRUE, 300),
('f0000000-0000-0000-0000-000000000290'::uuid, 'e0000000-0000-0000-0000-000000000015'::uuid, 'd0000000-0000-0000-0000-000000000179'::uuid, 129.99, 15, 5, TRUE, 550),
('f0000000-0000-0000-0000-000000000291'::uuid, 'e0000000-0000-0000-0000-000000000015'::uuid, 'd0000000-0000-0000-0000-000000000181'::uuid, 74.99, 25, 5, TRUE, 2500),
('f0000000-0000-0000-0000-000000000292'::uuid, 'e0000000-0000-0000-0000-000000000015'::uuid, 'd0000000-0000-0000-0000-000000000184'::uuid, 84.99, 25, 5, TRUE, 2200),
('f0000000-0000-0000-0000-000000000293'::uuid, 'e0000000-0000-0000-0000-000000000015'::uuid, 'd0000000-0000-0000-0000-000000000187'::uuid, 169.99, 10, 7, TRUE, 700),
('f0000000-0000-0000-0000-000000000294'::uuid, 'e0000000-0000-0000-0000-000000000015'::uuid, 'd0000000-0000-0000-0000-000000000190'::uuid, 159.99, 10, 5, TRUE, 550),
('f0000000-0000-0000-0000-000000000295'::uuid, 'e0000000-0000-0000-0000-000000000015'::uuid, 'd0000000-0000-0000-0000-000000000192'::uuid, 229.99, 10, 7, TRUE, 300),
('f0000000-0000-0000-0000-000000000296'::uuid, 'e0000000-0000-0000-0000-000000000015'::uuid, 'd0000000-0000-0000-0000-000000000194'::uuid, 209.99, 10, 7, TRUE, 400),
('f0000000-0000-0000-0000-000000000297'::uuid, 'e0000000-0000-0000-0000-000000000015'::uuid, 'd0000000-0000-0000-0000-000000000196'::uuid, 16.99, 100, 3, TRUE, 4500),
('f0000000-0000-0000-0000-000000000298'::uuid, 'e0000000-0000-0000-0000-000000000015'::uuid, 'd0000000-0000-0000-0000-000000000197'::uuid, 719.99, 3, 14, TRUE, 60),
('f0000000-0000-0000-0000-000000000299'::uuid, 'e0000000-0000-0000-0000-000000000015'::uuid, 'd0000000-0000-0000-0000-000000000199'::uuid, 39.99, 50, 3, TRUE, 1800),
('f0000000-0000-0000-0000-000000000300'::uuid, 'e0000000-0000-0000-0000-000000000015'::uuid, 'd0000000-0000-0000-0000-000000000200'::uuid, 259.99, 10, 7, TRUE, 300);

-- Vendor 16: Digital Frontier Inc (Austin TX) – smartphones + tablets
INSERT INTO vendor_products (id, vendor_id, product_id, unit_price, moq, lead_time_days, in_stock, stock_quantity) VALUES
('f0000000-0000-0000-0000-000000000301'::uuid, 'e0000000-0000-0000-0000-000000000016'::uuid, 'd0000000-0000-0000-0000-000000000001'::uuid, 889.99, 10, 5, TRUE, 480),
('f0000000-0000-0000-0000-000000000302'::uuid, 'e0000000-0000-0000-0000-000000000016'::uuid, 'd0000000-0000-0000-0000-000000000003'::uuid, 939.99, 10, 5, TRUE, 520),
('f0000000-0000-0000-0000-000000000303'::uuid, 'e0000000-0000-0000-0000-000000000016'::uuid, 'd0000000-0000-0000-0000-000000000006'::uuid, 739.99, 10, 5, TRUE, 380),
('f0000000-0000-0000-0000-000000000304'::uuid, 'e0000000-0000-0000-0000-000000000016'::uuid, 'd0000000-0000-0000-0000-000000000009'::uuid, 1379.99, 5, 7, TRUE, 130),
('f0000000-0000-0000-0000-000000000305'::uuid, 'e0000000-0000-0000-0000-000000000016'::uuid, 'd0000000-0000-0000-0000-000000000014'::uuid, 879.99, 5, 10, TRUE, 110),
('f0000000-0000-0000-0000-000000000306'::uuid, 'e0000000-0000-0000-0000-000000000016'::uuid, 'd0000000-0000-0000-0000-000000000015'::uuid, 979.99, 5, 10, TRUE, 90),
('f0000000-0000-0000-0000-000000000307'::uuid, 'e0000000-0000-0000-0000-000000000016'::uuid, 'd0000000-0000-0000-0000-000000000019'::uuid, 239.99, 25, 3, TRUE, 1400),
('f0000000-0000-0000-0000-000000000308'::uuid, 'e0000000-0000-0000-0000-000000000016'::uuid, 'd0000000-0000-0000-0000-000000000020'::uuid, 889.99, 5, 10, FALSE, 0),
('f0000000-0000-0000-0000-000000000309'::uuid, 'e0000000-0000-0000-0000-000000000016'::uuid, 'd0000000-0000-0000-0000-000000000061'::uuid, 889.99, 5, 5, TRUE, 380),
('f0000000-0000-0000-0000-000000000310'::uuid, 'e0000000-0000-0000-0000-000000000016'::uuid, 'd0000000-0000-0000-0000-000000000062'::uuid, 1079.99, 5, 5, TRUE, 230),
('f0000000-0000-0000-0000-000000000311'::uuid, 'e0000000-0000-0000-0000-000000000016'::uuid, 'd0000000-0000-0000-0000-000000000064'::uuid, 369.99, 15, 3, TRUE, 850),
('f0000000-0000-0000-0000-000000000312'::uuid, 'e0000000-0000-0000-0000-000000000016'::uuid, 'd0000000-0000-0000-0000-000000000066'::uuid, 869.99, 5, 7, TRUE, 190),
('f0000000-0000-0000-0000-000000000313'::uuid, 'e0000000-0000-0000-0000-000000000016'::uuid, 'd0000000-0000-0000-0000-000000000068'::uuid, 389.99, 15, 5, TRUE, 620),
('f0000000-0000-0000-0000-000000000314'::uuid, 'e0000000-0000-0000-0000-000000000016'::uuid, 'd0000000-0000-0000-0000-000000000069'::uuid, 1279.99, 5, 7, TRUE, 170),
('f0000000-0000-0000-0000-000000000315'::uuid, 'e0000000-0000-0000-0000-000000000016'::uuid, 'd0000000-0000-0000-0000-000000000071'::uuid, 539.99, 10, 7, TRUE, 280),
('f0000000-0000-0000-0000-000000000316'::uuid, 'e0000000-0000-0000-0000-000000000016'::uuid, 'd0000000-0000-0000-0000-000000000073'::uuid, 114.99, 25, 3, TRUE, 2800),
('f0000000-0000-0000-0000-000000000317'::uuid, 'e0000000-0000-0000-0000-000000000016'::uuid, 'd0000000-0000-0000-0000-000000000076'::uuid, 369.99, 10, 14, TRUE, 140),
('f0000000-0000-0000-0000-000000000318'::uuid, 'e0000000-0000-0000-0000-000000000016'::uuid, 'd0000000-0000-0000-0000-000000000078'::uuid, 539.99, 5, 14, TRUE, 80),
('f0000000-0000-0000-0000-000000000319'::uuid, 'e0000000-0000-0000-0000-000000000016'::uuid, 'd0000000-0000-0000-0000-000000000079'::uuid, 169.99, 20, 7, TRUE, 750),
('f0000000-0000-0000-0000-000000000320'::uuid, 'e0000000-0000-0000-0000-000000000016'::uuid, 'd0000000-0000-0000-0000-000000000080'::uuid, 239.99, 15, 5, TRUE, 720);

-- Vendor 17: Harbor Electronics Group (Miami FL) – audio + wearables
INSERT INTO vendor_products (id, vendor_id, product_id, unit_price, moq, lead_time_days, in_stock, stock_quantity) VALUES
('f0000000-0000-0000-0000-000000000321'::uuid, 'e0000000-0000-0000-0000-000000000017'::uuid, 'd0000000-0000-0000-0000-000000000081'::uuid, 299.99, 10, 7, TRUE, 400),
('f0000000-0000-0000-0000-000000000322'::uuid, 'e0000000-0000-0000-0000-000000000017'::uuid, 'd0000000-0000-0000-0000-000000000082'::uuid, 239.99, 15, 5, TRUE, 550),
('f0000000-0000-0000-0000-000000000323'::uuid, 'e0000000-0000-0000-0000-000000000017'::uuid, 'd0000000-0000-0000-0000-000000000084'::uuid, 459.99, 5, 10, FALSE, 0),
('f0000000-0000-0000-0000-000000000324'::uuid, 'e0000000-0000-0000-0000-000000000017'::uuid, 'd0000000-0000-0000-0000-000000000086'::uuid, 269.99, 10, 7, TRUE, 420),
('f0000000-0000-0000-0000-000000000325'::uuid, 'e0000000-0000-0000-0000-000000000017'::uuid, 'd0000000-0000-0000-0000-000000000088'::uuid, 104.99, 30, 3, TRUE, 2600),
('f0000000-0000-0000-0000-000000000326'::uuid, 'e0000000-0000-0000-0000-000000000017'::uuid, 'd0000000-0000-0000-0000-000000000089'::uuid, 144.99, 20, 5, TRUE, 1600),
('f0000000-0000-0000-0000-000000000327'::uuid, 'e0000000-0000-0000-0000-000000000017'::uuid, 'd0000000-0000-0000-0000-000000000092'::uuid, 289.99, 10, 10, TRUE, 200),
('f0000000-0000-0000-0000-000000000328'::uuid, 'e0000000-0000-0000-0000-000000000017'::uuid, 'd0000000-0000-0000-0000-000000000094'::uuid, 289.99, 10, 7, TRUE, 320),
('f0000000-0000-0000-0000-000000000329'::uuid, 'e0000000-0000-0000-0000-000000000017'::uuid, 'd0000000-0000-0000-0000-000000000096'::uuid, 124.99, 25, 3, TRUE, 1400),
('f0000000-0000-0000-0000-000000000330'::uuid, 'e0000000-0000-0000-0000-000000000017'::uuid, 'd0000000-0000-0000-0000-000000000098'::uuid, 134.99, 15, 7, TRUE, 420),
('f0000000-0000-0000-0000-000000000331'::uuid, 'e0000000-0000-0000-0000-000000000017'::uuid, 'd0000000-0000-0000-0000-000000000101'::uuid, 709.99, 5, 10, TRUE, 130),
('f0000000-0000-0000-0000-000000000332'::uuid, 'e0000000-0000-0000-0000-000000000017'::uuid, 'd0000000-0000-0000-0000-000000000103'::uuid, 229.99, 15, 5, TRUE, 750),
('f0000000-0000-0000-0000-000000000333'::uuid, 'e0000000-0000-0000-0000-000000000017'::uuid, 'd0000000-0000-0000-0000-000000000105'::uuid, 289.99, 10, 7, TRUE, 480),
('f0000000-0000-0000-0000-000000000334'::uuid, 'e0000000-0000-0000-0000-000000000017'::uuid, 'd0000000-0000-0000-0000-000000000108'::uuid, 459.99, 5, 10, TRUE, 90),
('f0000000-0000-0000-0000-000000000335'::uuid, 'e0000000-0000-0000-0000-000000000017'::uuid, 'd0000000-0000-0000-0000-000000000110'::uuid, 189.99, 15, 5, TRUE, 650),
('f0000000-0000-0000-0000-000000000336'::uuid, 'e0000000-0000-0000-0000-000000000017'::uuid, 'd0000000-0000-0000-0000-000000000112'::uuid, 359.99, 5, 14, TRUE, 100),
('f0000000-0000-0000-0000-000000000337'::uuid, 'e0000000-0000-0000-0000-000000000017'::uuid, 'd0000000-0000-0000-0000-000000000114'::uuid, 409.99, 5, 14, TRUE, 70),
('f0000000-0000-0000-0000-000000000338'::uuid, 'e0000000-0000-0000-0000-000000000017'::uuid, 'd0000000-0000-0000-0000-000000000116'::uuid, 289.99, 10, 10, TRUE, 180),
('f0000000-0000-0000-0000-000000000339'::uuid, 'e0000000-0000-0000-0000-000000000017'::uuid, 'd0000000-0000-0000-0000-000000000118'::uuid, 259.99, 10, 14, TRUE, 120),
('f0000000-0000-0000-0000-000000000340'::uuid, 'e0000000-0000-0000-0000-000000000017'::uuid, 'd0000000-0000-0000-0000-000000000120'::uuid, 359.99, 5, 10, TRUE, 160);

-- Vendor 18: Vertex Distribution LLC (Phoenix AZ) – laptops + TVs
INSERT INTO vendor_products (id, vendor_id, product_id, unit_price, moq, lead_time_days, in_stock, stock_quantity) VALUES
('f0000000-0000-0000-0000-000000000341'::uuid, 'e0000000-0000-0000-0000-000000000018'::uuid, 'd0000000-0000-0000-0000-000000000021'::uuid, 1419.99, 5, 5, TRUE, 250),
('f0000000-0000-0000-0000-000000000342'::uuid, 'e0000000-0000-0000-0000-000000000018'::uuid, 'd0000000-0000-0000-0000-000000000023'::uuid, 1669.99, 5, 5, TRUE, 200),
('f0000000-0000-0000-0000-000000000343'::uuid, 'e0000000-0000-0000-0000-000000000018'::uuid, 'd0000000-0000-0000-0000-000000000024'::uuid, 2749.99, 3, 7, TRUE, 70),
('f0000000-0000-0000-0000-000000000344'::uuid, 'e0000000-0000-0000-0000-000000000018'::uuid, 'd0000000-0000-0000-0000-000000000026'::uuid, 1519.99, 5, 5, TRUE, 240),
('f0000000-0000-0000-0000-000000000345'::uuid, 'e0000000-0000-0000-0000-000000000018'::uuid, 'd0000000-0000-0000-0000-000000000029'::uuid, 1419.99, 5, 5, TRUE, 320),
('f0000000-0000-0000-0000-000000000346'::uuid, 'e0000000-0000-0000-0000-000000000018'::uuid, 'd0000000-0000-0000-0000-000000000031'::uuid, 1569.99, 5, 7, TRUE, 130),
('f0000000-0000-0000-0000-000000000347'::uuid, 'e0000000-0000-0000-0000-000000000018'::uuid, 'd0000000-0000-0000-0000-000000000034'::uuid, 2249.99, 3, 10, FALSE, 0),
('f0000000-0000-0000-0000-000000000348'::uuid, 'e0000000-0000-0000-0000-000000000018'::uuid, 'd0000000-0000-0000-0000-000000000037'::uuid, 1369.99, 5, 5, TRUE, 200),
('f0000000-0000-0000-0000-000000000349'::uuid, 'e0000000-0000-0000-0000-000000000018'::uuid, 'd0000000-0000-0000-0000-000000000039'::uuid, 779.99, 10, 5, TRUE, 450),
('f0000000-0000-0000-0000-000000000350'::uuid, 'e0000000-0000-0000-0000-000000000018'::uuid, 'd0000000-0000-0000-0000-000000000041'::uuid, 1569.99, 3, 7, TRUE, 140),
('f0000000-0000-0000-0000-000000000351'::uuid, 'e0000000-0000-0000-0000-000000000018'::uuid, 'd0000000-0000-0000-0000-000000000043'::uuid, 879.99, 5, 5, TRUE, 300),
('f0000000-0000-0000-0000-000000000352'::uuid, 'e0000000-0000-0000-0000-000000000018'::uuid, 'd0000000-0000-0000-0000-000000000046'::uuid, 1069.99, 3, 7, TRUE, 180),
('f0000000-0000-0000-0000-000000000353'::uuid, 'e0000000-0000-0000-0000-000000000018'::uuid, 'd0000000-0000-0000-0000-000000000047'::uuid, 2149.99, 2, 10, TRUE, 40),
('f0000000-0000-0000-0000-000000000354'::uuid, 'e0000000-0000-0000-0000-000000000018'::uuid, 'd0000000-0000-0000-0000-000000000050'::uuid, 779.99, 5, 5, TRUE, 260),
('f0000000-0000-0000-0000-000000000355'::uuid, 'e0000000-0000-0000-0000-000000000018'::uuid, 'd0000000-0000-0000-0000-000000000053'::uuid, 879.99, 3, 7, TRUE, 120),
('f0000000-0000-0000-0000-000000000356'::uuid, 'e0000000-0000-0000-0000-000000000018'::uuid, 'd0000000-0000-0000-0000-000000000055'::uuid, 439.99, 5, 5, TRUE, 380),
('f0000000-0000-0000-0000-000000000357'::uuid, 'e0000000-0000-0000-0000-000000000018'::uuid, 'd0000000-0000-0000-0000-000000000057'::uuid, 1469.99, 3, 7, TRUE, 100),
('f0000000-0000-0000-0000-000000000358'::uuid, 'e0000000-0000-0000-0000-000000000018'::uuid, 'd0000000-0000-0000-0000-000000000058'::uuid, 579.99, 5, 5, TRUE, 360),
('f0000000-0000-0000-0000-000000000359'::uuid, 'e0000000-0000-0000-0000-000000000018'::uuid, 'd0000000-0000-0000-0000-000000000059'::uuid, 319.99, 10, 3, TRUE, 520),
('f0000000-0000-0000-0000-000000000360'::uuid, 'e0000000-0000-0000-0000-000000000018'::uuid, 'd0000000-0000-0000-0000-000000000060'::uuid, 439.99, 10, 5, TRUE, 440);

-- Vendor 19: Cascade Supply Network (Portland OR) – gaming + peripherals
INSERT INTO vendor_products (id, vendor_id, product_id, unit_price, moq, lead_time_days, in_stock, stock_quantity) VALUES
('f0000000-0000-0000-0000-000000000361'::uuid, 'e0000000-0000-0000-0000-000000000019'::uuid, 'd0000000-0000-0000-0000-000000000121'::uuid, 439.99, 5, 5, TRUE, 350),
('f0000000-0000-0000-0000-000000000362'::uuid, 'e0000000-0000-0000-0000-000000000019'::uuid, 'd0000000-0000-0000-0000-000000000122'::uuid, 389.99, 5, 5, TRUE, 380),
('f0000000-0000-0000-0000-000000000363'::uuid, 'e0000000-0000-0000-0000-000000000019'::uuid, 'd0000000-0000-0000-0000-000000000123'::uuid, 439.99, 5, 5, TRUE, 310),
('f0000000-0000-0000-0000-000000000364'::uuid, 'e0000000-0000-0000-0000-000000000019'::uuid, 'd0000000-0000-0000-0000-000000000125'::uuid, 289.99, 10, 3, TRUE, 520),
('f0000000-0000-0000-0000-000000000365'::uuid, 'e0000000-0000-0000-0000-000000000019'::uuid, 'd0000000-0000-0000-0000-000000000127'::uuid, 439.99, 5, 7, TRUE, 220),
('f0000000-0000-0000-0000-000000000366'::uuid, 'e0000000-0000-0000-0000-000000000019'::uuid, 'd0000000-0000-0000-0000-000000000130'::uuid, 589.99, 5, 7, FALSE, 0),
('f0000000-0000-0000-0000-000000000367'::uuid, 'e0000000-0000-0000-0000-000000000019'::uuid, 'd0000000-0000-0000-0000-000000000132'::uuid, 419.99, 5, 5, TRUE, 400),
('f0000000-0000-0000-0000-000000000368'::uuid, 'e0000000-0000-0000-0000-000000000019'::uuid, 'd0000000-0000-0000-0000-000000000133'::uuid, 489.99, 3, 7, TRUE, 190),
('f0000000-0000-0000-0000-000000000369'::uuid, 'e0000000-0000-0000-0000-000000000019'::uuid, 'd0000000-0000-0000-0000-000000000136'::uuid, 54.99, 20, 3, TRUE, 1600),
('f0000000-0000-0000-0000-000000000370'::uuid, 'e0000000-0000-0000-0000-000000000019'::uuid, 'd0000000-0000-0000-0000-000000000140'::uuid, 289.99, 5, 5, TRUE, 270),
('f0000000-0000-0000-0000-000000000371'::uuid, 'e0000000-0000-0000-0000-000000000019'::uuid, 'd0000000-0000-0000-0000-000000000161'::uuid, 389.99, 5, 7, TRUE, 220),
('f0000000-0000-0000-0000-000000000372'::uuid, 'e0000000-0000-0000-0000-000000000019'::uuid, 'd0000000-0000-0000-0000-000000000162'::uuid, 979.99, 2, 10, TRUE, 50),
('f0000000-0000-0000-0000-000000000373'::uuid, 'e0000000-0000-0000-0000-000000000019'::uuid, 'd0000000-0000-0000-0000-000000000165'::uuid, 77.99, 25, 3, TRUE, 3200),
('f0000000-0000-0000-0000-000000000374'::uuid, 'e0000000-0000-0000-0000-000000000019'::uuid, 'd0000000-0000-0000-0000-000000000167'::uuid, 174.99, 10, 5, TRUE, 550),
('f0000000-0000-0000-0000-000000000375'::uuid, 'e0000000-0000-0000-0000-000000000019'::uuid, 'd0000000-0000-0000-0000-000000000168'::uuid, 124.99, 15, 5, TRUE, 750),
('f0000000-0000-0000-0000-000000000376'::uuid, 'e0000000-0000-0000-0000-000000000019'::uuid, 'd0000000-0000-0000-0000-000000000169'::uuid, 164.99, 10, 5, TRUE, 420),
('f0000000-0000-0000-0000-000000000377'::uuid, 'e0000000-0000-0000-0000-000000000019'::uuid, 'd0000000-0000-0000-0000-000000000172'::uuid, 339.99, 3, 7, TRUE, 110),
('f0000000-0000-0000-0000-000000000378'::uuid, 'e0000000-0000-0000-0000-000000000019'::uuid, 'd0000000-0000-0000-0000-000000000174'::uuid, 134.99, 15, 5, TRUE, 680),
('f0000000-0000-0000-0000-000000000379'::uuid, 'e0000000-0000-0000-0000-000000000019'::uuid, 'd0000000-0000-0000-0000-000000000176'::uuid, 27.99, 50, 3, TRUE, 4800),
('f0000000-0000-0000-0000-000000000380'::uuid, 'e0000000-0000-0000-0000-000000000019'::uuid, 'd0000000-0000-0000-0000-000000000179'::uuid, 114.99, 15, 5, TRUE, 620);

-- Vendor 20: SunBelt Components (Tampa FL) – smart home + networking
INSERT INTO vendor_products (id, vendor_id, product_id, unit_price, moq, lead_time_days, in_stock, stock_quantity) VALUES
('f0000000-0000-0000-0000-000000000381'::uuid, 'e0000000-0000-0000-0000-000000000020'::uuid, 'd0000000-0000-0000-0000-000000000181'::uuid, 72.99, 25, 5, TRUE, 2800),
('f0000000-0000-0000-0000-000000000382'::uuid, 'e0000000-0000-0000-0000-000000000020'::uuid, 'd0000000-0000-0000-0000-000000000182'::uuid, 42.99, 50, 3, TRUE, 4500),
('f0000000-0000-0000-0000-000000000383'::uuid, 'e0000000-0000-0000-0000-000000000020'::uuid, 'd0000000-0000-0000-0000-000000000184'::uuid, 82.99, 25, 3, TRUE, 2300),
('f0000000-0000-0000-0000-000000000384'::uuid, 'e0000000-0000-0000-0000-000000000020'::uuid, 'd0000000-0000-0000-0000-000000000186'::uuid, 42.99, 50, 3, TRUE, 3800),
('f0000000-0000-0000-0000-000000000385'::uuid, 'e0000000-0000-0000-0000-000000000020'::uuid, 'd0000000-0000-0000-0000-000000000187'::uuid, 164.99, 10, 5, TRUE, 750),
('f0000000-0000-0000-0000-000000000386'::uuid, 'e0000000-0000-0000-0000-000000000020'::uuid, 'd0000000-0000-0000-0000-000000000188'::uuid, 209.99, 5, 7, TRUE, 280),
('f0000000-0000-0000-0000-000000000387'::uuid, 'e0000000-0000-0000-0000-000000000020'::uuid, 'd0000000-0000-0000-0000-000000000189'::uuid, 52.99, 30, 3, TRUE, 3200),
('f0000000-0000-0000-0000-000000000388'::uuid, 'e0000000-0000-0000-0000-000000000020'::uuid, 'd0000000-0000-0000-0000-000000000190'::uuid, 154.99, 10, 5, TRUE, 580),
('f0000000-0000-0000-0000-000000000389'::uuid, 'e0000000-0000-0000-0000-000000000020'::uuid, 'd0000000-0000-0000-0000-000000000192'::uuid, 224.99, 10, 7, FALSE, 0),
('f0000000-0000-0000-0000-000000000390'::uuid, 'e0000000-0000-0000-0000-000000000020'::uuid, 'd0000000-0000-0000-0000-000000000193'::uuid, 204.99, 10, 7, TRUE, 250),
('f0000000-0000-0000-0000-000000000391'::uuid, 'e0000000-0000-0000-0000-000000000020'::uuid, 'd0000000-0000-0000-0000-000000000195'::uuid, 184.99, 10, 7, TRUE, 280),
('f0000000-0000-0000-0000-000000000392'::uuid, 'e0000000-0000-0000-0000-000000000020'::uuid, 'd0000000-0000-0000-0000-000000000196'::uuid, 15.99, 100, 3, TRUE, 4800),
('f0000000-0000-0000-0000-000000000393'::uuid, 'e0000000-0000-0000-0000-000000000020'::uuid, 'd0000000-0000-0000-0000-000000000198'::uuid, 509.99, 3, 10, TRUE, 90),
('f0000000-0000-0000-0000-000000000394'::uuid, 'e0000000-0000-0000-0000-000000000020'::uuid, 'd0000000-0000-0000-0000-000000000200'::uuid, 254.99, 10, 7, TRUE, 320),
('f0000000-0000-0000-0000-000000000395'::uuid, 'e0000000-0000-0000-0000-000000000020'::uuid, 'd0000000-0000-0000-0000-000000000141'::uuid, 234.99, 10, 5, TRUE, 550),
('f0000000-0000-0000-0000-000000000396'::uuid, 'e0000000-0000-0000-0000-000000000020'::uuid, 'd0000000-0000-0000-0000-000000000143'::uuid, 304.99, 5, 5, TRUE, 370),
('f0000000-0000-0000-0000-000000000397'::uuid, 'e0000000-0000-0000-0000-000000000020'::uuid, 'd0000000-0000-0000-0000-000000000145'::uuid, 384.99, 3, 7, TRUE, 130),
('f0000000-0000-0000-0000-000000000398'::uuid, 'e0000000-0000-0000-0000-000000000020'::uuid, 'd0000000-0000-0000-0000-000000000149'::uuid, 354.99, 5, 5, TRUE, 310),
('f0000000-0000-0000-0000-000000000399'::uuid, 'e0000000-0000-0000-0000-000000000020'::uuid, 'd0000000-0000-0000-0000-000000000157'::uuid, 72.99, 25, 3, TRUE, 1800),
('f0000000-0000-0000-0000-000000000400'::uuid, 'e0000000-0000-0000-0000-000000000020'::uuid, 'd0000000-0000-0000-0000-000000000160'::uuid, 459.99, 3, 7, TRUE, 160);

-- Vendor 21: Heritage Tech Partners (Charlotte NC) – smartphones + audio
INSERT INTO vendor_products (id, vendor_id, product_id, unit_price, moq, lead_time_days, in_stock, stock_quantity) VALUES
('f0000000-0000-0000-0000-000000000401'::uuid, 'e0000000-0000-0000-0000-000000000021'::uuid, 'd0000000-0000-0000-0000-000000000002'::uuid, 1039.99, 10, 7, TRUE, 260),
('f0000000-0000-0000-0000-000000000402'::uuid, 'e0000000-0000-0000-0000-000000000021'::uuid, 'd0000000-0000-0000-0000-000000000004'::uuid, 1129.99, 5, 7, TRUE, 170),
('f0000000-0000-0000-0000-000000000403'::uuid, 'e0000000-0000-0000-0000-000000000021'::uuid, 'd0000000-0000-0000-0000-000000000007'::uuid, 539.99, 15, 5, TRUE, 580),
('f0000000-0000-0000-0000-000000000404'::uuid, 'e0000000-0000-0000-0000-000000000021'::uuid, 'd0000000-0000-0000-0000-000000000010'::uuid, 789.99, 10, 7, TRUE, 220),
('f0000000-0000-0000-0000-000000000405'::uuid, 'e0000000-0000-0000-0000-000000000021'::uuid, 'd0000000-0000-0000-0000-000000000013'::uuid, 539.99, 10, 10, FALSE, 0),
('f0000000-0000-0000-0000-000000000406'::uuid, 'e0000000-0000-0000-0000-000000000021'::uuid, 'd0000000-0000-0000-0000-000000000017'::uuid, 439.99, 15, 5, TRUE, 520),
('f0000000-0000-0000-0000-000000000407'::uuid, 'e0000000-0000-0000-0000-000000000021'::uuid, 'd0000000-0000-0000-0000-000000000019'::uuid, 244.99, 25, 3, TRUE, 1350),
('f0000000-0000-0000-0000-000000000408'::uuid, 'e0000000-0000-0000-0000-000000000021'::uuid, 'd0000000-0000-0000-0000-000000000081'::uuid, 284.99, 10, 7, TRUE, 470),
('f0000000-0000-0000-0000-000000000409'::uuid, 'e0000000-0000-0000-0000-000000000021'::uuid, 'd0000000-0000-0000-0000-000000000083'::uuid, 204.99, 20, 5, TRUE, 1100),
('f0000000-0000-0000-0000-000000000410'::uuid, 'e0000000-0000-0000-0000-000000000021'::uuid, 'd0000000-0000-0000-0000-000000000085'::uuid, 154.99, 25, 3, TRUE, 1900),
('f0000000-0000-0000-0000-000000000411'::uuid, 'e0000000-0000-0000-0000-000000000021'::uuid, 'd0000000-0000-0000-0000-000000000087'::uuid, 254.99, 10, 7, TRUE, 380),
('f0000000-0000-0000-0000-000000000412'::uuid, 'e0000000-0000-0000-0000-000000000021'::uuid, 'd0000000-0000-0000-0000-000000000089'::uuid, 144.99, 20, 3, TRUE, 1700),
('f0000000-0000-0000-0000-000000000413'::uuid, 'e0000000-0000-0000-0000-000000000021'::uuid, 'd0000000-0000-0000-0000-000000000091'::uuid, 354.99, 5, 7, TRUE, 290),
('f0000000-0000-0000-0000-000000000414'::uuid, 'e0000000-0000-0000-0000-000000000021'::uuid, 'd0000000-0000-0000-0000-000000000093'::uuid, 174.99, 20, 5, TRUE, 850),
('f0000000-0000-0000-0000-000000000415'::uuid, 'e0000000-0000-0000-0000-000000000021'::uuid, 'd0000000-0000-0000-0000-000000000095'::uuid, 409.99, 5, 10, TRUE, 90),
('f0000000-0000-0000-0000-000000000416'::uuid, 'e0000000-0000-0000-0000-000000000021'::uuid, 'd0000000-0000-0000-0000-000000000097'::uuid, 164.99, 15, 5, TRUE, 680),
('f0000000-0000-0000-0000-000000000417'::uuid, 'e0000000-0000-0000-0000-000000000021'::uuid, 'd0000000-0000-0000-0000-000000000099'::uuid, 334.99, 5, 10, TRUE, 190),
('f0000000-0000-0000-0000-000000000418'::uuid, 'e0000000-0000-0000-0000-000000000021'::uuid, 'd0000000-0000-0000-0000-000000000100'::uuid, 154.99, 15, 7, TRUE, 570),
('f0000000-0000-0000-0000-000000000419'::uuid, 'e0000000-0000-0000-0000-000000000021'::uuid, 'd0000000-0000-0000-0000-000000000090'::uuid, 384.99, 5, 7, TRUE, 240),
('f0000000-0000-0000-0000-000000000420'::uuid, 'e0000000-0000-0000-0000-000000000021'::uuid, 'd0000000-0000-0000-0000-000000000094'::uuid, 284.99, 10, 7, TRUE, 340);

-- Vendor 22: Bayshore Wholesale Tech (San Diego CA) – laptops + tablets
INSERT INTO vendor_products (id, vendor_id, product_id, unit_price, moq, lead_time_days, in_stock, stock_quantity) VALUES
('f0000000-0000-0000-0000-000000000421'::uuid, 'e0000000-0000-0000-0000-000000000022'::uuid, 'd0000000-0000-0000-0000-000000000022'::uuid, 1079.99, 10, 5, TRUE, 360),
('f0000000-0000-0000-0000-000000000422'::uuid, 'e0000000-0000-0000-0000-000000000022'::uuid, 'd0000000-0000-0000-0000-000000000025'::uuid, 1069.99, 10, 5, TRUE, 410),
('f0000000-0000-0000-0000-000000000423'::uuid, 'e0000000-0000-0000-0000-000000000022'::uuid, 'd0000000-0000-0000-0000-000000000027'::uuid, 1329.99, 5, 7, TRUE, 270),
('f0000000-0000-0000-0000-000000000424'::uuid, 'e0000000-0000-0000-0000-000000000022'::uuid, 'd0000000-0000-0000-0000-000000000028'::uuid, 1279.99, 5, 5, TRUE, 180),
('f0000000-0000-0000-0000-000000000425'::uuid, 'e0000000-0000-0000-0000-000000000022'::uuid, 'd0000000-0000-0000-0000-000000000030'::uuid, 989.99, 10, 5, TRUE, 430),
('f0000000-0000-0000-0000-000000000426'::uuid, 'e0000000-0000-0000-0000-000000000022'::uuid, 'd0000000-0000-0000-0000-000000000032'::uuid, 839.99, 10, 5, TRUE, 360),
('f0000000-0000-0000-0000-000000000427'::uuid, 'e0000000-0000-0000-0000-000000000022'::uuid, 'd0000000-0000-0000-0000-000000000035'::uuid, 2099.99, 3, 10, FALSE, 0),
('f0000000-0000-0000-0000-000000000428'::uuid, 'e0000000-0000-0000-0000-000000000022'::uuid, 'd0000000-0000-0000-0000-000000000038'::uuid, 1079.99, 10, 5, TRUE, 490),
('f0000000-0000-0000-0000-000000000429'::uuid, 'e0000000-0000-0000-0000-000000000022'::uuid, 'd0000000-0000-0000-0000-000000000040'::uuid, 839.99, 10, 5, TRUE, 350),
('f0000000-0000-0000-0000-000000000430'::uuid, 'e0000000-0000-0000-0000-000000000022'::uuid, 'd0000000-0000-0000-0000-000000000061'::uuid, 884.99, 5, 5, TRUE, 370),
('f0000000-0000-0000-0000-000000000431'::uuid, 'e0000000-0000-0000-0000-000000000022'::uuid, 'd0000000-0000-0000-0000-000000000063'::uuid, 544.99, 10, 5, TRUE, 580),
('f0000000-0000-0000-0000-000000000432'::uuid, 'e0000000-0000-0000-0000-000000000022'::uuid, 'd0000000-0000-0000-0000-000000000065'::uuid, 424.99, 10, 5, TRUE, 480),
('f0000000-0000-0000-0000-000000000433'::uuid, 'e0000000-0000-0000-0000-000000000022'::uuid, 'd0000000-0000-0000-0000-000000000067'::uuid, 739.99, 5, 7, TRUE, 260),
('f0000000-0000-0000-0000-000000000434'::uuid, 'e0000000-0000-0000-0000-000000000022'::uuid, 'd0000000-0000-0000-0000-000000000069'::uuid, 1279.99, 5, 5, TRUE, 190),
('f0000000-0000-0000-0000-000000000435'::uuid, 'e0000000-0000-0000-0000-000000000022'::uuid, 'd0000000-0000-0000-0000-000000000070'::uuid, 489.99, 10, 7, TRUE, 330),
('f0000000-0000-0000-0000-000000000436'::uuid, 'e0000000-0000-0000-0000-000000000022'::uuid, 'd0000000-0000-0000-0000-000000000074'::uuid, 82.99, 50, 3, TRUE, 3800),
('f0000000-0000-0000-0000-000000000437'::uuid, 'e0000000-0000-0000-0000-000000000022'::uuid, 'd0000000-0000-0000-0000-000000000075'::uuid, 394.99, 10, 7, TRUE, 210),
('f0000000-0000-0000-0000-000000000438'::uuid, 'e0000000-0000-0000-0000-000000000022'::uuid, 'd0000000-0000-0000-0000-000000000077'::uuid, 424.99, 10, 5, TRUE, 310),
('f0000000-0000-0000-0000-000000000439'::uuid, 'e0000000-0000-0000-0000-000000000022'::uuid, 'd0000000-0000-0000-0000-000000000079'::uuid, 174.99, 20, 5, TRUE, 780),
('f0000000-0000-0000-0000-000000000440'::uuid, 'e0000000-0000-0000-0000-000000000022'::uuid, 'd0000000-0000-0000-0000-000000000080'::uuid, 244.99, 15, 5, TRUE, 730);

-- Vendor 23: Central Valley Electronics (Fresno CA) – TVs + gaming
INSERT INTO vendor_products (id, vendor_id, product_id, unit_price, moq, lead_time_days, in_stock, stock_quantity) VALUES
('f0000000-0000-0000-0000-000000000441'::uuid, 'e0000000-0000-0000-0000-000000000023'::uuid, 'd0000000-0000-0000-0000-000000000042'::uuid, 2549.99, 2, 21, TRUE, 30),
('f0000000-0000-0000-0000-000000000442'::uuid, 'e0000000-0000-0000-0000-000000000023'::uuid, 'd0000000-0000-0000-0000-000000000044'::uuid, 1329.99, 3, 14, TRUE, 130),
('f0000000-0000-0000-0000-000000000443'::uuid, 'e0000000-0000-0000-0000-000000000023'::uuid, 'd0000000-0000-0000-0000-000000000045'::uuid, 1029.99, 5, 10, TRUE, 180),
('f0000000-0000-0000-0000-000000000444'::uuid, 'e0000000-0000-0000-0000-000000000023'::uuid, 'd0000000-0000-0000-0000-000000000048'::uuid, 3099.99, 1, 30, FALSE, 0),
('f0000000-0000-0000-0000-000000000445'::uuid, 'e0000000-0000-0000-0000-000000000023'::uuid, 'd0000000-0000-0000-0000-000000000049'::uuid, 309.99, 10, 7, TRUE, 750),
('f0000000-0000-0000-0000-000000000446'::uuid, 'e0000000-0000-0000-0000-000000000023'::uuid, 'd0000000-0000-0000-0000-000000000051'::uuid, 569.99, 5, 10, TRUE, 290),
('f0000000-0000-0000-0000-000000000447'::uuid, 'e0000000-0000-0000-0000-000000000023'::uuid, 'd0000000-0000-0000-0000-000000000052'::uuid, 669.99, 5, 10, TRUE, 250),
('f0000000-0000-0000-0000-000000000448'::uuid, 'e0000000-0000-0000-0000-000000000023'::uuid, 'd0000000-0000-0000-0000-000000000054'::uuid, 389.99, 10, 7, TRUE, 580),
('f0000000-0000-0000-0000-000000000449'::uuid, 'e0000000-0000-0000-0000-000000000023'::uuid, 'd0000000-0000-0000-0000-000000000056'::uuid, 1119.99, 3, 14, TRUE, 160),
('f0000000-0000-0000-0000-000000000450'::uuid, 'e0000000-0000-0000-0000-000000000023'::uuid, 'd0000000-0000-0000-0000-000000000060'::uuid, 459.99, 10, 10, TRUE, 380),
('f0000000-0000-0000-0000-000000000451'::uuid, 'e0000000-0000-0000-0000-000000000023'::uuid, 'd0000000-0000-0000-0000-000000000121'::uuid, 459.99, 5, 10, TRUE, 270),
('f0000000-0000-0000-0000-000000000452'::uuid, 'e0000000-0000-0000-0000-000000000023'::uuid, 'd0000000-0000-0000-0000-000000000124'::uuid, 279.99, 10, 7, TRUE, 550),
('f0000000-0000-0000-0000-000000000453'::uuid, 'e0000000-0000-0000-0000-000000000023'::uuid, 'd0000000-0000-0000-0000-000000000126'::uuid, 189.99, 15, 5, TRUE, 850),
('f0000000-0000-0000-0000-000000000454'::uuid, 'e0000000-0000-0000-0000-000000000023'::uuid, 'd0000000-0000-0000-0000-000000000128'::uuid, 559.99, 3, 14, TRUE, 80),
('f0000000-0000-0000-0000-000000000455'::uuid, 'e0000000-0000-0000-0000-000000000023'::uuid, 'd0000000-0000-0000-0000-000000000129'::uuid, 559.99, 5, 10, TRUE, 220),
('f0000000-0000-0000-0000-000000000456'::uuid, 'e0000000-0000-0000-0000-000000000023'::uuid, 'd0000000-0000-0000-0000-000000000131'::uuid, 459.99, 5, 14, TRUE, 100),
('f0000000-0000-0000-0000-000000000457'::uuid, 'e0000000-0000-0000-0000-000000000023'::uuid, 'd0000000-0000-0000-0000-000000000134'::uuid, 184.99, 10, 7, TRUE, 480),
('f0000000-0000-0000-0000-000000000458'::uuid, 'e0000000-0000-0000-0000-000000000023'::uuid, 'd0000000-0000-0000-0000-000000000137'::uuid, 659.99, 3, 21, TRUE, 50),
('f0000000-0000-0000-0000-000000000459'::uuid, 'e0000000-0000-0000-0000-000000000023'::uuid, 'd0000000-0000-0000-0000-000000000138'::uuid, 104.99, 20, 7, TRUE, 750),
('f0000000-0000-0000-0000-000000000460'::uuid, 'e0000000-0000-0000-0000-000000000023'::uuid, 'd0000000-0000-0000-0000-000000000139'::uuid, 94.99, 25, 7, TRUE, 900);

-- Vendor 24: Empire State Digital (Buffalo NY) – wearables + peripherals
INSERT INTO vendor_products (id, vendor_id, product_id, unit_price, moq, lead_time_days, in_stock, stock_quantity) VALUES
('f0000000-0000-0000-0000-000000000461'::uuid, 'e0000000-0000-0000-0000-000000000024'::uuid, 'd0000000-0000-0000-0000-000000000102'::uuid, 344.99, 10, 7, TRUE, 390),
('f0000000-0000-0000-0000-000000000462'::uuid, 'e0000000-0000-0000-0000-000000000024'::uuid, 'd0000000-0000-0000-0000-000000000104'::uuid, 344.99, 10, 7, TRUE, 340),
('f0000000-0000-0000-0000-000000000463'::uuid, 'e0000000-0000-0000-0000-000000000024'::uuid, 'd0000000-0000-0000-0000-000000000106'::uuid, 589.99, 5, 10, TRUE, 110),
('f0000000-0000-0000-0000-000000000464'::uuid, 'e0000000-0000-0000-0000-000000000024'::uuid, 'd0000000-0000-0000-0000-000000000107'::uuid, 374.99, 10, 7, TRUE, 240),
('f0000000-0000-0000-0000-000000000465'::uuid, 'e0000000-0000-0000-0000-000000000024'::uuid, 'd0000000-0000-0000-0000-000000000109'::uuid, 224.99, 15, 5, TRUE, 580),
('f0000000-0000-0000-0000-000000000466'::uuid, 'e0000000-0000-0000-0000-000000000024'::uuid, 'd0000000-0000-0000-0000-000000000111'::uuid, 294.99, 10, 7, FALSE, 0),
('f0000000-0000-0000-0000-000000000467'::uuid, 'e0000000-0000-0000-0000-000000000024'::uuid, 'd0000000-0000-0000-0000-000000000114'::uuid, 394.99, 5, 10, TRUE, 80),
('f0000000-0000-0000-0000-000000000468'::uuid, 'e0000000-0000-0000-0000-000000000024'::uuid, 'd0000000-0000-0000-0000-000000000116'::uuid, 274.99, 10, 10, TRUE, 190),
('f0000000-0000-0000-0000-000000000469'::uuid, 'e0000000-0000-0000-0000-000000000024'::uuid, 'd0000000-0000-0000-0000-000000000118'::uuid, 244.99, 10, 14, TRUE, 130),
('f0000000-0000-0000-0000-000000000470'::uuid, 'e0000000-0000-0000-0000-000000000024'::uuid, 'd0000000-0000-0000-0000-000000000120'::uuid, 344.99, 5, 10, TRUE, 170),
('f0000000-0000-0000-0000-000000000471'::uuid, 'e0000000-0000-0000-0000-000000000024'::uuid, 'd0000000-0000-0000-0000-000000000161'::uuid, 409.99, 5, 10, TRUE, 190),
('f0000000-0000-0000-0000-000000000472'::uuid, 'e0000000-0000-0000-0000-000000000024'::uuid, 'd0000000-0000-0000-0000-000000000163'::uuid, 559.99, 5, 7, TRUE, 170),
('f0000000-0000-0000-0000-000000000473'::uuid, 'e0000000-0000-0000-0000-000000000024'::uuid, 'd0000000-0000-0000-0000-000000000164'::uuid, 2479.99, 1, 14, TRUE, 20),
('f0000000-0000-0000-0000-000000000474'::uuid, 'e0000000-0000-0000-0000-000000000024'::uuid, 'd0000000-0000-0000-0000-000000000166'::uuid, 92.99, 25, 3, TRUE, 2400),
('f0000000-0000-0000-0000-000000000475'::uuid, 'e0000000-0000-0000-0000-000000000024'::uuid, 'd0000000-0000-0000-0000-000000000168'::uuid, 134.99, 15, 5, TRUE, 780),
('f0000000-0000-0000-0000-000000000476'::uuid, 'e0000000-0000-0000-0000-000000000024'::uuid, 'd0000000-0000-0000-0000-000000000171'::uuid, 254.99, 5, 7, TRUE, 140),
('f0000000-0000-0000-0000-000000000477'::uuid, 'e0000000-0000-0000-0000-000000000024'::uuid, 'd0000000-0000-0000-0000-000000000173'::uuid, 164.99, 10, 5, TRUE, 480),
('f0000000-0000-0000-0000-000000000478'::uuid, 'e0000000-0000-0000-0000-000000000024'::uuid, 'd0000000-0000-0000-0000-000000000175'::uuid, 104.99, 20, 3, TRUE, 1100),
('f0000000-0000-0000-0000-000000000479'::uuid, 'e0000000-0000-0000-0000-000000000024'::uuid, 'd0000000-0000-0000-0000-000000000178'::uuid, 174.99, 10, 5, TRUE, 420),
('f0000000-0000-0000-0000-000000000480'::uuid, 'e0000000-0000-0000-0000-000000000024'::uuid, 'd0000000-0000-0000-0000-000000000180'::uuid, 304.99, 5, 7, TRUE, 230);

-- Vendor 25: Keystone Supply Group (Pittsburgh PA) – smart home + networking
INSERT INTO vendor_products (id, vendor_id, product_id, unit_price, moq, lead_time_days, in_stock, stock_quantity) VALUES
('f0000000-0000-0000-0000-000000000481'::uuid, 'e0000000-0000-0000-0000-000000000025'::uuid, 'd0000000-0000-0000-0000-000000000181'::uuid, 67.99, 25, 3, TRUE, 3200),
('f0000000-0000-0000-0000-000000000482'::uuid, 'e0000000-0000-0000-0000-000000000025'::uuid, 'd0000000-0000-0000-0000-000000000183'::uuid, 194.99, 10, 3, TRUE, 420),
('f0000000-0000-0000-0000-000000000483'::uuid, 'e0000000-0000-0000-0000-000000000025'::uuid, 'd0000000-0000-0000-0000-000000000185'::uuid, 174.99, 10, 3, TRUE, 520),
('f0000000-0000-0000-0000-000000000484'::uuid, 'e0000000-0000-0000-0000-000000000025'::uuid, 'd0000000-0000-0000-0000-000000000187'::uuid, 154.99, 10, 3, TRUE, 850),
('f0000000-0000-0000-0000-000000000485'::uuid, 'e0000000-0000-0000-0000-000000000025'::uuid, 'd0000000-0000-0000-0000-000000000189'::uuid, 47.99, 30, 3, TRUE, 3600),
('f0000000-0000-0000-0000-000000000486'::uuid, 'e0000000-0000-0000-0000-000000000025'::uuid, 'd0000000-0000-0000-0000-000000000191'::uuid, 124.99, 15, 3, TRUE, 720),
('f0000000-0000-0000-0000-000000000487'::uuid, 'e0000000-0000-0000-0000-000000000025'::uuid, 'd0000000-0000-0000-0000-000000000192'::uuid, 214.99, 10, 5, TRUE, 370),
('f0000000-0000-0000-0000-000000000488'::uuid, 'e0000000-0000-0000-0000-000000000025'::uuid, 'd0000000-0000-0000-0000-000000000194'::uuid, 194.99, 10, 3, TRUE, 460),
('f0000000-0000-0000-0000-000000000489'::uuid, 'e0000000-0000-0000-0000-000000000025'::uuid, 'd0000000-0000-0000-0000-000000000195'::uuid, 174.99, 10, 5, TRUE, 310),
('f0000000-0000-0000-0000-000000000490'::uuid, 'e0000000-0000-0000-0000-000000000025'::uuid, 'd0000000-0000-0000-0000-000000000197'::uuid, 689.99, 3, 7, TRUE, 90),
('f0000000-0000-0000-0000-000000000491'::uuid, 'e0000000-0000-0000-0000-000000000025'::uuid, 'd0000000-0000-0000-0000-000000000198'::uuid, 489.99, 3, 7, TRUE, 110),
('f0000000-0000-0000-0000-000000000492'::uuid, 'e0000000-0000-0000-0000-000000000025'::uuid, 'd0000000-0000-0000-0000-000000000200'::uuid, 244.99, 10, 5, TRUE, 360),
('f0000000-0000-0000-0000-000000000493'::uuid, 'e0000000-0000-0000-0000-000000000025'::uuid, 'd0000000-0000-0000-0000-000000000142'::uuid, 389.99, 5, 5, TRUE, 210),
('f0000000-0000-0000-0000-000000000494'::uuid, 'e0000000-0000-0000-0000-000000000025'::uuid, 'd0000000-0000-0000-0000-000000000144'::uuid, 274.99, 10, 3, TRUE, 460),
('f0000000-0000-0000-0000-000000000495'::uuid, 'e0000000-0000-0000-0000-000000000025'::uuid, 'd0000000-0000-0000-0000-000000000146'::uuid, 289.99, 5, 5, TRUE, 310),
('f0000000-0000-0000-0000-000000000496'::uuid, 'e0000000-0000-0000-0000-000000000025'::uuid, 'd0000000-0000-0000-0000-000000000148'::uuid, 1079.99, 2, 10, TRUE, 40),
('f0000000-0000-0000-0000-000000000497'::uuid, 'e0000000-0000-0000-0000-000000000025'::uuid, 'd0000000-0000-0000-0000-000000000150'::uuid, 639.99, 3, 7, TRUE, 130),
('f0000000-0000-0000-0000-000000000498'::uuid, 'e0000000-0000-0000-0000-000000000025'::uuid, 'd0000000-0000-0000-0000-000000000154'::uuid, 174.99, 10, 3, TRUE, 470),
('f0000000-0000-0000-0000-000000000499'::uuid, 'e0000000-0000-0000-0000-000000000025'::uuid, 'd0000000-0000-0000-0000-000000000158'::uuid, 489.99, 3, 5, TRUE, 210),
('f0000000-0000-0000-0000-000000000500'::uuid, 'e0000000-0000-0000-0000-000000000025'::uuid, 'd0000000-0000-0000-0000-000000000160'::uuid, 439.99, 3, 5, TRUE, 190);

-- =============================================================================
-- PURCHASE ORDERS  (100 rows)
-- Buyer UUIDs (role=buyer): b03-b06 (org1), b13-b16 (org2), b23-b26 (org3)
-- Vendor UUIDs: e01-e09 (org1), e10-e17 (org2), e18-e25 (org3)
-- =============================================================================
INSERT INTO purchase_orders (id, po_number, buyer_id, vendor_id, status, total_amount, required_by_date, approval_required, approval_reason, approved_by, notes, created_at, updated_at) VALUES
-- 10 draft
('00010000-0000-0000-0000-000000000001'::uuid, 'PO-20250101-000001', 'b0000000-0000-0000-0000-000000000003'::uuid, 'e0000000-0000-0000-0000-000000000001'::uuid, 'draft', 450.00, '2025-02-15', FALSE, NULL, NULL, 'Initial draft for smartphone accessories', '2025-01-01 09:00:00+00', '2025-01-01 09:00:00+00'),
('00010000-0000-0000-0000-000000000002'::uuid, 'PO-20250103-000002', 'b0000000-0000-0000-0000-000000000004'::uuid, 'e0000000-0000-0000-0000-000000000002'::uuid, 'draft', 1200.00, '2025-02-20', FALSE, NULL, NULL, 'Draft for laptop order', '2025-01-03 10:30:00+00', '2025-01-03 10:30:00+00'),
('00010000-0000-0000-0000-000000000003'::uuid, 'PO-20250105-000003', 'b0000000-0000-0000-0000-000000000005'::uuid, 'e0000000-0000-0000-0000-000000000003'::uuid, 'draft', 899.97, '2025-02-25', FALSE, NULL, NULL, 'TV display units for showroom', '2025-01-05 11:15:00+00', '2025-01-05 11:15:00+00'),
('00010000-0000-0000-0000-000000000004'::uuid, 'PO-20250107-000004', 'b0000000-0000-0000-0000-000000000013'::uuid, 'e0000000-0000-0000-0000-000000000010'::uuid, 'draft', 350.00, '2025-03-01', FALSE, NULL, NULL, 'Smart home starter kits', '2025-01-07 08:45:00+00', '2025-01-07 08:45:00+00'),
('00010000-0000-0000-0000-000000000005'::uuid, 'PO-20250109-000005', 'b0000000-0000-0000-0000-000000000014'::uuid, 'e0000000-0000-0000-0000-000000000011'::uuid, 'draft', 2400.00, '2025-03-10', FALSE, NULL, NULL, 'Bulk phone order draft', '2025-01-09 14:00:00+00', '2025-01-09 14:00:00+00'),
('00010000-0000-0000-0000-000000000006'::uuid, 'PO-20250111-000006', 'b0000000-0000-0000-0000-000000000023'::uuid, 'e0000000-0000-0000-0000-000000000018'::uuid, 'draft', 780.00, '2025-03-15', FALSE, NULL, NULL, 'Laptop refresh cycle draft', '2025-01-11 09:30:00+00', '2025-01-11 09:30:00+00'),
('00010000-0000-0000-0000-000000000007'::uuid, 'PO-20250113-000007', 'b0000000-0000-0000-0000-000000000024'::uuid, 'e0000000-0000-0000-0000-000000000019'::uuid, 'draft', 1650.00, '2025-03-20', FALSE, NULL, NULL, 'Gaming peripherals draft', '2025-01-13 16:20:00+00', '2025-01-13 16:20:00+00'),
('00010000-0000-0000-0000-000000000008'::uuid, 'PO-20250115-000008', 'b0000000-0000-0000-0000-000000000006'::uuid, 'e0000000-0000-0000-0000-000000000004'::uuid, 'draft', 499.95, '2025-03-25', FALSE, NULL, NULL, 'Tablet resupply draft', '2025-01-15 10:00:00+00', '2025-01-15 10:00:00+00'),
('00010000-0000-0000-0000-000000000009'::uuid, 'PO-20250117-000009', 'b0000000-0000-0000-0000-000000000015'::uuid, 'e0000000-0000-0000-0000-000000000012'::uuid, 'draft', 3200.00, '2025-04-01', FALSE, NULL, NULL, 'AV equipment draft', '2025-01-17 13:45:00+00', '2025-01-17 13:45:00+00'),
('00010000-0000-0000-0000-000000000010'::uuid, 'PO-20250119-000010', 'b0000000-0000-0000-0000-000000000025'::uuid, 'e0000000-0000-0000-0000-000000000020'::uuid, 'draft', 150.00, '2025-04-05', FALSE, NULL, NULL, 'Smart plugs and basic IoT devices', '2025-01-19 15:30:00+00', '2025-01-19 15:30:00+00'),
-- 15 pending
('00010000-0000-0000-0000-000000000011'::uuid, 'PO-20250121-000011', 'b0000000-0000-0000-0000-000000000003'::uuid, 'e0000000-0000-0000-0000-000000000001'::uuid, 'pending', 2700.00, '2025-03-01', FALSE, NULL, NULL, 'Samsung Galaxy S24 Ultra bulk order', '2025-01-21 09:00:00+00', '2025-01-22 09:00:00+00'),
('00010000-0000-0000-0000-000000000012'::uuid, 'PO-20250123-000012', 'b0000000-0000-0000-0000-000000000004'::uuid, 'e0000000-0000-0000-0000-000000000002'::uuid, 'pending', 4500.00, '2025-03-10', FALSE, NULL, NULL, 'Dell XPS and MacBook Pro order', '2025-01-23 10:00:00+00', '2025-01-24 10:00:00+00'),
('00010000-0000-0000-0000-000000000013'::uuid, 'PO-20250125-000013', 'b0000000-0000-0000-0000-000000000005'::uuid, 'e0000000-0000-0000-0000-000000000005'::uuid, 'pending', 1800.00, '2025-03-15', FALSE, NULL, NULL, 'Audio equipment for conference rooms', '2025-01-25 11:00:00+00', '2025-01-26 11:00:00+00'),
('00010000-0000-0000-0000-000000000014'::uuid, 'PO-20250127-000014', 'b0000000-0000-0000-0000-000000000006'::uuid, 'e0000000-0000-0000-0000-000000000006'::uuid, 'pending', 3500.00, '2025-03-20', FALSE, NULL, NULL, 'Wearable devices for wellness program', '2025-01-27 14:00:00+00', '2025-01-28 14:00:00+00'),
('00010000-0000-0000-0000-000000000015'::uuid, 'PO-20250129-000015', 'b0000000-0000-0000-0000-000000000013'::uuid, 'e0000000-0000-0000-0000-000000000010'::uuid, 'pending', 950.00, '2025-03-25', FALSE, NULL, NULL, 'Smart home demo units', '2025-01-29 09:30:00+00', '2025-01-30 09:30:00+00'),
('00010000-0000-0000-0000-000000000016'::uuid, 'PO-20250131-000016', 'b0000000-0000-0000-0000-000000000014'::uuid, 'e0000000-0000-0000-0000-000000000011'::uuid, 'pending', 4800.00, '2025-04-01', FALSE, NULL, NULL, 'iPhone 15 Pro Max inventory restock', '2025-01-31 10:15:00+00', '2025-02-01 10:15:00+00'),
('00010000-0000-0000-0000-000000000017'::uuid, 'PO-20250202-000017', 'b0000000-0000-0000-0000-000000000015'::uuid, 'e0000000-0000-0000-0000-000000000012'::uuid, 'pending', 2200.00, '2025-04-05', FALSE, NULL, NULL, 'TV displays for client installations', '2025-02-02 11:30:00+00', '2025-02-03 11:30:00+00'),
('00010000-0000-0000-0000-000000000018'::uuid, 'PO-20250204-000018', 'b0000000-0000-0000-0000-000000000016'::uuid, 'e0000000-0000-0000-0000-000000000013'::uuid, 'pending', 1600.00, '2025-04-10', FALSE, NULL, NULL, 'Tablets and wearables bundle', '2025-02-04 08:45:00+00', '2025-02-05 08:45:00+00'),
('00010000-0000-0000-0000-000000000019'::uuid, 'PO-20250206-000019', 'b0000000-0000-0000-0000-000000000023'::uuid, 'e0000000-0000-0000-0000-000000000019'::uuid, 'pending', 3000.00, '2025-04-15', FALSE, NULL, NULL, 'Gaming console restock for spring season', '2025-02-06 13:00:00+00', '2025-02-07 13:00:00+00'),
('00010000-0000-0000-0000-000000000020'::uuid, 'PO-20250208-000020', 'b0000000-0000-0000-0000-000000000024'::uuid, 'e0000000-0000-0000-0000-000000000022'::uuid, 'pending', 4200.00, '2025-04-20', FALSE, NULL, NULL, 'Laptop and tablet combo order', '2025-02-08 15:00:00+00', '2025-02-09 15:00:00+00'),
('00010000-0000-0000-0000-000000000021'::uuid, 'PO-20250210-000021', 'b0000000-0000-0000-0000-000000000025'::uuid, 'e0000000-0000-0000-0000-000000000020'::uuid, 'pending', 600.00, '2025-04-25', FALSE, NULL, NULL, 'Networking equipment for new office', '2025-02-10 09:00:00+00', '2025-02-11 09:00:00+00'),
('00010000-0000-0000-0000-000000000022'::uuid, 'PO-20250212-000022', 'b0000000-0000-0000-0000-000000000026'::uuid, 'e0000000-0000-0000-0000-000000000025'::uuid, 'pending', 1400.00, '2025-04-30', FALSE, NULL, NULL, 'Smart home devices for showroom', '2025-02-12 10:30:00+00', '2025-02-13 10:30:00+00'),
('00010000-0000-0000-0000-000000000023'::uuid, 'PO-20250214-000023', 'b0000000-0000-0000-0000-000000000003'::uuid, 'e0000000-0000-0000-0000-000000000007'::uuid, 'pending', 2800.00, '2025-05-01', FALSE, NULL, NULL, 'Gaming accessories and controllers', '2025-02-14 11:00:00+00', '2025-02-15 11:00:00+00'),
('00010000-0000-0000-0000-000000000024'::uuid, 'PO-20250216-000024', 'b0000000-0000-0000-0000-000000000004'::uuid, 'e0000000-0000-0000-0000-000000000008'::uuid, 'pending', 3800.00, '2025-05-05', FALSE, NULL, NULL, 'Networking infrastructure upgrade', '2025-02-16 14:30:00+00', '2025-02-17 14:30:00+00'),
('00010000-0000-0000-0000-000000000025'::uuid, 'PO-20250218-000025', 'b0000000-0000-0000-0000-000000000005'::uuid, 'e0000000-0000-0000-0000-000000000009'::uuid, 'pending', 2100.00, '2025-05-10', FALSE, NULL, NULL, 'Peripheral devices for IT dept', '2025-02-18 16:00:00+00', '2025-02-19 16:00:00+00'),
-- 25 confirmed
('00010000-0000-0000-0000-000000000026'::uuid, 'PO-20250220-000026', 'b0000000-0000-0000-0000-000000000003'::uuid, 'e0000000-0000-0000-0000-000000000001'::uuid, 'confirmed', 4500.00, '2025-04-01', FALSE, NULL, NULL, 'Confirmed smartphone order batch 1', '2025-02-20 09:00:00+00', '2025-02-22 09:00:00+00'),
('00010000-0000-0000-0000-000000000027'::uuid, 'PO-20250222-000027', 'b0000000-0000-0000-0000-000000000004'::uuid, 'e0000000-0000-0000-0000-000000000002'::uuid, 'confirmed', 3200.00, '2025-04-05', FALSE, NULL, NULL, 'Laptop order for training center', '2025-02-22 10:00:00+00', '2025-02-24 10:00:00+00'),
('00010000-0000-0000-0000-000000000028'::uuid, 'PO-20250224-000028', 'b0000000-0000-0000-0000-000000000005'::uuid, 'e0000000-0000-0000-0000-000000000003'::uuid, 'confirmed', 2400.00, '2025-04-10', FALSE, NULL, NULL, 'TV order for retail partner', '2025-02-24 11:00:00+00', '2025-02-26 11:00:00+00'),
('00010000-0000-0000-0000-000000000029'::uuid, 'PO-20250226-000029', 'b0000000-0000-0000-0000-000000000006'::uuid, 'e0000000-0000-0000-0000-000000000004'::uuid, 'confirmed', 1800.00, '2025-04-15', FALSE, NULL, NULL, 'iPad Pro order for education sector', '2025-02-26 14:00:00+00', '2025-02-28 14:00:00+00'),
('00010000-0000-0000-0000-000000000030'::uuid, 'PO-20250228-000030', 'b0000000-0000-0000-0000-000000000003'::uuid, 'e0000000-0000-0000-0000-000000000005'::uuid, 'confirmed', 850.00, '2025-04-20', FALSE, NULL, NULL, 'Audio equipment for event space', '2025-02-28 09:30:00+00', '2025-03-02 09:30:00+00'),
('00010000-0000-0000-0000-000000000031'::uuid, 'PO-20250302-000031', 'b0000000-0000-0000-0000-000000000013'::uuid, 'e0000000-0000-0000-0000-000000000010'::uuid, 'confirmed', 1200.00, '2025-04-25', FALSE, NULL, NULL, 'Smart home devices for demo center', '2025-03-02 10:00:00+00', '2025-03-04 10:00:00+00'),
('00010000-0000-0000-0000-000000000032'::uuid, 'PO-20250304-000032', 'b0000000-0000-0000-0000-000000000014'::uuid, 'e0000000-0000-0000-0000-000000000011'::uuid, 'confirmed', 2600.00, '2025-05-01', FALSE, NULL, NULL, 'Smartphone inventory replenishment', '2025-03-04 11:00:00+00', '2025-03-06 11:00:00+00'),
('00010000-0000-0000-0000-000000000033'::uuid, 'PO-20250306-000033', 'b0000000-0000-0000-0000-000000000015'::uuid, 'e0000000-0000-0000-0000-000000000014'::uuid, 'confirmed', 3100.00, '2025-05-05', FALSE, NULL, NULL, 'Gaming and networking bundle', '2025-03-06 13:00:00+00', '2025-03-08 13:00:00+00'),
('00010000-0000-0000-0000-000000000034'::uuid, 'PO-20250308-000034', 'b0000000-0000-0000-0000-000000000016'::uuid, 'e0000000-0000-0000-0000-000000000016'::uuid, 'confirmed', 4200.00, '2025-05-10', FALSE, NULL, NULL, 'iPhone and iPad combo order', '2025-03-08 14:30:00+00', '2025-03-10 14:30:00+00'),
('00010000-0000-0000-0000-000000000035'::uuid, 'PO-20250310-000035', 'b0000000-0000-0000-0000-000000000023'::uuid, 'e0000000-0000-0000-0000-000000000018'::uuid, 'confirmed', 2900.00, '2025-05-15', FALSE, NULL, NULL, 'Laptop refresh for engineering team', '2025-03-10 09:00:00+00', '2025-03-12 09:00:00+00'),
('00010000-0000-0000-0000-000000000036'::uuid, 'PO-20250312-000036', 'b0000000-0000-0000-0000-000000000024'::uuid, 'e0000000-0000-0000-0000-000000000019'::uuid, 'confirmed', 1500.00, '2025-05-20', FALSE, NULL, NULL, 'Gaming peripherals for esports program', '2025-03-12 10:30:00+00', '2025-03-14 10:30:00+00'),
('00010000-0000-0000-0000-000000000037'::uuid, 'PO-20250314-000037', 'b0000000-0000-0000-0000-000000000025'::uuid, 'e0000000-0000-0000-0000-000000000020'::uuid, 'confirmed', 750.00, '2025-05-25', FALSE, NULL, NULL, 'Smart home devices for new branch', '2025-03-14 11:45:00+00', '2025-03-16 11:45:00+00'),
('00010000-0000-0000-0000-000000000038'::uuid, 'PO-20250316-000038', 'b0000000-0000-0000-0000-000000000026'::uuid, 'e0000000-0000-0000-0000-000000000021'::uuid, 'confirmed', 2100.00, '2025-06-01', FALSE, NULL, NULL, 'Audio systems for retail stores', '2025-03-16 14:00:00+00', '2025-03-18 14:00:00+00'),
('00010000-0000-0000-0000-000000000039'::uuid, 'PO-20250318-000039', 'b0000000-0000-0000-0000-000000000003'::uuid, 'e0000000-0000-0000-0000-000000000006'::uuid, 'confirmed', 3400.00, '2025-06-05', FALSE, NULL, NULL, 'Wearable devices for corporate wellness', '2025-03-18 15:30:00+00', '2025-03-20 15:30:00+00'),
('00010000-0000-0000-0000-000000000040'::uuid, 'PO-20250320-000040', 'b0000000-0000-0000-0000-000000000004'::uuid, 'e0000000-0000-0000-0000-000000000008'::uuid, 'confirmed', 4800.00, '2025-06-10', FALSE, NULL, NULL, 'Enterprise networking equipment', '2025-03-20 09:00:00+00', '2025-03-22 09:00:00+00'),
('00010000-0000-0000-0000-000000000041'::uuid, 'PO-20250322-000041', 'b0000000-0000-0000-0000-000000000005'::uuid, 'e0000000-0000-0000-0000-000000000009'::uuid, 'confirmed', 1900.00, '2025-06-15', FALSE, NULL, NULL, 'Monitor and keyboard bundle', '2025-03-22 10:00:00+00', '2025-03-24 10:00:00+00'),
('00010000-0000-0000-0000-000000000042'::uuid, 'PO-20250324-000042', 'b0000000-0000-0000-0000-000000000013'::uuid, 'e0000000-0000-0000-0000-000000000013'::uuid, 'confirmed', 2700.00, '2025-06-20', FALSE, NULL, NULL, 'Tablet fleet for field sales', '2025-03-24 11:30:00+00', '2025-03-26 11:30:00+00'),
('00010000-0000-0000-0000-000000000043'::uuid, 'PO-20250326-000043', 'b0000000-0000-0000-0000-000000000014'::uuid, 'e0000000-0000-0000-0000-000000000016'::uuid, 'confirmed', 1100.00, '2025-06-25', FALSE, NULL, NULL, 'Budget tablet order for training', '2025-03-26 13:00:00+00', '2025-03-28 13:00:00+00'),
('00010000-0000-0000-0000-000000000044'::uuid, 'PO-20250328-000044', 'b0000000-0000-0000-0000-000000000015'::uuid, 'e0000000-0000-0000-0000-000000000015'::uuid, 'confirmed', 800.00, '2025-07-01', FALSE, NULL, NULL, 'Webcams and peripherals for hybrid workers', '2025-03-28 14:30:00+00', '2025-03-30 14:30:00+00'),
('00010000-0000-0000-0000-000000000045'::uuid, 'PO-20250330-000045', 'b0000000-0000-0000-0000-000000000023'::uuid, 'e0000000-0000-0000-0000-000000000022'::uuid, 'confirmed', 3600.00, '2025-07-05', FALSE, NULL, NULL, 'MacBook Air fleet for designers', '2025-03-30 09:00:00+00', '2025-04-01 09:00:00+00'),
('00010000-0000-0000-0000-000000000046'::uuid, 'PO-20250401-000046', 'b0000000-0000-0000-0000-000000000024'::uuid, 'e0000000-0000-0000-0000-000000000023'::uuid, 'confirmed', 2200.00, '2025-07-10', FALSE, NULL, NULL, 'TV displays for digital signage', '2025-04-01 10:00:00+00', '2025-04-03 10:00:00+00'),
('00010000-0000-0000-0000-000000000047'::uuid, 'PO-20250403-000047', 'b0000000-0000-0000-0000-000000000025'::uuid, 'e0000000-0000-0000-0000-000000000024'::uuid, 'confirmed', 1700.00, '2025-07-15', FALSE, NULL, NULL, 'Fitness tracker rollout for employees', '2025-04-03 11:00:00+00', '2025-04-05 11:00:00+00'),
('00010000-0000-0000-0000-000000000048'::uuid, 'PO-20250405-000048', 'b0000000-0000-0000-0000-000000000026'::uuid, 'e0000000-0000-0000-0000-000000000025'::uuid, 'confirmed', 900.00, '2025-07-20', FALSE, NULL, NULL, 'Router and mesh system order', '2025-04-05 14:00:00+00', '2025-04-07 14:00:00+00'),
('00010000-0000-0000-0000-000000000049'::uuid, 'PO-20250407-000049', 'b0000000-0000-0000-0000-000000000006'::uuid, 'e0000000-0000-0000-0000-000000000007'::uuid, 'confirmed', 4900.00, '2025-07-25', FALSE, NULL, NULL, 'PS5 and Xbox bulk order for reseller', '2025-04-07 09:00:00+00', '2025-04-09 09:00:00+00'),
('00010000-0000-0000-0000-000000000050'::uuid, 'PO-20250409-000050', 'b0000000-0000-0000-0000-000000000003'::uuid, 'e0000000-0000-0000-0000-000000000004'::uuid, 'confirmed', 50.00, '2025-07-30', FALSE, NULL, NULL, 'Small tablet accessories order', '2025-04-09 10:30:00+00', '2025-04-11 10:30:00+00'),
-- 10 flagged_for_review
('00010000-0000-0000-0000-000000000051'::uuid, 'PO-20250411-000051', 'b0000000-0000-0000-0000-000000000004'::uuid, 'e0000000-0000-0000-0000-000000000001'::uuid, 'flagged_for_review', 8999.90, '2025-05-15', TRUE, 'Total amount exceeds $5,000 threshold', NULL, 'Large Samsung Galaxy order for enterprise client', '2025-04-11 09:00:00+00', '2025-04-11 09:00:00+00'),
('00010000-0000-0000-0000-000000000052'::uuid, 'PO-20250413-000052', 'b0000000-0000-0000-0000-000000000005'::uuid, 'e0000000-0000-0000-0000-000000000002'::uuid, 'flagged_for_review', 14499.95, '2025-05-20', TRUE, 'Total amount exceeds $5,000 threshold', NULL, 'MacBook Pro fleet order for dev team', '2025-04-13 10:00:00+00', '2025-04-13 10:00:00+00'),
('00010000-0000-0000-0000-000000000053'::uuid, 'PO-20250415-000053', 'b0000000-0000-0000-0000-000000000013'::uuid, 'e0000000-0000-0000-0000-000000000010'::uuid, 'flagged_for_review', 12000.00, '2025-06-01', TRUE, 'Total amount exceeds $5,000 threshold', NULL, 'Large smart home deployment project', '2025-04-15 11:00:00+00', '2025-04-15 11:00:00+00'),
('00010000-0000-0000-0000-000000000054'::uuid, 'PO-20250417-000054', 'b0000000-0000-0000-0000-000000000014'::uuid, 'e0000000-0000-0000-0000-000000000016'::uuid, 'flagged_for_review', 22000.00, '2025-06-05', TRUE, 'Total amount exceeds $5,000 threshold', NULL, 'Enterprise phone refresh - 20 units', '2025-04-17 14:00:00+00', '2025-04-17 14:00:00+00'),
('00010000-0000-0000-0000-000000000055'::uuid, 'PO-20250419-000055', 'b0000000-0000-0000-0000-000000000023'::uuid, 'e0000000-0000-0000-0000-000000000018'::uuid, 'flagged_for_review', 27499.90, '2025-06-10', TRUE, 'Total amount exceeds $5,000 threshold', NULL, 'Laptop fleet for new department - 10 MacBook Pros', '2025-04-19 09:30:00+00', '2025-04-19 09:30:00+00'),
('00010000-0000-0000-0000-000000000056'::uuid, 'PO-20250421-000056', 'b0000000-0000-0000-0000-000000000024'::uuid, 'e0000000-0000-0000-0000-000000000023'::uuid, 'flagged_for_review', 15000.00, '2025-06-15', TRUE, 'Total amount exceeds $5,000 threshold', NULL, 'TV and AV equipment for conference rooms', '2025-04-21 10:00:00+00', '2025-04-21 10:00:00+00'),
('00010000-0000-0000-0000-000000000057'::uuid, 'PO-20250423-000057', 'b0000000-0000-0000-0000-000000000006'::uuid, 'e0000000-0000-0000-0000-000000000004'::uuid, 'flagged_for_review', 9800.00, '2025-06-20', TRUE, 'Total amount exceeds $5,000 threshold', NULL, 'iPad fleet for warehouse staff', '2025-04-23 11:30:00+00', '2025-04-23 11:30:00+00'),
('00010000-0000-0000-0000-000000000058'::uuid, 'PO-20250425-000058', 'b0000000-0000-0000-0000-000000000015'::uuid, 'e0000000-0000-0000-0000-000000000014'::uuid, 'flagged_for_review', 7500.00, '2025-06-25', TRUE, 'Total amount exceeds $5,000 threshold', NULL, 'Gaming lounge equipment package', '2025-04-25 14:00:00+00', '2025-04-25 14:00:00+00'),
('00010000-0000-0000-0000-000000000059'::uuid, 'PO-20250427-000059', 'b0000000-0000-0000-0000-000000000025'::uuid, 'e0000000-0000-0000-0000-000000000025'::uuid, 'flagged_for_review', 5200.00, '2025-07-01', TRUE, 'Total amount exceeds $5,000 threshold', NULL, 'Smart home + networking bundle for new building', '2025-04-27 09:00:00+00', '2025-04-27 09:00:00+00'),
('00010000-0000-0000-0000-000000000060'::uuid, 'PO-20250429-000060', 'b0000000-0000-0000-0000-000000000003'::uuid, 'e0000000-0000-0000-0000-000000000008'::uuid, 'flagged_for_review', 18000.00, '2025-07-05', TRUE, 'Total amount exceeds $5,000 threshold', NULL, 'Network infrastructure overhaul - switches and APs', '2025-04-29 10:30:00+00', '2025-04-29 10:30:00+00'),
-- 15 approved
('00010000-0000-0000-0000-000000000061'::uuid, 'PO-20250301-000061', 'b0000000-0000-0000-0000-000000000004'::uuid, 'e0000000-0000-0000-0000-000000000001'::uuid, 'approved', 8500.00, '2025-04-15', TRUE, 'Total amount exceeds $5,000 threshold', 'robert.williams@techmart-global.com', 'Approved: bulk Galaxy order for Q2 inventory', '2025-03-01 09:00:00+00', '2025-03-05 09:00:00+00'),
('00010000-0000-0000-0000-000000000062'::uuid, 'PO-20250303-000062', 'b0000000-0000-0000-0000-000000000005'::uuid, 'e0000000-0000-0000-0000-000000000002'::uuid, 'approved', 16999.95, '2025-04-20', TRUE, 'Total amount exceeds $5,000 threshold', 'amanda.garcia@techmart-global.com', 'Approved: Dell XPS fleet for IT department', '2025-03-03 10:00:00+00', '2025-03-07 10:00:00+00'),
('00010000-0000-0000-0000-000000000063'::uuid, 'PO-20250305-000063', 'b0000000-0000-0000-0000-000000000006'::uuid, 'e0000000-0000-0000-0000-000000000003'::uuid, 'approved', 7200.00, '2025-04-25', TRUE, 'Total amount exceeds $5,000 threshold', 'robert.williams@techmart-global.com', 'Approved: LG OLED displays for showroom', '2025-03-05 11:00:00+00', '2025-03-09 11:00:00+00'),
('00010000-0000-0000-0000-000000000064'::uuid, 'PO-20250307-000064', 'b0000000-0000-0000-0000-000000000003'::uuid, 'e0000000-0000-0000-0000-000000000004'::uuid, 'approved', 11000.00, '2025-05-01', TRUE, 'Total amount exceeds $5,000 threshold', 'amanda.garcia@techmart-global.com', 'Approved: iPad Pro fleet for design team', '2025-03-07 14:00:00+00', '2025-03-11 14:00:00+00'),
('00010000-0000-0000-0000-000000000065'::uuid, 'PO-20250309-000065', 'b0000000-0000-0000-0000-000000000013'::uuid, 'e0000000-0000-0000-0000-000000000011'::uuid, 'approved', 9200.00, '2025-05-05', TRUE, 'Total amount exceeds $5,000 threshold', 'andrew.white@electrahub.com', 'Approved: iPhone fleet for sales team', '2025-03-09 09:30:00+00', '2025-03-13 09:30:00+00'),
('00010000-0000-0000-0000-000000000066'::uuid, 'PO-20250311-000066', 'b0000000-0000-0000-0000-000000000014'::uuid, 'e0000000-0000-0000-0000-000000000012'::uuid, 'approved', 6800.00, '2025-05-10', TRUE, 'Total amount exceeds $5,000 threshold', 'stephanie.harris@electrahub.com', 'Approved: Samsung TVs for client installations', '2025-03-11 10:00:00+00', '2025-03-15 10:00:00+00'),
('00010000-0000-0000-0000-000000000067'::uuid, 'PO-20250313-000067', 'b0000000-0000-0000-0000-000000000015'::uuid, 'e0000000-0000-0000-0000-000000000013'::uuid, 'approved', 12500.00, '2025-05-15', TRUE, 'Total amount exceeds $5,000 threshold', 'andrew.white@electrahub.com', 'Approved: tablet fleet for field operations', '2025-03-13 11:30:00+00', '2025-03-17 11:30:00+00'),
('00010000-0000-0000-0000-000000000068'::uuid, 'PO-20250315-000068', 'b0000000-0000-0000-0000-000000000016'::uuid, 'e0000000-0000-0000-0000-000000000016'::uuid, 'approved', 18800.00, '2025-05-20', TRUE, 'Total amount exceeds $5,000 threshold', 'stephanie.harris@electrahub.com', 'Approved: iPhone 15 Pro Max order - 20 units', '2025-03-15 13:00:00+00', '2025-03-19 13:00:00+00'),
('00010000-0000-0000-0000-000000000069'::uuid, 'PO-20250317-000069', 'b0000000-0000-0000-0000-000000000023'::uuid, 'e0000000-0000-0000-0000-000000000018'::uuid, 'approved', 28000.00, '2025-05-25', TRUE, 'Total amount exceeds $5,000 threshold', 'patrick.adams@primegadget.com', 'Approved: MacBook Pro fleet for engineering', '2025-03-17 14:30:00+00', '2025-03-21 14:30:00+00'),
('00010000-0000-0000-0000-000000000070'::uuid, 'PO-20250319-000070', 'b0000000-0000-0000-0000-000000000024'::uuid, 'e0000000-0000-0000-0000-000000000019'::uuid, 'approved', 5500.00, '2025-06-01', TRUE, 'Total amount exceeds $5,000 threshold', 'heather.nelson@primegadget.com', 'Approved: gaming peripherals for retail', '2025-03-19 09:00:00+00', '2025-03-23 09:00:00+00'),
('00010000-0000-0000-0000-000000000071'::uuid, 'PO-20250321-000071', 'b0000000-0000-0000-0000-000000000025'::uuid, 'e0000000-0000-0000-0000-000000000020'::uuid, 'approved', 7800.00, '2025-06-05', TRUE, 'Total amount exceeds $5,000 threshold', 'patrick.adams@primegadget.com', 'Approved: smart home deployment for new offices', '2025-03-21 10:30:00+00', '2025-03-25 10:30:00+00'),
('00010000-0000-0000-0000-000000000072'::uuid, 'PO-20250323-000072', 'b0000000-0000-0000-0000-000000000026'::uuid, 'e0000000-0000-0000-0000-000000000025'::uuid, 'approved', 50000.00, '2025-06-10', TRUE, 'Total amount exceeds $5,000 threshold - URGENT', 'heather.nelson@primegadget.com', 'Approved: massive networking overhaul project', '2025-03-23 11:00:00+00', '2025-03-27 11:00:00+00'),
('00010000-0000-0000-0000-000000000073'::uuid, 'PO-20250325-000073', 'b0000000-0000-0000-0000-000000000003'::uuid, 'e0000000-0000-0000-0000-000000000005'::uuid, 'approved', 5600.00, '2025-06-15', TRUE, 'Total amount exceeds $5,000 threshold', 'robert.williams@techmart-global.com', 'Approved: Sonos audio system for offices', '2025-03-25 14:00:00+00', '2025-03-29 14:00:00+00'),
('00010000-0000-0000-0000-000000000074'::uuid, 'PO-20250327-000074', 'b0000000-0000-0000-0000-000000000004'::uuid, 'e0000000-0000-0000-0000-000000000007'::uuid, 'approved', 6200.00, '2025-06-20', TRUE, 'Total amount exceeds $5,000 threshold', 'amanda.garcia@techmart-global.com', 'Approved: PS5 and VR headset bundle', '2025-03-27 15:30:00+00', '2025-03-31 15:30:00+00'),
('00010000-0000-0000-0000-000000000075'::uuid, 'PO-20250329-000075', 'b0000000-0000-0000-0000-000000000005'::uuid, 'e0000000-0000-0000-0000-000000000009'::uuid, 'approved', 8900.00, '2025-06-25', TRUE, 'Total amount exceeds $5,000 threshold', 'robert.williams@techmart-global.com', 'Approved: monitor upgrade for entire floor', '2025-03-29 09:00:00+00', '2025-04-02 09:00:00+00'),
-- 5 rejected
('00010000-0000-0000-0000-000000000076'::uuid, 'PO-20250331-000076', 'b0000000-0000-0000-0000-000000000006'::uuid, 'e0000000-0000-0000-0000-000000000003'::uuid, 'rejected', 35000.00, '2025-05-30', TRUE, 'Total amount exceeds $5,000 threshold', 'robert.williams@techmart-global.com', 'Rejected: budget not approved for Q3 TV procurement', '2025-03-31 10:00:00+00', '2025-04-04 10:00:00+00'),
('00010000-0000-0000-0000-000000000077'::uuid, 'PO-20250402-000077', 'b0000000-0000-0000-0000-000000000013'::uuid, 'e0000000-0000-0000-0000-000000000015'::uuid, 'rejected', 25000.00, '2025-06-15', TRUE, 'Total amount exceeds $5,000 threshold', 'andrew.white@electrahub.com', 'Rejected: preferred vendor required for this category', '2025-04-02 11:00:00+00', '2025-04-06 11:00:00+00'),
('00010000-0000-0000-0000-000000000078'::uuid, 'PO-20250404-000078', 'b0000000-0000-0000-0000-000000000023'::uuid, 'e0000000-0000-0000-0000-000000000023'::uuid, 'rejected', 18000.00, '2025-06-20', TRUE, 'Total amount exceeds $5,000 threshold', 'patrick.adams@primegadget.com', 'Rejected: vendor reliability score below threshold', '2025-04-04 14:00:00+00', '2025-04-08 14:00:00+00'),
('00010000-0000-0000-0000-000000000079'::uuid, 'PO-20250406-000079', 'b0000000-0000-0000-0000-000000000003'::uuid, 'e0000000-0000-0000-0000-000000000006'::uuid, 'rejected', 12000.00, '2025-07-01', TRUE, 'Total amount exceeds $5,000 threshold', 'amanda.garcia@techmart-global.com', 'Rejected: duplicate order - use PO-20250318-000039', '2025-04-06 09:00:00+00', '2025-04-10 09:00:00+00'),
('00010000-0000-0000-0000-000000000080'::uuid, 'PO-20250408-000080', 'b0000000-0000-0000-0000-000000000014'::uuid, 'e0000000-0000-0000-0000-000000000017'::uuid, 'rejected', 8500.00, '2025-07-05', TRUE, 'Total amount exceeds $5,000 threshold', 'stephanie.harris@electrahub.com', 'Rejected: wrong vendor selected, resubmit with Pinnacle', '2025-04-08 10:30:00+00', '2025-04-12 10:30:00+00'),
-- 5 cancelled
('00010000-0000-0000-0000-000000000081'::uuid, 'PO-20250410-000081', 'b0000000-0000-0000-0000-000000000005'::uuid, 'e0000000-0000-0000-0000-000000000005'::uuid, 'cancelled', 3200.00, '2025-05-15', FALSE, NULL, NULL, 'Cancelled: project scope changed', '2025-04-10 09:00:00+00', '2025-04-14 09:00:00+00'),
('00010000-0000-0000-0000-000000000082'::uuid, 'PO-20250412-000082', 'b0000000-0000-0000-0000-000000000015'::uuid, 'e0000000-0000-0000-0000-000000000012'::uuid, 'cancelled', 4500.00, '2025-05-20', FALSE, NULL, NULL, 'Cancelled: client withdrew request', '2025-04-12 10:00:00+00', '2025-04-16 10:00:00+00'),
('00010000-0000-0000-0000-000000000083'::uuid, 'PO-20250414-000083', 'b0000000-0000-0000-0000-000000000024'::uuid, 'e0000000-0000-0000-0000-000000000021'::uuid, 'cancelled', 2800.00, '2025-06-01', FALSE, NULL, NULL, 'Cancelled: found better pricing elsewhere', '2025-04-14 11:30:00+00', '2025-04-18 11:30:00+00'),
('00010000-0000-0000-0000-000000000084'::uuid, 'PO-20250416-000084', 'b0000000-0000-0000-0000-000000000006'::uuid, 'e0000000-0000-0000-0000-000000000008'::uuid, 'cancelled', 1500.00, '2025-06-10', FALSE, NULL, NULL, 'Cancelled: budget freeze', '2025-04-16 14:00:00+00', '2025-04-20 14:00:00+00'),
('00010000-0000-0000-0000-000000000085'::uuid, 'PO-20250418-000085', 'b0000000-0000-0000-0000-000000000025'::uuid, 'e0000000-0000-0000-0000-000000000024'::uuid, 'cancelled', 900.00, '2025-06-15', FALSE, NULL, NULL, 'Cancelled: product discontinued by vendor', '2025-04-18 15:00:00+00', '2025-04-22 15:00:00+00'),
-- 10 shipped
('00010000-0000-0000-0000-000000000086'::uuid, 'PO-20250301-000086', 'b0000000-0000-0000-0000-000000000003'::uuid, 'e0000000-0000-0000-0000-000000000001'::uuid, 'shipped', 4500.00, '2025-04-01', FALSE, NULL, NULL, 'Shipped: Galaxy S24 order in transit', '2025-03-01 09:00:00+00', '2025-04-10 09:00:00+00'),
('00010000-0000-0000-0000-000000000087'::uuid, 'PO-20250303-000087', 'b0000000-0000-0000-0000-000000000004'::uuid, 'e0000000-0000-0000-0000-000000000002'::uuid, 'shipped', 3400.00, '2025-04-05', FALSE, NULL, NULL, 'Shipped: laptop order via FedEx', '2025-03-03 10:00:00+00', '2025-04-12 10:00:00+00'),
('00010000-0000-0000-0000-000000000088'::uuid, 'PO-20250305-000088', 'b0000000-0000-0000-0000-000000000013'::uuid, 'e0000000-0000-0000-0000-000000000010'::uuid, 'shipped', 2800.00, '2025-04-10', FALSE, NULL, NULL, 'Shipped: smart home devices via UPS', '2025-03-05 11:00:00+00', '2025-04-14 11:00:00+00'),
('00010000-0000-0000-0000-000000000089'::uuid, 'PO-20250307-000089', 'b0000000-0000-0000-0000-000000000014'::uuid, 'e0000000-0000-0000-0000-000000000016'::uuid, 'shipped', 4700.00, '2025-04-15', FALSE, NULL, NULL, 'Shipped: tablet order partial delivery', '2025-03-07 14:00:00+00', '2025-04-16 14:00:00+00'),
('00010000-0000-0000-0000-000000000090'::uuid, 'PO-20250309-000090', 'b0000000-0000-0000-0000-000000000023'::uuid, 'e0000000-0000-0000-0000-000000000019'::uuid, 'shipped', 1900.00, '2025-04-20', FALSE, NULL, NULL, 'Shipped: gaming equipment via freight', '2025-03-09 09:30:00+00', '2025-04-18 09:30:00+00'),
('00010000-0000-0000-0000-000000000091'::uuid, 'PO-20250311-000091', 'b0000000-0000-0000-0000-000000000024'::uuid, 'e0000000-0000-0000-0000-000000000022'::uuid, 'shipped', 2600.00, '2025-04-25', FALSE, NULL, NULL, 'Shipped: laptop and tablet combo via DHL', '2025-03-11 10:00:00+00', '2025-04-20 10:00:00+00'),
('00010000-0000-0000-0000-000000000092'::uuid, 'PO-20250313-000092', 'b0000000-0000-0000-0000-000000000005'::uuid, 'e0000000-0000-0000-0000-000000000005'::uuid, 'shipped', 1200.00, '2025-05-01', FALSE, NULL, NULL, 'Shipped: audio equipment via USPS Priority', '2025-03-13 11:30:00+00', '2025-04-22 11:30:00+00'),
('00010000-0000-0000-0000-000000000093'::uuid, 'PO-20250315-000093', 'b0000000-0000-0000-0000-000000000006'::uuid, 'e0000000-0000-0000-0000-000000000007'::uuid, 'shipped', 3600.00, '2025-05-05', FALSE, NULL, NULL, 'Shipped: gaming consoles via FedEx Ground', '2025-03-15 13:00:00+00', '2025-04-24 13:00:00+00'),
('00010000-0000-0000-0000-000000000094'::uuid, 'PO-20250317-000094', 'b0000000-0000-0000-0000-000000000016'::uuid, 'e0000000-0000-0000-0000-000000000013'::uuid, 'shipped', 2100.00, '2025-05-10', FALSE, NULL, NULL, 'Shipped: wearables order via UPS Next Day', '2025-03-17 14:30:00+00', '2025-04-26 14:30:00+00'),
('00010000-0000-0000-0000-000000000095'::uuid, 'PO-20250319-000095', 'b0000000-0000-0000-0000-000000000026'::uuid, 'e0000000-0000-0000-0000-000000000025'::uuid, 'shipped', 3800.00, '2025-05-15', FALSE, NULL, NULL, 'Shipped: networking equipment via freight carrier', '2025-03-19 09:00:00+00', '2025-04-28 09:00:00+00'),
-- 5 completed
('00010000-0000-0000-0000-000000000096'::uuid, 'PO-20250201-000096', 'b0000000-0000-0000-0000-000000000003'::uuid, 'e0000000-0000-0000-0000-000000000001'::uuid, 'completed', 2700.00, '2025-03-01', FALSE, NULL, NULL, 'Completed: smartphone order delivered and verified', '2025-02-01 09:00:00+00', '2025-03-10 09:00:00+00'),
('00010000-0000-0000-0000-000000000097'::uuid, 'PO-20250203-000097', 'b0000000-0000-0000-0000-000000000013'::uuid, 'e0000000-0000-0000-0000-000000000010'::uuid, 'completed', 1500.00, '2025-03-05', FALSE, NULL, NULL, 'Completed: smart home devices received and inspected', '2025-02-03 10:00:00+00', '2025-03-12 10:00:00+00'),
('00010000-0000-0000-0000-000000000098'::uuid, 'PO-20250205-000098', 'b0000000-0000-0000-0000-000000000023'::uuid, 'e0000000-0000-0000-0000-000000000018'::uuid, 'completed', 4200.00, '2025-03-10', FALSE, NULL, NULL, 'Completed: laptop fleet deployed to users', '2025-02-05 11:00:00+00', '2025-03-15 11:00:00+00'),
('00010000-0000-0000-0000-000000000099'::uuid, 'PO-20250207-000099', 'b0000000-0000-0000-0000-000000000004'::uuid, 'e0000000-0000-0000-0000-000000000004'::uuid, 'completed', 900.00, '2025-03-15', FALSE, NULL, NULL, 'Completed: tablet accessories all accounted for', '2025-02-07 14:00:00+00', '2025-03-18 14:00:00+00'),
('00010000-0000-0000-0000-000000000100'::uuid, 'PO-20250209-000100', 'b0000000-0000-0000-0000-000000000025'::uuid, 'e0000000-0000-0000-0000-000000000020'::uuid, 'completed', 650.00, '2025-03-20', FALSE, NULL, NULL, 'Completed: networking equipment installed and tested', '2025-02-09 15:30:00+00', '2025-03-22 15:30:00+00');

-- =============================================================================
-- PO LINE ITEMS  (300 rows – 3 per PO on average)
-- Note: line_total is a generated column, do NOT insert it
-- =============================================================================

-- PO 1 (draft, vendor 1 = smartphones, total 450)
INSERT INTO po_line_items (id, po_id, vendor_product_id, quantity, unit_price) VALUES
('11000000-0000-0000-0000-000000000001'::uuid, '00010000-0000-0000-0000-000000000001'::uuid, 'f0000000-0000-0000-0000-000000000011'::uuid, 1, 329.99),
('11000000-0000-0000-0000-000000000002'::uuid, '00010000-0000-0000-0000-000000000001'::uuid, 'f0000000-0000-0000-0000-000000000018'::uuid, 1, 120.01);

-- PO 2 (draft, vendor 2 = laptops, total 1200)
INSERT INTO po_line_items (id, po_id, vendor_product_id, quantity, unit_price) VALUES
('11000000-0000-0000-0000-000000000003'::uuid, '00010000-0000-0000-0000-000000000002'::uuid, 'f0000000-0000-0000-0000-000000000032'::uuid, 1, 849.99),
('11000000-0000-0000-0000-000000000004'::uuid, '00010000-0000-0000-0000-000000000002'::uuid, 'f0000000-0000-0000-0000-000000000039'::uuid, 1, 350.01);

-- PO 3 (draft, vendor 3 = TVs, total 899.97)
INSERT INTO po_line_items (id, po_id, vendor_product_id, quantity, unit_price) VALUES
('11000000-0000-0000-0000-000000000005'::uuid, '00010000-0000-0000-0000-000000000003'::uuid, 'f0000000-0000-0000-0000-000000000049'::uuid, 3, 299.99);

-- PO 4 (draft, vendor 10 = smart home, total 350)
INSERT INTO po_line_items (id, po_id, vendor_product_id, quantity, unit_price) VALUES
('11000000-0000-0000-0000-000000000006'::uuid, '00010000-0000-0000-0000-000000000004'::uuid, 'f0000000-0000-0000-0000-000000000181'::uuid, 5, 70.00);

-- PO 5 (draft, vendor 11 = phones+laptops, total 2400)
INSERT INTO po_line_items (id, po_id, vendor_product_id, quantity, unit_price) VALUES
('11000000-0000-0000-0000-000000000007'::uuid, '00010000-0000-0000-0000-000000000005'::uuid, 'f0000000-0000-0000-0000-000000000201'::uuid, 2, 879.99),
('11000000-0000-0000-0000-000000000008'::uuid, '00010000-0000-0000-0000-000000000005'::uuid, 'f0000000-0000-0000-0000-000000000203'::uuid, 1, 640.02);

-- PO 6 (draft, vendor 18 = laptops+TVs, total 780)
INSERT INTO po_line_items (id, po_id, vendor_product_id, quantity, unit_price) VALUES
('11000000-0000-0000-0000-000000000009'::uuid, '00010000-0000-0000-0000-000000000006'::uuid, 'f0000000-0000-0000-0000-000000000349'::uuid, 1, 780.00);

-- PO 7 (draft, vendor 19 = gaming+peripherals, total 1650)
INSERT INTO po_line_items (id, po_id, vendor_product_id, quantity, unit_price) VALUES
('11000000-0000-0000-0000-000000000010'::uuid, '00010000-0000-0000-0000-000000000007'::uuid, 'f0000000-0000-0000-0000-000000000361'::uuid, 2, 439.99),
('11000000-0000-0000-0000-000000000011'::uuid, '00010000-0000-0000-0000-000000000007'::uuid, 'f0000000-0000-0000-0000-000000000373'::uuid, 5, 77.99),
('11000000-0000-0000-0000-000000000012'::uuid, '00010000-0000-0000-0000-000000000007'::uuid, 'f0000000-0000-0000-0000-000000000374'::uuid, 2, 174.99);

-- PO 8 (draft, vendor 4 = tablets, total 499.95)
INSERT INTO po_line_items (id, po_id, vendor_product_id, quantity, unit_price) VALUES
('11000000-0000-0000-0000-000000000013'::uuid, '00010000-0000-0000-0000-000000000008'::uuid, 'f0000000-0000-0000-0000-000000000072'::uuid, 2, 179.99),
('11000000-0000-0000-0000-000000000014'::uuid, '00010000-0000-0000-0000-000000000008'::uuid, 'f0000000-0000-0000-0000-000000000074'::uuid, 1, 79.99),
('11000000-0000-0000-0000-000000000300'::uuid, '00010000-0000-0000-0000-000000000008'::uuid, 'f0000000-0000-0000-0000-000000000079'::uuid, 1, 59.98);

-- PO 9 (draft, vendor 12 = TVs+audio, total 3200)
INSERT INTO po_line_items (id, po_id, vendor_product_id, quantity, unit_price) VALUES
('11000000-0000-0000-0000-000000000015'::uuid, '00010000-0000-0000-0000-000000000009'::uuid, 'f0000000-0000-0000-0000-000000000221'::uuid, 1, 1649.99),
('11000000-0000-0000-0000-000000000016'::uuid, '00010000-0000-0000-0000-000000000009'::uuid, 'f0000000-0000-0000-0000-000000000222'::uuid, 1, 929.99),
('11000000-0000-0000-0000-000000000017'::uuid, '00010000-0000-0000-0000-000000000009'::uuid, 'f0000000-0000-0000-0000-000000000225'::uuid, 1, 319.99),
('11000000-0000-0000-0000-000000000018'::uuid, '00010000-0000-0000-0000-000000000009'::uuid, 'f0000000-0000-0000-0000-000000000230'::uuid, 1, 300.03);

-- PO 10 (draft, vendor 20 = smart home+networking, total 150)
INSERT INTO po_line_items (id, po_id, vendor_product_id, quantity, unit_price) VALUES
('11000000-0000-0000-0000-000000000019'::uuid, '00010000-0000-0000-0000-000000000010'::uuid, 'f0000000-0000-0000-0000-000000000392'::uuid, 9, 15.99),
('11000000-0000-0000-0000-000000000020'::uuid, '00010000-0000-0000-0000-000000000010'::uuid, 'f0000000-0000-0000-0000-000000000399'::uuid, 1, 6.09);

-- PO 11-25 (pending, 3 items each = 45 rows)
INSERT INTO po_line_items (id, po_id, vendor_product_id, quantity, unit_price) VALUES
('11000000-0000-0000-0000-000000000021'::uuid, '00010000-0000-0000-0000-000000000011'::uuid, 'f0000000-0000-0000-0000-000000000001'::uuid, 3, 900.00),
('11000000-0000-0000-0000-000000000022'::uuid, '00010000-0000-0000-0000-000000000012'::uuid, 'f0000000-0000-0000-0000-000000000021'::uuid, 2, 1449.99),
('11000000-0000-0000-0000-000000000023'::uuid, '00010000-0000-0000-0000-000000000012'::uuid, 'f0000000-0000-0000-0000-000000000022'::uuid, 1, 1099.99),
('11000000-0000-0000-0000-000000000024'::uuid, '00010000-0000-0000-0000-000000000012'::uuid, 'f0000000-0000-0000-0000-000000000032'::uuid, 1, 500.03),
('11000000-0000-0000-0000-000000000025'::uuid, '00010000-0000-0000-0000-000000000013'::uuid, 'f0000000-0000-0000-0000-000000000081'::uuid, 3, 279.99),
('11000000-0000-0000-0000-000000000026'::uuid, '00010000-0000-0000-0000-000000000013'::uuid, 'f0000000-0000-0000-0000-000000000088'::uuid, 5, 99.99),
('11000000-0000-0000-0000-000000000027'::uuid, '00010000-0000-0000-0000-000000000013'::uuid, 'f0000000-0000-0000-0000-000000000090'::uuid, 1, 380.04),
('11000000-0000-0000-0000-000000000028'::uuid, '00010000-0000-0000-0000-000000000014'::uuid, 'f0000000-0000-0000-0000-000000000101'::uuid, 5, 700.00),
('11000000-0000-0000-0000-000000000029'::uuid, '00010000-0000-0000-0000-000000000015'::uuid, 'f0000000-0000-0000-0000-000000000181'::uuid, 5, 69.99),
('11000000-0000-0000-0000-000000000030'::uuid, '00010000-0000-0000-0000-000000000015'::uuid, 'f0000000-0000-0000-0000-000000000184'::uuid, 5, 79.99),
('11000000-0000-0000-0000-000000000031'::uuid, '00010000-0000-0000-0000-000000000015'::uuid, 'f0000000-0000-0000-0000-000000000187'::uuid, 1, 160.10),
('11000000-0000-0000-0000-000000000032'::uuid, '00010000-0000-0000-0000-000000000016'::uuid, 'f0000000-0000-0000-0000-000000000202'::uuid, 5, 929.99),
('11000000-0000-0000-0000-000000000033'::uuid, '00010000-0000-0000-0000-000000000016'::uuid, 'f0000000-0000-0000-0000-000000000214'::uuid, 1, 150.05),
('11000000-0000-0000-0000-000000000034'::uuid, '00010000-0000-0000-0000-000000000017'::uuid, 'f0000000-0000-0000-0000-000000000221'::uuid, 1, 1649.99),
('11000000-0000-0000-0000-000000000035'::uuid, '00010000-0000-0000-0000-000000000017'::uuid, 'f0000000-0000-0000-0000-000000000227'::uuid, 1, 399.99),
('11000000-0000-0000-0000-000000000036'::uuid, '00010000-0000-0000-0000-000000000017'::uuid, 'f0000000-0000-0000-0000-000000000233'::uuid, 1, 150.02),
('11000000-0000-0000-0000-000000000037'::uuid, '00010000-0000-0000-0000-000000000018'::uuid, 'f0000000-0000-0000-0000-000000000241'::uuid, 1, 879.99),
('11000000-0000-0000-0000-000000000038'::uuid, '00010000-0000-0000-0000-000000000018'::uuid, 'f0000000-0000-0000-0000-000000000250'::uuid, 2, 339.99),
('11000000-0000-0000-0000-000000000039'::uuid, '00010000-0000-0000-0000-000000000018'::uuid, 'f0000000-0000-0000-0000-000000000258'::uuid, 1, 40.03),
('11000000-0000-0000-0000-000000000040'::uuid, '00010000-0000-0000-0000-000000000019'::uuid, 'f0000000-0000-0000-0000-000000000361'::uuid, 3, 439.99),
('11000000-0000-0000-0000-000000000041'::uuid, '00010000-0000-0000-0000-000000000019'::uuid, 'f0000000-0000-0000-0000-000000000364'::uuid, 5, 289.99),
('11000000-0000-0000-0000-000000000042'::uuid, '00010000-0000-0000-0000-000000000019'::uuid, 'f0000000-0000-0000-0000-000000000369'::uuid, 1, 130.06),
('11000000-0000-0000-0000-000000000043'::uuid, '00010000-0000-0000-0000-000000000020'::uuid, 'f0000000-0000-0000-0000-000000000421'::uuid, 2, 1079.99),
('11000000-0000-0000-0000-000000000044'::uuid, '00010000-0000-0000-0000-000000000020'::uuid, 'f0000000-0000-0000-0000-000000000430'::uuid, 1, 884.99),
('11000000-0000-0000-0000-000000000045'::uuid, '00010000-0000-0000-0000-000000000020'::uuid, 'f0000000-0000-0000-0000-000000000431'::uuid, 2, 544.99),
('11000000-0000-0000-0000-000000000046'::uuid, '00010000-0000-0000-0000-000000000020'::uuid, 'f0000000-0000-0000-0000-000000000436'::uuid, 1, 65.05),
('11000000-0000-0000-0000-000000000047'::uuid, '00010000-0000-0000-0000-000000000021'::uuid, 'f0000000-0000-0000-0000-000000000395'::uuid, 2, 234.99),
('11000000-0000-0000-0000-000000000048'::uuid, '00010000-0000-0000-0000-000000000021'::uuid, 'f0000000-0000-0000-0000-000000000399'::uuid, 1, 72.99),
('11000000-0000-0000-0000-000000000049'::uuid, '00010000-0000-0000-0000-000000000021'::uuid, 'f0000000-0000-0000-0000-000000000381'::uuid, 1, 57.03),
('11000000-0000-0000-0000-000000000050'::uuid, '00010000-0000-0000-0000-000000000022'::uuid, 'f0000000-0000-0000-0000-000000000481'::uuid, 10, 67.99),
('11000000-0000-0000-0000-000000000051'::uuid, '00010000-0000-0000-0000-000000000022'::uuid, 'f0000000-0000-0000-0000-000000000484'::uuid, 4, 154.99),
('11000000-0000-0000-0000-000000000052'::uuid, '00010000-0000-0000-0000-000000000023'::uuid, 'f0000000-0000-0000-0000-000000000121'::uuid, 3, 449.99),
('11000000-0000-0000-0000-000000000053'::uuid, '00010000-0000-0000-0000-000000000023'::uuid, 'f0000000-0000-0000-0000-000000000134'::uuid, 5, 179.99),
('11000000-0000-0000-0000-000000000054'::uuid, '00010000-0000-0000-0000-000000000023'::uuid, 'f0000000-0000-0000-0000-000000000136'::uuid, 5, 59.99),
('11000000-0000-0000-0000-000000000055'::uuid, '00010000-0000-0000-0000-000000000024'::uuid, 'f0000000-0000-0000-0000-000000000141'::uuid, 5, 229.99),
('11000000-0000-0000-0000-000000000056'::uuid, '00010000-0000-0000-0000-000000000024'::uuid, 'f0000000-0000-0000-0000-000000000145'::uuid, 3, 379.99),
('11000000-0000-0000-0000-000000000057'::uuid, '00010000-0000-0000-0000-000000000024'::uuid, 'f0000000-0000-0000-0000-000000000151'::uuid, 1, 999.99),
('11000000-0000-0000-0000-000000000058'::uuid, '00010000-0000-0000-0000-000000000024'::uuid, 'f0000000-0000-0000-0000-000000000153'::uuid, 2, 249.99),
('11000000-0000-0000-0000-000000000059'::uuid, '00010000-0000-0000-0000-000000000025'::uuid, 'f0000000-0000-0000-0000-000000000161'::uuid, 3, 399.99),
('11000000-0000-0000-0000-000000000060'::uuid, '00010000-0000-0000-0000-000000000025'::uuid, 'f0000000-0000-0000-0000-000000000165'::uuid, 5, 79.99),
('11000000-0000-0000-0000-000000000061'::uuid, '00010000-0000-0000-0000-000000000025'::uuid, 'f0000000-0000-0000-0000-000000000170'::uuid, 5, 69.99);

-- PO 26-50 (confirmed, 3 items each = 75 rows)
INSERT INTO po_line_items (id, po_id, vendor_product_id, quantity, unit_price) VALUES
('11000000-0000-0000-0000-000000000062'::uuid, '00010000-0000-0000-0000-000000000026'::uuid, 'f0000000-0000-0000-0000-000000000001'::uuid, 5, 900.00),
('11000000-0000-0000-0000-000000000063'::uuid, '00010000-0000-0000-0000-000000000027'::uuid, 'f0000000-0000-0000-0000-000000000021'::uuid, 2, 1449.99),
('11000000-0000-0000-0000-000000000064'::uuid, '00010000-0000-0000-0000-000000000027'::uuid, 'f0000000-0000-0000-0000-000000000032'::uuid, 1, 300.02),
('11000000-0000-0000-0000-000000000065'::uuid, '00010000-0000-0000-0000-000000000028'::uuid, 'f0000000-0000-0000-0000-000000000041'::uuid, 1, 1599.99),
('11000000-0000-0000-0000-000000000066'::uuid, '00010000-0000-0000-0000-000000000028'::uuid, 'f0000000-0000-0000-0000-000000000049'::uuid, 2, 299.99),
('11000000-0000-0000-0000-000000000067'::uuid, '00010000-0000-0000-0000-000000000028'::uuid, 'f0000000-0000-0000-0000-000000000059'::uuid, 1, 200.03),
('11000000-0000-0000-0000-000000000068'::uuid, '00010000-0000-0000-0000-000000000029'::uuid, 'f0000000-0000-0000-0000-000000000061'::uuid, 2, 899.99),
('11000000-0000-0000-0000-000000000069'::uuid, '00010000-0000-0000-0000-000000000029'::uuid, 'f0000000-0000-0000-0000-000000000072'::uuid, 1, 0.02),
('11000000-0000-0000-0000-000000000070'::uuid, '00010000-0000-0000-0000-000000000030'::uuid, 'f0000000-0000-0000-0000-000000000081'::uuid, 2, 279.99),
('11000000-0000-0000-0000-000000000071'::uuid, '00010000-0000-0000-0000-000000000030'::uuid, 'f0000000-0000-0000-0000-000000000088'::uuid, 2, 99.99),
('11000000-0000-0000-0000-000000000072'::uuid, '00010000-0000-0000-0000-000000000030'::uuid, 'f0000000-0000-0000-0000-000000000096'::uuid, 1, 90.04),
('11000000-0000-0000-0000-000000000073'::uuid, '00010000-0000-0000-0000-000000000031'::uuid, 'f0000000-0000-0000-0000-000000000181'::uuid, 10, 69.99),
('11000000-0000-0000-0000-000000000074'::uuid, '00010000-0000-0000-0000-000000000031'::uuid, 'f0000000-0000-0000-0000-000000000184'::uuid, 5, 79.99),
('11000000-0000-0000-0000-000000000075'::uuid, '00010000-0000-0000-0000-000000000031'::uuid, 'f0000000-0000-0000-0000-000000000190'::uuid, 1, 100.15),
('11000000-0000-0000-0000-000000000076'::uuid, '00010000-0000-0000-0000-000000000032'::uuid, 'f0000000-0000-0000-0000-000000000201'::uuid, 3, 879.99),
('11000000-0000-0000-0000-000000000077'::uuid, '00010000-0000-0000-0000-000000000032'::uuid, 'f0000000-0000-0000-0000-000000000214'::uuid, 1, 0.03),
('11000000-0000-0000-0000-000000000078'::uuid, '00010000-0000-0000-0000-000000000033'::uuid, 'f0000000-0000-0000-0000-000000000261'::uuid, 3, 439.99),
('11000000-0000-0000-0000-000000000079'::uuid, '00010000-0000-0000-0000-000000000033'::uuid, 'f0000000-0000-0000-0000-000000000271'::uuid, 5, 219.99),
('11000000-0000-0000-0000-000000000080'::uuid, '00010000-0000-0000-0000-000000000033'::uuid, 'f0000000-0000-0000-0000-000000000279'::uuid, 1, 80.06),
('11000000-0000-0000-0000-000000000081'::uuid, '00010000-0000-0000-0000-000000000034'::uuid, 'f0000000-0000-0000-0000-000000000301'::uuid, 3, 889.99),
('11000000-0000-0000-0000-000000000082'::uuid, '00010000-0000-0000-0000-000000000034'::uuid, 'f0000000-0000-0000-0000-000000000309'::uuid, 1, 889.99),
('11000000-0000-0000-0000-000000000083'::uuid, '00010000-0000-0000-0000-000000000034'::uuid, 'f0000000-0000-0000-0000-000000000311'::uuid, 2, 369.99),
('11000000-0000-0000-0000-000000000084'::uuid, '00010000-0000-0000-0000-000000000035'::uuid, 'f0000000-0000-0000-0000-000000000341'::uuid, 2, 1419.99),
('11000000-0000-0000-0000-000000000085'::uuid, '00010000-0000-0000-0000-000000000035'::uuid, 'f0000000-0000-0000-0000-000000000349'::uuid, 1, 60.02),
('11000000-0000-0000-0000-000000000086'::uuid, '00010000-0000-0000-0000-000000000036'::uuid, 'f0000000-0000-0000-0000-000000000371'::uuid, 2, 389.99),
('11000000-0000-0000-0000-000000000087'::uuid, '00010000-0000-0000-0000-000000000036'::uuid, 'f0000000-0000-0000-0000-000000000374'::uuid, 3, 174.99),
('11000000-0000-0000-0000-000000000088'::uuid, '00010000-0000-0000-0000-000000000036'::uuid, 'f0000000-0000-0000-0000-000000000379'::uuid, 5, 27.99),
('11000000-0000-0000-0000-000000000089'::uuid, '00010000-0000-0000-0000-000000000037'::uuid, 'f0000000-0000-0000-0000-000000000381'::uuid, 5, 72.99),
('11000000-0000-0000-0000-000000000090'::uuid, '00010000-0000-0000-0000-000000000037'::uuid, 'f0000000-0000-0000-0000-000000000384'::uuid, 5, 42.99),
('11000000-0000-0000-0000-000000000091'::uuid, '00010000-0000-0000-0000-000000000037'::uuid, 'f0000000-0000-0000-0000-000000000392'::uuid, 10, 15.99),
('11000000-0000-0000-0000-000000000092'::uuid, '00010000-0000-0000-0000-000000000038'::uuid, 'f0000000-0000-0000-0000-000000000408'::uuid, 5, 284.99),
('11000000-0000-0000-0000-000000000093'::uuid, '00010000-0000-0000-0000-000000000038'::uuid, 'f0000000-0000-0000-0000-000000000412'::uuid, 5, 144.99),
('11000000-0000-0000-0000-000000000094'::uuid, '00010000-0000-0000-0000-000000000039'::uuid, 'f0000000-0000-0000-0000-000000000101'::uuid, 5, 700.00),
('11000000-0000-0000-0000-000000000095'::uuid, '00010000-0000-0000-0000-000000000039'::uuid, 'f0000000-0000-0000-0000-000000000110'::uuid, 1, 100.00),
('11000000-0000-0000-0000-000000000096'::uuid, '00010000-0000-0000-0000-000000000039'::uuid, 'f0000000-0000-0000-0000-000000000117'::uuid, 1, 0.00),
('11000000-0000-0000-0000-000000000097'::uuid, '00010000-0000-0000-0000-000000000040'::uuid, 'f0000000-0000-0000-0000-000000000141'::uuid, 10, 229.99),
('11000000-0000-0000-0000-000000000098'::uuid, '00010000-0000-0000-0000-000000000040'::uuid, 'f0000000-0000-0000-0000-000000000145'::uuid, 5, 379.99),
('11000000-0000-0000-0000-000000000099'::uuid, '00010000-0000-0000-0000-000000000040'::uuid, 'f0000000-0000-0000-0000-000000000153'::uuid, 2, 249.99),
('11000000-0000-0000-0000-000000000100'::uuid, '00010000-0000-0000-0000-000000000041'::uuid, 'f0000000-0000-0000-0000-000000000161'::uuid, 3, 399.99),
('11000000-0000-0000-0000-000000000101'::uuid, '00010000-0000-0000-0000-000000000041'::uuid, 'f0000000-0000-0000-0000-000000000166'::uuid, 5, 89.99),
('11000000-0000-0000-0000-000000000102'::uuid, '00010000-0000-0000-0000-000000000041'::uuid, 'f0000000-0000-0000-0000-000000000170'::uuid, 5, 69.99),
('11000000-0000-0000-0000-000000000103'::uuid, '00010000-0000-0000-0000-000000000042'::uuid, 'f0000000-0000-0000-0000-000000000241'::uuid, 2, 879.99),
('11000000-0000-0000-0000-000000000104'::uuid, '00010000-0000-0000-0000-000000000042'::uuid, 'f0000000-0000-0000-0000-000000000250'::uuid, 2, 339.99),
('11000000-0000-0000-0000-000000000105'::uuid, '00010000-0000-0000-0000-000000000042'::uuid, 'f0000000-0000-0000-0000-000000000256'::uuid, 3, 84.99),
('11000000-0000-0000-0000-000000000106'::uuid, '00010000-0000-0000-0000-000000000043'::uuid, 'f0000000-0000-0000-0000-000000000316'::uuid, 5, 114.99),
('11000000-0000-0000-0000-000000000107'::uuid, '00010000-0000-0000-0000-000000000043'::uuid, 'f0000000-0000-0000-0000-000000000320'::uuid, 2, 239.99),
('11000000-0000-0000-0000-000000000108'::uuid, '00010000-0000-0000-0000-000000000044'::uuid, 'f0000000-0000-0000-0000-000000000283'::uuid, 5, 84.99),
('11000000-0000-0000-0000-000000000109'::uuid, '00010000-0000-0000-0000-000000000044'::uuid, 'f0000000-0000-0000-0000-000000000286'::uuid, 5, 74.99),
('11000000-0000-0000-0000-000000000110'::uuid, '00010000-0000-0000-0000-000000000045'::uuid, 'f0000000-0000-0000-0000-000000000422'::uuid, 3, 1069.99),
('11000000-0000-0000-0000-000000000111'::uuid, '00010000-0000-0000-0000-000000000045'::uuid, 'f0000000-0000-0000-0000-000000000431'::uuid, 1, 390.03),
('11000000-0000-0000-0000-000000000112'::uuid, '00010000-0000-0000-0000-000000000046'::uuid, 'f0000000-0000-0000-0000-000000000442'::uuid, 1, 1329.99),
('11000000-0000-0000-0000-000000000113'::uuid, '00010000-0000-0000-0000-000000000046'::uuid, 'f0000000-0000-0000-0000-000000000445'::uuid, 2, 309.99),
('11000000-0000-0000-0000-000000000114'::uuid, '00010000-0000-0000-0000-000000000046'::uuid, 'f0000000-0000-0000-0000-000000000448'::uuid, 1, 250.03),
('11000000-0000-0000-0000-000000000115'::uuid, '00010000-0000-0000-0000-000000000047'::uuid, 'f0000000-0000-0000-0000-000000000461'::uuid, 3, 344.99),
('11000000-0000-0000-0000-000000000116'::uuid, '00010000-0000-0000-0000-000000000047'::uuid, 'f0000000-0000-0000-0000-000000000465'::uuid, 3, 224.99),
('11000000-0000-0000-0000-000000000117'::uuid, '00010000-0000-0000-0000-000000000048'::uuid, 'f0000000-0000-0000-0000-000000000494'::uuid, 2, 274.99),
('11000000-0000-0000-0000-000000000118'::uuid, '00010000-0000-0000-0000-000000000048'::uuid, 'f0000000-0000-0000-0000-000000000495'::uuid, 1, 289.99),
('11000000-0000-0000-0000-000000000119'::uuid, '00010000-0000-0000-0000-000000000048'::uuid, 'f0000000-0000-0000-0000-000000000498'::uuid, 1, 60.03),
('11000000-0000-0000-0000-000000000120'::uuid, '00010000-0000-0000-0000-000000000049'::uuid, 'f0000000-0000-0000-0000-000000000121'::uuid, 5, 449.99),
('11000000-0000-0000-0000-000000000121'::uuid, '00010000-0000-0000-0000-000000000049'::uuid, 'f0000000-0000-0000-0000-000000000123'::uuid, 5, 449.99),
('11000000-0000-0000-0000-000000000122'::uuid, '00010000-0000-0000-0000-000000000049'::uuid, 'f0000000-0000-0000-0000-000000000132'::uuid, 1, 400.12),
('11000000-0000-0000-0000-000000000123'::uuid, '00010000-0000-0000-0000-000000000050'::uuid, 'f0000000-0000-0000-0000-000000000072'::uuid, 1, 50.00);

-- PO 51-60 (flagged_for_review, 2-3 items each)
INSERT INTO po_line_items (id, po_id, vendor_product_id, quantity, unit_price) VALUES
('11000000-0000-0000-0000-000000000124'::uuid, '00010000-0000-0000-0000-000000000051'::uuid, 'f0000000-0000-0000-0000-000000000001'::uuid, 10, 899.99),
('11000000-0000-0000-0000-000000000125'::uuid, '00010000-0000-0000-0000-000000000052'::uuid, 'f0000000-0000-0000-0000-000000000021'::uuid, 5, 1449.99),
('11000000-0000-0000-0000-000000000126'::uuid, '00010000-0000-0000-0000-000000000052'::uuid, 'f0000000-0000-0000-0000-000000000032'::uuid, 5, 1449.99),
('11000000-0000-0000-0000-000000000127'::uuid, '00010000-0000-0000-0000-000000000053'::uuid, 'f0000000-0000-0000-0000-000000000181'::uuid, 20, 299.99),
('11000000-0000-0000-0000-000000000128'::uuid, '00010000-0000-0000-0000-000000000053'::uuid, 'f0000000-0000-0000-0000-000000000190'::uuid, 20, 299.99),
('11000000-0000-0000-0000-000000000129'::uuid, '00010000-0000-0000-0000-000000000054'::uuid, 'f0000000-0000-0000-0000-000000000301'::uuid, 20, 1099.99),
('11000000-0000-0000-0000-000000000130'::uuid, '00010000-0000-0000-0000-000000000055'::uuid, 'f0000000-0000-0000-0000-000000000341'::uuid, 10, 2749.99),
('11000000-0000-0000-0000-000000000131'::uuid, '00010000-0000-0000-0000-000000000056'::uuid, 'f0000000-0000-0000-0000-000000000422'::uuid, 5, 1499.99),
('11000000-0000-0000-0000-000000000132'::uuid, '00010000-0000-0000-0000-000000000056'::uuid, 'f0000000-0000-0000-0000-000000000431'::uuid, 5, 1499.99),
('11000000-0000-0000-0000-000000000133'::uuid, '00010000-0000-0000-0000-000000000057'::uuid, 'f0000000-0000-0000-0000-000000000061'::uuid, 10, 979.99),
('11000000-0000-0000-0000-000000000134'::uuid, '00010000-0000-0000-0000-000000000058'::uuid, 'f0000000-0000-0000-0000-000000000261'::uuid, 10, 499.99),
('11000000-0000-0000-0000-000000000135'::uuid, '00010000-0000-0000-0000-000000000058'::uuid, 'f0000000-0000-0000-0000-000000000271'::uuid, 10, 249.99),
('11000000-0000-0000-0000-000000000136'::uuid, '00010000-0000-0000-0000-000000000059'::uuid, 'f0000000-0000-0000-0000-000000000461'::uuid, 10, 279.99),
('11000000-0000-0000-0000-000000000137'::uuid, '00010000-0000-0000-0000-000000000059'::uuid, 'f0000000-0000-0000-0000-000000000465'::uuid, 10, 239.99),
('11000000-0000-0000-0000-000000000138'::uuid, '00010000-0000-0000-0000-000000000060'::uuid, 'f0000000-0000-0000-0000-000000000141'::uuid, 20, 899.99);

-- PO 61-75 (approved, 2-3 items each)
INSERT INTO po_line_items (id, po_id, vendor_product_id, quantity, unit_price) VALUES
('11000000-0000-0000-0000-000000000139'::uuid, '00010000-0000-0000-0000-000000000061'::uuid, 'f0000000-0000-0000-0000-000000000001'::uuid, 10, 849.99),
('11000000-0000-0000-0000-000000000140'::uuid, '00010000-0000-0000-0000-000000000062'::uuid, 'f0000000-0000-0000-0000-000000000021'::uuid, 5, 1699.99),
('11000000-0000-0000-0000-000000000141'::uuid, '00010000-0000-0000-0000-000000000062'::uuid, 'f0000000-0000-0000-0000-000000000032'::uuid, 5, 1699.99),
('11000000-0000-0000-0000-000000000142'::uuid, '00010000-0000-0000-0000-000000000063'::uuid, 'f0000000-0000-0000-0000-000000000041'::uuid, 3, 2399.99),
('11000000-0000-0000-0000-000000000143'::uuid, '00010000-0000-0000-0000-000000000064'::uuid, 'f0000000-0000-0000-0000-000000000061'::uuid, 10, 1099.99),
('11000000-0000-0000-0000-000000000144'::uuid, '00010000-0000-0000-0000-000000000065'::uuid, 'f0000000-0000-0000-0000-000000000201'::uuid, 10, 919.99),
('11000000-0000-0000-0000-000000000145'::uuid, '00010000-0000-0000-0000-000000000066'::uuid, 'f0000000-0000-0000-0000-000000000221'::uuid, 5, 1359.99),
('11000000-0000-0000-0000-000000000146'::uuid, '00010000-0000-0000-0000-000000000067'::uuid, 'f0000000-0000-0000-0000-000000000241'::uuid, 10, 849.99),
('11000000-0000-0000-0000-000000000147'::uuid, '00010000-0000-0000-0000-000000000067'::uuid, 'f0000000-0000-0000-0000-000000000250'::uuid, 10, 399.99),
('11000000-0000-0000-0000-000000000148'::uuid, '00010000-0000-0000-0000-000000000068'::uuid, 'f0000000-0000-0000-0000-000000000301'::uuid, 20, 939.99),
('11000000-0000-0000-0000-000000000149'::uuid, '00010000-0000-0000-0000-000000000069'::uuid, 'f0000000-0000-0000-0000-000000000341'::uuid, 10, 2799.99),
('11000000-0000-0000-0000-000000000150'::uuid, '00010000-0000-0000-0000-000000000070'::uuid, 'f0000000-0000-0000-0000-000000000361'::uuid, 10, 549.99),
('11000000-0000-0000-0000-000000000151'::uuid, '00010000-0000-0000-0000-000000000071'::uuid, 'f0000000-0000-0000-0000-000000000381'::uuid, 20, 199.99),
('11000000-0000-0000-0000-000000000152'::uuid, '00010000-0000-0000-0000-000000000071'::uuid, 'f0000000-0000-0000-0000-000000000392'::uuid, 20, 189.99),
('11000000-0000-0000-0000-000000000153'::uuid, '00010000-0000-0000-0000-000000000072'::uuid, 'f0000000-0000-0000-0000-000000000461'::uuid, 50, 499.99),
('11000000-0000-0000-0000-000000000154'::uuid, '00010000-0000-0000-0000-000000000072'::uuid, 'f0000000-0000-0000-0000-000000000465'::uuid, 50, 499.99),
('11000000-0000-0000-0000-000000000155'::uuid, '00010000-0000-0000-0000-000000000073'::uuid, 'f0000000-0000-0000-0000-000000000081'::uuid, 10, 279.99),
('11000000-0000-0000-0000-000000000156'::uuid, '00010000-0000-0000-0000-000000000073'::uuid, 'f0000000-0000-0000-0000-000000000088'::uuid, 10, 279.99),
('11000000-0000-0000-0000-000000000157'::uuid, '00010000-0000-0000-0000-000000000074'::uuid, 'f0000000-0000-0000-0000-000000000121'::uuid, 10, 619.99),
('11000000-0000-0000-0000-000000000158'::uuid, '00010000-0000-0000-0000-000000000075'::uuid, 'f0000000-0000-0000-0000-000000000161'::uuid, 10, 449.99),
('11000000-0000-0000-0000-000000000159'::uuid, '00010000-0000-0000-0000-000000000075'::uuid, 'f0000000-0000-0000-0000-000000000166'::uuid, 20, 219.99);

-- PO 76-80 (rejected, 2 items each)
INSERT INTO po_line_items (id, po_id, vendor_product_id, quantity, unit_price) VALUES
('11000000-0000-0000-0000-000000000160'::uuid, '00010000-0000-0000-0000-000000000076'::uuid, 'f0000000-0000-0000-0000-000000000041'::uuid, 10, 1749.99),
('11000000-0000-0000-0000-000000000161'::uuid, '00010000-0000-0000-0000-000000000076'::uuid, 'f0000000-0000-0000-0000-000000000049'::uuid, 10, 1749.99),
('11000000-0000-0000-0000-000000000162'::uuid, '00010000-0000-0000-0000-000000000077'::uuid, 'f0000000-0000-0000-0000-000000000281'::uuid, 25, 499.99),
('11000000-0000-0000-0000-000000000163'::uuid, '00010000-0000-0000-0000-000000000077'::uuid, 'f0000000-0000-0000-0000-000000000286'::uuid, 25, 499.99),
('11000000-0000-0000-0000-000000000164'::uuid, '00010000-0000-0000-0000-000000000078'::uuid, 'f0000000-0000-0000-0000-000000000422'::uuid, 5, 1799.99),
('11000000-0000-0000-0000-000000000165'::uuid, '00010000-0000-0000-0000-000000000078'::uuid, 'f0000000-0000-0000-0000-000000000431'::uuid, 5, 1799.99),
('11000000-0000-0000-0000-000000000166'::uuid, '00010000-0000-0000-0000-000000000079'::uuid, 'f0000000-0000-0000-0000-000000000101'::uuid, 10, 599.99),
('11000000-0000-0000-0000-000000000167'::uuid, '00010000-0000-0000-0000-000000000079'::uuid, 'f0000000-0000-0000-0000-000000000110'::uuid, 10, 599.99),
('11000000-0000-0000-0000-000000000168'::uuid, '00010000-0000-0000-0000-000000000080'::uuid, 'f0000000-0000-0000-0000-000000000316'::uuid, 10, 424.99),
('11000000-0000-0000-0000-000000000169'::uuid, '00010000-0000-0000-0000-000000000080'::uuid, 'f0000000-0000-0000-0000-000000000320'::uuid, 10, 424.99);

-- PO 81-85 (cancelled, 2 items each)
INSERT INTO po_line_items (id, po_id, vendor_product_id, quantity, unit_price) VALUES
('11000000-0000-0000-0000-000000000170'::uuid, '00010000-0000-0000-0000-000000000081'::uuid, 'f0000000-0000-0000-0000-000000000081'::uuid, 5, 319.99),
('11000000-0000-0000-0000-000000000171'::uuid, '00010000-0000-0000-0000-000000000081'::uuid, 'f0000000-0000-0000-0000-000000000088'::uuid, 5, 319.99),
('11000000-0000-0000-0000-000000000172'::uuid, '00010000-0000-0000-0000-000000000082'::uuid, 'f0000000-0000-0000-0000-000000000221'::uuid, 5, 449.99),
('11000000-0000-0000-0000-000000000173'::uuid, '00010000-0000-0000-0000-000000000082'::uuid, 'f0000000-0000-0000-0000-000000000214'::uuid, 5, 449.99),
('11000000-0000-0000-0000-000000000174'::uuid, '00010000-0000-0000-0000-000000000083'::uuid, 'f0000000-0000-0000-0000-000000000401'::uuid, 5, 279.99),
('11000000-0000-0000-0000-000000000175'::uuid, '00010000-0000-0000-0000-000000000083'::uuid, 'f0000000-0000-0000-0000-000000000408'::uuid, 5, 279.99),
('11000000-0000-0000-0000-000000000176'::uuid, '00010000-0000-0000-0000-000000000084'::uuid, 'f0000000-0000-0000-0000-000000000141'::uuid, 3, 249.99),
('11000000-0000-0000-0000-000000000177'::uuid, '00010000-0000-0000-0000-000000000084'::uuid, 'f0000000-0000-0000-0000-000000000145'::uuid, 3, 249.99),
('11000000-0000-0000-0000-000000000178'::uuid, '00010000-0000-0000-0000-000000000085'::uuid, 'f0000000-0000-0000-0000-000000000442'::uuid, 2, 224.99),
('11000000-0000-0000-0000-000000000179'::uuid, '00010000-0000-0000-0000-000000000085'::uuid, 'f0000000-0000-0000-0000-000000000448'::uuid, 2, 224.99);

-- PO 86-95 (shipped, 3 items each)
INSERT INTO po_line_items (id, po_id, vendor_product_id, quantity, unit_price) VALUES
('11000000-0000-0000-0000-000000000180'::uuid, '00010000-0000-0000-0000-000000000086'::uuid, 'f0000000-0000-0000-0000-000000000001'::uuid, 5, 899.99),
('11000000-0000-0000-0000-000000000181'::uuid, '00010000-0000-0000-0000-000000000086'::uuid, 'f0000000-0000-0000-0000-000000000011'::uuid, 1, 0.01),
('11000000-0000-0000-0000-000000000182'::uuid, '00010000-0000-0000-0000-000000000087'::uuid, 'f0000000-0000-0000-0000-000000000021'::uuid, 2, 1699.99),
('11000000-0000-0000-0000-000000000183'::uuid, '00010000-0000-0000-0000-000000000088'::uuid, 'f0000000-0000-0000-0000-000000000181'::uuid, 5, 279.99),
('11000000-0000-0000-0000-000000000184'::uuid, '00010000-0000-0000-0000-000000000088'::uuid, 'f0000000-0000-0000-0000-000000000190'::uuid, 5, 279.99),
('11000000-0000-0000-0000-000000000185'::uuid, '00010000-0000-0000-0000-000000000089'::uuid, 'f0000000-0000-0000-0000-000000000301'::uuid, 5, 939.99),
('11000000-0000-0000-0000-000000000186'::uuid, '00010000-0000-0000-0000-000000000090'::uuid, 'f0000000-0000-0000-0000-000000000361'::uuid, 3, 499.99),
('11000000-0000-0000-0000-000000000187'::uuid, '00010000-0000-0000-0000-000000000090'::uuid, 'f0000000-0000-0000-0000-000000000371'::uuid, 1, 399.99),
('11000000-0000-0000-0000-000000000188'::uuid, '00010000-0000-0000-0000-000000000091'::uuid, 'f0000000-0000-0000-0000-000000000408'::uuid, 3, 434.99),
('11000000-0000-0000-0000-000000000189'::uuid, '00010000-0000-0000-0000-000000000091'::uuid, 'f0000000-0000-0000-0000-000000000412'::uuid, 3, 434.99),
('11000000-0000-0000-0000-000000000190'::uuid, '00010000-0000-0000-0000-000000000092'::uuid, 'f0000000-0000-0000-0000-000000000081'::uuid, 3, 199.99),
('11000000-0000-0000-0000-000000000191'::uuid, '00010000-0000-0000-0000-000000000092'::uuid, 'f0000000-0000-0000-0000-000000000088'::uuid, 3, 199.99),
('11000000-0000-0000-0000-000000000192'::uuid, '00010000-0000-0000-0000-000000000093'::uuid, 'f0000000-0000-0000-0000-000000000121'::uuid, 5, 359.99),
('11000000-0000-0000-0000-000000000193'::uuid, '00010000-0000-0000-0000-000000000093'::uuid, 'f0000000-0000-0000-0000-000000000123'::uuid, 5, 359.99),
('11000000-0000-0000-0000-000000000194'::uuid, '00010000-0000-0000-0000-000000000094'::uuid, 'f0000000-0000-0000-0000-000000000241'::uuid, 3, 349.99),
('11000000-0000-0000-0000-000000000195'::uuid, '00010000-0000-0000-0000-000000000094'::uuid, 'f0000000-0000-0000-0000-000000000250'::uuid, 3, 349.99),
('11000000-0000-0000-0000-000000000196'::uuid, '00010000-0000-0000-0000-000000000095'::uuid, 'f0000000-0000-0000-0000-000000000461'::uuid, 5, 379.99),
('11000000-0000-0000-0000-000000000197'::uuid, '00010000-0000-0000-0000-000000000095'::uuid, 'f0000000-0000-0000-0000-000000000465'::uuid, 5, 379.99);

-- PO 96-100 (completed, 3 items each)
INSERT INTO po_line_items (id, po_id, vendor_product_id, quantity, unit_price) VALUES
('11000000-0000-0000-0000-000000000198'::uuid, '00010000-0000-0000-0000-000000000096'::uuid, 'f0000000-0000-0000-0000-000000000001'::uuid, 3, 899.99),
('11000000-0000-0000-0000-000000000199'::uuid, '00010000-0000-0000-0000-000000000097'::uuid, 'f0000000-0000-0000-0000-000000000181'::uuid, 5, 149.99),
('11000000-0000-0000-0000-000000000200'::uuid, '00010000-0000-0000-0000-000000000097'::uuid, 'f0000000-0000-0000-0000-000000000184'::uuid, 5, 149.99),
('11000000-0000-0000-0000-000000000201'::uuid, '00010000-0000-0000-0000-000000000098'::uuid, 'f0000000-0000-0000-0000-000000000341'::uuid, 2, 2099.99),
('11000000-0000-0000-0000-000000000202'::uuid, '00010000-0000-0000-0000-000000000099'::uuid, 'f0000000-0000-0000-0000-000000000061'::uuid, 1, 449.99),
('11000000-0000-0000-0000-000000000203'::uuid, '00010000-0000-0000-0000-000000000099'::uuid, 'f0000000-0000-0000-0000-000000000072'::uuid, 1, 449.99),
('11000000-0000-0000-0000-000000000204'::uuid, '00010000-0000-0000-0000-000000000100'::uuid, 'f0000000-0000-0000-0000-000000000381'::uuid, 3, 109.99),
('11000000-0000-0000-0000-000000000205'::uuid, '00010000-0000-0000-0000-000000000100'::uuid, 'f0000000-0000-0000-0000-000000000392'::uuid, 3, 109.99);

-- =============================================================================
-- REVIEW QUEUE  (15 rows)
-- =============================================================================

-- 5 pending_review (for flagged POs 51-55)
INSERT INTO review_queue (id, review_number, po_id, assigned_to, reason, urgency, status, created_at) VALUES
('12000000-0000-0000-0000-000000000001'::uuid, 'REV-20250411-000001', '00010000-0000-0000-0000-000000000051'::uuid, 'b0000000-0000-0000-0000-000000000007'::uuid, 'Total amount $8,999.90 exceeds $5,000 threshold. Large Samsung Galaxy order for enterprise client.', 'medium', 'pending_review', '2025-04-11 09:05:00+00'),
('12000000-0000-0000-0000-000000000002'::uuid, 'REV-20250413-000002', '00010000-0000-0000-0000-000000000052'::uuid, 'b0000000-0000-0000-0000-000000000008'::uuid, 'Total amount $14,499.95 exceeds $5,000 threshold. MacBook Pro fleet order for dev team.', 'high', 'pending_review', '2025-04-13 10:05:00+00'),
('12000000-0000-0000-0000-000000000003'::uuid, 'REV-20250415-000003', '00010000-0000-0000-0000-000000000053'::uuid, 'b0000000-0000-0000-0000-000000000017'::uuid, 'Total amount $12,000.00 exceeds $5,000 threshold. Large smart home deployment project.', 'medium', 'pending_review', '2025-04-15 11:05:00+00'),
('12000000-0000-0000-0000-000000000004'::uuid, 'REV-20250417-000004', '00010000-0000-0000-0000-000000000054'::uuid, 'b0000000-0000-0000-0000-000000000018'::uuid, 'Total amount $22,000.00 exceeds $5,000 threshold. Enterprise phone refresh - 20 units.', 'high', 'pending_review', '2025-04-17 14:05:00+00'),
('12000000-0000-0000-0000-000000000005'::uuid, 'REV-20250419-000005', '00010000-0000-0000-0000-000000000055'::uuid, NULL, 'Total amount $27,499.90 exceeds $5,000 threshold. Laptop fleet for new department.', 'high', 'pending_review', '2025-04-19 09:35:00+00');

-- 4 under_review (for flagged POs 56-59)
INSERT INTO review_queue (id, review_number, po_id, assigned_to, reason, urgency, status, created_at) VALUES
('12000000-0000-0000-0000-000000000006'::uuid, 'REV-20250421-000006', '00010000-0000-0000-0000-000000000056'::uuid, 'b0000000-0000-0000-0000-000000000027'::uuid, 'Total amount $15,000.00 exceeds $5,000 threshold. TV and AV equipment for conference rooms.', 'medium', 'under_review', '2025-04-21 10:05:00+00'),
('12000000-0000-0000-0000-000000000007'::uuid, 'REV-20250423-000007', '00010000-0000-0000-0000-000000000057'::uuid, 'b0000000-0000-0000-0000-000000000007'::uuid, 'Total amount $9,800.00 exceeds $5,000 threshold. iPad fleet for warehouse staff.', 'medium', 'under_review', '2025-04-23 11:35:00+00'),
('12000000-0000-0000-0000-000000000008'::uuid, 'REV-20250425-000008', '00010000-0000-0000-0000-000000000058'::uuid, 'b0000000-0000-0000-0000-000000000017'::uuid, 'Total amount $7,500.00 exceeds $5,000 threshold. Gaming lounge equipment package.', 'low', 'under_review', '2025-04-25 14:05:00+00'),
('12000000-0000-0000-0000-000000000009'::uuid, 'REV-20250427-000009', '00010000-0000-0000-0000-000000000059'::uuid, 'b0000000-0000-0000-0000-000000000028'::uuid, 'Total amount $5,200.00 exceeds $5,000 threshold. Smart home + networking bundle.', 'low', 'under_review', '2025-04-27 09:05:00+00');

-- 4 approved (for approved POs 61-64, resolved)
INSERT INTO review_queue (id, review_number, po_id, assigned_to, reason, urgency, status, created_at, resolved_at) VALUES
('12000000-0000-0000-0000-000000000010'::uuid, 'REV-20250301-000010', '00010000-0000-0000-0000-000000000061'::uuid, 'b0000000-0000-0000-0000-000000000007'::uuid, 'Total amount $8,500.00 exceeds $5,000 threshold. Bulk Galaxy order for Q2 inventory.', 'medium', 'approved', '2025-03-01 09:05:00+00', '2025-03-05 09:00:00+00'),
('12000000-0000-0000-0000-000000000011'::uuid, 'REV-20250303-000011', '00010000-0000-0000-0000-000000000062'::uuid, 'b0000000-0000-0000-0000-000000000008'::uuid, 'Total amount $16,999.95 exceeds $5,000 threshold. Dell XPS fleet for IT department.', 'high', 'approved', '2025-03-03 10:05:00+00', '2025-03-07 10:00:00+00'),
('12000000-0000-0000-0000-000000000012'::uuid, 'REV-20250305-000012', '00010000-0000-0000-0000-000000000063'::uuid, 'b0000000-0000-0000-0000-000000000007'::uuid, 'Total amount $7,200.00 exceeds $5,000 threshold. LG OLED displays for showroom.', 'medium', 'approved', '2025-03-05 11:05:00+00', '2025-03-09 11:00:00+00'),
('12000000-0000-0000-0000-000000000013'::uuid, 'REV-20250307-000013', '00010000-0000-0000-0000-000000000064'::uuid, 'b0000000-0000-0000-0000-000000000008'::uuid, 'Total amount $11,000.00 exceeds $5,000 threshold. iPad Pro fleet for design team.', 'medium', 'approved', '2025-03-07 14:05:00+00', '2025-03-11 14:00:00+00');

-- 2 rejected (for rejected POs 76-77, resolved)
INSERT INTO review_queue (id, review_number, po_id, assigned_to, reason, urgency, status, created_at, resolved_at) VALUES
('12000000-0000-0000-0000-000000000014'::uuid, 'REV-20250331-000014', '00010000-0000-0000-0000-000000000076'::uuid, 'b0000000-0000-0000-0000-000000000007'::uuid, 'Total amount $35,000.00 exceeds $5,000 threshold. Budget not approved for Q3 TV procurement.', 'high', 'rejected', '2025-03-31 10:05:00+00', '2025-04-04 10:00:00+00'),
('12000000-0000-0000-0000-000000000015'::uuid, 'REV-20250402-000015', '00010000-0000-0000-0000-000000000077'::uuid, 'b0000000-0000-0000-0000-000000000017'::uuid, 'Total amount $25,000.00 exceeds $5,000 threshold. Preferred vendor required for this category.', 'medium', 'rejected', '2025-04-02 11:05:00+00', '2025-04-06 11:00:00+00');
