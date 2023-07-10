                    /* DML 연습문제 */
                    
DROP TABLE CUSTOMER_TBL;
DROP TABLE BANK_TBL;


CREATE TABLE BANK_TBL (
    BANK_CODE VARCHAR2(20 BYTE) NOT NULL,
    BANK_NAME VARCHAR2(30 BYTE),
    CONSTRAINT PK_BANK PRIMARY KEY(BANK_CODE)
);

CREATE TABLE CUSTOMER_TBL (
    NO        NUMBER            NOT NULL,
    NAME      VARCHAR2(30 BYTE) NOT NULL,
    PHONE     VARCHAR2(30 BYTE) UNIQUE,
    AGE       NUMBER            CHECK(AGE BETWEEN 0 AND 100),
    BANK_CODE VARCHAR2(20 BYTE),
    CONSTRAINT PK_CUST PRIMARY KEY(NO),
    CONSTRAINT FK_BANK_CUST FOREIGN KEY(BANK_CODE) REFERENCES BANK_TBL(BANK_CODE)
);

-- 1. 은행 테이블에 연락처(BANK_TEL) 칼럼을 추가하시오.
ALTER TABLE BANK_TBL ADD BANK_TEL VARCHAR2(30 BYTE) NOT NULL;

-- 2. 은행 테이블의 은행명(BANK_NAME) 칼럼의 데이터타입을 VARCHAR2(15 BYTE)로 변경하시오.
ALTER TABLE BANK_TBL MODIFY BANK_NAME VARCHAR2(15 BYTE);

-- 3. 고객 테이블의 나이(AGE) 칼럼을 삭제하시오.
ALTER TABLE CUSTOMER_TBL DROP COLUMN AGE;

-- 4. 고객 테이블의 고객번호(NO) 칼럼명을 CUST_NO로 변경하시오.
ALTER TABLE CUSTOMER_TBL RENAME COLUMN NO TO CUST_NO;

-- 5. 고객 테이블에 GRADE 칼럼을 추가하시오. ('VIP', 'GOLD', 'SILVER', 'BRONZE' 중 하나의 값을 가지도록 한다.)
ALTER TABLE CUSTOMER_TBL ADD GRADE VARCHAR2(6 BYTE) NULL CHECK(GRADE IN('VIP', 'GOLD', 'SILVER', 'BRONZE'));

-- 6. 고객 테이블의 고객명(NAME)과 연락처(PHONE) 칼럼 이름을 CUST_NAME, CUST_PHONE으로 변경하시오.
ALTER TABLE CUSTOMER_TBL RENAME COLUMN NAME  TO CUST_NAME;
ALTER TABLE CUSTOMER_TBL RENAME COLUMN PHONE TO CUST_PHONE;

-- 7. 고객 테이블의 연락처(CUST_PHONE) 칼럼을 필수 칼럼으로 변경하시오.
ALTER TABLE CUSTOMER_TBL MODIFY CUST_PHONE NOT NULL;

-- 8. 고객 테이블의 고객명(CUST_NAME) 칼럼의 필수 제약조건을 없애시오.
ALTER TABLE CUSTOMER_TBL MODIFY CUST_NAME NULL;

-- 9. 테이블 구조 확인하기
DESC BANK_TBL;
DESC CUSTOMER_TBL;
                    /* DQL 연습문제 */
                    

DROP TABLE EMPLOYEE_T;
DROP TABLE DEPARTMENT_T;

CREATE TABLE DEPARTMENT_T (
    DEPT_NO   NUMBER            NOT NULL
  , DEPT_NAME VARCHAR2(15 BYTE) NOT NULL
  , LOCATION  VARCHAR2(15 BYTE) NOT NULL
  , CONSTRAINT PK_DEPART PRIMARY KEY(DEPT_NO)
);

CREATE TABLE EMPLOYEE_T (
    EMP_NO    NUMBER            NOT NULL
  , NAME      VARCHAR2(20 BYTE) NOT NULL
  , DEPART    NUMBER            NULL
  , POSITION  VARCHAR2(20 BYTE) NULL
  , GENDER    CHAR(2 BYTE)      NULL
  , HIRE_DATE DATE              NULL
  , SALARY    NUMBER            NULL
  , CONSTRAINT PK_EMPLOYEE PRIMARY KEY(EMP_NO)
  , CONSTRAINT FK_DEPART_EMP FOREIGN KEY(DEPART) REFERENCES DEPARTMENT_T(DEPT_NO) ON DELETE SET NULL
);
DROP SEQUENCE DEPT_SEQ;
CREATE SEQUENCE DEPT_SEQ ORDER;

INSERT INTO DEPARTMENT_T(DEPT_NO, DEPT_NAME, LOCATION) VALUES(DEPT_SEQ.NEXTVAL, '영업부', '대구');
INSERT INTO DEPARTMENT_T(DEPT_NO, DEPT_NAME, LOCATION) VALUES(DEPT_SEQ.NEXTVAL, '인사부', '서울');
INSERT INTO DEPARTMENT_T(DEPT_NO, DEPT_NAME, LOCATION) VALUES(DEPT_SEQ.NEXTVAL, '총무부', '대구');
INSERT INTO DEPARTMENT_T(DEPT_NO, DEPT_NAME, LOCATION) VALUES(DEPT_SEQ.NEXTVAL, '기획부', '서울');
COMMIT;


DROP SEQUENCE EMP_SEQ;
CREATE SEQUENCE EMP_SEQ
    START WITH 1001
    ORDER;

INSERT INTO EMPLOYEE_T(EMP_NO, NAME, DEPART, POSITION, GENDER, HIRE_DATE, SALARY) VALUES(EMP_SEQ.NEXTVAL, '구창민', 1, '과장', 'M', '95-05-01', 5000000);  -- 날짜는 하이픈(-) 또는 슬래시(/)로 구분
INSERT INTO EMPLOYEE_T(EMP_NO, NAME, DEPART, POSITION, GENDER, HIRE_DATE, SALARY) VALUES(EMP_SEQ.NEXTVAL, '김민서', 1, '사원', 'M', '17-09-01', 2500000);  -- 날짜는 하이픈(-) 또는 슬래시(/)로 구분
INSERT INTO EMPLOYEE_T(EMP_NO, NAME, DEPART, POSITION, GENDER, HIRE_DATE, SALARY) VALUES(EMP_SEQ.NEXTVAL, '이은영', 2, '부장', 'F', '90/09/01', 5500000);  -- 날짜는 하이픈(-) 또는 슬래시(/)로 구분
INSERT INTO EMPLOYEE_T(EMP_NO, NAME, DEPART, POSITION, GENDER, HIRE_DATE, SALARY) VALUES(EMP_SEQ.NEXTVAL, '한성일', 2, '과장', 'M', '93/04/01', 5000000);  -- 날짜는 하이픈(-) 또는 슬래시(/)로 구분
COMMIT;

-- 1. 부서번호가 3인 부서의 지역을 '인천'으로 변경하시오.
UPDATE DEPARTMENT_T
   SET LOCATION = '인천'
 WHERE DEPT_NO = 3;

-- 2. 부서번호가 2인 부서에 근무하는 모든 사원들의 연봉을 500000 증가시키시오.
UPDATE EMPLOYEE_T
   SET SALARY = SALARY + 500000
 WHERE DEPART = 2;

-- 3. 지역이 '인천'인 부서를 삭제하시오. ('인천'에 근무하는 사원이 없다.)
DELETE 
  FROM DEPARTMENT_T
 WHERE LOCATION = '인천';

-- 4. 지역이 '서울'인 부서를 삭제하시오. ('서울'에 근무하는 사원이 있다. -> ON DELETE SET NULL 외래키 옵션에 의해서 해당 사원들의 부서정보가 NULL 값으로 처리된다.)
DELETE
  FROM DEPARTMENT_T
 WHERE LOCATION = '서울';
 
COMMIT;
ROLLBACK;


                    /* DQL 연습문제 (HR)*/


-- 1. 사원 테이블에서 FIRST_NAME, LAST_NAME 조회하기
SELECT FIRST_NAME,
       LAST_NAME
  FROM EMPLOYEES;

-- 2. 사원 테이블에서 DEPARTMENT_ID의 중복을 제거하고 조회하기
SELECT DISTINCT DEPARTMENT_ID
  FROM EMPLOYEES
 ORDER BY DEPARTMENT_ID;

-- 3. 사원 테이블에서 EMPLOYEE_ID가 150인 사원의 정보 조회하기
SELECT *
  FROM EMPLOYEES
 WHERE EMPLOYEE_ID = 150;

-- 4. 사원 테이블에서 연봉이 10000 이상인 사원의 정보 조회하기
SELECT *
  FROM EMPLOYEES
 WHERE SALARY >= 10000;

-- 5. 사원 테이블에서 연봉이 10000 이상, 20000 이하인 사원의 정보 조회하기
SELECT *
  FROM EMPLOYEES
 WHERE SALARY BETWEEN 10000 AND 20000;  

-- 6. 사원 테이블에서 부서번호가 30, 40, 50인 사원의 정보 조회하기
SELECT *
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID IN(30, 40, 50);

-- 7. 사원 테이블에서 부서번호가 없는 사원의 정보 조회하기
SELECT *
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID IS NULL

-- 8. 사원 테이블에서 커미션을 받는 사원의 정보 조회하기

SELECT *
  FROM EMPLOYEES 
 WHERE COMMISSION_PCT IS NOT NULL;

-- 9. 사원 테이블에서 전화번호가 '515'로 시작하는 사원의 정보 조회하기

SELECT *
 FROM EMPLOYEES
 WHERE PHONE_NUMBER LIKE '515' || '%'

-- 10. 사원 테이블에서 전화번호가 '515'로 시작하는 전화번호의 중복을 제거하고 조회하기

SELECT DISTINCT PHONE_NUMBER,
       FIRST_NAME || ' ' || LAST_NAME AS 이름
 FROM EMPLOYEES
 WHERE PHONE_NUMBER LIKE '515' || '%'
-- 11. 사원 테이블의 사원들을 연봉순으로 조회하기 (높은 연봉을 먼저 조회)

SELECT *
  FROM EMPLOYEES
 ORDER BY SALARY DESC;


-- 12. 사원 테이블의 사원들을 입사순으로 조회하기 (먼저 입사한 사원을 먼저 조회)

SELECT *
  FROM EMPLOYEES
 ORDER BY HIRE_DATE ASC;

-- 13. 사원 테이블의 사원들을 부서별로 비교할 수 있도록 같은 부서의 사원들을 모아서 조회한 뒤
-- 같은 부서 내의 사원들은 연봉순으로 조회하기

SELECT *
  FROM EMPLOYEES
 ORDER BY DEPARTMENT_ID ASC,
          SALARY DESC;




                    /* 함수 연습문제 */

                /* 형변환 함수 연습문제 */

DROP TABLE EXAMPLE_T;
CREATE TABLE EXAMPLE_T (
    DT1 DATE
  , DT2 TIMESTAMP
);
INSERT INTO EXAMPLE_T(DT1, DT2) VALUES(SYSDATE, SYSTIMESTAMP);
COMMIT;

-- 1. DT1이 '23/07/04'인 데이터를 조회하기

SELECT *
  FROM EXAMPLE_T
 WHERE TO_DATE(DT1, 'YY/MM/DD') = TO_DATE('23/07/10', 'YY/MM/DD');


            /* NULL 함수 연습문제 */

-- 1. 사원 테이블에서 사원번호와 부서번호를 조회하기
-- 부서번호가 없는 경우에는 0으로 조회하기

SELECT EMPLOYEE_ID,
       NVL(DEPARTMENT_ID, 0)
  FROM EMPLOYEES;


-- 2. 사원 테이블에서 모든 사원들의 실제 커미션을 조회하기
-- 커미션 = 연봉 * 커미션퍼센트
-- 커미션을 받지 않는 경우 0으로 조회하기

SELECT EMPLOYEE_ID,
       NVL2(COMMISSION_PCT, COMMISSION_PCT * SALARY,0)
  FROM EMPLOYEES;

SELECT EMPLOYEE_ID
     , NVL(SALARY * COMMISSION_PCT, 0) AS COMMISSION1
     , SALARY * NVL(COMMISSION_PCT, 0) AS COMMISSION2
     , NVL2(COMMISSION_PCT, COMMISSION_PCT * SALARY,0)
  FROM EMPLOYEES;
  
            /* 통계 함수 연습문제 */


-- 1. 사원 테이블에서 전체 사원의 연봉 합계 조회하기
SELECT AVG(SALARY) AS 연봉합계
  FROM EMPLOYEES;

-- 2. 사원 테이블에서 전체 사원의 커미션퍼센트의 평균 조회하기
-- 커미션이 없는 사원은 제외하고 조회하기

SELECT AVG(COMMISSION_PCT) AS 커미션퍼센트_평균
  FROM EMPLOYEES
 WHERE COMMISSION_PCT IS NOT NULL;

-- 3. 사원 테이블에서 전체 사원의 최대 연봉 조회하기

SELECT MAX(SALARY) AS 최대연봉
  FROM EMPLOYEES;

-- 4. 사원 테이블에서 전체 사원의 최대 커미션 조회하기
-- 커미션 = 연봉 * 커미션퍼센트

SELECT MAX(SALARY * COMMISSION_PCT) AS 최대_커미션
  FROM EMPLOYEES;


-- 5. 사원 테이블에서 전체 사원 중 가장 나중에 입사한 사원의 입사일 조회하기

SELECT MIN(HIRE_DATE) AS 가장_나중에_입사한_사원
  FROM EMPLOYEES;


-- 6. 전체 사원 수 조회하기

SELECT COUNT(*) AS 전체_사원수
  FROM EMPLOYEES;


-- 7. 사원들이 근무하는 부서의 갯수 조회하기

SELECT COUNT(DISTINCT DEPARTMENT_ID) AS 부서_개수
  FROM EMPLOYEES;



            /* 문자 함수 연습문제 */

-- 1. 사원 테이블의 JOB_ID에서 밑줄(_) 앞/뒷 부분 분리 조회하기
-- 예시) IT_PROG   ->    IT / PROG

SELECT SUBSTR(JOB_ID, 1, INSTR(JOB_ID, '_') - 1),
       SUBSTR(JOB_ID,INSTR(JOB_ID, '_') + 1)
  FROM EMPLOYEES;


-- 2. FIRST_NAME과 LAST_NAME을 연결해서 모두 대문자로 바꾼 FULL_NAME 조회하기
-- 예시) FIRST_NAME : Steven

SELECT CONCAT(FIRST_NAME, CONCAT(' ', LAST_NAME)) AS FULL_NAME
  FROM EMPLOYEES;


            /* 기타 함수 연습문제 */
            
-- 1. 사원 연봉순위 구하기

SELECT SALARY,
       EMPLOYEE_ID,
       RANK() OVER(ORDER BY SALARY DESC) AS 연봉순위
       
  FROM EMPLOYEES;


-- 2. 사원 입사순위 구하기

SELECT EMPLOYEE_ID,
       HIRE_DATE,
       RANK() OVER(ORDER BY HIRE_DATE ASC) AS 입사순위
  FROM EMPLOYEES;


-- 3. 사원 연봉순위 번호 붙여서 구하기

SELECT EMPLOYEE_ID,
       SALARY,
       ROW_NUMBER() OVER(ORDER BY SALARY DESC) AS 번호
  FROM EMPLOYEES;



-- 4. SHA256 비번 '1111' 으로 암호화된 해쉬번호 뽑기

SELECT STANDARD_HASH('1111', 'SHA256')
  FROM DUAL;



-- 5. 사원 테이블에서 부서 아이디에 따른 부서 이름을  10, 'Administration', 20, 'Marketing', 30, 'Purchasing', 40, 'Human Resources', 50, 'Shipping', 60, 'IT 으로 바꾸어 뽑기 

SELECT EMPLOYEE_ID,
       DEPARTMENT_ID,
       DECODE(DEPARTMENT_ID,
       10, 'Administration', 
       20, 'Marketing', 
       30, 'Purchasing', 
       40, 'Human Resources', 
       50, 'Shipping', 
       60, 'IT'
       ) AS 부서이름
  FROM EMPLOYEES;

SELECT EMPLOYEE_ID,
       DEPARTMENT_ID,
       CASE
        WHEN DEPARTMENT_ID = 10 THEN 'Administration'
        WHEN DEPARTMENT_ID = 20 THEN 'Marketing'
        WHEN DEPARTMENT_ID = 30 THEN 'Purchasing'
        WHEN DEPARTMENT_ID = 40 THEN 'Human Resources'
        WHEN DEPARTMENT_ID = 50 THEN 'Shipping'
        WHEN DEPARTMENT_ID = 60 THEN 'IT'
        ELSE 'Unknown'
       END AS 부서이름
  FROM EMPLOYEES;

            /* GROUP BY 연습문제 */

-- 1. 사원 테이블에서 동일한 부서번호를 가진 사원들을 그룹화하여 각 그룹별로 몇 명의 사원이 있는지 조회하시오.

SELECT DEPARTMENT_ID,
       COUNT(*)
  FROM EMPLOYEES
 GROUP BY DEPARTMENT_ID;

-- 2. 사원 테이블에서 같은 직업을 가진 사원들을 그룹화하여 각 그룹별로 연봉의 평균이 얼마인지 조회하시오.

SELECT JOB_ID,
       ROUND(AVG(SALARY), 2) AS 연봉평균
  FROM EMPLOYEES
 GROUP BY JOB_ID;


-- 3. 사원 테이블에서 전화번호 앞 3자리가 같은 사원들을 그룹화하여 각 그룹별로 연봉의 합계가 얼마인지 조회하시오.

SELECT SUBSTR(PHONE_NUMBER, 1, 3) AS 전화번호_앞자리,
       SUM(SALARY) AS 연봉_합계
  FROM EMPLOYEES
 GROUP BY SUBSTR(PHONE_NUMBER, 1, 3);

-- 참고. GROUP BY 절 없이 통계내기

SELECT DISTINCT DEPARTMENT_ID AS 부서_ID,
       COUNT(*) OVER(PARTITION BY DEPARTMENT_ID) AS 부서수,
       ROUND(AVG(SALARY) OVER(ORDER BY DEPARTMENT_ID), 2) AS 연봉_평균
  FROM EMPLOYEES
 ORDER BY DEPARTMENT_ID;


-- 4. 사원 테이블에서 각 부서별 사원수가 20명 이상인 부서를 조회하시오.

SELECT DEPARTMENT_ID,
       COUNT(*)
  FROM EMPLOYEES
 GROUP BY DEPARTMENT_ID
HAVING COUNT(*) >= 20;




-- 5. 사원 테이블에서 부서별 연봉 평균과 사원수를 조회하시오. 부서별 사원수가 2명 이상인 부서만 조회하시오.

SELECT ROUND(AVG(SALARY), 2) AS 연봉_평균,
       COUNT(*)              AS 부서수,
       DEPARTMENT_ID         AS 부서_ID
  FROM EMPLOYEES
 GROUP BY DEPARTMENT_ID
HAVING COUNT(*) >= 2;



            /* JOIN 연습문제 */

-- 1. 사원번호, 사원명, 부서번호, 부서명을 조회하시오.

SELECT E.EMPLOYEE_ID        AS 사원번호,
       E.FIRST_NAME         AS 성,
       E.LAST_NAME          AS 이름,
       D.DEPARTMENT_ID      AS 부서번호,
       D.DEPARTMENT_NAME    AS 부서명
  FROM EMPLOYEES E, DEPARTMENTS D
 WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID;



-- 2. 사원번호, 사원명, 직업, 연봉, 직업별 최대연봉, 직업별 최소연봉을 조회하시오.

SELECT E.FIRST_NAME     AS 성,
       E.LAST_NAME      AS 이름,
       E.JOB_ID         AS 직업ID,
       E.SALARY         AS 연봉,    
       J.MAX_SALARY     AS 최대연봉,
       J.MIN_SALARY     AS 최소연봉
  FROM EMPLOYEES E, JOBS J
 WHERE E.JOB_ID = J.JOB_ID;



-- 3. 모든 사원들의(부서가 없는 사원도 포함) 사원번호, 사원명, 부서번호, 부서명을 조회하시오.

SELECT E.EMPLOYEE_ID        AS 사원번호,
       E.FIRST_NAME         AS 성,
       E.LAST_NAME          AS 이름,
       D.DEPARTMENT_ID      AS 부서번호,
       D.DEPARTMENT_NAME    AS 부서이름
  FROM EMPLOYEES E, DEPARTMENTS D
 WHERE D.DEPARTMENT_ID(+) = E.DEPARTMENT_ID;


-- 4. 사원번호, 사원명, 부서번호, 부서명을 조회하시오. 사원이 근무하지 않는 유령 부서도 조회하시오.

SELECT E.EMPLOYEE_ID        AS 사원번호,
       E.FIRST_NAME         AS 성,
       E.LAST_NAME          AS 이름,
       D.DEPARTMENT_ID      AS 부서번호,
       D.DEPARTMENT_NAME    AS 부서명
  FROM EMPLOYEES E, DEPARTMENTS D
 WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID(+);
 
-- 5. 사원번호, 사원명, 부서번호, 부서명, 근무지역을 조회하시오.

SELECT E.EMPLOYEE_ID        AS 사원번호,
       E.FIRST_NAME         AS 성,
       E.LAST_NAME          AS 이름,
       D.DEPARTMENT_ID      AS 부서번호,
       D.DEPARTMENT_NAME    AS 부서이름,
       L.CITY               AS 근무지역
  FROM EMPLOYEES E, DEPARTMENTS D, LOCATIONS L
 WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID
   AND L.LOCATION_ID = D.LOCATION_ID;
   
-- 6. 부서번호, 부서명, 근무도시, 근무국가를 조회하시오.

SELECT D.DEPARTMENT_ID      AS 부서번호,
       D.DEPARTMENT_NAME    AS 부서이름,
       L.CITY               AS 근무도시,
       C.COUNTRY_NAME       AS 근무국가
  FROM DEPARTMENTS D, LOCATIONS L, COUNTRIES C
 WHERE D.LOCATION_ID = L.LOCATION_ID
   AND L.COUNTRY_ID = C.COUNTRY_ID;



            /* 서브쿼리 연습문제 */

-- 1. 사원번호가 101인 사원의 직업과 동일한 직업을 가진 사원을 조회하기

SELECT *
  FROM EMPLOYEES
 WHERE JOB_ID = (SELECT JOB_ID
                   FROM EMPLOYEES
                  WHERE EMPLOYEE_ID = 101);


-- 2. 부서명이 'IT'인 부서에 근무하는 사원 조회하기

SELECT *
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID
                          FROM DEPARTMENTS
                         WHERE DEPARTMENT_NAME = 'IT');

-- 3. 'Seattle'에서 근무하는 사원 조회하기

SELECT *
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID
                           FROM DEPARTMENTS
                          WHERE LOCATION_ID = (SELECT LOCATION_ID
                                                 FROM LOCATIONS
                                                WHERE CITY = 'Seattle'));


-- 4. 연봉 가장 높은 사원 조회하기

SELECT *
  FROM EMPLOYEES
 WHERE SALARY = (SELECT MAX(SALARY)
                   FROM EMPLOYEES);

-- 5. 가장 먼저 입사한 사원 조회하기

SELECT *
  FROM EMPLOYEES
 WHERE HIRE_DATE = (SELECT MIN(HIRE_DATE)
                      FROM EMPLOYEES);

-- 6. 평균 연봉 이상을 받는 사원 조회하기

SELECT *
  FROM EMPLOYEES
 WHERE SALARY >= (SELECT AVG(SALARY)
                    FROM EMPLOYEES);


-- 7. 연봉이 3번째로 높은 사원 조회하기

SELECT 행번호,
       EMPLOYEE_ID
  FROM (SELECT ROW_NUMBER() OVER(ORDER BY SALARY DESC) AS 행번호,
               EMPLOYEE_ID
          FROM EMPLOYEES)
 WHERE 행번호 = 3;


-- 8. 연봉 11 ~ 20번째 사원 조회하기

SELECT 행번호,
       EMPLOYEE_ID
  FROM (SELECT RANK() OVER(ORDER BY SALARY DESC) AS 행번호,
               EMPLOYEE_ID
          FROM EMPLOYEES)
 WHERE 행번호 BETWEEN 11 AND 20;


-- 9. 21 ~ 30번째로 입사한 사원 조회하기

SELECT 입사순,
       EMPLOYEE_ID
  FROM (SELECT RANK() OVER(ORDER BY HIRE_DATE DESC) AS 입사순,
               EMPLOYEE_ID
          FROM EMPLOYEES)
 WHERE 입사순 BETWEEN 21 AND 30;



-- 10.부서번호가 50인 부서에 근무하는 사원번호, 사원명, 부서명 조회하기 (비상관)

SELECT EMPLOYEE_ID,
       FIRST_NAME,
       LAST_NAME,
       (SELECT DEPARTMENT_NAME
          FROM DEPARTMENTS
         WHERE DEPARTMENT_ID = 50)
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID = 50;
 
-- 11. 부서번호가 50인 부서에 근무하는 사원번호, 사원명, 부서명 조회하기 (상관)

SELECT EMPLOYEE_ID,
       FIRST_NAME,
       LAST_NAME,
       (SELECT D.DEPARTMENT_NAME
          FROM DEPARTMENTS D
         WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID
           AND D.DEPARTMENT_ID = 50)
  FROM EMPLOYEES E;



            /* WITH 연습문제 */
            
-- 1. 1 ~ 10번째로 고용된 사원 조회하기
-- 1) 서브쿼리

SELECT 고용순서,
       EMPLOYEE_ID
  FROM (SELECT RANK() OVER(ORDER BY HIRE_DATE ASC) AS 고용순서,
               EMPLOYEE_ID
          FROM EMPLOYEES)
 WHERE 고용순서 BETWEEN 1 AND 10;


-- 2) WITH
WITH
    MY_SUBQUERY AS (
    SELECT RANK() OVER(ORDER BY HIRE_DATE ASC) AS 고용순서,
           EMPLOYEE_ID
      FROM EMPLOYEES
    )
SELECT *
  FROM MY_SUBQUERY
 WHERE 고용순서 BETWEEN 1 AND 10;




-- 2. 부서별 부서번호, 부서명, 연봉총액을 조회하기
-- 1) 조인
SELECT E.DEPARTMENT_ID    AS 부서번호,
       D.DEPARTMENT_NAME  AS 부서명,
       E.연봉총액
  FROM DEPARTMENTS D, (SELECT SUM(SALARY) AS 연봉총액,
                              DEPARTMENT_ID
                         FROM EMPLOYEES
                        GROUP BY DEPARTMENT_ID) E
 WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID;


-- 2) WITH
WITH
    MY_SUBQUERY AS (SELECT SUM(SALARY) AS 연봉총액,
                           DEPARTMENT_ID
                      FROM EMPLOYEES
                     GROUP BY DEPARTMENT_ID)
SELECT D.DEPARTMENT_ID    AS 부서번호,
       D.DEPARTMENT_NAME  AS 부서명,
       MY.연봉총액
  FROM DEPARTMENTS D, MY_SUBQUERY MY
 WHERE D.DEPARTMENT_ID = MY.DEPARTMENT_ID;



