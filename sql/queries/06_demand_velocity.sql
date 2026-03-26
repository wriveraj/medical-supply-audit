SELECT
    p.product_name,
    p.category,
    COUNT(al.log_id) AS total_adjustments,
    SUM(ABS(al.new_qty - al.previous_qty)) AS total_units_moved,
    ROUND(AVG(ABS(al.new_qty - al.previous_qty)), 1) AS avg_units_per_adjustment,
    MIN(al.changed_at) AS first_movement,
    MAX(al.changed_at) AS last_movement
FROM medical_supply.audit_log al
JOIN medical_supply.products p ON al.product_id = p.product_id
GROUP BY p.product_name, p.category
ORDER BY total_units_moved DESC;
