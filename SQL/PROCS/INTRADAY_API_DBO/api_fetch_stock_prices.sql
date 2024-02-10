CREATE OR REPLACE FUNCTION intraday_api_dbo.api_fetch_stock_prices(IN P_SYMBOL_I VARCHAR(10),
                                                                  IN P_WINDOW_START_I TIMESTAMP,
                                                                  IN P_WINDOW_END_I TIMESTAMP)
RETURNS TABLE ( P_SYMBOL_O VARCHAR(10),
                P_WINDOW_CLOSE_O TIMESTAMP,
                P_OPENING_PRICE_O DECIMAL(7,4),
                P_CLOSING_PRICE_O DECIMAL(7,4),
                P_HIGH_PRICE_O DECIMAL(7,4),
                P_LOW_PRICE_O DECIMAL(7,4),
                P_VOLUME_O INTEGER,
                P_CREATE_ID_O VARCHAR(10),
                P_CREATE_TS_O TIMESTAMP,
                P_UPDATE_ID_O VARCHAR(10),
                P_UPDATE_TS_O TIMESTAMP )
AS $$
BEGIN
  IF P_WINDOW_END_I IS NOT NULL THEN
    RETURN QUERY SELECT
                    SYMBOL,
                    WINDOW_CLOSE,
                    OPENING_PRICE,
                    CLOSING_PRICE,
                    HIGH_PRICE,
                    LOW_PRICE,
                    VOLUME,
                    CREATE_ID,
                    CREATE_TS,
                    UPDATE_ID,
                    UPDATE_TS
                 FROM intraday.stock_prices
                 WHERE symbol = P_SYMBOL_I
                  AND window_close > P_WINDOW_START_I
                  AND window_close < P_WINDOW_END_I;
  ELSIF P_WINDOW_END_I IS NULL THEN
    RETURN QUERY SELECT
                    SYMBOL,
                    WINDOW_CLOSE,
                    OPENING_PRICE,
                    CLOSING_PRICE,
                    HIGH_PRICE,
                    LOW_PRICE,
                    VOLUME,
                    CREATE_ID,
                    CREATE_TS,
                    UPDATE_ID,
                    UPDATE_TS
                 FROM intraday.stock_prices
                 WHERE symbol = P_SYMBOL_I
                  AND window_close > P_WINDOW_START_I;
  ELSIF P_WINDOW_START_I IS NULL THEN
    RETURN QUERY SELECT
                SYMBOL,
                WINDOW_CLOSE,
                OPENING_PRICE,
                CLOSING_PRICE,
                HIGH_PRICE,
                LOW_PRICE,
                VOLUME,
                CREATE_ID,
                CREATE_TS,
                UPDATE_ID,
                UPDATE_TS
            FROM intraday.stock_prices
            WHERE symbol = P_SYMBOL_I
              AND window_close = p_window_close_i;
  ELSE
    RETURN QUERY SELECT
                SYMBOL,
                WINDOW_CLOSE,
                OPENING_PRICE,
                CLOSING_PRICE,
                HIGH_PRICE,
                LOW_PRICE,
                VOLUME,
                CREATE_ID,
                CREATE_TS,
                UPDATE_ID,
                UPDATE_TS
            FROM intraday.stock_prices
            WHERE symbol = P_SYMBOL_I;
  END IF;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE EXCEPTION 'Exception raised in intraday_api_dbo.api_fetch_stock_prices (%)', SQLERRM;
END;
$$ LANGUAGE plpgsql;