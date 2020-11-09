CREATE TABLE hkssprangers.googleFormImport (
	importTime TIMESTAMP NOT NULL,
	spreadsheetId varchar(100) NOT NULL,
	lastRow INT UNSIGNED NOT NULL,
	CONSTRAINT googleFormImport_PK PRIMARY KEY (importTime,spreadsheetId)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_bin;
