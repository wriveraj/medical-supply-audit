SELECT 
    l.location_name,
    p.product_name,
    p.category,
    i.quantity_on_hand,
    p.par_level,
    p.par_level - i.quantity_on_hand AS units_below_par
FROM medical_supply.inventory i
JOIN medical_supply.products p ON i.product_id = p.product_id
JOIN medical_supply.locations l ON i.location_id = l.location_id
WHERE i.quantity_on_hand < p.par_level
ORDER BY units_below_par DESC;
