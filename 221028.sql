-- ▶ 22/10/28 ===================
-- [chun 계정] 실습문제
/*
1. 영어영문학과(학과코드 002) 학생들의 학번과 이름, 입학 년도를 입학 년도가 빠른 순으로 표시하는 SQL 문장을 작성하시오.
( 단, 헤더는 "학번", "이름", "입학년도" 가 표시되도록 한다.)
*/
select
    student_no "학번",
    student_name "이름",
    to_char(entrance_date, 'yyyy-mm-dd') "입학년도"
from
    tb_student
where
    department_no = '002'
order by
    entrance_date;
    
/*
2. 춘 기술대학교의 교수 중 이름이 세 글자가 아닌 교수가 한 명 있다고 핚다. 
그 교수의 이름과 주민번호를 화면에 출력하는 SQL 문장을 작성해 보자. 
(* 이때 올바르게 작성한 SQL문장의 결과 값이 예상과 다르게 나올 수 있다. 원인이 무엇일지 생각해볼 것)
*/
select
    professor_name "교수명",
    professor_ssn "주민번호"
from
    tb_professor
where
    professor_name not like '___';

/*
3. 춘 기술대학교의 남자 교수들의 이름과 나이를 출력하는 SQL 문장을 작성하시오. 
단, 이때 나이가 적은 사람에서 많은 사람 순서로 화면에 출력되도록 만드시오. 
(단, 교수 중 2000 년 이후 출생자는 없으며 출력 헤더는 "교수이름", "나이"로 한다. 나이는 ‘만’으로 계산한다.)
*/
select
    professor_name "교수이름",
    professor_ssn,
    extract(year from sysdate) - (substr(professor_ssn, 1, 2) + 1900) "나이"
from
    tb_professor
where
    substr(professor_ssn, 8 ,1) = '1'
order by
    나이;

/*
4. 교수들의 이름 중 성을 제외한 이름만 출력하는 SQL 문장을 작성하시오. 
출력 헤더는 "이름" 이 찍히도록 한다. (성이 2 자인 경우는 교수는 없다고 가정하시오)
*/
select
    substr(professor_name, 2) "이름"
from 
    tb_professor;

/*
5. 춘 기술대학교의 재수생 입학자를 구하려고 한다. 어떻게 찾아낼 것인가? 
이때, 19 살에 입학하면 재수를 하지 않은 것으로 간주한다.
*/
select * from tb_student;
select
    student_no"학번",
    student_name "이름"
from
    tb_student
where
    (substr(student_ssn, 1, 2) + decode(substr(student_ssn, 8, 1), '1', 1900 , '2', 1900, 2000) + 19) < to_char(entrance_date, 'yyyy');
    
-- 알송달송,,,, 이건,,, 만나이로 결국 계산되어서 그런가,,,?
select
--    to_date(substr(student_ssn, 1, 6), 'yymmdd') "출생년도" ,
--    entrance_date "입학년도",
    trunc(months_between(to_char(entrance_date, 'rrmmdd'),to_char(to_date(substr(student_ssn, 1, 6), 'yymmdd'), 'rrmmdd')) / 12) + 1 "나이",
    student_no"학번",
    student_name "이름"
from
    tb_student
where
    trunc(months_between(to_char(entrance_date, 'rrmmdd'),to_char(to_date(substr(student_ssn, 1, 6), 'yymmdd'), 'rrmmdd')) / 12) + 1 > 19;

/*
6. 2020 년 크리스마스는 무슨 요일인가?
*/
select
    to_char(to_date('2020/12/25', 'yyyy/mm/dd'), 'day') "2022년 크리스마스는 무슨 요일?"
from
    dual;

/*
7. TO_DATE('99/10/11','YY/MM/DD'), TO_DATE('49/10/11','YY/MM/DD') 은 
각각 몇 년 몇 월 몇 일을 의미할까? 
또 TO_DATE('99/10/11','RR/MM/DD'), TO_DATE('49/10/11','RR/MM/DD') 은 
각각 몇 년 몇 월 몇 일을 의미할까?
*/
select
    to_char(to_date('99/10/11', 'yy/mm/dd'), 'yyyy"년"mm"월"dd"일"') "yymmdd" ,
    to_char(to_date('49/10/11' , 'yy/mm/dd'), 'yyyy"년"mm"월"dd"일"') "yymmdd2",
    to_char(to_date('99/10/11' , 'rr/mm/dd'), 'rrrr"년"mm"월"dd"일"') "rrmmdd",
    to_char(to_date('49/10/11' , 'rr/mm/dd'), 'rrrr"년"mm"월"dd"일"') "rrmmdd2"
from
    dual;

/*
8. 춘 기술대학교의 2000 년도 이후 입학자들은 학번이 A 로 시작하게 되어있다. 
2000년도 이전 학번을 받은 학생들의 학번과 이름을 보여주는 SQL 문장을 작성하시오.
*/
select
    student_no "학번",
    student_name "이름"
--    entrance_date "입학년도"
from
    tb_student
where
    extract(year from entrance_date) < 2000
order by
    student_no desc;

/*
9. 학번이 A517178 인 한아름 학생의 학점 총 평점을 구하는 SQL 문을 작성하시오. 
단, 이때 출력 화면의 헤더는 "평점" 이라고 찍히게 하고, 점수는 반올림하여 소수점 이하 한자리까지만 표시한다.
*/
select * from tb_student;
select * from tb_grade;

select 
    round(avg(point), 1) "평점"
from
    tb_grade 
where
    student_no = 'A517178';

/*
10. 학과별 학생수를 구하여 "학과번호", "학생수(명)" 의 형태로 헤더를 만들어 결과값이 출력되도록 하시오.
*/
select 
    department_no "학과번호",
    count(department_no) "학생수(명)"
from    
    tb_student
group by
    department_no
order by
    department_no;

/*
11. 지도 교수를 배정받지 못한 학생의 수는 몇 명 정도 되는 알아내는 SQL 문을 작성하시오.
*/
select
    count(nvl(coach_professor_no, '없음')) "인원수"
from
    tb_student
where
    coach_professor_no is null;

/*
12. 학번이 A112113 인 김고운 학생의 년도 별 평점을 구하는 SQL 문을 작성하시오. 
단, 이때 출력 화면의 헤더는 "년도", "년도 별 평점" 이라고 찍히게 하고, 
점수는 반올림하여 소수점 이하 한 자리까지맊 표시한다.
*/
select * from tb_grade;

select 
    substr(term_no, 1, 4) "년도",
    round(avg(point), 1) "년도 별 평점"
from 
    tb_grade
where
    student_no = 'A112113'
group by
    substr(term_no, 1, 4)
order by
    substr(term_no, 1, 4);
    
/*
13. 학과 별 휴학생 수를 파악하고자 한다. 학과 번호와 휴학생 수를 표시하는 SQL 문장을 작성하시오.
*/
select * from tb_student;
select * from tb_department;

select
    department_no "학과코드명",
    sum(decode(absence_yn, 'Y', '1', 'N', '0')) || '명' "휴학생 수"
from
    tb_student 
group by
    department_no
order by
    department_no;

/*
14. 춘 대학교에 다니는 동명이인 학생들의 이름을 찾고자 한다. 
어떤 SQL 문장을 사용하면 가능하겠는가?
*/
select
    student_name "동일이름",
    count(student_name) "동명인 수"
from
    tb_student
group by
    student_name
having
    count(student_name) != 1
order by
    student_name;

/*
15. 학번이 A112113 인 김고운 학생의 년도, 학기 별 평점과 년도 별 누적 평점 , 총 평점을 구하는 SQL 문을 작성하시오. 
(단, 평점은 소수점 1 자리까지만 반올림하여 표시한다.)
*/
select 
    nvl(substr(term_no, 1, 4), '총계') "연도",
    nvl(substr(term_no, 5, 2), ' ') "학기",
    round(avg(point), 1) "평점"
from 
    tb_grade
where
    student_no = 'A112113'
group by    
    rollup(substr(term_no, 1, 4), substr(term_no, 5, 2));

------------------------------------------------------------------
-- [sh 계정] 실습문제
/*
1. 2020년 12월 25일이 무슨 요일인지 조회하시오.
*/
select
    to_char(to_date('2020/12/25', 'yyyy/mm/dd'), 'day') "무슨 요일?"
from
    dual;

/*
2. 주민번호가 70년대 생이면서 성별이 여자이고, 성이 전씨인 직원들의 
사원명, 주민번호, 부서명, 직급명을 조회하시오.
*/
select
    e.emp_name "사원명",
    e.emp_no "주민번호",
    d.dept_title "부서명",
    j.job_name "직급명"
from
    employee e join department d
        on e.dept_code = d.dept_id
    join job j
        using(job_code)
where
    substr(emp_no, 1, 1) = '7' and 
    substr(emp_no, 8, 1) in ('2', '4') and 
    e.emp_name like '전%';

/*
3. 가장 나이가 적은 직원의 사번, 사원명, 나이, 부서명, 직급명을 조회하시오.
*/
select
    emp_id "사번",
    emp_name "사원명",
    c.age "나이",
    d.dept_title "부서명",
    j.job_name "직급명"
from
    employee e 
    join department d on e.dept_code = d.dept_id
    join (select emp_id, extract(year from sysdate) - (decode(substr(emp_no, 8, 1), '1', 1900, '2', 1900, 2000) + substr(emp_no, 1, 2)) "age"
            from employee) c using(emp_id)
    join job j using(job_code)
where -- where절에 그룹함수 불가
    age = (select min(extract(year from sysdate) - (decode(substr(emp_no, 8, 1), '1', 1900, '2', 1900, 2000) + substr(emp_no, 1, 2))) from employee);
-- 왜 age = (select min(age) from employee) 는 안되는걸까??

/*
4. 이름에 '형'자가 들어가는 직원들의 사번, 사원명, 부서명을 조회하시오.
*/
select
    e.emp_id "사번",
    e.emp_name "사원명",
    d.dept_title "부서명"
from
    employee e join department d
        on e.dept_code = d.dept_id
where
    emp_name like '%형%';

/*
5. 해외영업팀에 근무하는 사원명, 직급명, 부서코드, 부서명을 조회하시오.
*/
select 
    emp_name "사원명",
    j.job_name "직급명",
    e.dept_code "부서코드",
    d.dept_title "부서명"
from
    employee e join department d
        on e.dept_code = d.dept_id
    join location l
        on d.location_id = l.local_code
    join nation n
        using(national_code)
    join job j
        using(job_code)
where
    n.national_name not like '한국';

/*
6. 보너스포인트를 받는 직원들의 사원명, 보너스포인트, 부서명, 근무지역명을 조회하시오.
*/
select
    e.emp_name "사원명",
    to_char(bonus * salary, 'FML999,999,999') "보너스포인트",
    d.dept_title "부서명",
    l.local_name "근무지역명"
from
    employee e join department d
        on e.dept_code = d.dept_id
    join location l
        on d.location_id = l.local_code
where
    e.bonus is not null;

/*
7. 부서코드가 D2인 직원들의 사원명, 직급명, 부서명, 근무지역명을 조회하시오.
*/
select
    e.emp_name "사원명",
    j.job_name "직급명",
    d.dept_title "부서명",
    l.local_name "근무지역명"
from
    employee e join department d
        on e.dept_code = d.dept_id
    join location l
        on d.location_id = l.local_code
    join job j
        using(job_code)
where 
    e.dept_code = 'D2';
        
/*
8. 급여등급테이블의 등급별 최대급여(MAX_SAL)보다 많이 받는 직원들의 사원명, 직급명, 급여, 연봉을 조회하시오.
(사원테이블과 급여등급테이블을 SAL_LEVEL컬럼기준으로 동등 조인할 것)
*/
select
    e.emp_name "사원명",
    j.job_name "직급명",
    to_char(e.salary, 'FML999,999,999,999') "급여",
    to_char(salary * 12, 'FML999,999,999,999') "연봉"
from
    employee e join job j
        using(job_code)
    right join sal_grade s
        using(sal_level)
where
    e.salary > s.max_sal;
    
/*
9. 한국(KO)과 일본(JP)에 근무하는 직원들의 
사원명, 부서명, 지역명, 국가명을 조회하시오.
*/
select 
    e.emp_name "사원명",
    d.dept_title "부서명",
    l.local_name "지역명",
    n.national_name "국가명"
from
    employee e join department d
        on e.dept_code = d.dept_id
    join location l
        on d.location_id = l.local_code
    join nation n
        on l.national_code = n.national_code
where
    national_name in ('한국', '일본')
order by
    national_name desc;
    
/*
10. 같은 부서에 근무하는 직원들의 사원명, 부서코드, 동료이름을 조회하시오.
self join 사용
*/
select
    e.emp_name "사원명",
    e.dept_code "부서코드",
    m.emp_name "동료이름"
from 
    employee e join employee m
        on e.dept_code = m.dept_code
where
    e.emp_name != m.emp_name
order by
    e.emp_name;
 
/*
11. 보너스포인트가 없는 직원들 중에서 직급이 차장과 사원인 직원들의 사원명, 직급명, 급여를 조회하시오.
*/
select
    e.emp_name "사원명",
    j.job_name "직급명",
    to_char(e.salary, 'FML999,999,999') "급여"
from
    employee e join job j
        on e.job_code = j.job_code
where
    e.bonus is null 
    and j.job_name in ('차장', '사원');

/*
12. 재직중인 직원과 퇴사한 직원의 수를 조회하시오.
*/
select
    decode(quit_yn, 'N', '재직자', '퇴사자') "구분",
    count(quit_yn) || '명' "인원"
from
    employee
group by
    quit_yn;
    
select
    trunc(months_between(sysdate, '19960130') / 12) + 1,
    trunc(months_between(sysdate, '19961225') / 12) + 1
from
    dual;