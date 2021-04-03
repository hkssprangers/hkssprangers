ALTER TABLE hkssprangers.delivery ADD customerWhatsApp varchar(64) NULL;
ALTER TABLE hkssprangers.delivery CHANGE customerWhatsApp customerWhatsApp varchar(64) NULL AFTER customerTel;
ALTER TABLE hkssprangers.delivery ADD customerSignal varchar(64) NULL;
ALTER TABLE hkssprangers.delivery CHANGE customerSignal customerSignal varchar(64) NULL AFTER customerWhatsApp;
ALTER TABLE hkssprangers.delivery CHANGE customerTel customerTel varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL AFTER customerTgId;
ALTER TABLE hkssprangers.delivery ADD customerBackupContactMethod varchar(64) NULL;
ALTER TABLE hkssprangers.delivery CHANGE customerBackupContactMethod customerBackupContactMethod varchar(64) NULL AFTER customerPreferredContactMethod;
