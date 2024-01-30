CREATE TABLE INTRADAY.PRICE_LOAD_LOOKUP(SYMBOL VARCHAR(10),
                                        LAST_PRICE_W TIMESTAMP,
                                        LAST_SMA20_W,
                                        LAST_SMA50_W,
                                        LAST_SMA100_W,
                                        LAST_SMA200_W,
                                        LAST_RSI_W,
                                        LAST_MACD_W,
                                        LAST_DELTA_W,
                                        PRIMARY KEY (SYMBOL)
);