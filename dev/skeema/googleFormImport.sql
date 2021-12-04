CREATE TABLE `googleFormImport` (
  `importTime` timestamp NOT NULL,
  `spreadsheetId` varchar(100) COLLATE utf8mb4_bin NOT NULL,
  `lastRow` int unsigned NOT NULL,
  PRIMARY KEY (`importTime`,`spreadsheetId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
