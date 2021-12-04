-- use unsigned for AUTO_INCREMENT cols as suggested by skeema
ALTER TABLE `delivery` MODIFY COLUMN `deliveryId` int unsigned NOT NULL AUTO_INCREMENT;
ALTER TABLE `receipt` MODIFY COLUMN `receiptId` int unsigned NOT NULL AUTO_INCREMENT;
ALTER TABLE `courier` MODIFY COLUMN `courierId` int unsigned NOT NULL AUTO_INCREMENT;
ALTER TABLE `order` MODIFY COLUMN `orderId` int unsigned NOT NULL AUTO_INCREMENT;
ALTER TABLE `tgMessage` MODIFY COLUMN `tgMessageId` int unsigned NOT NULL AUTO_INCREMENT;
ALTER TABLE `twilioMessage` MODIFY COLUMN `twilioMessageId` int unsigned NOT NULL AUTO_INCREMENT;
