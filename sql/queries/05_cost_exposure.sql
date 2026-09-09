SELECT
    l.location_name,
    COUNT(*) AS products_below_par,
    SUM(p.reorder_qty * p.unit_cost) AS total_reorder_cost,
    SUM((p.par_level - i.quantity_on_hand) * p.unit_cost) AS minimum_gap_cost
FROM medical_supply.inventory i
JOIN medical_supply.products p ON i.product_id = p.product_id
JOIN medical_supply.locations l ON i.location_id = l.location_id
WHERE i.quantity_on_hand < p.par_level
AND l.location_type != 'Warehouse'
GROUP BY l.location_name
ORDER BY total_reorder_cost DESC;
