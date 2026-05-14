-- Master Status Report
SELECT 'Users' AS Table, COUNT(*) FROM users
UNION ALL SELECT 'Brands', COUNT(*) FROM brands
UNION ALL SELECT 'Categories', COUNT(*) FROM categories
UNION ALL SELECT 'Products', COUNT(*) FROM products
UNION ALL SELECT 'Product Variants', COUNT(*) FROM product_variants
UNION ALL SELECT 'Orders', COUNT(*) FROM orders
UNION ALL SELECT 'Order Items', COUNT(*) FROM order_items
UNION ALL SELECT 'Payments', COUNT(*) FROM payments
UNION ALL SELECT 'Reviews', COUNT(*) FROM reviews
UNION ALL SELECT 'Coupons', COUNT(*) FROM coupons
UNION ALL SELECT 'Wishlists', COUNT(*) FROM wishlists
UNION ALL SELECT 'Wishlist Items', COUNT(*) FROM wishlist_items
UNION ALL SELECT 'Notifications', COUNT(*) FROM notifications;