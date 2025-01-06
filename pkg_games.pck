CREATE OR REPLACE PACKAGE pkg_games AS
  user_not_found_exc EXCEPTION;
  PRAGMA EXCEPTION_INIT(user_not_found_exc, -20001);

  -- One-player games
  PROCEDURE add_game(p_user_id NUMBER
                    ,p_result  VARCHAR2
                    ,p_date    DATE);

  -- Two-player games
  PROCEDURE add_game(p_user_id_1 NUMBER
                    ,p_user_id_2 NUMBER
                    ,p_winner    NUMBER
                    ,p_date      DATE);
END pkg_games;
/
CREATE OR REPLACE PACKAGE BODY pkg_games AS
  -- One-player games
  PROCEDURE add_game(p_user_id NUMBER
                    ,p_result  VARCHAR2
                    ,p_date    DATE) IS
    v_user_count NUMBER;
  BEGIN
    SELECT COUNT(*)
      INTO v_user_count
      FROM appuser
     WHERE user_id = p_user_id;
  
    IF v_user_count = 0
    THEN
      RAISE user_not_found_exc;
    END IF;
  
    INSERT INTO game
      (match_id
      ,user_id
      ,RESULT
      ,game_date)
    VALUES
      (match_seq.nextval
      ,p_user_id
      ,p_result
      ,p_date);
  END add_game;

  -- Two-player games
  PROCEDURE add_game(p_user_id_1 NUMBER
                    ,p_user_id_2 NUMBER
                    ,p_winner    NUMBER
                    ,p_date      DATE) IS
    v_user_1_count NUMBER;
    v_user_2_count NUMBER;
    v_match_id     NUMBER;
  BEGIN
    SELECT COUNT(*)
      INTO v_user_1_count
      FROM appuser
     WHERE user_id = p_user_id_1;
    SELECT COUNT(*)
      INTO v_user_2_count
      FROM appuser
     WHERE user_id = p_user_id_2;
  
    IF v_user_1_count = 0
       OR v_user_2_count = 0
    THEN
      RAISE user_not_found_exc;
    END IF;
  
    SELECT match_seq.nextval INTO v_match_id FROM dual;
  
    IF p_winner = p_user_id_1
    THEN
      INSERT INTO game
        (match_id
        ,user_id
        ,RESULT
        ,game_date)
      VALUES
        (v_match_id
        ,p_user_id_1
        ,'Win'
        ,p_date);
    
      INSERT INTO game
        (match_id
        ,user_id
        ,RESULT
        ,game_date)
      VALUES
        (v_match_id
        ,p_user_id_2
        ,'Loss'
        ,p_date);
    
    ELSE
      INSERT INTO game
        (match_id
        ,user_id
        ,RESULT
        ,game_date)
      VALUES
        (v_match_id
        ,p_user_id_2
        ,'Win'
        ,p_date);
    
      INSERT INTO game
        (match_id
        ,user_id
        ,RESULT
        ,game_date)
      VALUES
        (v_match_id
        ,p_user_id_1
        ,'Loss'
        ,p_date);
    
    END IF;
  END add_game;
END pkg_games;
/
