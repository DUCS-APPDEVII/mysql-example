-- MySQL Script generated by MySQL Workbench
-- Tue Apr 13 12:14:21 2021
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema scott
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema scott
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `scott` DEFAULT CHARACTER SET utf8 ;
USE `scott` ;

-- -----------------------------------------------------
-- Table `scott`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `scott`.`user` ;

CREATE TABLE IF NOT EXISTS `scott`.`user` (
  `uid` INT NOT NULL AUTO_INCREMENT,
  `password` VARCHAR(60) NOT NULL,
  `email` VARCHAR(60) NOT NULL,
  `lname` VARCHAR(45) NOT NULL,
  `fname` VARCHAR(45) NOT NULL,
  `role` ENUM('student', 'instructor') NOT NULL,
  `created` DATETIME NOT NULL DEFAULT now(),
  PRIMARY KEY (`uid`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `scott`.`student`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `scott`.`student` ;

CREATE TABLE IF NOT EXISTS `scott`.`student` (
  `sid` INT NOT NULL,
  `uid` INT NOT NULL,
  `major` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`sid`, `uid`),
  INDEX `fk_student_user_idx` (`uid` ASC) VISIBLE,
  CONSTRAINT `fk_student_user`
    FOREIGN KEY (`uid`)
    REFERENCES `scott`.`user` (`uid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `scott`.`project`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `scott`.`project` ;

CREATE TABLE IF NOT EXISTS `scott`.`project` (
  `projectid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `date_created` DATETIME NOT NULL,
  PRIMARY KEY (`projectid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `scott`.`worksession`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `scott`.`worksession` ;

CREATE TABLE IF NOT EXISTS `scott`.`worksession` (
  `worksessionid` INT NOT NULL AUTO_INCREMENT,
  `student_studentid` INT NOT NULL,
  `student_user_userId` INT NOT NULL,
  `project_projectid` INT NOT NULL,
  `date` DATETIME NOT NULL DEFAULT now(),
  `start` TIME NOT NULL,
  `finish` TIME NOT NULL,
  `code` CHAR(2) NOT NULL,
  `code90Desc` TEXT NOT NULL,
  `description` TEXT NOT NULL,
  PRIMARY KEY (`worksessionid`, `student_studentid`, `student_user_userId`, `project_projectid`),
  INDEX `fk_worksession_student1_idx` (`student_studentid` ASC, `student_user_userId` ASC) VISIBLE,
  INDEX `fk_worksession_project1_idx` (`project_projectid` ASC) VISIBLE,
  CONSTRAINT `fk_worksession_student1`
    FOREIGN KEY (`student_studentid` , `student_user_userId`)
    REFERENCES `scott`.`student` (`sid` , `uid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_worksession_project1`
    FOREIGN KEY (`project_projectid`)
    REFERENCES `scott`.`project` (`projectid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `scott`.`course`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `scott`.`course` ;

CREATE TABLE IF NOT EXISTS `scott`.`course` (
  `cid` INT NOT NULL AUTO_INCREMENT,
  `dept` CHAR(4) NOT NULL,
  `number` CHAR(3) NOT NULL,
  `name` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`cid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `scott`.`instructor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `scott`.`instructor` ;

CREATE TABLE IF NOT EXISTS `scott`.`instructor` (
  `uid` INT NOT NULL,
  `dept` CHAR(4) NOT NULL,
  PRIMARY KEY (`uid`),
  CONSTRAINT `fk_instructor_user1`
    FOREIGN KEY (`uid`)
    REFERENCES `scott`.`user` (`uid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `scott`.`course-offering`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `scott`.`course-offering` ;

CREATE TABLE IF NOT EXISTS `scott`.`course-offering` (
  `uid` INT NOT NULL,
  `cid` INT NOT NULL,
  `semester` CHAR(4) NOT NULL,
  PRIMARY KEY (`uid`, `cid`),
  INDEX `fk_instructor_has_course_course1_idx` (`cid` ASC) VISIBLE,
  INDEX `fk_instructor_has_course_instructor1_idx` (`uid` ASC) VISIBLE,
  CONSTRAINT `fk_instructor_has_course_instructor1`
    FOREIGN KEY (`uid`)
    REFERENCES `scott`.`instructor` (`uid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_instructor_has_course_course1`
    FOREIGN KEY (`cid`)
    REFERENCES `scott`.`course` (`cid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `scott`.`course-offering_has_project`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `scott`.`course-offering_has_project` ;

CREATE TABLE IF NOT EXISTS `scott`.`course-offering_has_project` (
  `course-offering_instructor_instructorId` INT NOT NULL,
  `course-offering_instructor_user_userId` INT NOT NULL,
  `course-offering_course_courseId` INT NOT NULL,
  `project_projectid` INT NOT NULL,
  PRIMARY KEY (`course-offering_instructor_instructorId`, `course-offering_instructor_user_userId`, `course-offering_course_courseId`, `project_projectid`),
  INDEX `fk_course-offering_has_project_project1_idx` (`project_projectid` ASC) VISIBLE,
  INDEX `fk_course-offering_has_project_course-offering1_idx` (`course-offering_instructor_instructorId` ASC, `course-offering_instructor_user_userId` ASC, `course-offering_course_courseId` ASC) VISIBLE,
  CONSTRAINT `fk_course-offering_has_project_course-offering1`
    FOREIGN KEY (`course-offering_instructor_user_userId` , `course-offering_course_courseId`)
    REFERENCES `scott`.`course-offering` (`uid` , `cid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_course-offering_has_project_project1`
    FOREIGN KEY (`project_projectid`)
    REFERENCES `scott`.`project` (`projectid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `scott`.`works-on`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `scott`.`works-on` ;

CREATE TABLE IF NOT EXISTS `scott`.`works-on` (
  `student_sid` INT NOT NULL,
  `student_uid` INT NOT NULL,
  `project_projectid` INT NOT NULL,
  `semester` CHAR(4) NULL,
  PRIMARY KEY (`student_sid`, `student_uid`, `project_projectid`),
  INDEX `fk_student_has_project_project1_idx` (`project_projectid` ASC) VISIBLE,
  INDEX `fk_student_has_project_student1_idx` (`student_sid` ASC, `student_uid` ASC) VISIBLE,
  CONSTRAINT `fk_student_has_project_student1`
    FOREIGN KEY (`student_sid` , `student_uid`)
    REFERENCES `scott`.`student` (`sid` , `uid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_student_has_project_project1`
    FOREIGN KEY (`project_projectid`)
    REFERENCES `scott`.`project` (`projectid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
