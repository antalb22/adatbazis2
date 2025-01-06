CREATE OR REPLACE PACKAGE pkg_users AS
  email_mar_letezik_exc EXCEPTION;
  PRAGMA EXCEPTION_INIT(email_mar_letezik_exc, -20000);

  PROCEDURE adduser(p_name  VARCHAR2
                   ,p_email VARCHAR2);
END pkg_users;
/
CREATE OR REPLACE PACKAGE BODY pkg_users AS
  PROCEDURE adduser(p_name  VARCHAR2
                   ,p_email VARCHAR2) IS
    v_count NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_count FROM appuser WHERE email = p_email;
  
    IF v_count > 0
    THEN
      RAISE email_mar_letezik_exc;
    END IF;
  
    INSERT INTO appuser
      (NAME
      ,email
      ,registration_date)
    VALUES
      (p_name
      ,p_email
      ,SYSDATE);
  END adduser;
END pkg_users;
/
