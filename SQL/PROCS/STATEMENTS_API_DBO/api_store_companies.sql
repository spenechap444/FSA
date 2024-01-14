CREATE OR REPLACE PROCEDURE statements_api_dbo.api_store_companies(IN P_SYMBOL_I VARCHAR(10),
                                                                   IN P_ASSET_TYPE_I VARCHAR(100),
                                                                   IN P_COMPANY_DESC_I VARCHAR(2000),
                                                                   IN P_EXCHANGE_I VARCHAR(20),
                                                                   IN P_CURRENCY_I VARCHAR(10),
                                                                   IN P_COUNTRY_I VARCHAR(20),
                                                                   IN P_SECTOR_I VARCHAR(100),
                                                                   IN P_INDUSTRY_I VARCHAR(100),
                                                                   IN P_COMPANY_ADDRESS_I VARCHAR(200),
                                                                   IN P_LATEST_QUARTER_I DATE,
                                                                   IN P_CREATE_ID_I VARCHAR(10),
                                                                   IN P_CREATE_TS_I TIMESTAMP)
AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM STATEMENTS.COMPANIES
                WHERE symbol = P_SYMBOL_I) THEN
        UPDATE STATEMENTS.COMPANIES SET
                ASSET_TYPE = P_ASSET_TYPE_I,
                COMPANY_DESC = P_COMPANY_DESC_I,
                EXCHANGE = P_EXCHANGE_I,
                CURRENCY = P_CURRENCY_I,
                COUNTRY = P_COUNTRY_I,
                SECTOR = P_SECTOR_I,
                INDUSTRY = P_INDUSTRY_I,
                COMPANY_ADDRESS = P_COMPANY_ADDRESS_I,
                LATEST_QUARTER = P_LATEST_QUARTER_I,
                UPDATE_ID = P_CREATE_ID_I,
                UPDATE_TS = P_CREATE_TS_I
        WHERE SYMBOL = P_SYMBOL_I;
    ELSE
        INSERT INTO STATEMENTS.COMPANIES(SYMBOL,
                                        ASSET_TYPE,
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
                                        UPDATE_TS)
                            VALUES (P_SYMBOL_I,
                                        P_ASSET_TYPE_I,
                                        P_COMPANY_DESC_I,
                                        P_EXCHANGE_I,
                                        P_CURRENCY_I,
                                        P_COUNTRY_I,
                                        P_SECTOR_I,
                                        P_INDUSTRY_I,
                                        P_COMPANY_ADDRESS_I,
                                        P_LATEST_QUARTER_I,
                                        P_CREATE_ID_I,
                                        P_CREATE_TS_I,
                                        NULL,
                                        NULL);
END IF;
EXCEPTION
  WHEN OTHERS THEN
    RAISE EXCEPTION 'Error in procedure statements_api_dbo.api_store_comapnies (%)', SQLERRM;
END;
$$ LANGUAGE plpgsql;