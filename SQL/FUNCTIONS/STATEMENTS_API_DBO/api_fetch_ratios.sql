CREATE OR REPLACE FUNCTION statements_api_dbo.api_fetch_ratios( P_SYMBOL_I VARCHAR(4),
                                                                P_FISCAL_DATE_END_I DATE)
RETURNS TABLE ( P_SYMBOL_O VARCHAR(10),
                P_FISCAL_DATE_END_O DATE,
                P_CURRENT_RATIO_O DECIMAL(10,4),
                P_QUICK_RATIO_O DECIMAL(10,4),
                P_DEBT_TO_EQUITY_O DECIMAL(10,4),
                P_INTEREST_COVERAGE_O DECIMAL(20,4),
                P_NET_PROFIT_MARGIN_O DECIMAL(10,4),
                P_RETURN_ON_ASSETS_O DECIMAL(10,4),
                P_RETURN_ON_EQUITY_O DECIMAL(10,4),
                P_INVENTORY_TURNOVER_O DECIMAL(10,4),
                P_DAYS_SALES_OUTSTANDING_O DECIMAL(10,4),
                P_PRICE_EARNINGS_O DECIMAL(10,4),
                P_PRICE_BOOK_RATIO_O DECIMAL(10,4),
                P_PRICE_CASHFLOW_RATIO_O DECIMAL(10,4),
                P_DIVIDEND_YIELD_O DECIMAL(10,4),
                P_EV_EBITDA_O DECIMAL(10,4),
                P_FREE_CASH_FLOW_O DECIMAL(10,4),
                P_OPERATING_MARGIN_O DECIMAL(10,4),
                P_GROSS_MARGIN_O DECIMAL(10,4),
                P_CASH_CONVERSION_CYCLE_O DECIMAL(10,4),
                P_CREATE_ID_O VARCHAR(10),
                P_CREATE_TS_O TIMESTAMP,
                P_UPDATE_ID_O VARCHAR(10),
                P_UPDATE_TS_O TIMESTAMP)
AS $$
BEGIN
    RETURN QUERY SELECT SYMBOL,
                        FISCAL_DATE_END,
                        CURRENT_RATIO,
                        QUICK_RATIO,
                        DEBT_TO_EQUITY,
                        INTEREST_COVERGE,
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
                        GROSS_MARGIN,
                        CASH_CONVERSION_CYCLE,
                        CREATE_ID,
                        CREATE_TS,
                        UPDATE_ID,
                        UPDATE_TS
                    FROM STATEMENTS.RATIOS
                    WHERE SYMBOL = COALESCE(P_SYMBOL_I, SYMBOL)
                      AND FISCAL_DATE_END = COALESCE(P_FISCAL_DATE_END_I);
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'STATEMENTS_API_DBO.api_fetch_ratios (%)', SQLERRM;
END;
$$ LANGUAGE plpgsql;