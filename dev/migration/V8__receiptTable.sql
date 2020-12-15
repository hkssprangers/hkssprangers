CREATE TABLE hkssprangers.receipt (
	receiptId INT auto_increment NOT NULL,
	receiptUrl varchar(1024) NOT NULL,
	orderId INT NULL,
	uploaderCourierId INT NULL,
	CONSTRAINT receipt_PK PRIMARY KEY (receiptId),
	CONSTRAINT receipt_order_FK FOREIGN KEY (orderId) REFERENCES hkssprangers.`order`(orderId) ON DELETE RESTRICT ON UPDATE RESTRICT,
	CONSTRAINT receipt_courier_FK FOREIGN KEY (uploaderCourierId) REFERENCES hkssprangers.`courier`(courierId) ON DELETE RESTRICT ON UPDATE RESTRICT
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_bin;
