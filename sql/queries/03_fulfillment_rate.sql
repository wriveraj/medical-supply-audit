SELECT
    l.location_name,
    COUNT(s.shipment_id) AS total_shipments,
    SUM(CASE WHEN s.received_qty = po.ordered_qty THEN 1 ELSE 0 END) AS perfect_shipments,
    ROUND(100.0 * SUM(CASE WHEN s.received_qty = po.ordered_qty THEN 1 ELSE 0 END) / COUNT(s.shipment_id), 1) AS fulfillment_rate_pct
FROM medical_supply.shipments s
JOIN medical_supply.purchase_orders po ON s.po_id = po.po_id
JOIN medical_supply.locations l ON po.location_id = l.location_id
GROUP BY l.location_name
ORDER BY fulfillment_rate_pct;
