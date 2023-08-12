/* 1. Create a database named employee, then import data_science_team.csv proj_table.csv and emp_record_table.csv into the employee database from the given resources.*/
CREATE DATABASE EMPLOYEE;

USE EMPLOYEE;
SELECT * FROM DATA_SCIENCE_TEAM;
SELECT * FROM EMP_RECORD_TABLE;
SELECT * FROM PROJ_TABLE;

/* 3.Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table,
 and make a list of employees and details of their department.*/
 SELECT EMP_ID,FIRST_NAME,LAST_NAME,GENDER,DEPT FROM EMP_RECORD_TABLE;
 
 /* 4Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is: 
less than two. .*/
SELECT EMP_ID,FIRST_NAME,LAST_NAME,GENDER,DEPT,EMP_RATING FROM EMP_RECORD_TABLE
WHERE EMP_RATING < 2;
/*greater than four */
SELECT EMP_ID,FIRST_NAME,LAST_NAME,GENDER,DEPT,EMP_RATING FROM EMP_RECORD_TABLE
WHERE EMP_RATING >4;
/*between two and four*/
SELECT EMP_ID,FIRST_NAME,LAST_NAME,GENDER,DEPT,EMP_RATING FROM EMP_RECORD_TABLE
WHERE EMP_RATING BETWEEN 2 AND 4
ORDER BY EMP_RATING;

/* 5.Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance 
department from the employee table and then give the resultant column alias as NAME.*/
  SELECT  concat(FIRST_NAME," ",LAST_NAME) AS NAME,DEPT FROM  EMP_RECORD_TABLE
  WHERE DEPT IN("FINANCE");
  
  /*6.Write a query to list only those employees who have someone reporting to them. Also, show the number of reporters (including the President).*/
  SELECT first_name,last_name,role,manager_id, count(emp_id) 
FROM emp_record_table 
GROUP BY manager_id ORDER BY manager_id ASC;

/*7.Write a query to list down all the employees from the healthcare and finance departments using union. Take data from the employee record table.*/
   SELECT E.FIRST_NAME,E.LAST_NAME,E.ROLE,E.DEPT FROM EMP_RECORD_TABLE E WHERE DEPT = "FINANCE"
  UNION 
  SELECT A.FIRST_NAME,A.LAST_NAME,A.ROLE,A.DEPT FROM EMP_RECORD_TABLE A WHERE DEPT ="HEALTHCARE";
  
  /*8.Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, 
  and EMP_RATING grouped by dept. Also include the respective employee rating along with the max emp rating for the department.*/
  
  SELECT EMP_ID,FIRST_NAME,LAST_NAME,ROLE,DEPT,EMP_RATING,MAX(EMP_RATING) FROM EMP_RECORD_TABLE 
  GROUP BY DEPT;
  
  /*9.Write a query to calculate the minimum and the maximum salary of the employees in each role. Take data from the employee record table.*/
SELECT ROLE,max(SALARY),MIN(SALARY) FROM EMP_RECORD_TABLE 
GROUP BY ROLE;

/* 10.Write a query to assign ranks to each employee based on their experience. Take data from the employee record table.*/
SELECT * ,RANK()OVER(ORDER BY EXP)  AS RANK_BASEDON_EXP,dense_rank()OVER(ORDER BY EXP) AS DENSE_RANK_ONEXP,
ROW_NUMBER() OVER(ORDER BY EXP)  AS ROW_NUM_ON_EXP,percent_rank () OVER(ORDER BY EXP)  AS PERCENTRANK_ON_EXP FROM EMP_RECORD_TABLE;

/*11.Write a query to create a view that displays employees in various countries whose salary is more than six thousand. Take data from the employee record table.*/
CREATE VIEW EMP_DETAILS_ONCOUNTRY AS
SELECT EMP_ID,concat(FIRST_NAME," ",LAST_NAME) AS FULL_NAME,ROLE,DEPT,EXP,SALARY FROM EMP_RECORD_TABLE
WHERE SALARY >6000;
SELECT * FROM EMP_DETAILS_ONCOUNTRY;

/* 12.Write a nested query to find employees with experience of more than ten years. Take data from the employee record table.*/
SELECT EMP_ID,FIRST_NAME,LAST_NAME,ROLE,DEPT,EXP FROM  EMP_RECORD_TABLE WHERE EXP =ANY
(SELECT  EXP FROM EMP_RECORD_TABLE WHERE EXP >10);

/* 13.Write a query to create a stored procedure to retrieve the details of the employees whose experience is more than three years. Take data from the employee record table.*/
DELIMITER &&
CREATE PROCEDURE EXP_MORETHAN_TEN(  )
BEGIN
SELECT * FROM EMP_RECORD_TABLE WHERE EXP >10;
END &&
CALL EXP_MORETHAN_TEN();

/*14.Write a query using stored functions in the project table to check whether the job profile assigned to each
 employee in the data science team matches the organization’s set standard.
The standard being:
For an employee with experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST',
For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST',
For an employee with the experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST',
For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST',
For an employee with the experience of 12 to 16 years assign 'MANAGER'.*/
 DELIMITER &&
CREATE FUNCTION CUSTOMER_DETAILS (EXP INT)
RETURNS VARCHAR(225) DETERMINISTIC
BEGIN DECLARE  CUSTOMER_DETAILS  VARCHAR (225);
IF EXP <2 THEN SET  CUSTOMER_DETAILS="JUNIOR DATA SCIENTIST";
ELSEIF EXP >=2 AND EXP <5 THEN SET  CUSTOMER_DETAILS="ASSOCIATE DATA SCIENTIST";
 ELSEIF EXP >=5 AND EXP <10 THEN SET  CUSTOMER_DETAILS="SENIOR DATA SCIENTIST";
ELSEIF EXP >=10 AND EXP >12 THEN SET  CUSTOMER_DETAILS="LEAD DATA SCIENTIST";
ELSEIF EXP >=12 AND EXP <16 THEN SET  CUSTOMER_DETAILS="MANAGER";
END IF;RETURN(CUSTOMER_DETAILS);END && DELIMITER &&;

SELECT CONCAT(FIRST_NAME," ",LAST_NAME) AS FULL_NAME,EXP,COUNTRY,CUSTOMER_DETAILS(EXP) AS DESIGNATION FROM EMP_RECORD_TABLE
ORDER BY EXP;

/*15.Create an index to improve the cost and performance of the query to find the employee whose FIRST_NAME 
is ‘Eric’ in the employee table after checking the execution plan.*/
CREATE INDEX INDEX_ON_FIRSTNAME ON EMP_RECORD_TABLE(FIRST_NAME);
select * from emp_record_table where first_name="eric";

/*16./*Write a query to calculate the bonus for all the employees, based on their ratings and salaries (Use the formula: 5% of salary * employee rating).*/

SELECT EMP_ID,FIRST_NAME,LAST_NAME,SALARY,EMP_RATING,((0.05*SALARY)*EMP_RATING) AS BONUS FROM EMP_RECORD_TABLE
ORDER BY EMP_ID ASC;

/*17.Write a query to calculate the average salary distribution based on the continent and country. Take data from the employee record table.*/
SELECT country, AVG(salary) FROM emp_record_table GROUP BY country;
SELECT continent, AVG(salary) FROM emp_record_table GROUP BY continent;
