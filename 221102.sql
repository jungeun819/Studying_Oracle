-- ▶ 2022/11/02  ========================
-- [sh 계정] DQL종합실습문제
/*
1. 기술지원부에 속한 사람들의 사람의 이름,부서코드,급여를 출력하시오
*/
-- > join ver.
select
    e.emp_name 이름,
    e.dept_code 부서코드,
    to_char(e.salary, 'FML999,999,999') 급여
from
    employee e 
        join department d on e.dept_code = d.dept_id
where
    d.dept_title = '기술지원부';

--> subquery ver.
select
    emp_name 이름,
    dept_code 부서코드,
    to_char(salary, 'FML999,999,999') 급여
from
    employee
where
    dept_code = (select dept_id from department where dept_title = '기술지원부');

/*
2. 기술지원부에 속한 사람들 중 가장 연봉이 높은 사람의 이름,부서코드,급여를 출력하시오
*/
select
    emp_name 이름,
    dept_code 부서코드,
    salary 급여
from
    employee
where
    (dept_code, salary) in (select 
                                            dept_code, max(salary) 
                                        from employee 
                                        group by dept_code 
                                        having dept_code = (select dept_id from department where dept_title = '기술지원부'));

/*
3. 매니저가 있는 사원중에 월급이 전체사원 평균보다 많은 사원의 사번,이름,매니저 이름, 월급을 구하시오. 
    - JOIN을 이용하시오
    - JOIN하지 않고, 스칼라상관쿼리(SELECT)를 이용하기
*/
-->  join ver.
select  
    e.emp_id 사번,
    e.emp_name 이름,
    m.emp_name "매니저 이름",
    to_char(e.salary, 'FML999,999,999') 월급
from
    employee e left join employee m 
        on e.manager_id = m.emp_id 
where
    e.manager_id is not null 
    and e.salary > (select avg(salary) from employee);
    
--> scalar subquery ver.
select
    emp_id 사번,
    emp_name 이름,
    (select emp_name from employee m where m.emp_id = e.manager_id) "매니저 이름",
    to_char(e.salary, 'FML999,999,999') 월급
from
    employee e
where
    manager_id is not null 
    and salary > (select avg(salary) from employee);

/*
4. 같은 직급의 평균급여보다 같거나 많은 급여를 받는 직원의 이름, 직급코드, 급여, 급여등급 조회
*/
--> join ver.
select
    emp_name 이름,
    job_code 직급코드,
    to_char(salary, 'FML999,999,999') 급여,
    sal_level 급여등급
from
    employee join (select job_code, avg(salary) avg_sal from employee group by job_code)
        using(job_code)
where
    salary >= avg_sal;

--> inline view ver.
select
    emp_name 이름,
    job_code 직급코드,
    to_char(salary, 'FML999,999,999') 급여,
    sal_level 급여등급
from(
    select
        e.*,
        trunc(avg(salary) over (partition by job_code)) avg_sal
    from
        employee e
    )
where
    salary >= avg_sal;

/*
5. 부서별 평균 급여가 3000000 이상인 부서명, 평균 급여 조회
    단, 평균 급여는 소수점 버림, 부서명이 없는 경우 '인턴'처리
*/
--> with as ver.
with dept_avg_sal
as(
    select
        nvl((select dept_title from department d where d.dept_id = e.dept_code), '인턴') 부서명,
        trunc(avg(salary)) 평균급여
    from
        employee e 
    group by
        dept_code
    )
select
    *
from
    dept_avg_sal
where
    avg_sal >= 3000000; 
    
/*
6. 직급의 연봉 평균보다 적게 받는 여자사원의 사원명,직급명,부서명,연봉을 이름 오름차순으로 조회하시오.
     - 연봉 계산 => (급여 + (급여*보너스))*12
*/
select
    emp_name 사원명,
    (select dept_title from department where dept_id = e.dept_code) 부서명,
    to_char((salary + (salary * nvl(bonus, 0))) * 12, 'FML999,999,999,999') 연봉
from(
    select
        e.*,
        decode(substr(emp_no, 8, 1), '2', '여', '4', '여', '남') gender,
        trunc(avg(salary) over (partition by job_code)) avg_sal
    from
        employee e
    ) e
where
    gender = '여' 
    and salary < avg_sal
order by
    emp_name;
    
/*
7. 다음 도서목록테이블을 생성하고, 공저인 도서만 출력하세요. (공저 : 두명이상의 작가가 함께 쓴 도서)
*/
select * from tbl_books;

select
    book_title
from
    tbl_books
group by
    book_title
having
    count(book_title) > 1;
