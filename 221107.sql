-- ▶ 221107=======================
-- [chun 계정]
-- ▷ DDL
/*
1. 계열 정보를 저장할 카테고리 테이블을 만들려고 한다. 다음과 같은 테이블을 작성하시오.
*/
create table tb_category (
    name varchar2(10),
    use_yn char(1) default 'Y'
);

/*
2. 과목 구분을 저장할 테이블을 만들려고 한다. 다음과 같은 테이블을 작성하시오.
*/
create table tb_class_type (
    no varchar2(5),
    name varchar2(10),
    constraint pk_tb_class_type_no primary key(no)
);

/*
3. TB_CATAGORY 테이블의 NAME 컬럼에 PRIMARY KEY 를 생성하시오.
(KEY 이름을 생성하지 않아도 무방함. 만일 KEY 이를 지정하고자 한다면 이름은 본인이 알아서 적당한 이름을 사용한다.)
*/
alter table
    tb_category
add constraint
    pk_tb_category_name primary key(name);

/*
4. TB_CLASS_TYPE 테이블의 NAME 컬럼에 NULL 값이 들어가지 않도록 속성을 변경하시오.
*/
alter table
    tb_class_type
modify
    name varchar2(10) not null;

/*
5. 두 테이블에서 컬럼 명이 NO 인 것은 기존 타입을 유지하면서 크기는 10 으로, 
컬럼명이 NAME인 것은 마찬가지로 기존 타입을 유지하면서 크기 20 으로 변경하시오.
*/
alter table
    tb_category
modify
    name varchar2(20); -- not null을 다시 입력하지 않아도 됨! 그냥 기본값만 바뀜!

--alter table
--    tb_class_type
--modify
--    no varchar2(10); 
--alter table
--    tb_class_type
--modify
--    name varchar2(20); -- * 한 테이블의 no와 name을 동시에 바꿀수는 없는건가,,,?

alter table 
    tb_class_type 
modify 
    no varchar2(10) 
modify 
    name varchar2(20); -- > 두 개 동시에 바꾸는 방법!

/*
6. 두 테이블의 NO 컬럼과 NAME 컬럼의 이름을 각 각 TB_ 를 제외핚 테이블 이름이 앞에 붙은 형태로 변경한다.
*/
alter table
    tb_category
rename column name to category_name;

--alter table
--    tb_calss_type
--rename column no to class_type_no           -- rename은 같이 못쓰는건가,,,
--rename column name to class_type_name; -- ORA-23290: 이 작업을 다른 작업과 결합할 수 없음

alter table
    tb_class_type
rename column no to class_type_no;

alter table
    tb_class_type
rename column name to class_type_name;

/*
7. TB_CATAGORY 테이블과 TB_CLASS_TYPE 테이블의 PRIMARY KEY 이름을 다음과 같이 변경하시오.
    (Primary Key 의 이름은 "PK_ + 컬럼이름"으로 지정하시오. (ex. PK_CATEGORY_NAME ))
*/
alter table
    tb_category
rename constraint pk_tb_category_name to pk_category_name;

alter table
    tb_class_type
rename constraint pk_tb_class_type_no to pk_class_type_no;

/*
8. 다음과 같은 INSERT 문을 수행한다.
*/
INSERT INTO TB_CATEGORY VALUES ('공학','Y');
INSERT INTO TB_CATEGORY VALUES ('자연과학','Y');
INSERT INTO TB_CATEGORY VALUES ('의학','Y');
INSERT INTO TB_CATEGORY VALUES ('예체능','Y');
INSERT INTO TB_CATEGORY VALUES ('인문사회','Y');
COMMIT;
select * from tb_category;

/*
9. TB_DEPARTMENT 의 CATEGORY 컬럼이 TB_CATEGORY 테이블의 CATEGORY_NAME 컬럼을 
부모값으로 참조하도록 FOREIGN KEY 를 지정하시오. 
이 때 KEY 이름은 FK_테이블이름_컬럼이름으로 지정한다. (ex. FK_DEPARTMENT_CATEGORY )
*/
alter table
    tb_department
add constraint
    fk_department_category foreign key(category) references tb_category(category_name);

/*
10. 춘 기술대학교 학생들의 정보만이 포함되어 있는 학생일반정보 VIEW 를 만들고자 한다.
아래 내용을 참고하여 적절한 SQL 문을 작성하시오.
*/
grant create view to chun; -- 권한 부여는 관리자 계정에서!
create or replace view view_student_info
as
select
    student_no 학번,
    student_name 학생이름,
    student_address 주소
from
    tb_student;

/*
11.  춘 기술대학교는 1년에 두 번씩 학과별로 학생과 지도교수가 지도 면담을 진행한다.
이를 위해 사용한 학생이름, 학과이름, 담당교수이름으로 구성되어 있는 VIEW를 만드시오.
이때 지도 교수가 없는 학생이 있을 수 있음을 고려하시오. 
(단, 이 VIEW는 단순 SELECT만을 할 경우 학과별로 정렬되어 화면에 보여지게 만드시오.)
*/
create or replace view view_interview
as
select
    student_name 학생이름,
    (select department_name from tb_department where department_no = s.department_no) 학과이름,
    nvl((select professor_name from tb_professor where professor_no = s.coach_professor_no), '미정') 지도교수이름
from
    tb_student s
order by
    학과이름;
    
/*
12. 모든 학과의 학과별 학생 수를 확인할 수 있도록 적절한 VIEW를 작성해 보자.
*/
create or replace view view_department_total
as
select
    (select department_name from tb_department where department_no = s.department_no) 학과이름,
    count(department_no) 학생수
from
    tb_student s
group by
    department_no;

/*
13. 위에서 생성한 학생일반정보 View 를 통해서 학번이 A213046 인 학생의 이름을 
본인 이름으로 변경하는 SQL 문을 작성하시오.
*/
update
    view_student_info
set
    학생이름 = '서정은'
where
    학번 = 'A213046';

/*
14. 13 번에서와 같이 VIEW를 통해서 데이터가 변경될 수 있는 상황을 막으려면 VIEW 를
어떻게 생성해야 하는지 작성하시오.
*/
create or replace view view_student_info
as
select
    student_no 학번,
    student_name 학생이름,
    student_address 주소
from
    tb_student
with check option;

/*
15.  춘 기술대학교는 매년 수강신청 기간만 되면 특정 인기 과목들에 수강 신청이 몰려 문제가 되고 있다. 
최근 3 년을 기준으로 수강인원이 가장 많았던 3 과목을 찾는 구문을 작성해보시오.
*/
-- 최근 3년 확인용 view 
create or replace view view_last_three_year
as
select
    year
from(
    select 
        substr(term_no, 1, 4) year
    from
        tb_grade g
    group by
        substr(term_no, 1, 4)
    order by 
        1 desc
    )
where
    rownum <= 3;

-- 최근 3년기준 수강인원 top
select
    과목번호, 과목이름, "누적수강생수(명)"
from(
    select 
        class_no 과목번호,
        (select class_name from tb_class where class_no = g.class_no) 과목이름,
        count(class_no) "누적수강생수(명)",
        dense_rank() over(order by count(class_no) desc) rank
    from
        tb_grade g
    where
        substr(term_no, 1, 4) in (select * from view_last_three_year)
    group by
        class_no
    ) g
where
    rank between 1 and 3; 

-----------------------------------------
desc tb_category;
desc tb_class_type;
desc tb_department;
    
select
    constraint_name,
    uc.table_name,
    ucc.column_name,
    uc.constraint_type,
    uc.search_condition,
    uc.r_constraint_name
from 
    user_constraints uc join user_cons_columns ucc
        using(constraint_name)
where
    uc.table_name = 'TB_CATEGORY';

select
    constraint_name,
    uc.table_name,
    ucc.column_name,
    uc.constraint_type,
    uc.search_condition,
    uc.r_constraint_name
from 
    user_constraints uc join user_cons_columns ucc
        using(constraint_name)
where
    uc.table_name = 'TB_CLASS_TYPE';

select
    constraint_name,
    uc.table_name,
    ucc.column_name,
    uc.constraint_type,
    uc.search_condition,
    uc.r_constraint_name
from 
    user_constraints uc join user_cons_columns ucc
        using(constraint_name)
where
    uc.table_name = 'TB_DEPARTMENT';
    

-- ▷ DML
/*
1. 과목유형 테이블(TB_CLASS_TYPE)에 아래와 같은 데이터를 입력하시오.
*/
insert into tb_class_type values ('01', '전공필수');
insert into tb_class_type values ('02', '전공선택');
insert into tb_class_type values ('03', '교양필수');
insert into tb_class_type values ('04', '교양선택');
insert into tb_class_type values ('05', '논문지도');

select * from tb_class_type;

/*
2. 춘 기술대학교 학생들의 정보가 포함되어 있는 학생일반정보 테이블을 만들고자 한다.
아래 내용을 참고하여 적절한 SQL 문을 작성하시오. (서브쿼리를 이용하시오)
*/
desc tb_student;
create table TB_학생일반정보 (
    student_no varchar2(10) not null,
    student_name varchar2(40) not null,
    student_address varchar2(200)
);

--  subquery를 사용한 insert
insert into
    TB_학생일반정보
(
select
    student_no 학번,
    student_name 학생이름,
    student_address 주소
from
    tb_student
);

select * from tb_학생일반정보;

/*
3. 국어국문학과 학생들의 정보만이 포함되어 있는 학과정보 테이블을 만들고자 한다.
아래 내용을 참고하여 적절한 SQL 문을 작성하시오. (힌트 : 방법은 다양함, 소신껏 작성하시오)
*/
create table TB_국어국문학과
as
select
    student_no 학번,
    student_name 학생이름,
    decode(substr(student_ssn, 8, 1), '1', 1900, '2', 1900, 2000) + substr(student_ssn, 1, 2) || '년' 출생년도,
    nvl((select professor_name from tb_professor where professor_no = s.coach_professor_no), '미정') 교수이름
from
    tb_student s;

select * from TB_국어국문학과;

/*
4. 현 학과들의 정원을 10% 증가시키게 되었다. 이에 사용한 SQL 문을 작성하시오. 
(단, 반올림을 사용하여 소수점 자릿수는 생기지 않도록 한다)
*/
update
    tb_department   
set
    capacity = round(capacity + (capacity * 0.1));
    
select * from tb_department;

/*
5. 학번 A413042인 박건우 학생의 주소가 "서울시 종로구 숭인동 181-21 "로 변경되었다고 한다. 
주소지를 정정하기 위해 사용한 SQL 문을 작성하시오.
*/
update
    tb_student
set
    student_address = '서울시 종로구 숭인동 181-21'
where
    student_no = 'A413042';

select * from tb_student where student_no = 'A413042';

/*
6. 주민등록번호 보호법에 따라 학생정보 테이블에서 주민번호 뒷자리를 저장하지 않기로 결정하였다. 
이 내용을 반영할 적절한 SQL 문장을 작성하시오.
(예. 830530-2124663 ==> 830530 )
*/
update
    tb_student
set
    student_ssn = substr(student_ssn, 1, 6);

select * from tb_student;
--rollback;

/*
7. 의학과 김명훈 학생은 2005 년 1학기에 자신이 수강한 '피부생리학' 점수가
잘못되었다는 것을 발견하고는 정정을 요청하였다. 담당 교수의 확인 받은 결과 해당
과목의 학점을 3.5 로 변경키로 결정되었다. 적절한 SQL 문을 작성하시오.
*/
update
    tb_grade
set
    point = 3.5
where
    student_no in (select student_no from tb_student where student_name = '김명훈') and
    class_no = (select class_no from tb_class where class_name = '피부생리학');

-- 확인용
select
    *
from
    tb_grade
where
    student_no in (select student_no from tb_student where student_name = '김명훈') and
    class_no = (select class_no from tb_class where class_name = '피부생리학');

/*
8. 성적 테이블(TB_GRADE) 에서 휴학생들의 성적항목을 제거하시오.
*/
delete from
    tb_grade
where
    student_no in (select student_no from tb_student where absence_yn = 'Y');
--rollback;
-- 확인용
select 
    g.*,
    (select absence_yn from tb_student where student_no = g.student_no) absence_n
from 
    tb_grade g;
    