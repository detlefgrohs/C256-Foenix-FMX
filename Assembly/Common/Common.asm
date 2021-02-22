

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

; This is ugly trace code and I hate it...
PrintTrace .proc
        PHP
        setaxl
        PHA
        PHX
        PHY
        PHB
        PHD

        setaxl
        LDA 11,S        ; Get the return address
calc_addr   
        CLC
        ADC #3          ; Add 3 to skip over the following branch
        TAX

        setas
        LDA #`PrintTrace
        PHA
        PLB

pr_loop     
        LDA #0,B,X
        BEQ done
        CALL ScreenPutChar
        INX
        BRA pr_loop

done    
        setaxl
        PLD
        PLB
        PLY
        PLX
        PLA
        PLP
        RTS
        .pend

PrintTraceAXY .proc
        PHP
        setaxl
        PHA
        PHX
        PHY
        PHB
        PHD

        PHY
        PHX
        PHA

        setaxl
        LDA 17,S        ; Get the return address
calc_addr   
        CLC
        ADC #3          ; Add 3 to skip over the following branch
        TAX

        setas
        LDA #`PrintTraceAXY
        PHA
        PLB

pr_loop     
        LDA #0,B,X
        BEQ done
        CALL ScreenPutChar
        INX
        BRA pr_loop

done    
        SETAS
        LDA#'('
        CALL ScreenPutChar
        LDA#'A'
        CALL ScreenPutChar
        LDA#'='
        CALL ScreenPutChar

        SETAL
        PLA
        PHA
        SETAS
        XBA
        JSL PRINTAH
        SETAL
        PLA
        SETAS
        JSL PRINTAH

        SETAS
        LDA#','
        CALL ScreenPutChar
        LDA#'X'
        CALL ScreenPutChar
        LDA#'='
        CALL ScreenPutChar

        SETAL
        PLA
        PHA
        SETAS
        XBA
        JSL PRINTAH
        SETAL
        PLA
        SETAS
        JSL PRINTAH

        SETAS
        LDA#','
        CALL ScreenPutChar
        LDA#'Y'
        CALL ScreenPutChar
        LDA#'='
        CALL ScreenPutChar

        SETAL
        PLA
        PHA
        SETAS
        XBA
        JSL PRINTAH
        SETAL
        PLA
        SETAS
        JSL PRINTAH

        SETAS
        LDA#')'
        CALL ScreenPutChar
        LDA #13
        CALL ScreenPutChar

        setaxl
        PLD
        PLB
        PLY
        PLX
        PLA
        PLP
        RTS
        .pend



PrintMemory .proc
        PHP
        setaxl
        PHA
        PHX
        PHY
        PHB
        PHD

        setaxl
        LDA 11,S        ; Get the return address
calc_addr   
        CLC
        ADC #3          ; Add 3 to skip over the following branch
        TAX

        setas
        LDA #`PrintTraceAXY
        PHA
        PLB

        ; Get the DataBank 1st
        SETAS
        INX
        INX
        LDA #0,B,X
        STA TraceMemoryStart + 2
        DEX
        DEX

        ; Get Address
        SETAL
        LDA #0,B,X
        STA TraceMemoryStart

        ; Get Length
        INX
        INX
        INX
        LDA #0,B,X
        TAX
        LDY #0

        SETAS
        LDA #' '
        CALL ScreenPutChar
        LDA TraceMemoryStart + 2
        JSL PRINTAH
        LDA #':'
        CALL ScreenPutChar
        LDA TraceMemoryStart + 1
        JSL PRINTAH
        LDA TraceMemoryStart
        JSL PRINTAH
        LDA #' '
        CALL ScreenPutChar

loop
        LDA [TraceMemoryStart], Y
        JSL PRINTAH

        DEX
        BEQ +
        INY

        LDA #' '
        CALL ScreenPutChar

        BRA loop

+
        SETAS
        LDA #13
        CALL ScreenPutChar

        SETAXL
        PLD
        PLB
        PLY
        PLX
        PLA
        PLP
        RTS
        .pend


ScreenPutChar .proc
        PHP
        setas
        PHA

        PHA
        LDA #CHAN_CONSOLE       ; Switch to the console device
        JSL FK_SETOUT
        PLA

        JSL FK_PUTC
        
loop    
        LDA @lKEYBOARD_LOCKS    ; Check the status of the lock keys
        AND #KB_SCROLL_LOCK     ; Is Scroll Lock pressed?
        BNE loop                ; Yes: wait until it's released

        PLA
        PLP
        RETURN
        .pend