--▶22/11/10====================
-- [sh 계정] TRIGGER
/*
1. EMPLOYEE테이블의 퇴사자관리를 별도의 테이블 TBL_EMP_QUIT에서 하려고 한다.
    다음과 같이 TBL_EMP_JOIN, TBL_EMP_QUIT테이블을 생성하고, 
    TBL_EMP_JOIN에서 DELETE시 자동으로 퇴사자 데이터가 TBL_EMP_QUIT에 INSERT되도록 트리거를 생성하라.
*/

-- * TBL_EMP_JOIN 테이블 생성 : QUIT_DATE, QUIT_YN 제외
create table tbl_emp_join
as
select emp_id, emp_name, emp_no, email, phone, dept_code, job_code, sal_level, salary, bonus, manager_id, hire_date
from employee
where quit_yn = 'N';

select * from tbl_emp_join;

-- * TBL_EMP_QUIT : EMPLOYEE테이블에서 QUIT_YN 컬럼제외하고 복사
create table tbl_emp_quit
as
select emp_id, emp_name, emp_no, email, phone, dept_code, job_code, sal_level, salary, bonus, manager_id, hire_date, quit_date
from employee
where quit_yn = 'Y';

select * from tbl_emp_quit;

-- * 트리거 생성
create or replace trigger trig_tbl_emp
    before 
    delete on tbl_emp_join
    for each row
begin
    if deleting then
        insert into
            tbl_emp_quit(emp_id, emp_name, emp_no, email, phone, dept_code, job_code, sal_level, salary, bonus, manager_id, hire_date, quit_date)
        values (
            :old.emp_id, :old.emp_name, :old.emp_no, :old.email, :old.phone, :old.dept_code, :old.job_code, 
            :old.sal_level, :old.salary, :old.bonus, :old.manager_id, :old.hire_date, sysdate   
        );
    end if;
end;
/

-- * 확인
delete from tbl_emp_join where emp_id = '223';
select * from tbl_emp_join;
select * from tbl_emp_quit;
rollback;


/*
2. 사원변경내역을 기록하는 emp_log테이블을 생성하고, ex_employee 사원테이블의 insert, update가 있을 때마다 
    신규데이터를 기록하는 트리거를 생성하라.
    * 로그테이블명 emp_log : 컬럼 log_no(시퀀스객체로부터 채번함. pk), log_date(기본값 sysdate, not null), ex_employee테이블의 모든 컬럼
    * 트리거명 trg_emp_log
*/

-- * 테이블 생성
create table emp_log 
as
select
    *
from
    ex_employee
where
    1 = 0;
    
alter table
    emp_log
add ( 
    log_no number, 
    log_date date default sysdate not null, 
    constraint pk_emp_log_no primary key(log_no)
);

select * from emp_log;

--* 시퀀스 생성
create sequence seq_emp_log_log_no;
    
--* 트리거 생성
create or replace trigger trg_emp_log
    before
    insert or update on ex_employee
    for each row
begin
    if inserting then
        insert into
            emp_log(emp_id, emp_name, emp_no, email, phone, dept_code, job_code, sal_level, salary, bonus, manager_id, hire_date, quit_date, quit_yn, log_no, log_date)
        values (
            :new.emp_id, :new.emp_name, :new.emp_no, :new.email, :new.phone, :new.dept_code, :new.job_code, :new.sal_level, 
            :new.salary, :new.bonus, :new.manager_id, :new.hire_date, :new.quit_date, :new.quit_yn, seq_emp_log_log_no.nextval, default
        );
    elsif updating then
        insert into
            emp_log(emp_id, emp_name, emp_no, email, phone, dept_code, job_code, sal_level, salary, bonus, manager_id, hire_date, quit_date, quit_yn, log_no, log_date)
        values (
            :new.emp_id, :new.emp_name, :new.emp_no, :new.email, :new.phone, :new.dept_code, :new.job_code, :new.sal_level, 
            :new.salary, :new.bonus, :new.manager_id, :new.hire_date, :new.quit_date, :new.quit_yn, seq_emp_log_log_no.nextval, default
        );
    end if;
end;
/
-- # :new.emp어쩌고 이거 하나하나 다 적어야하는걸까..? 다른 방법은 없을까...

-- * 확인
select * from ex_employee;
select * from emp_log;

insert into ex_employee (emp_id, emp_name, emp_no, job_code, sal_level, hire_date, quit_yn) 
values ('310', '나망고', '990909-2020202', 'J5', 'S5', sysdate, 'N');
insert into ex_employee (emp_id, emp_name, emp_no, job_code, sal_level, hire_date, quit_yn) 
values ('311', '나포도', '020202-3030303', 'J5', 'S5', sysdate, 'N');

update ex_employee set dept_code = 'D1' where emp_id = '311';
update ex_employee set email = 'mango123@tropical.com' where emp_name = '나망고';
