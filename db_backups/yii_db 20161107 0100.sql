--
-- Скрипт сгенерирован Devart dbForge Studio for MySQL, Версия 6.3.358.0
-- Домашняя страница продукта: http://www.devart.com/ru/dbforge/mysql/studio
-- Дата скрипта: 07.11.2016 1:00:42
-- Версия сервера: 5.6.23-log
-- Версия клиента: 4.1
--


-- 
-- Отключение внешних ключей
-- 
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

-- 
-- Установить режим SQL (SQL mode)
-- 
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- 
-- Установка кодировки, с использованием которой клиент будет посылать запросы на сервер
--
SET NAMES 'utf8';

-- 
-- Установка базы данных по умолчанию
--
USE yii_db;

--
-- Описание для таблицы migration
--
DROP TABLE IF EXISTS migration;
CREATE TABLE migration (
  version VARCHAR(180) NOT NULL,
  apply_time INT(11) DEFAULT NULL,
  PRIMARY KEY (version)
)
ENGINE = INNODB
AVG_ROW_LENGTH = 8192
CHARACTER SET utf8
COLLATE utf8_general_ci;

--
-- Описание для таблицы module_group
--
DROP TABLE IF EXISTS module_group;
CREATE TABLE module_group (
  id BINARY(16) NOT NULL,
  name VARCHAR(50) NOT NULL,
  sortIndex INT(11) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB
AVG_ROW_LENGTH = 8192
CHARACTER SET utf8
COLLATE utf8_general_ci;

--
-- Описание для таблицы rights
--
DROP TABLE IF EXISTS rights;
CREATE TABLE rights (
  id BINARY(16) NOT NULL,
  name VARCHAR(150) NOT NULL,
  deleted TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (id)
)
ENGINE = INNODB
AVG_ROW_LENGTH = 8192
CHARACTER SET utf8
COLLATE utf8_general_ci;

--
-- Описание для таблицы role_module_right
--
DROP TABLE IF EXISTS role_module_right;
CREATE TABLE role_module_right (
  roleId BINARY(16) NOT NULL,
  module_rightId BINARY(16) NOT NULL,
  PRIMARY KEY (roleId, module_rightId)
)
ENGINE = INNODB
CHARACTER SET utf8
COLLATE utf8_general_ci;

--
-- Описание для таблицы roles
--
DROP TABLE IF EXISTS roles;
CREATE TABLE roles (
  id BINARY(16) NOT NULL,
  name VARCHAR(150) NOT NULL,
  description VARCHAR(255) DEFAULT NULL COMMENT 'Комментарий',
  deleted TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (id)
)
ENGINE = INNODB
AVG_ROW_LENGTH = 16384
CHARACTER SET utf8
COLLATE utf8_general_ci;

--
-- Описание для таблицы site_settings
--
DROP TABLE IF EXISTS site_settings;
CREATE TABLE site_settings (
  id BINARY(16) NOT NULL,
  title VARCHAR(255) DEFAULT NULL,
  short_title VARCHAR(150) DEFAULT NULL,
  hide_title TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
  copyright VARCHAR(150) DEFAULT NULL,
  pageelems INT(11) UNSIGNED NOT NULL DEFAULT 10 COMMENT 'Количество элементов на странице',
  mainpage_moduleId INT(11) UNSIGNED DEFAULT NULL COMMENT 'Показываемый на главной странице модуль',
  timezoneId INT(11) UNSIGNED DEFAULT NULL COMMENT 'Часовой пояс',
  PRIMARY KEY (id)
)
ENGINE = INNODB
CHARACTER SET utf8
COLLATE utf8_general_ci
COMMENT = 'Общие настройки сайта';

--
-- Описание для таблицы modules
--
DROP TABLE IF EXISTS modules;
CREATE TABLE modules (
  id BINARY(16) NOT NULL,
  module_groupId BINARY(16) NOT NULL,
  name VARCHAR(50) NOT NULL,
  caption VARCHAR(255) DEFAULT NULL,
  sortIndex INT(11) UNSIGNED DEFAULT NULL,
  deleted TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (id),
  CONSTRAINT FK_modules_module_group_id FOREIGN KEY (module_groupId)
    REFERENCES module_group(id) ON DELETE RESTRICT ON UPDATE RESTRICT
)
ENGINE = INNODB
AVG_ROW_LENGTH = 8192
CHARACTER SET utf8
COLLATE utf8_general_ci;

--
-- Описание для таблицы user
--
DROP TABLE IF EXISTS user;
CREATE TABLE user (
  id BINARY(16) NOT NULL,
  username VARCHAR(255) NOT NULL,
  auth_key VARCHAR(32) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  password_reset_token VARCHAR(255) DEFAULT NULL,
  email VARCHAR(255) NOT NULL,
  status SMALLINT(6) NOT NULL DEFAULT 10,
  created_at INT(11) NOT NULL,
  updated_at INT(11) NOT NULL,
  roleId BINARY(16) DEFAULT NULL,
  PRIMARY KEY (id),
  CONSTRAINT FK_user_roles_id FOREIGN KEY (roleId)
    REFERENCES roles(id) ON DELETE RESTRICT ON UPDATE RESTRICT
)
ENGINE = INNODB
AVG_ROW_LENGTH = 16384
CHARACTER SET utf8
COLLATE utf8_unicode_ci;

--
-- Описание для таблицы module_rights
--
DROP TABLE IF EXISTS module_rights;
CREATE TABLE module_rights (
  id BINARY(16) NOT NULL,
  moduleId BINARY(16) NOT NULL DEFAULT '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',
  rightId BINARY(16) NOT NULL DEFAULT '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',
  PRIMARY KEY (id, moduleId, rightId),
  CONSTRAINT FK_module_rights_modules_id FOREIGN KEY (moduleId)
    REFERENCES modules(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT FK_module_rights_rights_id FOREIGN KEY (rightId)
    REFERENCES rights(id) ON DELETE RESTRICT ON UPDATE RESTRICT
)
ENGINE = INNODB
CHARACTER SET utf8
COLLATE utf8_general_ci;

DELIMITER $$

--
-- Описание для функции f_gt
--
DROP FUNCTION IF EXISTS f_gt$$
CREATE DEFINER = 'root'@'localhost'
FUNCTION f_gt($data BINARY(16))
  RETURNS char(38) CHARSET utf8
  DETERMINISTIC
BEGIN
  DECLARE $result CHAR(38) DEFAULT NULL;

  IF $data IS NOT NULL THEN
    SET $result = concat('{', hex(substring($data, 4, 1)), hex(substring($data, 3, 1)), hex(substring($data, 2, 1)), hex(substring($data, 1, 1)), '-',
    hex(substring($data, 6, 1)), hex(substring($data, 5, 1)), '-',
    hex(substring($data, 8, 1)), hex(substring($data, 7, 1)), '-',
    hex(substring($data, 9, 2)), '-', hex(substring($data, 11, 6)), '}');
    SET $result = ucase($result);
  END IF;
  RETURN $result;
END
$$

--
-- Описание для функции f_tg
--
DROP FUNCTION IF EXISTS f_tg$$
CREATE DEFINER = 'root'@'localhost'
FUNCTION f_tg($data VARCHAR(38))
  RETURNS binary(16)
  DETERMINISTIC
BEGIN
  DECLARE $result BINARY(16) DEFAULT NULL;

  IF $data IS NOT NULL THEN
    SET $data = replace($data, '-', '');
    SET $data = replace($data, '{', '');
    SET $data = replace($data, '}', '');
    SET $result = concat(unhex(substring($data, 7, 2)), unhex(substring($data, 5, 2)), unhex(substring($data, 3, 2)), unhex(substring($data, 1, 2)),
    unhex(substring($data, 11, 2)), unhex(substring($data, 9, 2)), unhex(substring($data, 15, 2)), unhex(substring($data, 13, 2)),
    unhex(substring($data, 17, 16)));
  END IF;
  RETURN $result;
END
$$

DELIMITER ;

-- 
-- Вывод данных для таблицы migration
--
INSERT INTO migration VALUES
('m000000_000000_base', 1444498177),
('m130524_201442_init', 1444498182);

-- 
-- Вывод данных для таблицы module_group
--
INSERT INTO module_group VALUES
('���M����lbm^��', 'Ифноблоки', 1),
('���M����lbm^��', 'Основное управление', 0);

-- 
-- Вывод данных для таблицы rights
--
INSERT INTO rights VALUES
('�d''P����lbm^��', 'Просмотр', 0),
('�d''P����lbm^��', 'Редактирование', 0);

-- 
-- Вывод данных для таблицы role_module_right
--

-- Таблица yii_db.role_module_right не содержит данных

-- 
-- Вывод данных для таблицы roles
--
INSERT INTO roles VALUES
('�5Q\nP����lbm^��', 'Администратор', 'Все права', 0),
('�9Q\nP����lbm^��', 'Общие', 'Для впервые зарегистрированных ползователей (общий набор прав)', 0);

-- 
-- Вывод данных для таблицы site_settings
--

-- Таблица yii_db.site_settings не содержит данных

-- 
-- Вывод данных для таблицы modules
--
INSERT INTO modules VALUES
('k�9�M����lbm^��', '���M����lbm^��', 'site_settings', 'Настройка сайта', 0, 0),
('�0qN����lbm^��', '���M����lbm^��', 'infoblocks', 'Управление инфоблоками', 1, 0);

-- 
-- Вывод данных для таблицы user
--
INSERT INTO user VALUES
('^G8M����lbm^��', 'admin', 'z04OixJb324cjFuCq9NsA0JlehAwkF_u', '$2y$13$FJi51y67pCb8qEOJXd7r5.WpKbufe7k0lWq4EEjsuW5fTf2.xmKyK', NULL, 'dus92@yandex.ru', 10, 1472846781, 1472846781, NULL);

-- 
-- Вывод данных для таблицы module_rights
--

-- Таблица yii_db.module_rights не содержит данных

-- 
-- Восстановить предыдущий режим SQL (SQL mode)
-- 
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;

-- 
-- Включение внешних ключей
-- 
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;