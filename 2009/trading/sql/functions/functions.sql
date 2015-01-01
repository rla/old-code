CREATE OR REPLACE FUNCTION f_name_of_day(p_day_of_week INT)
RETURNS TEXT AS $$
DECLARE ret VARCHAR(10);
BEGIN
  SELECT name_of_day INTO ret
  FROM day_of_week
  WHERE nr = $1;

  RETURN ret;
END;
$$  LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION f_prev_day(p_day_of_week INT)
RETURNS INT AS $$
BEGIN
  IF p_day_of_week = 1 THEN
    RETURN 7;
  ELSE
    RETURN p_day_of_week - 1;
  END IF;
END;
$$  LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION f_next_day(p_day_of_week INT)
RETURNS INT AS $$
BEGIN
  IF p_day_of_week = 7 THEN
    RETURN 1;
  ELSE
    RETURN p_day_of_week + 1;
  END IF;
END;
$$  LANGUAGE plpgsql;