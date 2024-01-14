CREATE OR REPLACE FUNCTION statements_api_dbo.api_fetch_companies( IN P_SYMBOL_I VARCHAR(10))
RETURNS TABLE ( P_SYMBOL_O VARCHAR(10),
                P_ASSET_TYPE_O VARCHAR(100),
                P_COMPANY_NAME_O VARCHAR(100),
                P_COMPANY_DESC_O VARCHAR(2000),
                P_EXCHANGE_O VARCHAR(20),
                P_CURRENCY_O VARCHAR(10),
                P_COUNTRY_O VARCHAR(20),
                P_SECTOR_O VARCHAR(100),
                P_INDUSTRY_O VARCHAR(100),
                P_COMPANY_ADDRESS_O VARCHAR(200),
                P_LATEST_QUARTER_O DATE,
                P_CREATE_ID_O VARCHAR(10),
                P_CREATE_TS_O TIMESTAMP,
                P_UPDATE_ID_O VARCHAR(10),
                P_UPDATE_TS_O TIMESTAMP)

AS $$
BEGIN
    RETURN QUERY SELECT SYMBOL,
                        ASSET_TYPE,
                        COMPANY_NAME,
                        COMPANY_DESC,
                        EXCHANGE,
                        CURRENCY,
                        COUNTRY,
                        SECTOR,
                        INDUSTRY,
                        COMPANY_ADDRESS,
                        LATEST_QUARTER,
                        CREATE_ID,
                        CREATE_TS,
                        UPDATE_ID,
                        UPDATE_TS
                  FROM STATEMENTS.COMPANIES
                  WHERE SYMBOL = COALESCE(P_SYMBOL_I, SYMBOL);
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'STATEMENTS_API_DBO.api_fetch_companies (%)', SQLERRM;
END;
$$ LANGUAGE plpgsql;