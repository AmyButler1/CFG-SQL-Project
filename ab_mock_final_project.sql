######### AMY BUTLER PROJECT#################
#########Indicators and Risk factors of Malaria in Cats in reserves in Iceland and  Chad ############


SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema ab_mock_project_db
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema ab_mock_project_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ab_mock_project_db` ;
USE `ab_mock_project_db` ;

-- -----------------------------------------------------
-- Table `ab_mock_project_db`.`location_annual_data`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ab_mock_project_db`.`location_annual_data` (
  `COUNTRY` VARCHAR(45) NOT NULL,
  `YEAR` INT NOT NULL,
  `AVERAGE_RAINFALL_MM` INT NULL DEFAULT NULL,
  `AVERAGE_TEMP_°C` INT NULL DEFAULT NULL,
  `LOCATION_DATA_ID` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`LOCATION_DATA_ID`),
  INDEX `FK_COUNTRY_ANNUAL_idx` (`COUNTRY` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `ab_mock_project_db`.`population_data`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ab_mock_project_db`.`population_data` (
  `COUNTRY` VARCHAR(45) NOT NULL,
  `DATE_OF_COUNT` DATE NOT NULL,
  `CAT_POPULATION_SIZE` INT NULL DEFAULT NULL,
  `COW_POPULATION_SIZE` INT NULL DEFAULT NULL,
  `POPULATION_COUNT_ID` INT NOT NULL,
  PRIMARY KEY (`POPULATION_COUNT_ID`),
  INDEX `COUNTRY_idx` (`COUNTRY` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `ab_mock_project_db`.`cat_id_table`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ab_mock_project_db`.`cat_id_table` (
  `CAT_ID` INT NOT NULL,
  `DOB` DATE NOT NULL,
  `COUNTRY` VARCHAR(45) NOT NULL,
  `FUR_COLOUR` VARCHAR(45) NOT NULL,
  `BLOOD_TYPE` VARCHAR(45) NOT NULL,
  `SEX` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`CAT_ID`),
  INDEX `FK_COUNTRY2_idx` (`COUNTRY` ASC) VISIBLE,
  CONSTRAINT `FK_COUNTRY2`
    FOREIGN KEY (`COUNTRY`)
    REFERENCES `ab_mock_project_db`.`location_annual_data` (`COUNTRY`),
  CONSTRAINT `FK_COUNTRY3`
    FOREIGN KEY (`COUNTRY`)
    REFERENCES `ab_mock_project_db`.`population_data` (`COUNTRY`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `ab_mock_project_db`.`cat_measurements`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ab_mock_project_db`.`cat_measurements` (
  `MEASUREMENT_ID` INT NOT NULL,
  `CAT_ID` INT NOT NULL,
  `DATE_OF_MEASUREMENT` DATE NOT NULL,
  `WEIGHT_KG` INT NULL DEFAULT NULL,
  `HEIGHT_CM` INT NULL DEFAULT NULL,
  PRIMARY KEY (`MEASUREMENT_ID`),
  INDEX `FK_CAT_ID_idx` (`CAT_ID` ASC) VISIBLE,
  CONSTRAINT `FK_CAT_ID`
    FOREIGN KEY (`CAT_ID`)
    REFERENCES `ab_mock_project_db`.`cat_id_table` (`CAT_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `ab_mock_project_db`.`malarial_status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ab_mock_project_db`.`malarial_status` (
  `CAT_ID` INT NOT NULL,
  `DATE_OF_TEST` DATE NOT NULL,
  `MALARIAL_STATUS` VARCHAR(45) NULL DEFAULT NULL,
  `TEST_ID` INT NOT NULL,
  PRIMARY KEY (`TEST_ID`),
  INDEX `FK_CAT_ID2_idx` (`CAT_ID` ASC) VISIBLE,
  CONSTRAINT `FK_CAT_ID2`
    FOREIGN KEY (`CAT_ID`)
    REFERENCES `ab_mock_project_db`.`cat_id_table` (`CAT_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

select * from cat_id_table;
select * from cat_measurements;
select * from malarial_status;
select * from location_annual_data;
select * from population_data;

### average rainfall in iceland ###
SELECT L.AVERAGE_RAINFALL_MM
FROM location_annual_data L
WHERE L.COUNTRY = 'ICELAND';

####  The sex of individuals in the chad reserve? ####
# FOR BREEDING PROGRAMMES WOULD BE VITAL TO KNOW SEX OF INDIVIDUALS IN EACH LOCATION
SELECT C.SEX
FROM cat_id_table C
WHERE C.COUNTRY = 'CHAD';

#### Individuals with blue fur or R+ blood type ####
## IF BLOOD TYPE R+ AND BLUE FUR WHERE FOUND TO CORRELATE WITH HIGHER SENSITIVITY TO MALARIA, INDIVIUALS WITH ONE OR BOTH COULD BE FOUND BY:
SELECT C.FUR_COLOUR, C.BLOOD_TYPE, C.CAT_ID
FROM cat_id_table C
WHERE C.FUR_COLOUR = 'BLUE'
OR C.BLOOD_TYPE = 'R+';


#### order cat_ids by weight from year 2017 ####
SELECT
M.Cat_id, M.WEIGHT_KG, M.DATE_OF_MEASUREMENT
FROM cat_measurements M
WHERE M.DATE_OF_MEASUREMENT = '2017-05-07'
ORDER BY M.WEIGHT_KG;

#### what is the total number of cats in the database? ####
### total number of cats = 15
SELECT
count(c.cat_id)
FROM cat_id_table c;


### left join
SELECT C.CAT_ID, M.WEIGHT_KG, C.SEX
FROM cat_measurements M LEFT JOIN cat_id_table C
ON C.CAT_ID=M.CAT_ID;


#############################################################################################################################
#############################################################################################################################
##### query on joined table -- showing only female cats with weight less than 220kg ######
## for example if low body weight was shown to be a indicator of malarial infection in females ##
##shows all female cats that weigh below 220kg have pink fur - if real data possible correlation?
SELECT C.CAT_ID, M.WEIGHT_KG, M.DATE_OF_MEASUREMENT, C.FUR_COLOUR
FROM cat_measurements M LEFT JOIN cat_id_table C
ON C.CAT_ID=M.CAT_ID
WHERE C.SEX = 'FEMALE' and M.WEIGHT_KG<220;





############################################################################################################################
############################################################################################################################
#### counts the number of cats positive for malaria from each year - group by ######
SELECT
COUNT(S.MALARIAL_STATUS),
S.MALARIAL_STATUS, DATE_OF_TEST
FROM malarial_status S
WHERE  S.MALARIAL_STATUS= 'POSITIVE'
GROUP BY DATE_OF_TEST
;

##### find average weight of female cat measured on 7/5/2017
SELECT
AVG(M.WEIGHT_KG)
FROM cat_measurements M LEFT JOIN cat_id_table C
ON C.CAT_ID=M.CAT_ID
WHERE c.sex='female' and M.DATE_OF_MEASUREMENT = '2017-05-07';



### create view ####

CREATE VIEW cat_female_less_than_220kg_fur
AS
SELECT C.CAT_ID, M.WEIGHT_KG, C.FUR_COLOUR
FROM cat_measurements M LEFT JOIN cat_id_table C
ON C.CAT_ID=M.CAT_ID
WHERE C.SEX = 'FEMALE' and M.WEIGHT_KG<220;

select * from cat_female_less_than_220kg_fur;
##shows all female cats from that year that weigh below 220kg have pink fur - correlation?

### average weight from view ####
SELECT
AVG(WEIGHT_KG)
FROM cat_female_less_than_220kg_fur;

##################################################################################################################################
##################################################################################################################################
##create set procedure for female cats

DELIMITER //
CREATE PROCEDURE female_cats()
BEGIN
SELECT C.CAT_ID, C.SEX
FROM cat_id_table C
WHERE C.SEX = 'female';
END //
DELIMITER ;

CALL female_cats();

################################################################################################################################
################################################################################################################################
#### view of 3 tables ##########################################################################################################
CREATE VIEW malaria_cats_weight
AS
SELECT
  C.CAT_ID,
  C.SEX,
  S.MALARIAL_STATUS,
  M.WEIGHT_KG,
  M.DATE_OF_MEASUREMENT
FROM cat_id_table C
Left JOIN malarial_status S
  ON C.CAT_ID = S.CAT_ID
Left JOIN cat_measurements M
  ON C.CAT_ID = M.CAT_ID;
  
select * from malaria_cats_weight;
#### average weight of female cat positive for malaria #######################################################
SELECT
AVG(M.Weight_kg)
FROM  malaria_cats_weight M
WHERE M.SEX = 'FEMALE' and M.malarial_status = 'positive';




#################################################################################################################
#################################################################################################################
#### set function #####


DELIMITER //
CREATE FUNCTION warning_levels(weight_kg INT)
Returns VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE warning_level VARCHAR(20);
    IF weight_kg > 250 THEN
		SET warning_level = 'low';
    ELSEIF (weight_kg <= 250 AND 
			weight_kg >= 220) THEN
        SET warning_level = 'Medium';
    ELSEIF weight_kg < 220 THEN
        SET warning_level = 'High';
    END IF;
	RETURN (warning_Level);
END//weight_kg
DELIMITER ;

select
cat_id, date_of_measurement, weight_kg, warning_levels(weight_kg)
from cat_measurements
