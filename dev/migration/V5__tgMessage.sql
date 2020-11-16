CREATE TABLE hkssprangers.tgMessage (
	tgMessageId INT auto_increment NOT NULL,
	receiverId INT NOT NULL,
	messageData json NOT NULL,
	CONSTRAINT tgMessage_PK PRIMARY KEY (tgMessageId)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_bin;
