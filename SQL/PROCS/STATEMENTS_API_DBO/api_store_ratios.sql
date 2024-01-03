CREATE OR REPLACE PROCEDURE statements_api_dbo.api_store_ratios(IN P_SYMBOL_I VARCHAR(10),
                                                                IN P_FISCAL_DATE_END_I DATE,
                                                                IN P_CURRENT_RATIO_I DECIMAL(10,4),
                                                                IN P_QUICK_RATIO_I DECIMAL(10,4),
                                                                IN P_DEBT_TO_EQUITY_I DECIMAL(10,4),
                                                                IN P_INTEREST_COVERAGE_I DECIMAL(20,4),
                                                                IN P_NET_PROFIT_MARGIN_I DECIMAL(10,4),
                                                                IN P_RETURN_IN_ASSETS_I DECIMAL(10,4),
                                                                IN P_RETURN_IN_EQUITY_I DECIMAL(10,4),
                                                                IN P_INVENTORY_TURNOVER_I DECIMAL(10,4),
                                                                IN P_DAYS_SALES_IUTSTANDING_I DECIMAL(10,4),
                                                                IN P_PRICE_EARNINGS_I DECIMAL(10,4),
                                                                IN P_PRICE_BOOK_RATIO_I DECIMAL(10,4),
                                                                IN P_PRICE_CASHFLOW_RATIO_I DECIMAL(10,4),
                                                                IN P_DIVIDEND_YIELD_I DECIMAL(10,4),
                                                                IN P_EV_EBITDA_I DECIMAL(10,4),
                                                                IN P_FREE_CASH_FLOW_I DECIMAL(10,4),
                                                                IN P_IPERATING_MARGIN_I DECIMAL(10,4),
                                                                IN P_GROSS_MARGIN_I DECIMAL(10,4),
                                                                IN P_CASH_CONVERSION_CYCLE_I DECIMAL(10,4),
                                                                IN P_CREATE_ID_I VARCHAR(10),
                                                                IN P_CREATE_TS_I TIMESTAMP)
AS $$
BEGIN
  IF EXISTS (SELECT 1 FROM statements.RATIOS
            WHERE P_SYMBOL_I = SYMBOL
              AND P_FISCAL_DATE_END_I = FISCAL_DATE_END) THEN
    UPDATE STATEMENTS.RATIOS
    SET CURRENT_RATIO = P_CURRENT_RATIO_I,
        QUICK_RATIO = P_QUICK_RATIO_I,
        DEBT_TO_EQUITY = P_DEBT_TO_EQUITY_I,
        INTEREST_COVERGE = P_INTEREST_COVERGE_I,
        NET_PROFIT_MARGIN = P_NET_PROFIT_MARGIN_I,
        RETURN_ON_ASSETS = P_RETURN_ON_ASSETS_I, 
        RETURN_ON_EQUITY = P_RETURN_ON_EQUITY_I,
        INVENTORY_TURNOVER = P_INVENTORY_TURNOVER_I,
        DAYS_SALES_OUTSTANDING = P_DAYS_SALES_OUTSTANDING_I,
        PRICE_EARNINGS = P_PRICE_EARNINGS_I,
        PRICE_BOOK_RATIO = P_PRICE_BOOK_RATIO_I,
        PRICE_CASHFLOW_RATIO = P_PRICE_CASHFLOW_RATIO_I,
        DIVIDEND_YIELD = P_DIVIDEND_YIELD_I,
        EV_EBITDA = P_EV_EBITDA_I,
        FREE_CASHFLOW = P_FREE_CASHFLOW_I,
        OPERATING_MARGIN = P_OPERATING_MARGIN_I,
        GROSS_MARGIN = P_GROSS_MARGIN_I,
        CASH_CONVERSION_CYCLE = P_CASH_CONVERSION_CYCLE_I,
        UPDATE_ID = P_CREATE_ID_I,
        UPDATE_TS = P_CREATE_TS_I
    WHERE
        P_SYMBOL_I = SYMBOL
     AND P_FISCAL_DATE_END_I = FISCAL_DATE_END;
ELSE
  INSERT INTO STATEMENTS.RATIOS(SYMBOL,
                                FISCAL_DATE_END,
                                CURRENT_RATIO,
                                QUICK_RATIO,
                                DEBT_TO_EQUITY,
                                INTEREST_COVERAGE,
                                NET_PROFIT_MARGIN,
                                RETURN_ON_ASSETS,
                                RETURN_ON_EQUITY,
                                INVENTORY_TURNOVER,
                                DAYS_SALES_OUTSTANDING,
                                PRICE_EARNINGS,
                                PRICE_BOOK_RATIO,
                                PRICE_CASHFLOW_RATIO,
                                DIVIDEND_YIELD,
                                EV_EBITDA,
                                FREE_CASHFLOW,
                                OPERATING_MARGIN,
                                CASH_CONVERSION_CYCLE,
                                CREATE_ID,
                                CREATE_TS,
                                UPDATE_ID,
                                UPDATE_TS)
                        VALUES (P_SYMBOL_I,
                                P_FISCAL_DATE_END_I,
                                P_CURRENT_RATIO_I,
                                P_QUICK_RATIO_I,
                                P_DEBT_TO_EQUITY_I,
                                P_INTEREST_COVERAGE_I,
                                P_NET_PROFIT_MARGIN_I,
                                P_RETURN_ON_ASSETS_I,
                                P_RETURN_ON_EQUITY_I,
                                P_INVENTORY_TURNOVER_I,
                                P_DAYS_SALES_OUTSTANDING_I,
                                P_PRICE_EARNINGS_I,
                                P_PRICE_BOOK_RATIO_I,
                                P_PRICE_CASHFLOW_RATIO_I,
                                P_DIVIDEND_YIELD_I,
                                P_EV_EBITDA_I,
                                P_FREE_CASHFLOW_I,
                                P_OPERATING_MARGIN_I,
                                P_CASH_CONVERSION_CYCLE_I,
                                P_CREATE_ID_I,
                                P_CREATE_TS_I,
                                NULL,
                                NULL);
END IF;
EXCEPTION
  WHEN OTHERS THEN
    RAISE EXCEPTION 'Error in procedure statements_api_dbo.api_store_ratios (%)', SQLERRM;
END;
$$ LANGUAGE plpgsql;