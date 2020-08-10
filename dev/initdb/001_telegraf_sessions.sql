CREATE DATABASE telegraf_sessions;

USE telegraf_sessions;

CREATE TABLE `sessions` (
  `id` varchar(100) NOT NULL,
  `session` longtext NOT NULL,
  PRIMARY KEY (`id`));
