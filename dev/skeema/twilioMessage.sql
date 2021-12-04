CREATE TABLE `twilioMessage` (
  `twilioMessageId` int NOT NULL AUTO_INCREMENT,
  `creationTime` timestamp NOT NULL,
  `data` json NOT NULL,
  PRIMARY KEY (`twilioMessageId`),
  KEY `_To` ((json_value(`data`, _utf8mb4'$.To' returning char(512)))),
  KEY `_From` ((json_value(`data`, _utf8mb4'$.From' returning char(512)))),
  KEY `_AccountSid` ((json_value(`data`, _utf8mb4'$.AccountSid' returning char(512)))),
  KEY `_MessageSid` ((json_value(`data`, _utf8mb4'$.MessageSid' returning char(512))))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
