BEGIN
  pkg_users.adduser('Kiss János', 'kiss.janos@example.com');
END;
/
BEGIN
  pkg_users.adduser('József Attila', 'jozsef.attila@example.com');
END;
/
BEGIN
  pkg_users.adduser('Luke Littler', 'luke.littler@example.com');
END;
/
BEGIN
  pkg_users.adduser('Nagy Ferenc', 'nagy.ferenc@example.com');
END;
/

-- One-player games
BEGIN
  pkg_games.add_game(1, 'Win', SYSDATE - 10);
  pkg_games.add_game(1, 'Loss', SYSDATE - 8);
  pkg_games.add_game(2, 'Win', SYSDATE - 7);
  pkg_games.add_game(3, 'Loss', SYSDATE - 5);
END;
/

-- Two- player games
BEGIN
  pkg_games.add_game(1, 2, 1, SYSDATE - 10);
  pkg_games.add_game(3, 4, 3, SYSDATE - 8);
  pkg_games.add_game(2, 1, 2, SYSDATE - 6);
  pkg_games.add_game(4, 3, 4, SYSDATE - 4);
END;
/


-- Training plans
BEGIN
  pkg_plans.add_plan('Accuracy', 'Improve precision on trebles', 2);
  pkg_plans.add_plan('Speed', 'Reduce average throw time', 1);
  pkg_plans.add_plan('Endurance', 'Maintain consistency for 20 rounds', 3);
  pkg_plans.add_plan('Strategy', 'Practice finishes under pressure', 4);
END;
/


-- Throws for one-player games
BEGIN
  pkg_throws.add_throw(1, 1, '60, 20, 50, 100, 140, 91, 40'); -- Total = 501
END;
/
BEGIN
  pkg_throws.add_throw(2, 1, '100, 80, 60, 140, 101'); -- Total = 481
END;
/
BEGIN
  pkg_throws.add_throw(3, 2, '50, 40, 180, 60, 171'); -- Total = 501
END;
/
BEGIN
  pkg_throws.add_throw(4, 3, '80, 60, 100, 120, 139'); -- Total = 499
END;
/

-- Throws for two-player matches
BEGIN
  pkg_throws.add_throw(5, 1, '60, 100, 140, 100, 101'); -- Winner: Total = 501
  pkg_throws.add_throw(6, 2, '60, 100, 120, 80, 100');  -- Loser: Total = 460
END;
/
BEGIN
  pkg_throws.add_throw(7, 3, '100, 140, 60, 100, 101'); -- Winner: Total = 501
  pkg_throws.add_throw(8, 4, '80, 60, 100, 100, 120');  -- Loser: Total = 460
END;
/
BEGIN
  pkg_throws.add_throw(9, 2, '60, 140, 60, 100, 141');  -- Winner: Total = 501
  pkg_throws.add_throw(10, 1, '100, 60, 100, 80, 80');  -- Loser: Total = 420
END;
/
BEGIN
  pkg_throws.add_throw(11, 4, '60, 100, 100, 140, 101'); -- Winner: Total = 501
  pkg_throws.add_throw(12, 3, '80, 60, 100, 140, 80');   -- Loser: Total = 460
END;
/





SELECT * FROM vw_statistics;
/
