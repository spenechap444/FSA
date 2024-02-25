CREATE OR REPLACE PROCEDURE intraday.ssp_price_partition_assign()
AS $$
DECLARE
  symbol_cur CURSOR FOR
    SELECT DISTINCT symbol
    FROM intraday.stock_prices;
	
  lv_symbol VARCHAR(10);
  lv_partition_name VARCHAR(10);
BEGIN
  OPEN symbol_cur;
  LOOP
    FETCH symbol_cur INTO lv_symbol;
	EXIT WHEN NOT FOUND;
	lv_partition_name := 'p_' || lv_symbol; 
	
	EXECUTE FORMAT('INSERT INTO %I SELECT * FROM intraday.stock_prices WHERE symbol = %L',
				  lv_partition_name, lv_symbol);
	EXECUTE FORMAT('DELETE FROM intraday.stock_prices WHERE symbol = %L', lv_symbol);
  END LOOP;
  CLOSE symbol_cur;				  
END;
$$ LANGUAGE plpgsql;
