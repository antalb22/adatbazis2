CREATE OR REPLACE PACKAGE pkg_plans AS

  user_not_found_exc EXCEPTION;
  PRAGMA EXCEPTION_INIT(user_not_found_exc, -20300);

  PROCEDURE add_plan(p_name    VARCHAR2
                    ,p_goal    VARCHAR2
                    ,p_user_id NUMBER);
END pkg_plans;
/
CREATE OR REPLACE PACKAGE BODY pkg_plans AS
  PROCEDURE add_plan(p_name    VARCHAR2
                    ,p_goal    VARCHAR2
                    ,p_user_id NUMBER) IS
    v_user_count NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_user_count FROM users WHERE user_id = p_user_id;
  
    IF v_user_count = 0
    THEN
      RAISE user_not_found_exc;
    END IF;
  
    INSERT INTO plans
      (plan_id
      ,NAME
      ,goal
      ,user_id)
    VALUES
      (plans_seq.nextval
      ,p_name
      ,p_goal
      ,p_user_id);
  END add_plan;
END pkg_plans;
/
