--
-- Скрипт сгенерирован Devart dbForge Studio for MySQL, Версия 6.3.358.0
-- Домашняя страница продукта: http://www.devart.com/ru/dbforge/mysql/studio
-- Дата скрипта: 14.11.2016 0:00:52
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
  id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  sortIndex INT(11) UNSIGNED NOT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB
AUTO_INCREMENT = 1
CHARACTER SET utf8
COLLATE utf8_general_ci;

--
-- Описание для таблицы module_rights
--
DROP TABLE IF EXISTS module_rights;
CREATE TABLE module_rights (
  id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  moduleId INT(11) UNSIGNED NOT NULL DEFAULT 0,
  rightId INT(11) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (id),
  INDEX FK_module_rights_modules_id (moduleId),
  INDEX FK_module_rights_rights_id (rightId)
)
ENGINE = INNODB
AUTO_INCREMENT = 1
CHARACTER SET utf8
COLLATE utf8_general_ci;

--
-- Описание для таблицы rights
--
DROP TABLE IF EXISTS rights;
CREATE TABLE rights (
  id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(150) NOT NULL,
  deleted TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (id)
)
ENGINE = INNODB
AUTO_INCREMENT = 1
CHARACTER SET utf8
COLLATE utf8_general_ci;

--
-- Описание для таблицы roles
--
DROP TABLE IF EXISTS roles;
CREATE TABLE roles (
  id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(150) NOT NULL,
  description VARCHAR(255) DEFAULT NULL COMMENT 'Комментарий',
  deleted TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (id)
)
ENGINE = INNODB
AUTO_INCREMENT = 2
AVG_ROW_LENGTH = 16384
CHARACTER SET utf8
COLLATE utf8_general_ci;

--
-- Описание для таблицы site_settings
--
DROP TABLE IF EXISTS site_settings;
CREATE TABLE site_settings (
  id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
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
AUTO_INCREMENT = 1
CHARACTER SET utf8
COLLATE utf8_general_ci
COMMENT = 'Общие настройки сайта';

--
-- Описание для таблицы modules
--
DROP TABLE IF EXISTS modules;
CREATE TABLE modules (
  id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  module_groupId INT(11) UNSIGNED NOT NULL,
  name VARCHAR(50) NOT NULL,
  caption VARCHAR(255) DEFAULT NULL,
  sortIndex INT(11) UNSIGNED DEFAULT NULL,
  deleted TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (id),
  CONSTRAINT FK_modules_module_group_id FOREIGN KEY (module_groupId)
    REFERENCES module_group(id) ON DELETE RESTRICT ON UPDATE RESTRICT
)
ENGINE = INNODB
AUTO_INCREMENT = 1
CHARACTER SET utf8
COLLATE utf8_general_ci;

--
-- Описание для таблицы role_module_right
--
DROP TABLE IF EXISTS role_module_right;
CREATE TABLE role_module_right (
  roleId INT(11) UNSIGNED NOT NULL,
  module_rightId INT(11) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (roleId, module_rightId),
  CONSTRAINT FK_role_module_right_module_rights_id FOREIGN KEY (module_rightId)
    REFERENCES module_rights(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT FK_role_module_right_roles_id FOREIGN KEY (roleId)
    REFERENCES roles(id) ON DELETE RESTRICT ON UPDATE RESTRICT
)
ENGINE = INNODB
CHARACTER SET utf8
COLLATE utf8_general_ci;

--
-- Описание для таблицы user
--
DROP TABLE IF EXISTS user;
CREATE TABLE user (
  id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  username VARCHAR(255) NOT NULL,
  auth_key VARCHAR(32) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  password_reset_token VARCHAR(255) DEFAULT NULL,
  email VARCHAR(255) NOT NULL,
  status SMALLINT(6) NOT NULL DEFAULT 10,
  created_at INT(11) NOT NULL,
  updated_at INT(11) NOT NULL,
  roleId INT(11) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (id),
  CONSTRAINT FK_user_roles_id FOREIGN KEY (roleId)
    REFERENCES roles(id) ON DELETE RESTRICT ON UPDATE RESTRICT
)
ENGINE = INNODB
AUTO_INCREMENT = 1
CHARACTER SET utf8
COLLATE utf8_unicode_ci;

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

-- Таблица yii_db.module_group не содержит данных

-- 
-- Вывод данных для таблицы module_rights
--

-- Таблица yii_db.module_rights не содержит данных

-- 
-- Вывод данных для таблицы rights
--

-- Таблица yii_db.rights не содержит данных

-- 
-- Вывод данных для таблицы roles
--
INSERT INTO roles VALUES
(1, 'Администратор', 'Все права', 0);

-- 
-- Вывод данных для таблицы site_settings
--

-- Таблица yii_db.site_settings не содержит данных

-- 
-- Вывод данных для таблицы modules
--

-- Таблица yii_db.modules не содержит данных

-- 
-- Вывод данных для таблицы role_module_right
--

-- Таблица yii_db.role_module_right не содержит данных

-- 
-- Вывод данных для таблицы user
--

-- Таблица yii_db.user не содержит данных

-- 
-- Восстановить предыдущий режим SQL (SQL mode)
-- 
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;

-- 
-- Включение внешних ключей
-- 
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;