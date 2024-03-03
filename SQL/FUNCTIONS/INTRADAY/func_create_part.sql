CREATE OR REPLACE FUNCTION INTRADAY.FUNC_CREATE_PART(P_SYMBOL_I IN VARCHAR(10),
													 P_SCHEMA_I IN VARCHAR(50))
RETURNS VARCHAR
AS $$
DECLARE
  	p_name varchar(10) := LOWER('p_'||P_SYMBOL_I);
	v_count bigint;
BEGIN
  --Attempt to count the relevant rows
  SELECT COUNT(*)
  INTO v_count
  FROM pg_inherits INNER JOIN pg_class child
  	  ON child.oid = pg_inherits.inrelid
    INNER JOIN pg_class parent ON parent.oid = pg_inherits.inhparent
  WHERE child.relname = p_name
    AND child.relnamespace = (SELECT oid FROM pg_namespace
							  WHERE nspname = LOWER(p_schema));
							  
  IF v_count = 0 THEN
    EXECUTE FORMAT('CREATE TABLE %I.%I PARTITION OF %I.%I FOR VALUES IN (%L)',
				  P_SCHEMA_I, p_name, P_SCHEMA_I, P_TABLE_I, P_SYMBOL_I);
  END IF;
  RETURN p_name;
END;
$$ LANGUAGE plpgsql;