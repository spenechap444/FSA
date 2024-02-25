CREATE OR REPLACE FUNCTION intraday.func_create_price_part(IN P_SYMBOL_I VARCHAR(10))
RETURNS VARCHAR
AS $$
DECLARE
  lv_part_name VARCHAR(12) := 'P_' || P_SYMBOL_I;
BEGIN
    PERFORM 1 FROM pg_partitions WHERE part_name = lv_part_name;
    IF NOT FOUND THEN
        -- Create a new partition
        EXECUTE FORMAT('CREATE TABLE %I PARTITION OF INTRADAY.STOCK_PRICES FOR VALUES IN (%L)', 
            lv_part_name, P_SYMBOL_I);
    END IF;
    RETURN lv_part_name;
END;
$$ LANGUAGE plpgsql;