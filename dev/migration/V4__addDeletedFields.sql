ALTER TABLE hkssprangers.delivery ADD deleted BOOL DEFAULT FALSE NOT NULL;
ALTER TABLE hkssprangers.deliveryCourier ADD deleted BOOL DEFAULT FALSE NOT NULL;
ALTER TABLE hkssprangers.deliveryOrder ADD deleted BOOL DEFAULT FALSE NOT NULL;
ALTER TABLE hkssprangers.order ADD deleted BOOL DEFAULT FALSE NOT NULL;
ALTER TABLE hkssprangers.courier ADD deleted BOOL DEFAULT FALSE NOT NULL;
