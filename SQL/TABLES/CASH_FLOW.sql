CREATE TABLE STATEMENTS.CASH_FLOW (
    SYMBOL 	VARCHAR(4),
	FISCAL_DATE_END DATE,
    CURRENCY_CD VARCHAR(4),
    OP_CASH_FLOW DECIMAL(20,0),
    PAYMENTS_TO_OP DECIMAL(20,0),
    PROCEEDS_FROM_OP DECIMAL(20,0),
    CHG_IN_OP_LIAB DECIMAL(20,0),
    CHG_IN_OP_ASST DECIMAL(20,0),
    DEPR_AND_AMORT_DEPLETION DECIMAL(20,0),
    CAPITAL_EXPENDITURES DECIMAL(20,0),
    CHG_IN_RECEIVABLES DECIMAL(20,0),
    CHG_IN_INVENTORY DECIMAL(20,0),
    PROFIT DECIMAL(20,0),
    CASHFLOW_INVEST DECIMAL(20,0),
    CASHFLOW_FINANCING DECIMAL(20,0),
    ST_DEBT_REPAY_PROC DECIMAL(20,0),
    COM_STCK_REPUR_PAYM DECIMAL(20,0),
    EQUITY_REPUR_PAYM DECIMAL(20,0),
    PREF_STCK_REPUR_PAYM DECIMAL(20,0),
    DIV_PAYOUT DECIMAL(20,0),
    DIV_PAYOUT_COM_STCK DECIMAL(20,0),
    DIV_PAYOUT_PREF_STCK DECIMAL(20,0),
    COM_STCK_ISSUE_PROC DECIMAL(20,0),
    LT_DEBT_ISSUE_PROCEEDS DECIMAL(20,0),
    PREF_STOCK_ISSUE_PROC DECIMAL(20,0),
    EQUITY_REPUR_PROC DECIMAL(20,0),
    TRES_STOCK_SALE_PROC DECIMAL(20,0),
    CHG_IN_CSH_EQUIV DECIMAL(20,0),
    CHG_IN_EXCHG_RT DECIMAL(20,0),
    NET_INCOME DECIMAL(20,0),
    CREATE_ID VARCHAR(10),
    CREATE_TS TIMESTAMP,
    UPDATE_ID VARCHAR(10),
    UPDATE_TS TIMESTAMP,
    PRIMARY KEY (SYMBOL, FISCAL_DATE_END)
);