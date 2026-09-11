DROP TABLE IF EXISTS deal_items;
DROP TABLE IF EXISTS deals;

CREATE TABLE deals (
    id SERIAL PRIMARY KEY,

    customer_id INTEGER NOT NULL
        REFERENCES customers(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    discount_rule_id INTEGER
        REFERENCES discount_rules(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    created_by INTEGER NOT NULL
        REFERENCES users(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    subtotal NUMERIC(12, 2) NOT NULL DEFAULT 0
        CHECK (subtotal >= 0),

    discount_percent NUMERIC(5, 2) NOT NULL DEFAULT 0
        CHECK (discount_percent BETWEEN 0 AND 100),

    total_amount NUMERIC(12, 2) NOT NULL DEFAULT 0
        CHECK (total_amount >= 0),

    status VARCHAR(50) NOT NULL DEFAULT 'Новая'
        CHECK (
            status IN (
                'Новая',
                'Оформлена',
                'Закрыта',
                'Отменена'
            )
        ),

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE deal_items (
    id SERIAL PRIMARY KEY,

    deal_id INTEGER NOT NULL
        REFERENCES deals(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    product_id INTEGER NOT NULL
        REFERENCES products(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    quantity INTEGER NOT NULL
        CHECK (quantity > 0),

    unit_price NUMERIC(12, 2) NOT NULL
        CHECK (unit_price >= 0),

    line_total NUMERIC(12, 2) NOT NULL
        CHECK (line_total >= 0),

    CONSTRAINT deal_items_product_unique
        UNIQUE (deal_id, product_id)
);