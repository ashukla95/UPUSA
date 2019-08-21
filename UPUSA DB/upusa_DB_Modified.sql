-- Schema upusa
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `upusa`;
USE `upusa` ;

-- -----------------------------------------------------
-- Table `upusa`.`payment_entity`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `upusa`.`payment_entity` ;

CREATE TABLE IF NOT EXISTS `upusa`.`payment_entity` (
  `bank_id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `payment_entity_name` VARCHAR(45) NOT NULL,
  `payment_address_street1` VARCHAR(45) NOT NULL,
  `payment_address_street2` VARCHAR(45) NULL,
  `payment_address_city` VARCHAR(45) NOT NULL,
  `payment_address_state` VARCHAR(45) NOT NULL,
  `payment_address_zip` INT NOT NULL,
  `payment_contact` BIGINT(20) NOT NULL,
  `payment_email` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`bank_id`),
  UNIQUE INDEX `bank_id_UNIQUE` (`bank_id` ASC) VISIBLE,
  UNIQUE INDEX `payment_contact_UNIQUE` (`payment_contact` ASC) VISIBLE,
  UNIQUE INDEX `payment_email_UNIQUE` (`payment_email` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `upusa`.`upusa_user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `upusa`.`upusa_user` ;

CREATE TABLE IF NOT EXISTS `upusa`.`upusa_user` (
  `upusa_SSN` INT(11) NOT NULL,
  `full_name` VARCHAR(45) NULL DEFAULT NULL,
  `user_address_street1` VARCHAR(45) NULL DEFAULT NULL,
  `user_address_street2` VARCHAR(45) NULL DEFAULT NULL,
  `user_address_city` VARCHAR(45) NULL DEFAULT NULL,
  `user_address_state` VARCHAR(45) NULL DEFAULT NULL,
  `user_email` VARCHAR(45) NOT NULL DEFAULT 'TEST1@TEST.COM',
  `user_contact` BIGINT(20) NOT NULL DEFAULT ((now() + 0) / 10000),
  `user_name` VARCHAR(50) NOT NULL DEFAULT 'GROUP 2 FROM BOSTON',
  `password` VARCHAR(50) NOT NULL DEFAULT '123',
  PRIMARY KEY (`upusa_SSN`),
  UNIQUE INDEX `upusa_SSN_UNIQUE` (`upusa_SSN` ASC) VISIBLE,
  UNIQUE INDEX `userName_UNIQUE` (`user_name` ASC) VISIBLE,
  UNIQUE INDEX `user_email_UNIQUE` (`user_email` ASC) VISIBLE,
  UNIQUE INDEX `user_contact_UNIQUE` (`user_contact` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `upusa`.`biller_entity`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `upusa`.`biller_entity` ;

CREATE TABLE IF NOT EXISTS `upusa`.`biller_entity` (
  `biller_id` INT NOT NULL AUTO_INCREMENT,
  `biller_entity_name` VARCHAR(45) NOT NULL,
  `biller_address_street1` VARCHAR(45) NOT NULL,
  `biller_address_street2` VARCHAR(45) NULL,
  `biller_address_city` VARCHAR(45) NOT NULL,
  `biller_address_state` VARCHAR(45) NOT NULL,
  `biller_address_zip` VARCHAR(45) NOT NULL,
  `biller_contact` BIGINT(20) NOT NULL,
  `biller_email` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`biller_id`),
  UNIQUE INDEX `biller_id_UNIQUE` (`biller_id` ASC) VISIBLE,
  UNIQUE INDEX `biller_contact_UNIQUE` (`biller_contact` ASC) VISIBLE,
  UNIQUE INDEX `biller_email_UNIQUE` (`biller_email` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `upusa`.`user_bank_account_info`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `upusa`.`user_bank_account_info` ;

CREATE TABLE IF NOT EXISTS `upusa`.`user_bank_account_info` (
  `user_id` INT(11) NULL,
  `bank_account_number` BIGINT(20) NOT NULL,
  `bank_id` BIGINT(20) NOT NULL,
  `unique_user_bank_info` INT(11) NOT NULL,
  `biller_id` INT NULL,
  PRIMARY KEY (`unique_user_bank_info`),
  UNIQUE INDEX `bank_account_number_UNIQUE` (`bank_account_number` ASC) VISIBLE,
  UNIQUE INDEX `unique_user_bank_info_UNIQUE` (`unique_user_bank_info` ASC) VISIBLE,
  INDEX `upusa_SSN_idx` (`user_id` ASC) VISIBLE,
  INDEX `bank_id_fk` (`bank_id` ASC) VISIBLE,
  INDEX `biller_id_fk_idx` (`biller_id` ASC) VISIBLE,
  CONSTRAINT `bank_id_fk`
    FOREIGN KEY (`bank_id`)
    REFERENCES `upusa`.`payment_entity` (`bank_id`),
  CONSTRAINT `upusa_SSN_reference`
    FOREIGN KEY (`user_id`)
    REFERENCES `upusa`.`upusa_user` (`upusa_SSN`),
  CONSTRAINT `biller_id_fk`
    FOREIGN KEY (`biller_id`)
    REFERENCES `upusa`.`biller_entity` (`biller_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `upusa`.`bill_payments`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `upusa`.`bill_payments` ;

CREATE TABLE IF NOT EXISTS `upusa`.`bill_payments` (
  `bill_unique_index` INT(11) NOT NULL AUTO_INCREMENT,
  `user_biller_account_number` BIGINT(20) NOT NULL,
  `biller_bill_id` BIGINT(20) NOT NULL,
  `bill_amount` INT(11) NOT NULL,
  `bill_paid` TINYINT(4) NOT NULL,
  `unique_user_bank_info` INT(11) NOT NULL,
  `bill_payment_date` DATETIME NULL DEFAULT NULL,
  `bill_payment_due_dt` DATETIME NOT NULL,
  `bill_payment_delay_allowed` TINYINT(1) NOT NULL,
  `biller_id` INT NOT NULL,
  `service_type_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`bill_unique_index`),
  UNIQUE INDEX `biller_bill_id_UNIQUE` (`biller_bill_id` ASC) VISIBLE,
  UNIQUE INDEX `unique_index_UNIQUE` (`bill_unique_index` ASC) VISIBLE,
  INDEX `bank_account_reference_idx` (`unique_user_bank_info` ASC) VISIBLE,
  INDEX `biller_id_fk_idx` (`biller_id` ASC) VISIBLE,
  CONSTRAINT `bank_account_reference`
    FOREIGN KEY (`unique_user_bank_info`)
    REFERENCES `upusa`.`user_bank_account_info` (`unique_user_bank_info`),
  CONSTRAINT `biller_id_fk_bill`
    FOREIGN KEY (`biller_id`)
    REFERENCES `upusa`.`biller_entity` (`biller_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `upusa`.`Transaction`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `upusa`.`Transaction` ;

CREATE TABLE IF NOT EXISTS `upusa`.`Transaction` (
  `user_id` INT NOT NULL,
  `bill_id` INT NOT NULL,
  `user_bank_acc_info` INT NOT NULL,
  `date_of_payment` DATETIME NOT NULL,
  INDEX `user_id_fk_idx` (`user_id` ASC) VISIBLE,
  INDEX `bill_id_fk_idx` (`bill_id` ASC) VISIBLE,
  INDEX `user_bank_acc_info_fk_idx` (`user_bank_acc_info` ASC) VISIBLE,
  CONSTRAINT `user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `upusa`.`upusa_user` (`upusa_SSN`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `bill_id_fk`
    FOREIGN KEY (`bill_id`)
    REFERENCES `upusa`.`bill_payments` (`bill_unique_index`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `user_bank_acc_info_fk`
    FOREIGN KEY (`user_bank_acc_info`)
    REFERENCES `upusa`.`user_bank_account_info` (`unique_user_bank_info`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `upusa`.`biller_routing`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `upusa`.`biller_routing` ;

CREATE TABLE IF NOT EXISTS `upusa`.`biller_routing` (
  `biller_id` INT NOT NULL,
  `API_call` VARCHAR(45) NOT NULL,
  `call_type` ENUM('GET', 'POST') NOT NULL,
  INDEX `biller_id_fk_idx` (`biller_id` ASC) VISIBLE,
  CONSTRAINT `biller_id_fk_routing`
    FOREIGN KEY (`biller_id`)
    REFERENCES `upusa`.`biller_entity` (`biller_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `upusa`.`bank_routing`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `upusa`.`bank_routing` ;

CREATE TABLE IF NOT EXISTS `upusa`.`bank_routing` (
  `bank_id` BIGINT(20) NOT NULL,
  `API_call` VARCHAR(45) NOT NULL,
  `call_type` ENUM('GET', 'POST') NOT NULL,
  INDEX `bank_id_fk_idx` (`bank_id` ASC) VISIBLE,
  CONSTRAINT `bank_id_fk_routing`
    FOREIGN KEY (`bank_id`)
    REFERENCES `upusa`.`payment_entity` (`bank_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `upusa` ;

-- -----------------------------------------------------
-- procedure check_user
-- -----------------------------------------------------

USE `upusa`;
DROP procedure IF EXISTS `upusa`.`check_user`;

DELIMITER $$
USE `upusa`$$
CREATE PROCEDURE `check_user`(
in username varchar(255),
in password varchar(255),
out result boolean
)
begin
declare userExistence int;

select count(*)
into userExistence
from upusa_user
where upusa_user.user_name = username and upusa_user.password = password;

if userExistence > 0 then
set result = true;
else
set result = false;
end if;
end$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure check_user_credentials
-- -----------------------------------------------------

USE `upusa`;
DROP procedure IF EXISTS `upusa`.`check_user_credentials`;

DELIMITER $$
USE `upusa`$$
CREATE PROCEDURE `check_user_credentials`(
in ssn int,
in address_street1 varchar(45),
in address_city varchar(45),
in address_state varchar(45)
)
begin

declare user_validity tinyint default true;
DECLARE CONTINUE HANDLER FOR 1062
SET user_validity = FALSE;

insert into upusa_user(upusa_ssn, user_address_street1, user_address_city, user_address_state) values (ssn, address_street1,
address_city, address_state);
 
if user_validity = TRUE then
select 'Successful validation' as message;
else
select 'Unsuccessful validation' as message;
end if;

end$$

DELIMITER ;

