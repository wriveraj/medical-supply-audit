SELECT
    l.location_name,
    p.product_name,
    po.ordered_qty,
    s.received_qty,
    s.received_qty - po.ordered_qty AS variance,
    s.notes
FROM medical_supply.shipments s
JOIN medical_supply.purchase_orders po ON s.po_id = po.po_id
JOIN medical_supply.products p ON po.product_id = p.product_id
JOIN medical_supply.locations l ON po.location_id = l.location_id
WHERE s.received_qty <> po.ordered_qty
ORDER BY variance;
