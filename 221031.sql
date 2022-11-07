-- ▶ 22/10/31 ======================
-- [chun 계정]
/*
1. 학번, 학생명, 담당교수명을 출력하세요.
담당교수가 없는 학생은 '없음'으로 표시
*/
select
    s.student_no "학번",
    s.student_name "학생명",
    nvl2(s.coach_professor_no, p.professor_name, '없음') "담당교수명"
from
    tb_student s, tb_professor p
where
    s.coach_professor_no = p.professor_no (+);
/*
2. 학과별 교수명과 인원수를 모두 표시하세요.
*/
select
    d.department_name "학과번호",
    nvl(p.professor_name, '총 인원') "교수명",
    count(*) "인원"
from
    tb_professor p
        join tb_department d on p.department_no = d.department_no 
where
    p.department_no is not null and
    p.professor_name is not null
group by
    rollup(d.department_name, p.professor_name)
order by
    1;
--------------------    
select *
from tb_professor 
where department_no is null;

select decode(grouping(department_name),0,nvl(department_name,'미지정'),1,'총계') 학과명
       , decode(grouping(professor_name),0,professor_name,1,count(*)) 교수명  
from tb_professor p 
    left join tb_department d using(department_no)
group by rollup(department_name, professor_name)
order by d.department_name;

/*
3. 이름이 [~람]인 학생의 평균학점을 구해서 학생명과 평균학점(반올림해서 소수점둘째자리까지)과 같이 출력.
(동명이인일 경우에 대비해서 student_name만으로 group by 할 수 없다.)
*/
select
    g.student_no "학번",
    s.student_name "이름",
    round(avg(point), 2) "평균학점"
from
    tb_grade g, tb_student s
where
    g.student_no = s.student_no and
    s.student_name like '%람'
group by
    g.student_no, s.student_name;

/*
4. 학생별 다음정보를 구하라.
(group by 없는 단순 조회)
--------------------------------------------
학생명         학기         과목명           학점
-------------------------------------------
감현제    200702    치과분자약리학    4.5
감현제    200701    구강회복학          4
            .
            .
--------------------------------------------
*/
select
    s.student_name "학생명",
    g.term_no "학기",
    c.class_name "과목명",
    g.point "학점"
from
    tb_student s, tb_grade g,  tb_class c
where
    s.student_no = g.student_no (+) and
    g.class_no = c.class_no
order by
    1, 2;