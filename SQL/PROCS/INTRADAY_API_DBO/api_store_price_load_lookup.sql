CREATE OR REPLACE PROCEDURE intraday_api_dbo.api_store_price_load_config(IN P_SYMBOL_I VARCHAR(10),
                                                                        IN P_LAST_PRICE_W_I TIMESTAMP,
                                                                        IN P_LAST_SMA20_W_I TIMESTAMP,
                                                                        IN P_LAST_SMA50_W_I TIMESTAMP,
                                                                        IN P_LAST_SMA100_W_I TIMESTAMP,
                                                                        IN P_LAST_SMA200_W_I TIMESTAMP,
                                                                        IN P_LAST_RSI_W_I TIMESTAMP,
                                                                        IN P_LAST_MACD_W_I TIMESTAMP,
                                                                        IN P_LAST_DELTA_W_I TIMESTAMP)
AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM INTRADAY.PRICE_LOAD_LOOKUP
               WHERE SYMBOL = P_SYMBOL_I) THEN
        UPDATE INTRADAY.PRICE_LOAD_LOOKUP 
        SET
            LAST_PRICE_W = COALESCE(P_LAST_PRICE_W_I, LAST_PRICE_W),
            LAST_SMA20_W = COALESCE(P_LAST_SMA20_W_I, LAST_SMA20_W),
            LAST_SMA50_W = COALESCE(P_LAST_SMA50_W_I, LAST_SMA50_W),
            LAST_SMA100_W = COALESCE(P_LAST_SMA100_W_I, LAST_SMA100_W),
            LAST_SMA200_W = COALESCE(P_LAST_SMA200_W_I, LAST_SMA200_W),
            LAST_RSI_W = COALESCE(P_LAST_RSI_W_I, LAST_RSI_W),
            LAST_MACD_W = COALESCE(P_LAST_MACD_W_I, LAST_MACD_W),
            LAST_DELTA_W = COALESCE(P_LAST_DELTA_W_I, LAST_DELTA_W)
        WHERE SYMBOL = P_SYMBOL_I;
    ELSE
        INSERT INTO INTRADAY.PRICE_LOAD_LOOKUP (SYMBOL,
                                                LAST_PRICE_W,
                                                LAST_SMA20_W,
                                                LAST_SMA50_W,
                                                LAST_SMA100_W,
                                                LAST_SMA200_W,
                                                LAST_RSI_W,
                                                LAST_MACD_W,
                                                LAST_DELTA_W)
                                        VALUES (P_SYMBOL_I,
                                                P_LAST_PRICE_W_I,
                                                P_LAST_SMA20_W_I,
                                                P_LAST_SMA50_W_I,
                                                P_LAST_SMA100_W_I,
                                                P_LAST_SMA200_W_I,
                                                P_LAST_RSI_W_I,
                                                P_LAST_MACD_W_I,
                                                P_LAST_DELTA_W_I);
    END IF;
    EXCEPTION
  WHEN OTHERS THEN
    RAISE EXCEPTION 'Error in procedure intraday_api_dbo.api_store_price_load_lookup (%)', SQLERRM;
END;
$$ LANGUAGE plpgsql;