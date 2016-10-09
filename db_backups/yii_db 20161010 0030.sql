--
-- Скрипт сгенерирован Devart dbForge Studio for MySQL, Версия 6.3.358.0
-- Домашняя страница продукта: http://www.devart.com/ru/dbforge/mysql/studio
-- Дата скрипта: 10.10.2016 0:30:50
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
  sortIndex INT(11) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (id)
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
AUTO_INCREMENT = 3
AVG_ROW_LENGTH = 8192
CHARACTER SET utf8
COLLATE utf8_general_ci;

--
-- Описание для таблицы role_module_right
--
DROP TABLE IF EXISTS role_module_right;
CREATE TABLE role_module_right (
  roleId INT(11) UNSIGNED NOT NULL,
  module_rightId INT(11) NOT NULL,
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
  id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(150) NOT NULL,
  description VARCHAR(255) DEFAULT NULL COMMENT 'Комментарий',
  deleted TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (id)
)
ENGINE = INNODB
AUTO_INCREMENT = 3
AVG_ROW_LENGTH = 8192
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
-- Описание для таблицы user
--
DROP TABLE IF EXISTS user;
CREATE TABLE user (
  id INT(11) NOT NULL AUTO_INCREMENT,
  username VARCHAR(255) NOT NULL,
  auth_key VARCHAR(32) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  password_reset_token VARCHAR(255) DEFAULT NULL,
  email VARCHAR(255) NOT NULL,
  status SMALLINT(6) NOT NULL DEFAULT 10,
  created_at INT(11) NOT NULL,
  updated_at INT(11) NOT NULL,
  roleId INT(11) UNSIGNED NOT NULL DEFAULT 2,
  PRIMARY KEY (id),
  CONSTRAINT FK_user_roles_id FOREIGN KEY (roleId)
    REFERENCES roles(id) ON DELETE CASCADE ON UPDATE RESTRICT
)
ENGINE = INNODB
AUTO_INCREMENT = 3
CHARACTER SET utf8
COLLATE utf8_unicode_ci;

--
-- Описание для таблицы module_rights
--
DROP TABLE IF EXISTS module_rights;
CREATE TABLE module_rights (
  id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  moduleId INT(11) UNSIGNED NOT NULL,
  rightId INT(11) UNSIGNED NOT NULL,
  PRIMARY KEY (id, moduleId, rightId),
  CONSTRAINT FK_module_rights_modules_id FOREIGN KEY (moduleId)
    REFERENCES modules(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT FK_module_rights_rights_id FOREIGN KEY (rightId)
    REFERENCES rights(id) ON DELETE RESTRICT ON UPDATE RESTRICT
)
ENGINE = INNODB
AUTO_INCREMENT = 1
CHARACTER SET utf8
COLLATE utf8_general_ci;

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
-- Вывод данных для таблицы rights
--
INSERT INTO rights VALUES
(1, 'Просмотр', 0),
(2, 'Редактирование', 0);

-- 
-- Вывод данных для таблицы role_module_right
--

-- Таблица yii_db.role_module_right не содержит данных

-- 
-- Вывод данных для таблицы roles
--
INSERT INTO roles VALUES
(1, 'Администратор', 'Все права', 0),
(2, 'Общие', 'Для впервые зарегистрированных ползователей (общий набор прав)', 0);

-- 
-- Вывод данных для таблицы site_settings
--

-- Таблица yii_db.site_settings не содержит данных

-- 
-- Вывод данных для таблицы modules
--

-- Таблица yii_db.modules не содержит данных

-- 
-- Вывод данных для таблицы user
--
INSERT INTO user VALUES
(2, 'admin', 'z04OixJb324cjFuCq9NsA0JlehAwkF_u', '$2y$13$FJi51y67pCb8qEOJXd7r5.WpKbufe7k0lWq4EEjsuW5fTf2.xmKyK', NULL, 'dus92@yandex.ru', 10, 1472846781, 1472846781, 2);

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