CREATE OR REPLACE FUNCTION statements_api_dbo.api_store_income_statement(
      IN src statements.typ_income_statement,
      OUT p_return_cd_o INTEGER,
      OUT p_err_msg_o VARCHAR(255))
AS $$
BEGIN
  p_err_msg_o := '';
  IF EXISTS (SELECT 1 FROM statements.income_statement tgt
                      WHERE src.symbol = tgt.symbol
                          AND  src.fiscal_date_end = tgt.fiscal_date_end) THEN
    UPDATE statements.income_statement tgt
    SET tgt.CURRENCY_CD = src.CURRENCY_CD,
            tgt.GROSS_PROFIT = src.GROSS_PROFIT,
            tgt.TOTAL_REVENUE = src.TOTAL_REVENUE,
            tgt.COST_OF_REVENUE = src.COST_OF_REVENUE,
            tgt.COGS = src.COGS,
            tgt.OP_INCOME = src.OP_INCOME,
            tgt.SELLING_ADMIN_EXP = src.SELLING_ADMIN_EXP,
            tgt.RESEARCH_AND_DEV = src.RESEARCH_AND_DEV,
            tgt.OP_EXPENCES = src.OP_EXPENCES,
            tgt.INV_INCOME_NET = src.INV_INCOME_NET,
            tgt.NET_INTEREST_INC = src.NET_INTEREST_INC,
            tgt.INTEREST_INC = src.INETEREST_INC,
            tgt.INTEREST_EXP = src.INTEREST_EXP,
            tgt.NON_INTEREST_INC = src.NON_INTEREST_INC,
            tgt.OTHER_NONOP_INCOME = src.OTHER_NONOP_INCOME,
            tgt.DEPRECIATION = src.DEPRECIATION,
            tgt.DEPR_AND_AMORT = src.DEPR_AND_AMORT,
            tgt.INC_BEFORE_TAX = src.INC_BEFORE_TAX,
            tgt.INC_TAX_EXP = src.INC_TAX_EXP,
            tgt.INT_AND_DEBT_EXP = src.INT_AND_DEBT_EXP,
            tgt.NET_INC_CONT_OP = src.NET_INC_CONT_OP,
            tgt.COMP_INC_NET_TAX = src.COMP_INC_NET_TAX,
            tgt.EBIT = src.EBIT,
            tgt.EBITDA = src.EBITDA,
            tgt.NET_INCOME = src.NET_INCOME,
            tgt.UPDATE_ID = src.CREATE_ID,
            tgt.UPDATE_TS = src.CREATE_TS
    WHERE
          src.symbol = tgt.symbol
        AND  src.fiscal_date_end = tgt.fiscal_date_end;
        p_return_cd_o := 0;
  ELSE
    INSERT INTO statements.income_statement(SYMBOL,
                                                                              FISCAL_DATE_END,
                                                                              CURRENY_CD,
                                                                              GROSS_PROFIT,
                                                                              TOTAL_REVENUE,
                                                                              COST_OF_REVENUE,
                                                                              COGS,
                                                                              OP_INCOME,
                                                                              SELLING_ADMIN_EXP,
                                                                              RESEARCH_AND_DEV,
                                                                              OP_EXPENCES,
                                                                              INV_INCOME_NET,
                                                                              NET_INTEST_INC,
                                                                              INTEREST_INC,
                                                                              INTEREST_EXP,
                                                                              NON_INTEREST_INC,
                                                                              OTHER_NONOP_INCOME,
                                                                              DEPRECIATION,
                                                                              DEPR_AND_AMORT,
                                                                              INC_BEFORE_TAX,
                                                                              INC_TAX_EXP,
                                                                              INT_AND_DEBT_EXP,
                                                                              NET_INC_CONT_OP,
                                                                              COMP_INC_NET_TAX,
                                                                              EBIT,
                                                                              EBITDA,
                                                                              NET_INCOME,
                                                                              CREATE_ID,
                                                                              CREATE_TS )
                                                    VALUES         (src.SYMBOL,
                                                                              src.FISCAL_DATE_END,
                                                                              src.CURRENCY_CD,
                                                                              src.GROSS_PROFIT,
                                                                              src.TOTAL_REVENUE,
                                                                              src.COST_OF_REVENUE,
                                                                              src.COGS,
                                                                              src.OP_INCOME,
                                                                              src.SELLING_ADMIN_EXP,
                                                                              src.RESEARCH_AND_DEV,
                                                                              src.OP_EXPERIENCES,
                                                                              src.INV_INCOME_NET,
                                                                              src.NET_INTEREST_INC,
                                                                              src.INTEREST_INC,
                                                                              src.INTEREST_EXP,
                                                                              src.NON_INTEREST_INC,
                                                                              src.OTHER_NONOP_INCOME,
                                                                              src.DEPRECIATION,
                                                                              src.DEPR_AND_AMORT,
                                                                              src.INC_BEFORE_TAX,
                                                                              src.INC_TAX_EXP,
                                                                              src.INT_AND_DEBT_EXP,
                                                                              src.NET_INC_CONT_OP,
                                                                              src.COMP_INC_NET_TAX,
                                                                              src.EBIT,
                                                                              src.EBITDA,
                                                                              src.NET_INCOME,
                                                                              src.CREATE_ID,
                                                                              src.CREATE_TS,
                                                                              null,
                                                                              null);
       p_return_cd_o := 0;
    END IF;
    COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            p_err_msg_o := 'STATEMENTS_API_DBO.api_store_balance_sheet :' || SQLERRM;
            p_return_cd_o := 1;
END;
$$ LANGUAGE plpgsql;
