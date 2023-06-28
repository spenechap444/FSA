CREATE OR REPLACE FUNCTION statements_api_dbo.api_store_balance_sheet(
    IN src statements.typ_balance_sheet,
    OUT p_return_cd_o INTEGER,
    OUT p_err_msg_o VARCHAR(255))
AS $$
BEGIN
    p_err_msg_o := '';
    IF EXISTS (SELECT 1 FROM statements.balance_sheet tgt
                        WHERE src.symbol = tgt.symbol
                            AND src.fiscal_date_end = tgt.fiscal_date_end) THEN
      --existing record
      UPDATE statements.balance_sheet tgt
      SET
            tgt.CURRENCY_CD = src.CURRENCY_CD,
            tgt.TOTAL_ASSETS = src.TOTAL_ASSETS,
            tgt.TOTAL_CURR_ASSETS = src.TOTAL_CURR_ASSETS,
            tgt.CASH_AND_EQUIV = src.CASH_AND_EQUIV,
            tgt.CASH_AND_SHORT_INV = src.CASH_AND_SHORT_INV,
            tgt.INVENTORY = src.INVENTORY,
            tgt.CURRENT_NET_REC = src.CURRENT_NET_REC,
            tgt.TOTAL_NON_CURR_ASSETS = src.TOTAL_NON_CURR_ASSETS,
            tgt.PROPERTY_PLANT_EQUIP = src.PROPERTY_PLANT_EQUIP,
            tgt.ACCUM_DEPR = src.ACCUM_DEPR,
            tgt.INTANG_ASSETS = src.INTANG_ASSETS,
            tgt.INTANG_ASSETS_NO_GW = src.INTANG_ASSETS_NO_GW,
            tgt.GOODWILL = src.GOODWILL,
            tgt.INVESTMENTS = src.INVESTMENTS,
            tgt.LT_INVESTMENTS = src.LT_INVESTMENTS,
            tgt.ST_INVESTMENTS = src.ST_INVESTMENTS,
            tgt.OTHER_CURR_ASSETS = src.OTHER_CURR_ASSETS,
            tgt.OTHER_NONCURR_ASSETS = src.OTHER_NONCURR_ASSETS,
            tgt.TOTAL_LIAB = src.TOTAL_LIAB,
            tgt.TOTAL_CURR_LIAB = src.TOTAL_CURR_LIAB,
            tgt.CURR_AP = src.CURR_AP,
            tgt.DEFF_REVENUE = src.DEFF_REVENUE,
            tgt.CURR_DEBT = src.CURR_DEBT,
            tgt.ST_DEBT = src.ST_DEBT,
            tgt.TOTAL_NONCURR_LIAB = src.TOTAL_NONCURR_LIAB,
            tgt.CURR_LT_DEBT = src.CURR_LT_DEBT,
            tgt.NONCURR_LT_DEBT = src.NONCURR_LT_DEBT,
            tgt.NONCURR_ST_DEBT = src.NONCURR_ST_DEBT,
            tgt.TOT_SHAREHOLD_EQ = src.TOT_SHAREHOLD_EQ,
            tgt.TREASURY_STOCK = src.TREASURY_STOCK,
            tgt.RET_EARNINGS = src.RET_EARNINGS,
            tgt.COMMON_STOCK = src.COMMON_STOCK,
            tgt.COMMON_STOCK_OUT = src.COMMON_STOCK_OUT,
            tgt.UPDATE_ID = src.CREATE_ID,
            tgt.UPDATE_TS = src.CREATE_TS
    WHERE
                  src.symbol = tgt.symbol
        AND src.fiscal_date_end = tgt.fiscal_date_end;
      p_return_cd_o := 0;
    ELSE --Record does not exist
       INSERT INTO statements.balance_sheet(SYMBOL,
                                                                        FISCAL_DATE_END,
                                                                        CURRENCY_CD,
                                                                        TOTAL_ASSETS,
                                                                        TOTAL_CURR_ASSETS,
                                                                        CASH_AND_EQUIV,
                                                                        CASH_AND_SHORT_INV,
                                                                        INVENTORY,
                                                                        CURRENT_NET_REC,
                                                                        TOTAL_NON_CURR_ASSETS,
                                                                        PROPERTY_PLANT_EQUIP, ACCUM_DEPR,
                                                                        INTANG_ASSETS,
                                                                        INTANG_ASSETS_NO_GW,
                                                                        GOODWILL,
                                                                        INVESTMENTS,
                                                                        LT_INVESTMENTS,
                                                                        ST_INVESTMENTS,
                                                                        OTHER_CURR_ASSETS,
                                                                        OTHER_NONCURR_ASSETS,
                                                                        TOTAL_LIAB,
                                                                        TOTAL_CURR_LIAB,
                                                                        CURR_AP,
                                                                        DEFF_REVENUE,
                                                                        CURR_DEBT,
                                                                        ST_DEBT,
                                                                        TOTAL_NONCURR_LIAB,
                                                                        CURR_LT_DEBT,
                                                                        NONCURR_LT_DEBT,
                                                                        NONCURR_ST_DEBT,
                                                                        TOT_SHAREHOLD_EQ,
                                                                        TREASURY_STOCK,
                                                                        RET_EARNINGS,
                                                                        COMMON_STOCK,
                                                                        COMMON_STOCK_OUT,
                                                                        CREATE_ID,
                                                                        CREATE_TS,
                                                                        UPDATE_ID,
                                                                        UPDATE_TS)
                                              VALUES         (src.SYMBOL,
                                                                        src.FISCAL_DATE_END,
                                                                        src.CURRENCY_CD,
                                                                        src.TOTAL_ASSETS,
                                                                        src.TOTAL_CURR_ASSETS,
                                                                        src.CASH_AND_EQUIV,
                                                                        src.CASH_AND_SHORT_INV,
                                                                        src.INVENTORY,
                                                                        src.CURRENT_NET_REC,
                                                                        src.TOTAL_NON_CURR_ASSETS,
                                                                        src.PROPERTY_PLANT_EQUIP,
                                                                        src.ACCUM_DEPR,
                                                                        src.INTANG_ASSETS,
                                                                        src.INTANG_ASSETS_NO_GW,
                                                                        src.GOODWILL,
                                                                        src.INVESTMENTS,
                                                                        src.LT_INVESTMENTS,
                                                                        src.ST_INVESTMENTS,
                                                                        src.OTHER_CURR_ASSETS,
                                                                        src.OTHER_NONCURR_ASSETS,
                                                                        src.TOTAL_LIAB,
                                                                        src.TOTAL_CURR_LIAB,
                                                                        src.CURR_AP,
                                                                        src.DEFF_REVENUE,
                                                                        src.CURR_DEBT,
                                                                        src.ST_DEBT,
                                                                        src.TOT_NONCURR_LIAB,
                                                                        src.CURR_LT_DEBT,
                                                                        src.NONCURR_LT_DEBT,
                                                                        src.NONCURR_ST_DEBT,
                                                                        src.TOT_SHAREHOLD_EQ,
                                                                        src.TREASURY_STOCK,
                                                                        src.RET_EARNINGS,
                                                                        src.COMMON_STOCK,
                                                                        src.COMMON_STOCK_OUT,
                                                                        src.CREATE_ID,
                                                                        src.CREATE_TS,
                                                                        NULL,
                                                                        NULL);
        p_return_cd_o := 0;
    END IF;
    COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            p_err_msg_o := 'STATEMENTS_API_DBO.api_store_balance_sheet :' || SQLERRM;
            p_return_cd_o := 1;
END;
$$ LANGUAGE plpgsql;
