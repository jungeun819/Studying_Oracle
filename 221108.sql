-- ▶22/11/08========================
-- [sh 계정]
/*
1. EX_EMPLOYEE테이블에서 사번 마지막번호를 구한뒤, +1한 사번에 사용자로 부터 입력받은 
    이름, 주민번호, 전화번호, 직급코드(J5), 급여등급(S5)를 등록하는 PL/SQL을 작성하세요.
*/
SET SERVEROUTPUT ON;
select * from ex_employee order by 1;

declare
    v_emp_id ex_employee.emp_id%type;
    v_emp_name ex_employee.emp_name%type := '&이름';
    v_emp_no ex_employee.emp_no%type := '&주민번호';
    v_job_code ex_employee.job_code%type := '&직급코드';
    v_sal_level ex_employee.sal_level%type := '&급여등급';
begin

    -- 마지막 번호 + 1 / v_emp_id 값 대입
    select
        (select max(emp_id) + 1 from ex_employee)
    into
        v_emp_id
    from
        dual;
    
    -- 데이터 추가
    insert into 
        ex_employee(emp_id, emp_name, emp_no, job_code, sal_level)
    values (
        v_emp_id, v_emp_name, v_emp_no, v_job_code, v_sal_level
    );
            
    -- 확인
    dbms_output.put_line('사번 : ' || v_emp_id);
    dbms_output.put_line('이름 : ' || v_emp_name);
    dbms_output.put_line('주민번호 : ' || v_emp_no);
    dbms_output.put_line('직급코드 : ' || v_job_code);
    dbms_output.put_line('급여등급 : ' || v_sal_level);
    commit;

end;
/

/*
2. 동전 앞뒤맞추기 게임 익명블럭을 작성하세요.
dbms_random.value api 참고해 난수 생성할 것.
*/
select
    round(dbms_random.value(1, 2))
from
    dual;

declare
    user_pick number := &1번_앞_2번_뒤;
    com_pick number;
begin
    select
        trunc(dbms_random.value(1, 3))
    into
        com_pick
    from
        dual;
    
    -- 사용자 선택
    if user_pick = 1 then
        dbms_output.put_line('사용자 선택 > 앞');
    elsif user_pick = 2 then
        dbms_output.put_line('사용자 선택 > 뒤');
    else
        dbms_output.put_line('1(앞) 또는 2(뒤)만 입력해주세요');
    end if;
    
    -- 컴퓨터 선택
    if com_pick = 1 then
        dbms_output.put_line('컴퓨터 선택 > 앞');
    else
        dbms_output.put_line('컴퓨터 선택 > 뒤' );
    end if;
    
    -- 결과 
    if user_pick = com_pick then
        dbms_output.put_line('정답입니다!');
    else
        dbms_output.put_line('틀렸습니다ㅠ');
    end if;
end;
/
