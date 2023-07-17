CREATE OR REPLACE FUNCTION statements_api_dbo.api_fetch_balance_sheet(IN P_SYMBOL_I VARCHAR(4),
																	  IN P_FISCAL_DATE_END_I DATE,
																	  OUT BS_OUT statements.typ_balance_sheet_out)
AS $$
DECLARE
	v_cur_o REFCURSOR;
BEGIN
	OPEN v_cur_o FOR SELECT
										SYMBOL,
										FISCAL_DATE_END,
										CURRENCY_CD,
										TOTAL_ASSETS,
										TOTAL_CURR_ASSETS,
										CASH_AND_EQUIV,
										CASH_AND_SHORT_INV,
										INVENTORY,
										CURRENT_NET_REC,
										TOT_NON_CURR_ASSETS,
										PROPERTY_PLAN_EQUIP,
										ACCUM_DEPR,
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
										TOT_NONCURR_LIAB,
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
										UPDATE_TS
										FROM statements.balance_sheet
										WHERE SYMBOL = COALESCE(P_SYMBOL_I, SYMBOL)
										  AND FISCAL_DATE_END = COALESCE(P_FISCAL_DATE_END_I, FISCAL_DATE_END);
	BS_OUT.P_ERR_MSG_O := '';
	BS_OUT.P_RESULT_CD_O := 0;
	BS_OUT.BS_REF_CURSOR_O := v_cur_o;
	EXCEPTION
		WHEN OTHERS THEN
			BS_OUT.P_ERR_MSG_O := 'STATEMENTS_API_DBO.api_fetch_balance_sheet :' || SQLERRM;
			BS_OUT.RETURN_CD := 1;
END;
$$ LANGUAGE plpgsql;
