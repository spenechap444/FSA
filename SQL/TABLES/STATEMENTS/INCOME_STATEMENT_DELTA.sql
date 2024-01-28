CREATE TABLE STATEMENTS.INCOME_STATEMENT_DELTA (
    SYMBOL VARCHAR(4),
    FISCAL_DATE_END DATE,
    CURRENCY_CD VARCHAR(4),
    GROSS_PROFIT DECIMAL(3,3),
    TOTAL_REVENUE DECIMAL(3,3),
    COST_OF_REVENUE DECIMAL(3,3),
    COGS DECIMAL(3,3),
    OP_INCOME DECIMAL(3,3),
    SELLING_ADMIN_EXP DECIMAL(3,3),
    RESEARCH_AND_DEV DECIMAL(3,3),
    OP_EXPENSES DECIMAL(3,3),
    INV_INCOME_NET DECIMAL(3,3),
    NET_INTEREST_INC DECIMAL(3,3),
    INTEREST_INC DECIMAL(3,3),
    INTEREST_EXP DECIMAL(3,3),
    NON_INTEREST_INC DECIMAL(3,3),
    OTHER_NONOP_INCOME DECIMAL(3,3),
    DEPRECIATION DECIMAL(3,3),
    DEPR_AND_AMORT DECIMAL(3,3),
    INC_BEFORE_TAX DECIMAL(3,3),
    INC_TAX_EXP DECIMAL(3,3),
    INT_AND_DEBT_EXP DECIMAL(3,3),
    NET_INC_CONT_OP DECIMAL(3,3),
    COMP_INC_NET_TAX DECIMAL(3,3),
    EBIT DECIMAL(3,3),
    EBITDA DECIMAL(3,3),
    NET_INCOME DECIMAL(3,3),
    CREATE_ID VARCHAR(10),
    CREATE_TS TIMESTAMP,
    UPDATE_ID VARCHAR(10),
    UPDATE_TS TIMESTAMP,
    PRIMARY KEY (SYMBOL, FISCAL_DATE_END)
);