CREATE OR REPLACE PACKAGE pkg_throws AS
  user_not_found_exc EXCEPTION;
  PRAGMA EXCEPTION_INIT(user_not_found_exc, -20003);

  game_not_found_exc EXCEPTION;
  PRAGMA EXCEPTION_INIT(game_not_found_exc, -20004);

  score_exceeds_limit_exc EXCEPTION;
  PRAGMA EXCEPTION_INIT(score_exceeds_limit_exc, -20005);

  invalid_point_exc EXCEPTION;
  PRAGMA EXCEPTION_INIT(invalid_point_exc, -20006);

  PROCEDURE add_throw(p_game_id     NUMBER
                     ,p_user_id     NUMBER
                     ,p_points_list VARCHAR2);
END pkg_throws;
/
CREATE OR REPLACE PACKAGE BODY pkg_throws AS
  PROCEDURE add_throw(p_game_id     NUMBER
                     ,p_user_id     NUMBER
                     ,p_points_list VARCHAR2) IS
    v_user_count   NUMBER;
    v_game_count   NUMBER;
    v_total_points NUMBER := 0;
    v_throw_number NUMBER := 1;
    v_start_idx    NUMBER := 1;
    v_end_idx      NUMBER := 1;
    v_point_str    VARCHAR2(10);
    v_point        NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_user_count FROM users WHERE user_id = p_user_id;
  
    IF v_user_count = 0
    THEN
      RAISE user_not_found_exc;
    END IF;
  
    SELECT COUNT(*) INTO v_game_count FROM games WHERE game_id = p_game_id;
  
    IF v_game_count = 0
    THEN
      RAISE game_not_found_exc;
    END IF;
  
    WHILE v_start_idx <= length(p_points_list)
    LOOP
      v_end_idx := instr(p_points_list, ',', v_start_idx);
      IF v_end_idx = 0
      THEN
        v_end_idx := length(p_points_list) + 1;
      END IF;
    
      v_point_str := TRIM(substr(p_points_list,
                                 v_start_idx,
                                 v_end_idx - v_start_idx));
      v_start_idx := v_end_idx + 1;
    
      BEGIN
        v_point := to_number(v_point_str);
      EXCEPTION
        WHEN OTHERS THEN
          RAISE invalid_point_exc;
      END;
    
      v_total_points := v_total_points + v_point;
    
      IF v_total_points > 501
      THEN
        RAISE score_exceeds_limit_exc;
      END IF;
    
      INSERT INTO throws
        (throw_id
        ,game_id
        ,user_id
        ,points
        ,throw_number)
      VALUES
        (throws_seq.nextval
        ,p_game_id
        ,p_user_id
        ,v_point
        ,v_throw_number);
    
      v_throw_number := v_throw_number + 1;
    END LOOP;
  END add_throw;
END pkg_throws;
/
