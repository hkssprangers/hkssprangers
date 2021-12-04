CREATE TABLE `tgMessage` (
  `tgMessageId` int NOT NULL AUTO_INCREMENT,
  `receiverId` int NOT NULL,
  `messageData` json DEFAULT NULL,
  `updateType` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `updateData` json DEFAULT NULL,
  PRIMARY KEY (`tgMessageId`),
  KEY `receiverId` (`receiverId`),
  KEY `updateId` ((json_value(`updateData`, _utf8mb4'$.update_id' returning signed))),
  KEY `messageId` ((json_value(`updateData`, _utf8mb4'$.message.message_id' returning signed))),
  KEY `messageDate` ((json_value(`updateData`, _utf8mb4'$.message.date' returning signed))),
  KEY `messageChatId` ((json_value(`updateData`, _utf8mb4'$.message.chat.id' returning signed))),
  KEY `messageFromId` ((json_value(`updateData`, _utf8mb4'$.message.from.id' returning signed)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
