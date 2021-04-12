ALTER TABLE hkssprangers.tgMessage ADD INDEX receiverId (receiverId);
ALTER TABLE hkssprangers.tgMessage ADD INDEX updateId (
    (JSON_VALUE(updateData, '$.update_id' RETURNING SIGNED))
);
ALTER TABLE hkssprangers.tgMessage ADD INDEX messageId (
    (JSON_VALUE(updateData, '$.message.message_id' RETURNING SIGNED))
);
ALTER TABLE hkssprangers.tgMessage ADD INDEX messageDate (
    (JSON_VALUE(updateData, '$.message.date' RETURNING SIGNED))
);
ALTER TABLE hkssprangers.tgMessage ADD INDEX messageChatId (
    (JSON_VALUE(updateData, '$.message.chat.id' RETURNING SIGNED))
);
ALTER TABLE hkssprangers.tgMessage ADD INDEX messageFromId (
    (JSON_VALUE(updateData, '$.message.from.id' RETURNING SIGNED))
);
