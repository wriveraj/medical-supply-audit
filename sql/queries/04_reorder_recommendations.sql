SELECT
    l.location_name,
    p.product_name,
    p.category,
    i.quantity_on_hand,
    p.par_level,
    p.reorder_qty,
    p.unit_cost,
    ROUND((p.reorder_qty * p.unit_cost)::NUMERIC, 2) AS estimated_reorder_cost
FROM medical_supply.inventory i
JOIN medical_supply.products p ON i.product_id = p.product_id
JOIN medical_supply.locations l ON i.location_id = l.location_id
WHERE i.quantity_on_hand < p.par_level
AND l.location_type != 'Warehouse'
ORDER BY l.location_name, estimated_reorder_cost DESC;
