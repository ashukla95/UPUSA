-- -----------------------------------------------------
-- Schema UPUSA
-- -----------------------------------------------------
drop database if exists UPUSA;
CREATE SCHEMA IF NOT EXISTS `UPUSA`;
USE `UPUSA` ;



-- -----------------------------------------------------
-- Table `UPUSA`.`upusa_user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `UPUSA`.`upusa_user` ;

-- CREATE TABLE IF NOT EXISTS `UPUSA`.`upusa_user` (
--   `upusa_SSN` INT NOT NULL,
--   `user_name` VARCHAR(45) NOT NULL,
--   `user_address_street1` VARCHAR(45) NOT NULL,
--   `user_address_street2` VARCHAR(45),
--   `user_address_city` VARCHAR(45) NOT NULL,
--   `user_address_state` VARCHAR(45) NOT NULL,
--   `user_email` VARCHAR(45) NOT NULL,
--   `user_contact` BIGINT(20) NOT NULL,
--   PRIMARY KEY (`upusa_SSN`),
--   UNIQUE INDEX `upusa_SSN_UNIQUE` (`upusa_SSN` ASC) VISIBLE,
--   UNIQUE INDEX `userName_UNIQUE` (`user_name` ASC) VISIBLE,
--   UNIQUE INDEX `user_email_UNIQUE` (`user_email` ASC) VISIBLE,
--   UNIQUE INDEX `user_contact_UNIQUE` (`user_contact` ASC) VISIBLE)
-- ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `UPUSA`.`upusa_user` (
  `upusa_SSN` INT DEFAULT ((NOW()+0) /10000),
  `full_name` VARCHAR(45),
  `user_address_street1` VARCHAR(45),
  `user_address_street2` VARCHAR(45),
  `user_address_city` VARCHAR(45),
  `user_address_state` VARCHAR(45),
  `user_email` VARCHAR(45) NOT NULL DEFAULT 'TEST1@TEST.COM',
  `user_contact` BIGINT(20) NOT NULL DEFAULT ((NOW()+0) /10000),
  `user_name` VARCHAR(50) NOT NULL DEFAULT 'GROUP 2 FROM BOSTON',
  `password` VARCHAR(50) NOT NULL, 
  PRIMARY KEY (`upusa_SSN`),
  UNIQUE INDEX `upusa_SSN_UNIQUE` (`upusa_SSN` ASC) VISIBLE,
  UNIQUE INDEX `userName_UNIQUE` (`user_name` ASC) VISIBLE,
  UNIQUE INDEX `user_email_UNIQUE` (`user_email` ASC) VISIBLE,
  UNIQUE INDEX `user_contact_UNIQUE` (`user_contact` ASC) VISIBLE)
ENGINE = InnoDB;

ALTER TABLE upusa_user
modify password varchar(50) NOT NULL DEFAULT 123;
-- -----------------------------------------------------
-- Table `UPUSA`.`payment_entity`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `UPUSA`.`payment_entity` ;

CREATE TABLE IF NOT EXISTS `UPUSA`.`payment_entity` (
  `bank_id` BIGINT(20) NOT NULL,
  `payment_entity_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`bank_id`),
  UNIQUE INDEX `bank_id_UNIQUE` (`bank_id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `UPUSA`.`user_bank_account_info`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `UPUSA`.`user_bank_account_info` ;

CREATE TABLE IF NOT EXISTS `UPUSA`.`user_bank_account_info` (
  `user_id` INT NOT NULL,
  `bank_account_number` BIGINT(20) NOT NULL,
  `bank_id` BIGINT(20) NOT NULL,
  `unique_user_bank_info` INT NOT NULL,
  UNIQUE INDEX `bank_account_number_UNIQUE` (`bank_account_number` ASC) VISIBLE,
  PRIMARY KEY (`unique_user_bank_info`),
  UNIQUE INDEX `unique_user_bank_info_UNIQUE` (`unique_user_bank_info` ASC) VISIBLE,
  INDEX `upusa_SSN_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `upusa_SSN_reference`
    FOREIGN KEY (`user_id`)
    REFERENCES `UPUSA`.`upusa_user` (`upusa_SSN`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `bank_id_fk`
    FOREIGN KEY (`bank_id`)
    REFERENCES `UPUSA`.`payment_entity` (`bank_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `UPUSA`.`biller_user_information`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `UPUSA`.`biller_user_information` ;

CREATE TABLE IF NOT EXISTS `UPUSA`.`biller_user_information` (
  `user_id` INT NOT NULL,
  `user_biller_account_number` BIGINT(20) NOT NULL,
  `user_biller_id` BIGINT(20) NOT NULL,
  `service_type_name` VARCHAR(20) NOT NULL,
  UNIQUE INDEX `user_biller_account_number_UNIQUE` (`user_biller_account_number` ASC) VISIBLE,
  INDEX `biller_user_SSN_reference_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `biller_user_SSN_reference`
    FOREIGN KEY (`user_id`)
    REFERENCES `UPUSA`.`upusa_user` (`upusa_SSN`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `UPUSA`.`bill_payments`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `UPUSA`.`bill_payments` ;

CREATE TABLE IF NOT EXISTS `UPUSA`.`bill_payments` (
  `bill_unique_index` INT NOT NULL,
  `user_biller_account_number` BIGINT(20) NOT NULL,
  `biller_bill_id` BIGINT(20) NOT NULL,
  `bill_amount` INT NOT NULL,
  `bill_paid` TINYINT NOT NULL,
  `unique_user_bank_info` INT NOT NULL,
  `bill_payment_date` DATETIME,
  `bill_payment_due_dt` DATETIME NOT NULL,
  `bill_payment_delay_allowed` TINYINT(1) NOT NULL,
  UNIQUE INDEX `biller_bill_id_UNIQUE` (`biller_bill_id` ASC) VISIBLE,
  PRIMARY KEY (`bill_unique_index`),
  UNIQUE INDEX `unique_index_UNIQUE` (`bill_unique_index` ASC) VISIBLE,
  INDEX `bank_account_reference_idx` (`unique_user_bank_info` ASC) VISIBLE,
  INDEX `user_viller_account_number_foreign_key_idx` (`user_biller_account_number` ASC) VISIBLE,
  CONSTRAINT `bank_account_reference`
    FOREIGN KEY (`unique_user_bank_info`)
    REFERENCES `UPUSA`.`user_bank_account_info` (`unique_user_bank_info`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `user_viller_account_number_foreign_key`
    FOREIGN KEY (`user_biller_account_number`)
    REFERENCES `UPUSA`.`biller_user_information` (`user_biller_account_number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

select * from upusa_user;
-- INSERT INTO upusa_user VALUES
-- (123456789, 'John Smith', '20 Shwmut St', null, 'Boston', 'MA', 'john25@gmail.com', 8572309178),
-- (748293657, 'Sheila Dsousa', '1173 Cave St', 'Opp Macys 20', 'Los Angeles', 'CA', 'sweetsheiladsouza@yahoo.in', 6175326734),
-- (592638263, 'Rachel P Green', '7B32 Edison Road', null, 'Edison', 'NJ', 'green.r@gmail.com', 6172308776),
-- (390309093, 'Joey Tribbiani', '82C 32nd St', null, 'New York Ciy', 'NY', 'joeyhwd@gmail.com', 8743128920),
-- (195685762, 'Ross Geller', '70A 33rd St', null, 'New York City', 'NY', 'profgeller.ross@gmail.com', 6172387437), 
-- (569236284, 'Jason D Stathom', '177 Dallas Ave', '7th cross road', 'Dallas', 'TX', 'stathom.j@yahoo.in', 6171234567),
-- (628465728, 'Harold Pavlo', '693 Parker St', null, 'Boston', 'MA', 'harold1995@hsuky.neu.edu', 8167263389), 
-- (628462719, 'Dianne Pavlo', '693 Parker St', null, 'Boston', 'MA', 'dianne1993@northeastern.edu', 8174658266), 
-- (291748267, 'Rachel Longbottom', '85 DragonStone', '5th Avenue St', 'Jacksonville', 'FL', 'rachel.tcs@gmail.com', 8572301834),
-- (836492489, 'Amin Khoury', '2 The Hamptons', null, 'Long Island', 'NY', 'khoury.amin@gmail.com', '6717776623');

INSERT INTO upusa_user VALUES
(123456789, 'John Smith', '20 Shwmut St', null, 'Boston', 'MA', 'john25@gmail.com', 8572309178, 'jsmith',123),
(748293657, 'Sheila Dsousa', '1173 Cave St', 'Opp Macys 20', 'Los Angeles', 'CA', 'sweetsheiladsouza@yahoo.in', 6175326734, 'sdsousa',123),
(592638263, 'Rachel P Green', '7B32 Edison Road', null, 'Edison', 'NJ', 'green.r@gmail.com', 6172308776, 'rpg',123),
(390309093, 'Joey Tribbiani', '82C 32nd St', null, 'New York Ciy', 'NY', 'joeyhwd@gmail.com', 8743128920, 'jtribb',123),
(195685762, 'Ross Geller', '70A 33rd St', null, 'New York City', 'NY', 'profgeller.ross@gmail.com', 6172387437, 'rgeller',123), 
(569236284, 'Jason D Stathom', '177 Dallas Ave', '7th cross road', 'Dallas', 'TX', 'stathom.j@yahoo.in', 6171234567, 'jds',123),
(628465728, 'Harold Pavlo', '693 Parker St', null, 'Boston', 'MA', 'harold1995@hsuky.neu.edu', 8167263389, 'hpavlo',123), 
(628462719, 'Dianne Pavlo', '693 Parker St', null, 'Boston', 'MA', 'dianne1993@northeastern.edu', 8174658266, 'dpavlo',123), 
(291748267, 'Rachel Longbottom', '85 DragonStone', '5th Avenue St', 'Jacksonville', 'FL', 'rachel.tcs@gmail.com', 8572301834, 'rlbottom',123),
(836492489, 'Amin Khoury', '2 The Hamptons', null, 'Long Island', 'NY', 'khoury.amin@gmail.com', '6717776623', 'khoury.A',123);

select * from payment_entity;
INSERT INTO payment_entity VALUES
(1, 'Bank Of America Savings Account'),
(2, 'Bank Of America Checkings Account'),
(3, 'Santandar Bank Savings Account'),
(4, 'Santandar Bank Checkings Account'),
(5, 'TD Bank Savings Account'),
(6, 'TD Bank Checkings Account'),
(7, 'VISA'),
(8, 'MASTERCARD'),
(9, 'Google Pay'),
(10, 'PayPal');

use upusa;

select * from user_bank_account_info;
INSERT INTO user_bank_account_info VALUES
(123456789, 8273972847, 1, 101),
(123456789, 1005078235300127, 7, 102),
(748293657, 6483266185, 4, 103),
(592638263, 4117803099456718, 8, 104),
(592638263, 9473625138369322, 7, 105),
(390309093, 667251, 10, 106),
(195685762, 6172387437, 9, 107),
(195685762, 5628176392, 5, 108),
(195685762, 7739273646, 2, 109),
(195685762, 4237642387468374, 7, 110),
(569236284, 4435273642, 3, 111), 
(628465728, 7346134763, 5, 112),
(628465728, 8976578665, 6, 113),
(628462719, 3287463276, 5, 114),
(628462719, 8976547656, 6, 115),
(628462719, 8732443764736441, 7, 116),
(291748267, 8572301834, 9, 117),
(291748267, 2109738261, 1, 118),
(836492489, 5678657513864920, 8, 119),
(836492489, 5678257513864921, 7, 120);

SELECT * from biller_user_information;
describe biller_user_information;
INSERT INTO biller_user_information VALUES 
(123456789,61389, 7801,'Flight'),
(748293657,79628, 7802, 'Movie'),
(592638263,14134, 7803,'Electricity'),
(390309093,98141, 7804,'Gas Bill'),
(195685762,41244, 7805,'Movie'), 
(569236284,20852, 7806,'Electricity'),
(628465728,62083, 7807,'Gas Bill'), 
(628462719,51243, 7808,'Flight'), 
(291748267,31293, 7809,'Gas Bill'),
(836492489,91461, 7810,'Flight'),
(628465728,87522, 7811,'Electricity'),
(836492489,70123, 7812,'Gas Bill'),
(195685762,20194, 7813,'Flight'),
(569236284,49614, 7814,'Electricity'),
(569236284,90128, 7815,'Flight'),
(195685762,80745, 7816,'Parking Ticket'),
(748293657,86583, 7817,'Flight'),
(123456789,35777, 7818,'Electricity'),
(748293657,27847, 7819,'Flight'),
(123456789,57853, 7820,'Speed Ticket');


select * from bill_payments;
describe bill_payments;
insert into bill_payments values 
(1001 , 61389 , 6501 , 287 , 0 , 101 , null , '20190718103009' , 0 ),
(1002 , 79628 , 6502 , 34 , 1 , 102 , '20190722123409' , '20190722123409' , 0 ),
(1003 , 14134 , 6503 , 290 , 0 , 103 , null , '20190810140000' , 1 ),
(1004 , 98141 , 6504 , 789 , 1 , 104 , '20190715163500' , '20190715163500' , 1 ),
(1005 , 41244 , 6505 , 19 , 1, 105 , '20190720105400' , '20190720105400' , 0 ),
(1006 , 20852 , 6506 , 87 , 1 , 106 , '20190714223000' , '20190718103000' , 1 ),
(1007 , 62083 , 6507 , 190 , 0 , 107 , null , '20190730201409' , 1 ),
(1008 , 51243 , 6508 , 238 , 0 , 108 , null , '20190620235500' , 0 ),
(1009 , 31293 , 6509 , 654 , 1 , 109 , '20190724085954' , '20190730065959' , 1 ),
(1010 , 91461 , 6510 , 120 , 1 , 110 , '20190704153000' , '20190704153000' , 0 ),
(1011 , 87522 , 6511 , 190 , 0 , 111 , null , '20190710100000' , 1 ),
(1012 , 70123 , 6512 , 398 , 1 , 112 , '20190712200000' , '20190730195959' , 1 ),
(1013 , 20194 , 6513 , 657 , 1 , 113 , '20190724130000' , '20190724130000' , 0 ),
(1014 , 49614 , 6514 , 475 , 1 , 114 , '20190702163700' , '20190801140000' , 1 ),
(1015 , 90128 , 6515 , 908 , 0 , 115 , null , '20190720120000' , 0 ),
(1016 , 80745 , 6516 , 80 , 1 , 116 , '20190725120000' , '20190725120000' , 0 ),
(1017 , 86583 , 6517 , 8 , 1 , 117 , '20190721170000' , '20190721170000' , 0 ),
(1018 , 35777 , 6518 , 105 , 0 , 118 , null , '20190720190000' , 1 ),
(1019 , 27847 , 6519 , 55 , 1 , 119 , '20190720190000' , '20190720190000' , 0 ),
(1020 , 57853 , 6520 , 6 , 1 , 120 , '20190711100000' , '20190721100000' , 1 );

drop procedure if exists check_user;
delimiter //
create procedure check_user
(
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
end //
delimiter ;
call check_user("rpg",123,@result);
select @result;


drop procedure if exists registerUserInitial;
delimiter //
create procedure registerUserInitial
(
in username varchar(50),
in password varchar(50),
in email varchar(45),
in contact bigint(20),
in ssn int(11),
in fullName varchar(45),
in add1 varchar(45),
in add2 varchar(45),
in city varchar(45),
in state varchar(45)
)
begin
	declare successfulRegistrationFlag tinyint default true;
	declare continue handler for 1062
		set successfulRegistrationFlag = false;
	insert into upusa_user(user_name, password, user_email, user_contact, upusa_ssn, full_name, user_address_street1, user_address_street2, user_address_city, user_address_state) 
    values (username, password, email, contact,ssn, fullName, add1, add2, city, state);
    
    if successfulRegistrationFlag = true then
		select 1 as finalMessage;
	else
		select 0 as finalMessage;
	end if;
end//
delimiter ;


call registerUserInitial('ashukla95',123,'ashukla95@gmail.com',7709747097,987654321,'Ars',"test","test2","boston",'ma');
select * from upusa_user;
delete from upusa_user where user_email = 'ashukla95@gmail.com';

describe upusa_user;


describe upusa_user;

drop procedure if exists get_user_current_bills;
delimiter //
create procedure get_user_current_bills
(
in username varchar(50)
)
begin

select * 
from bill_payments left join biller_user_information on bill_payments.user_biller_account_number = biller_user_information.user_biller_account_number
				   join upusa_user on biller_user_information.user_id = upusa_user.upusa_ssn
where bill_paid = false and upusa_user.user_name = username;
end//
delimiter ;

call get_user_current_bills('jsmith');


drop procedure if exists get_user_bill_history;
delimiter //
create procedure get_user_bill_history
(
in username varchar(50)
)
begin
select bill_payments.user_biller_account_number,biller_bill_id,bill_payment_date,user_biller_id,service_type_name,bill_amount 
from bill_payments left join biller_user_information on bill_payments.user_biller_account_number = biller_user_information.user_biller_account_number
				   join upusa_user on biller_user_information.user_id = upusa_user.upusa_ssn
where bill_paid = true and upusa_user.user_name = username;
end //
delimiter ;

call get_user_bill_history('jsmith');


select * from user_bank_account_info;
drop procedure if exists get_user_bank_information;
delimiter //
create procedure get_user_bank_information
(
in userName varchar(50)
)
begin
	select bank_account_number, user_bank_account_info.bank_id, payment_entity_name
	from user_bank_account_info join upusa_user on upusa_user.upusa_SSN = user_bank_account_info.user_id
								join payment_entity on user_bank_account_info.bank_id = payment_entity.bank_id
	where user_name = userName;
end//
delimiter ;
call get_user_bank_information('jsmith');
select * from upusa_user;


drop procedure if exists get_bill_data;
delimiter //
create procedure get_bill_data
(
in billId bigint(20)
)
begin
	select bill_amount 
    from bill_payments
    where biller_bill_id = billId;
end //
delimiter ;
call get_bill_data(6501);

select * from bill_payments;

select * from upusa_user;

select * 
from bill_payments left join biller_user_information on bill_payments.user_biller_account_number = biller_user_information.user_biller_account_number
				   join upusa_user on biller_user_information.user_id = upusa_user.upusa_ssn;
                   
                   

drop procedure if exists insert_new_bill;
delimiter //
create procedure insert_new_bill
(
userUpusaId int(11),
billId bigint(20),
billAmount int(11),
billGenerationDate datetime,
billDueDate datetime,
paymentDelayAllowed tinyint(1),
serviceName varchar(20)
)
begin
declare successfulFlag boolean;
declare continue handler for sqlexception
	set successfulFlag = false;
start transaction;
insert into bill_payments (biller_bill_id, bill_amount, bill_generation_date, bill_payment_due_dt,service_type_name, bill_payment_delay_allowed, user_upusa_id)
			values(billId, billAmount, billGenerationDate, billDueDate, serviceName, paymentDelayAllowed, userUpusaId);
if successfulFlag = false then
	begin
		rollback;
		select "Insert not possible";
    end;
else
	begin
		commit;
		select "Insert successful";
    end;
end if ;
end //
delimiter ;


drop procedure if exists remove_bill;
delimiter //
create procedure remove_bill
(
 billId bigint(20)
 )
 begin
	declare successful_flag boolean default true;
    
    declare continue handler for sqlexception
		set successful_flag = false;
        
	start transaction;
	update bill_payments
    set 
		bill_paid = true,
        bill_payment_date = now()
        
    where biller_bill_id = billId;
    if successful_flag = false then
	begin
		rollback;
		select "update failed" as finalMessage;
    end;
else
	begin
		commit;
		select "update successful"as finalMessage;
    end;
end if ;
 end//
 delimiter ;
 
 use UPUSA;
 describe bill_payments;