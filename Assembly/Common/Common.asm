

RESET_SCREEN:    ; Need to write routine to clear 
        SETAS
        SETXL
        LDX #0

-       LDA #' '
        STA @l SCREEN_TEXT_MEM, X
        LDA #TEXT_COLOR
        STA @l SCREEN_TEXT_COL, X

        INX
        CPX #(NUM_COLS * NUM_ROWS)
        BNE -

        LDX #0
        LDY #0
        JSL LOCATE
        
        RETURN

SETUP:  ; Setup the CPU
        CLC                         ; Make sure we're native mode
        XCE
        SETAS
        SETXL
        ; Setup Vicky
        LDA #TEXT_COLOR            ; Set the Text Color (Green Text on Black Background)
        STA @lCUR_COLOR             ; @l forces 24 bit addressing mode...
        LDA #$00                    ; Set to No Border
        STA @lBORDER_CTRL_REG
        JSL FK_SETSIZES
;;; =========================================================================
        CALL RESET_SCREEN
;;; =========================================================================
        RETURN      