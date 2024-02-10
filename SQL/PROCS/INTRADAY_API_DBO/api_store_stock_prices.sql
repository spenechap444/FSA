CREATE OR REPLACE PROCEDURE intraday_api_dbo.api_store_stock_prices(P_SYMBOL_I IN VARCHAR(10),
                                                                    P_WINDOW_CLOSE_I IN TIMESTAMP,
                                                                    P_OPENING_PRICE_I IN DECIMAL(7,4),
                                                                    P_CLOSING_PRICE_I IN DECIMAL(7,4),
                                                                    P_HIGH_PRICE_I IN DECIMAL(7,4),
                                                                    P_LOW_PRICE_I IN DECIMAL(7,4),
                                                                    P_VOLUME_I IN INTEGER,
                                                                    P_CREATE_ID_I IN VARCHAR(10),
                                                                    P_CREATE_TS_I IN TIMESTAMP)
AS $$
BEGIN
  IF EXISTS (SELECT 1 FROM intraday.stock_prices
            WHERE SYMBOL = P_SYMBOL_I AND WINDOW_CLOSE = P_WINDOW_CLOSE_I) THEN
    UPDATE intraday.stock_prices
    SET
      OPENING_PRICE = P_OPENING_PRICE_I,
      CLOSING_PRICE = P_CLOSING_PRICE_I,
      HIGH_PRICE = P_HIGH_PRICE_I,
      LOW_PRICE = P_LOW_PRICE_I,
      VOLUME = P_VOLUME_I,
      UPDATE_ID = P_CREATE_ID_I,
      UPDATE_TS = P_CREATE_TS_I
    WHERE SYMBOL = P_SYMBOL_I
      AND WINDOW_CLOSE = P_WINDOW_CLOSE_I;
  ELSE
    INSERT INTO intraday.stock_prices(SYMBOL,
                                      WINDOW_CLOSE,
                                      OPENING_PRICE,
                                      CLOSING_PRICE,
                                      HIGH_PRICE,
                                      LOW_PRICE,
                                      VOLUME,
                                      CREATE_ID,
                                      CREATE_TS,
                                      UPDATE_ID,
                                      UPDATE_TS)
                            VALUES (P_SYMBOL_I,
                                    P_WINDOW_CLOSE_I,
                                    P_OPENING_PRICE_I,
                                    P_CLOSING_PRICE_I,
                                    P_HIGH_PRICE_I,
                                    P_LOW_PRICE_I,
                                    P_VOLUME_I,
                                    P_CREATE_ID_I,
                                    P_CREATE_TS_I,
                                    NULL,
                                    NULL);
  END IF;

  EXCEPTION 
    WHEN OTHERS THEN
      RAISE EXCEPTION 'Error in procedure intraday_api_dbo.api_store_stock_prices (%)', SQLERRM;
END;
$$ LANGUAGE plpgsql;