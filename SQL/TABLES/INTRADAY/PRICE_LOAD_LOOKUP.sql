CREATE TABLE INTRADAY.PRICE_LOAD_LOOKUP(SYMBOL VARCHAR(10),
                                        LAST_PRICE_W TIMESTAMP,
                                        LAST_SMA20_W TIMESTAMP,
                                        LAST_SMA50_W TIMESTAMP,
                                        LAST_SMA100_W TIMESTAMP,
                                        LAST_SMA200_W TIMESTAMP,
                                        LAST_RSI_W TIMESTAMP,
                                        LAST_MACD_W TIMESTAMP,
                                        LAST_DELTA_W TIMESTAMP,
                                        PRIMARY KEY (SYMBOL)
);