CREATE TABLE INTRADAY.STOCK_PRICES(SYMBOL VARCHAR(10),
                                    WINDOW_CLOSE TIMESTAMP,
                                    OPENING_PRICE DECIMAL(7,4),
                                    CLOSING_PRICE DECIMAL(7,4),
                                    HIGH_PRICE DECIMAL(7,4),
                                    LOW_PRICE DECIMAL(7,4),
                                    VOLUME INTEGER,
                                    CREATE_ID VARCHAR(10),
                                    CREATE_TS TIMESTAMP,
                                    UPDATE_ID VARCHAR(10),
                                    UPDATE_TS TIMESTAMP,
                                    PRIMARY KEY (SYMBOL, WINDOW_CLOSE)
) PARTITION BY LIST (SYMBOL);