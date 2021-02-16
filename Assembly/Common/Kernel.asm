; Kernel defines
PUTS                    = $00101C              ; Print a string to the currently selected channel
PUTC                    = $001018
PRINTCR                 = $00106C
PRINTAH                 = $001080
FK_IPRINTH              = $001078
LOCATE                  = $001084

FK_SETSIZES             = $00112C
CUR_COLOR               = $00001E
BORDER_CTRL_REG	        = $AF0004
SCREEN_TEXT_MEM         = $AFA000
SCREEN_TEXT_COL         = $AFC000
NUM_COLS                = 80
NUM_ROWS                = 60