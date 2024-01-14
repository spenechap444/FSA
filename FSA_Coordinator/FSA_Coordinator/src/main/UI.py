import tkinter
from tkinter import ttk


class FSA_UI:
    def __init__(self):
        self.main_window = tkinter.Tk()
        self.config_frame_interface(self.main_window)
        self.init_company_analysis()

        self.main_window.mainloop()

    def config_frame_interface(self, main_window):
        main_window.title('FINANCIAL STATEMENT ANALYSIS')
        self.tabControl = ttk.Notebook(self.main_window)

        self.portfolio_tab = ttk.Frame(self.tabControl)
        self.analysis_tab = ttk.Frame(self.tabControl)
        self.pricing_tab = ttk.Frame(self.tabControl)

        self.tabControl.add(self.portfolio_tab, text="Portfolio Analysis")
        self.tabControl.add(self.analysis_tab, text="Company Analysis")
        self.tabControl.add(self.pricing_tab, text="Pricing Analysis")

        #packing the tabs
        self.tabControl.pack(expand=1, fill = "both")
        self.main_window.geometry('1000x800')

    def init_company_analysis(self):
        #label for ticker selection
        self.ticker_lbl = tkinter.Label(self.analysis_tab,
                                        text="Ticker")
        self.ticker_lbl.place(x=5,y=5)
        #text box for ticker selection
        self.ticker_input = tkinter.Entry(self.analysis_tab)
        self.ticker_input.place(x=100, y=0)

        self.quarter_radio = Radiobuttion(self.analysis_tab,
                                                 text="Quarterly",
                                                  command=lambda:self.annual_radio.deselect())
        self.quarter_radio.place(x=5,y=20)

        self.annual_radio = Radiobutton(self.analysis_tab,
                                                text="Annual",
                                                command=lambda:self.quarter_radio.deselect())
        self.annual_radio.place(x=50,y=20)
