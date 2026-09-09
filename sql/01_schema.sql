DROP SCHEMA IF EXISTS medical_supply CASCADE;
CREATE SCHEMA medical_supply;

CREATE TABLE medical_supply.products (
    product_id      SERIAL PRIMARY KEY,
    product_name    VARCHAR(150)   NOT NULL,
    category        VARCHAR(100)   NOT NULL,
    unit_cost       NUMERIC(10,2)  NOT NULL,
    par_level       INT            NOT NULL,
    reorder_qty     INT            NOT NULL,
    unit_of_measure VARCHAR(50)    NOT NULL,
    is_active       BOOLEAN        DEFAULT TRUE,
    created_at      TIMESTAMP      DEFAULT NOW()
);

CREATE TABLE medical_supply.locations (
    location_id     SERIAL PRIMARY KEY,
    location_name   VARCHAR(150)   NOT NULL,
    location_type   VARCHAR(100)   NOT NULL,
    city            VARCHAR(100)   NOT NULL,
    state           CHAR(2)        NOT NULL,
    is_active       BOOLEAN        DEFAULT TRUE,
    created_at      TIMESTAMP      DEFAULT NOW()
);

CREATE TABLE medical_supply.inventory (
    inventory_id     SERIAL PRIMARY KEY,
    product_id       INT            NOT NULL REFERENCES medical_supply.products(product_id),
    location_id      INT            NOT NULL REFERENCES medical_supply.locations(location_id),
    quantity_on_hand INT            NOT NULL DEFAULT 0,
    last_counted_at  TIMESTAMP      DEFAULT NOW(),
    updated_at       TIMESTAMP      DEFAULT NOW(),
    UNIQUE (product_id, location_id)
);

CREATE TABLE medical_supply.purchase_orders (
    po_id           SERIAL PRIMARY KEY,
    product_id      INT            NOT NULL REFERENCES medical_supply.products(product_id),
    location_id     INT            NOT NULL REFERENCES medical_supply.locations(location_id),
    ordered_qty     INT            NOT NULL,
    order_date      DATE           NOT NULL,
    expected_date   DATE           NOT NULL,
    status          VARCHAR(50)    DEFAULT 'Pending',
    created_at      TIMESTAMP      DEFAULT NOW()
);

CREATE TABLE medical_supply.shipments (
    shipment_id     SERIAL PRIMARY KEY,
    po_id           INT            NOT NULL REFERENCES medical_supply.purchase_orders(po_id),
    received_qty    INT            NOT NULL,
    received_date   DATE           NOT NULL,
    received_by     VARCHAR(100),
    notes           TEXT,
    created_at      TIMESTAMP      DEFAULT NOW()
);

CREATE TABLE medical_supply.discrepancies (
    discrepancy_id   SERIAL PRIMARY KEY,
    po_id            INT            REFERENCES medical_supply.purchase_orders(po_id),
    inventory_id     INT            REFERENCES medical_supply.inventory(inventory_id),
    discrepancy_type VARCHAR(100)   NOT NULL,
    expected_qty     INT,
    actual_qty       INT,
    variance         INT GENERATED ALWAYS AS (actual_qty - expected_qty) STORED,
    flagged_at       TIMESTAMP      DEFAULT NOW(),
    resolved         BOOLEAN        DEFAULT FALSE,
    resolution_notes TEXT
);

CREATE TABLE medical_supply.audit_log (
    log_id          SERIAL PRIMARY KEY,
    inventory_id    INT            NOT NULL REFERENCES medical_supply.inventory(inventory_id),
    product_id      INT            NOT NULL REFERENCES medical_supply.products(product_id),
    location_id     INT            NOT NULL REFERENCES medical_supply.locations(location_id),
    previous_qty    INT,
    new_qty         INT,
    change_reason   VARCHAR(150),
    changed_by      VARCHAR(100),
    changed_at      TIMESTAMP      DEFAULT NOW()
);

CREATE INDEX idx_inventory_product    ON medical_supply.inventory(product_id);
CREATE INDEX idx_inventory_location   ON medical_supply.inventory(location_id);
CREATE INDEX idx_po_product           ON medical_supply.purchase_orders(product_id);
CREATE INDEX idx_po_location          ON medical_supply.purchase_orders(location_id);
CREATE INDEX idx_po_status            ON medical_supply.purchase_orders(status);
CREATE INDEX idx_shipments_po         ON medical_supply.shipments(po_id);
CREATE INDEX idx_discrepancies_po     ON medical_supply.discrepancies(po_id);
CREATE INDEX idx_discrepancies_type   ON medical_supply.discrepancies(discrepancy_type);
CREATE INDEX idx_audit_log_inventory  ON medical_supply.audit_log(inventory_id);
CREATE INDEX idx_audit_log_changed_at ON medical_supply.audit_log(changed_at);
