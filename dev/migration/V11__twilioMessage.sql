CREATE TABLE hkssprangers.twilioMessage (
	`twilioMessageId` int auto_increment NOT NULL,
    `creationTime` timestamp NOT NULL,
	`data` json NOT NULL,
	CONSTRAINT twilioMessage_PK PRIMARY KEY (twilioMessageId)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_bin;

ALTER TABLE hkssprangers.twilioMessage ADD INDEX _To (
    (JSON_VALUE(`data`, '$.To'))
);
ALTER TABLE hkssprangers.twilioMessage ADD INDEX _From (
    (JSON_VALUE(`data`, '$.From'))
);
ALTER TABLE hkssprangers.twilioMessage ADD INDEX _AccountSid (
    (JSON_VALUE(`data`, '$.AccountSid'))
);
ALTER TABLE hkssprangers.twilioMessage ADD INDEX _MessageSid (
    (JSON_VALUE(`data`, '$.MessageSid'))
);
