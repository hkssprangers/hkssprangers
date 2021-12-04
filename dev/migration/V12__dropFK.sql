-- drop FKs to prepare migrating to planetscale
ALTER TABLE `deliveryOrder` DROP FOREIGN KEY `deliveryOrder_FK_delivery`, DROP FOREIGN KEY `deliveryOrder_FK_order`;
ALTER TABLE `deliveryCourier` DROP FOREIGN KEY `deliveryCourier_FK_courier`, DROP FOREIGN KEY `deliveryCourier_FK_delivery`;
ALTER TABLE `receipt` DROP FOREIGN KEY `receipt_courier_FK`, DROP FOREIGN KEY `receipt_order_FK`;
