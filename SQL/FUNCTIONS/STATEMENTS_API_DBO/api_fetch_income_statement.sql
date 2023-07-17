CREATE OR REPLACE FUNCTION statements_api_dbo.api_fetch_income_statement(IN P_SYMBOL_I VARCHAR(4),
																		 IN P_FISCAL_DATE_END_I DATE,
																		 OUT IS_OUT statements.typ_income_statement_out)
AS $$
DECLARE
	v_cur_o REFCURSOR;
BEGIN OPEN  v_cur_o FOR SELECT SYMBOL,
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
											  CREATE_TS,
											  UPDATE_ID,
											  UPDATE_TS
										FROM statements.income_statement
										WHERE SYMBOL = COALESCE(P_SYMBOL_I, SYMBOL)
										  AND FISCAL_DATE_END = COALESCE(P_FISCAL_DATE_END_I, FISCAL_DATE_END);
	IS_OUT.P_ERR_MSG_O := '';
	IS_OUT.P_RESULT_CD_O := 0;
	IS_OUT.IS_REF_CURSOR_O := v_cur_o;
	EXCEPTION
		WHEN OTHERS THEN
			IS_OUT.P_ERR_MSG_O := 'STATEMENTS_API_DBO.api_fetch_income_statement :' || SQLERRM;
			IS_OUT.RETURN_CD := 1;
END;
$$ LANGUAGE plpgsql;
