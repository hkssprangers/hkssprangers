ALTER TABLE hkssprangers.tgMessage MODIFY COLUMN messageData json NULL;
ALTER TABLE hkssprangers.tgMessage ADD updateType varchar(50) NULL;
ALTER TABLE hkssprangers.tgMessage ADD updateData json NULL;
