----------------------------------
-- 1. Create user, add grants   --
----------------------------------

DECLARE
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count FROM dba_users t WHERE t.username='DARTS_ADMIN';
  IF v_count = 1 THEN 
    EXECUTE IMMEDIATE 'DROP USER DARTS_ADMIN CASCADE';
  END IF;
END;
/
CREATE USER DARTS_ADMIN 
  IDENTIFIED BY "12345678" 
  DEFAULT TABLESPACE users
  QUOTA UNLIMITED ON users
;

GRANT CREATE TRIGGER to DARTS_ADMIN;
GRANT CREATE SESSION TO DARTS_ADMIN;
GRANT CREATE TABLE TO DARTS_ADMIN;
GRANT CREATE VIEW TO DARTS_ADMIN;
GRANT CREATE SEQUENCE TO DARTS_ADMIN;
GRANT CREATE PROCEDURE TO DARTS_ADMIN;


ALTER SESSION SET CURRENT_SCHEMA=DARTS_ADMIN;


---------------------------------------
-- 2. Create tables and connections  --
---------------------------------------

-- Users
CREATE TABLE Users (
    user_id NUMBER PRIMARY KEY,
    name VARCHAR2(255) NOT NULL,
    email VARCHAR2(255) UNIQUE NOT NULL,
    registration_date DATE NOT NULL
);

-- Plans
CREATE TABLE Plans (
    plan_id NUMBER PRIMARY KEY,
    name VARCHAR2(255) NOT NULL,
    goal VARCHAR2(255) NOT NULL,
    user_id NUMBER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Games
CREATE TABLE Games (
    game_id NUMBER PRIMARY KEY,
    match_id NUMBER NOT NULL,
    user_id NUMBER NOT NULL,
    result VARCHAR2(50) NOT NULL,
    game_date DATE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Throws
CREATE TABLE Throws (
    throw_id NUMBER PRIMARY KEY,
    game_id NUMBER NOT NULL,
    user_id NUMBER NOT NULL,
    points NUMBER NOT NULL,
    throw_number NUMBER NOT NULL,
    FOREIGN KEY (game_id) REFERENCES Games(game_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-----------------------------
-- 3. Creating Sequences   --
-----------------------------

CREATE SEQUENCE users_seq
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE plans_seq
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE games_seq
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE match_seq
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE throws_seq
START WITH 1
INCREMENT BY 1;

--------------------------
-- 4. Create Triggers   --
--------------------------

-- Users Trigger
CREATE OR REPLACE TRIGGER users_seq_tr
BEFORE INSERT ON Users
FOR EACH ROW
BEGIN
    IF :new.user_id IS NULL THEN
        :new.user_id := users_seq.NEXTVAL;
    END IF;
END;
/

-- Plans Trigger
CREATE OR REPLACE TRIGGER plans_seq_tr
BEFORE INSERT ON Plans
FOR EACH ROW
BEGIN
    IF :new.plan_id IS NULL THEN
        :new.plan_id := plans_seq.NEXTVAL;
    END IF;
END;
/

-- Games Trigger
CREATE OR REPLACE TRIGGER games_seq_tr
BEFORE INSERT ON Games
FOR EACH ROW
BEGIN
    IF :new.game_id IS NULL THEN
        :new.game_id := games_seq.NEXTVAL;
    END IF;
END;
/

-- Throws Trigger
CREATE OR REPLACE TRIGGER throws_seq_tr
BEFORE INSERT ON Throws
FOR EACH ROW
BEGIN
    IF :new.throw_id IS NULL THEN
        :new.throw_id := throws_seq.NEXTVAL;
    END IF;
END;
/

-----------------------
-- 5. Create views   --
-----------------------
CREATE OR REPLACE VIEW vw_statistics AS
SELECT
    u.user_id,
    (SELECT COUNT(*) 
     FROM Games g 
     WHERE g.user_id = u.user_id) AS total_games,
    (SELECT COUNT(*) 
     FROM Games g 
     WHERE g.user_id = u.user_id AND g.result = 'Win') AS total_wins,
    (SELECT COUNT(*) 
     FROM Games g 
     WHERE g.user_id = u.user_id AND g.result = 'Loss') AS total_losses,
    (SELECT COALESCE(MAX(t.points), 0) 
     FROM Throws t 
     WHERE t.user_id = u.user_id) AS highest_score
FROM
    Users u;

