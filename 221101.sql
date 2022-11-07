-- ▶ 22/11/01=======================
-- [sh계정] 실습문제 -- 서브쿼리 ver.
/*
1. 주민번호가 70년대 생이면서 성별이 여자이고, 성이 전씨인 직원들의 
사원명, 주민번호, 부서명, 직급명을 조회하시오.
*/
select
    emp_name "사원명",
    emp_no "주민번호",
    (select dept_title from department where dept_id = t.dept_code) "부서명",
    (select job_name from job where job_code = t.job_code) "직급명"
from
    (select e.*, decode(substr(emp_no, 8, 1), '1', '남', '3', '남' ,'여') gender from employee e) t
where
    emp_name like '전%' and
    gender = '여' and
    substr(emp_no, 1,  2) between '70' and '79'; 

/*
2. 가장 나이가 적은 직원의 사번, 사원명, 나이, 부서명, 직급명을 조회하시오.
*/
select
    emp_id "사번",
    emp_name "사원명",
    age "나이",
    (select dept_title from department where dept_id = em.dept_code) "부서명",
    (select job_name from job where job_code = em.job_code) "직급명"
from
    (select e.*, extract(year from sysdate) - (decode(substr(emp_no, 8, 1), '1', 1900, '2', 1900, 2000) + substr(emp_no, 1, 2)) age
    from employee e) em
where
    age = (select min(extract(year from sysdate) - (decode(substr(emp_no, 8, 1), '1', 1900, '2', 1900, 2000) + substr(emp_no, 1, 2))) from employee); 
    -- 왜,,, min(age) / min(em.min) /  min(e.min) 안되는거람,,,,                                                                                                                                                                                                                             

/*
3. 이름에 '형'자가 들어가는 직원들의 사번, 사원명, 부서명을 조회하시오.
*/
select
    emp_id "사번",
    emp_name "사원명",
    (select dept_title from department where dept_id = e.dept_code) "부서명"
from
    employee e
where
    emp_name like '%형%';

/*
4. 해외영업팀에 근무하는 사원명, 직급명, 부서코드, 부서명을 조회하시오.
*/
select
    emp_name "사원명",
    (select job_name from job where job_code = e.job_code) "직급명",
    dept_code "부서코드",
    (select dept_title from department where dept_id = e.dept_code) "부서명"
from
    employee e
where
    (select  location_id from department where dept_id = e.dept_code) != (select local_code from location where national_code = 'KO');
    
/*
5. 보너스포인트를 받는 직원들의 사원명, 보너스포인트, 부서명, 근무지역명을 조회하시오.
*/
select
    emp_name "사원명",
    bonus "보너스포인트",
    nvl((select dept_title from department where dept_id = e.dept_code), '인턴') "부서명",
    (select local_name from location l, department d where l.local_code = d.location_id and dept_id = e.dept_code) "근무지역명"
from
    employee e
where 
    bonus is not null;

/*
6. 부서코드가 D2인 직원들의 사원명, 직급명, 부서명, 근무지역명을 조회하시오.
*/
select
    emp_name "사원명",
    (select job_name from job where job_code = e.job_code) "직급명",
    (select dept_title from department where dept_id = e.dept_code) "부서명",
    (select local_name from location l, department d where l.local_code = d.location_id and dept_id = e.dept_code) "근무지역명"
from
    employee e
where
    dept_code = 'D2';

/*
7. 급여등급테이블의 등급별 최대급여(MAX_SAL)보다 많이 받는 직원들의 사원명, 직급명, 급여, 연봉을 조회하시오.
(사원테이블과 급여등급테이블을 SAL_LEVEL컬럼기준으로 동등 조인할 것)
*/
select
    emp_name "사원명",
    (select job_name from job where job_code = e.job_code) "직급명",
    to_char(salary, 'FML999,999,999,999') "급여",
    to_char(salary * 12, 'FML999,999,999,999') "연봉"
from
    employee e
where
    salary > (select max_sal from sal_grade where sal_level = e.sal_level);

/*
8. 한국(KO)과 일본(JP)에 근무하는 직원들의 
사원명, 부서명, 지역명, 국가명을 조회하시오. @@
*/
select * from nation;
select * from location;

select
    emp_name "사원명",
    (select dept_title from department where dept_id = e.dept_code) "부서명",
    (select local_name from location l, department d where l.local_code = d.location_id and dept_id = e.dept_code) "지역명"
from 
    employee e
where
    (select location_id from department where dept_id = e.dept_code) in (select local_code from location where national_code in ('KO', 'JP'));

/*
9. 같은 부서에 근무하는 직원들의 사원명, 부서코드, 동료이름을 조회하시오.
self join 사용 @@
*/
select * from employee;

select
    emp_name "사원명",
    nvl(dept_code, '인턴') "부서코드"
from
    employee e;

/*
10. 보너스포인트가 없는 직원들 중에서 직급이 차장과 사원인 직원들의 사원명, 직급명, 급여를 조회하시오.
*/
select
    emp_name "사원명",
    (select job_name from job where job_code = e.job_code) "직급명",
    to_char(salary, 'FML999,999,999,999') "급여"
from
    employee e
where
    bonus is null and
    (select job_name from job where job_code = e.job_code) in ('차장', '사원');
    