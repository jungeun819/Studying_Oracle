-- ▶22/11/04 ========================
-- [chun 계정] Additional SELECT - Option
/*
1. 학생이름과 주소지를 표시하시오. 단, 출력 헤더는 "학생 이름", "주소지"로 하고, 정렬은 이름으로 오름차순 표시.
*/
select 
    student_name "학생 이름",
    student_address "주소지"
from 
    tb_student
order by
    student_name asc;

/*
2. 휴학중인 학생들의 이름과 주민번호를 나이가 적은 순서로 화면에 출력하시오.
*/
select * from tb_student;

select
    student_name,
    student_ssn
--    age
from(
    select
        s.*,
        extract(year from sysdate) - (decode(substr(student_ssn, 8, 1), '1', 1900, '2', 1900, 2000) + substr(student_ssn, 1, 2)) age
    from
        tb_student s
    )
where
    absence_yn = 'Y'
order by
    age;

/*
3. 주소지가 강원도나 경기도인 학생들 중 1900 년대 학번을 가진 학생들의 이름과 학번, 주소를 
이름의 오름차순으로 화면에 출력하시오. 단, 출력헤더에는 "학생이름","학번", "거주지 주소" 가 출력되도록 한다.
*/
select
    student_name 학생이름,
    student_no 학번,
    student_address "거주지 주소"
from
    tb_student
where
    student_no not like 'A%'
    and substr(student_address, 1, 2) in ('강원', '경기');

/*
4. 현재 법학과 교수 중 가장 나이가 많은 사람부터 이름을 확인 수 있는 SQL 문장을 작성하시오. 
(법학과의 '학과코드'는 학과 테이블(TB_DEPARTMENT)을 조회해서 찾아 내도록 하자)
*/
select
    professor_name 교수명,
    professor_ssn 주민번호
--    age
from(
    select
        p.*,
        extract(year from sysdate) - (decode(substr(professor_ssn, 8, 1), '1', 1900, '2', 1900, 2000) + substr(professor_ssn, 1, 2)) age
    from
        tb_professor p
    )
where
    department_no = (select department_no from tb_department where department_name = '법학과')
order by
    age desc;

/*
5. 2004년 2학기에 'C3118100' 과목을 수강한 학생들의 학점을 조회하려고 한다. 
학점이 높은 학생부터 표시하고, 학점이 같으면 학번이 낮은 학생부터 표시하는 구문을 작성해보시오.
*/
select
    student_no 학번,
    point 학점
from
    tb_student s left join tb_grade g
        using(student_no)
where
    g.term_no = '200402'
    and g.class_no = 'C3118100'
order by
    point desc, student_no ;

/*
6. 학생 번호, 학생 이름, 학과 이름을 학생 이름으로 오름차순 정렬하여 출력하는 SQL문을 작성하시오.
*/
-- join ver.
select
    s.student_no 학번,
    s.student_name 이름,
    d.department_name 학과명
from
    tb_student s left join tb_department d
        using(department_no)
order by
    s.student_name;

-- scalar_subquery ver.
select
    student_no 학번,
    student_name 이름,
    (select department_name from tb_department where department_no = s.department_no) 학과명
from
    tb_student s
order by
    student_name;

/*
7. 춘 기술대학교의 과목 이름과 과목의 학과 이름을 출력하는 SQL 문장을 작성하시오.
*/
-- join ver.
select
    c.class_name 수업명,
    d.department_name 학과명
from
    tb_class c left join tb_department d
        using(department_no);

-- scalar_subquery ver.
select
    class_name 수업명,
    (select department_name from tb_department where department_no = c.department_no) 학과명
from
    tb_class c;

/*
8. 과목별 교수 이름을 찾으려고 한다. 과목 이름과 교수 이름을 출력하는 SQL 문을 작성하시오.
*/
-- join ver.
select
    c.class_name 수업명,
    p.professor_name 교수명
from
    tb_class_professor m join tb_professor p
        using(professor_no)
    join tb_class c
        using(class_no)
order by
    교수명;

-- scalar_subquery ver.
select
    (select class_name from tb_class where class_no = m.class_no) 수업명,
    (select professor_name from tb_professor where professor_no = m.professor_no) 교수명
from
    tb_class_professor m
order by
    교수명;

/*
9. 8 번의 결과 중 ‘인문사회’ 계열에 속한 과목의 교수 이름을 찾으려고 한다. 
이에 해당하는 과목 이름과 교수 이름을 출력하는 SQL 문을 작성하시오.
*/
select * from tb_class;
select * from tb_department;
-- join ver.
select
    c.class_name 수업명,
    p.professor_name 교수명
from
    tb_class_professor m join tb_professor p
        using(professor_no)
    join tb_class c
        using(class_no)
    join tb_department d
        on d.department_no = c.department_no
where
    d.category = '인문사회'
order by
    교수명;

-- scalar_subquery ver.
select
    (select class_name from tb_class where class_no = m.class_no) 수업명,
    (select professor_name from tb_professor where professor_no = m.professor_no) 교수명
from
    tb_class_professor m
where
    (select department_no from tb_professor where professor_no = m.professor_no) in (select department_no from tb_department where category = '인문사회')
order by
    교수명;

/*
10. ‘음악학과’ 학생들의 평점을 구하려고 한다. 음악학과 학생들의 "학번", "학생 이름", "전체 평점"을 
출력하는 SQL 문장을 작성하시오. (단, 평점은 소수점 1 자리까지만 반올림하여 표시한다.)
*/
select
    s.student_no 학번,
    s.student_name "학생 이름",
    g.avg_sal "전체 평점"
from
    tb_student s join (select student_no, round(avg(point), 1) avg_sal from tb_grade group by student_no) g
        on s.student_no = g.student_no
where
    department_no = (select department_no from tb_department where department_name = '음악학과')
order by
    "전체 평점" desc;







