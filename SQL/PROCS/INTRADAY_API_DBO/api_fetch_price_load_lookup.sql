CREATE OR REPLACE FUNCTION intraday_api_dbo.api_fetch_price_load_lookup( IN P_SYMBOL_I VARCHAR(10))
RETURNS TABLE ( P_SYMBOL_O VARCHAR(10),
                P_LAST_PRICE_W_O TIMESTAMP,
                P_LAST_SMA20_W_O TIMESTAMP,
                P_LAST_SMA50_W_O TIMESTAMP,
                P_LAST_SMA100_W_O TIMESTAMP,
                P_LAST_SMA200_W_O TIMESTAMP,
                P_LAST_RSI_W_O TIMESTAMP,
                P_LAST_MACD_W_O TIMESTAMP,
                P_LAST_DELTA_W_O TIMESTAMP)
AS $$
BEGIN
    RETURN QUERY SELECT
                    SYMBOL,
                    LAST_PRICE_W,
                    LAST_SMA20_W,
                    LAST_SMA50_W,
                    LAST_SMA100_W,
                    LAST_SMA200_W,
                    LAST_RSI_W,
                    LAST_MACD_W,
                    LAST_DELTA_W
                FROM INTRADAY.PRICE_LOAD_LOOKUP
                WHERE SYMBOL = COALESCE(P_SYMBOL_I, SYMBOL);
        EXCEPTION
            WHEN OTHERS THEN
                RAISE EXCEPTION 'Error raised for INTRADAY_API_DBO.api_fetch_price_load_lookup (%)', SQLERRM;
END;
$$ LANGUAGE plpgsql;