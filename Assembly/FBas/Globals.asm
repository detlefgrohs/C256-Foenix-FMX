TEXT_COLOR              = $20


SOURCE:         .NULL "Label:", 13, "var1 = 100", 13, "var2 = 'test'"
;"Label: symbol = 'test'", 13, "Goto 100"

NOT_CHAR_MSG:   .NULL "Not a character"
CHAR_MSG:       .NULL "Character"
NON_PRINTABLE_CHAR: .NULL "'?'"

SOURCE_POS:     .WORD ?
COMPARE_TEMP:   .BYTE ?
CURRENT_CHAR:   .BYTE ?
