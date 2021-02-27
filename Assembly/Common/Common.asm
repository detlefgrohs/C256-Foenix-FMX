

RESET_SCREEN .proc    
; Need to write routine to clear 

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
.pend

SETUP .proc ; Setup the CPU
        PushAll
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
        PullAll
        RETURN      
.pend

.if TraceEnabled == true
; This is ugly trace code and I hate it...
PrintTrace .proc
        PushAll
        SetTextColor TraceTextColor

        SETAXL
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
        SetTextColor TEXT_COLOR
        PullAll
        .pend



PrintTraceAX .proc
        PushAll
        ; SetTextColor TraceTextColor

        PHX
        PHA

        SETAXL
        LDA 15,S        ; Get the return address
calc_addr   
        CLC
        ADC #3          ; Add 3 to skip over the following branch
        TAX

        setas
        LDA #`PrintTraceAX
        PHA
        PLB

        SetTextColor TraceTextColor
pr_loop     
        LDA #0,B,X
        BEQ done
        CALL ScreenPutChar
        INX
        BRA pr_loop

done    
        SetTextColor TraceParameterTextColor
        PrintChar '('
        PrintChar 'A'
        PrintChar '='
        
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

        PrintChar ','
        PrintChar 'X'
        PrintChar '='

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

        PrintChar ')'
        PrintChar 13

        SetTextColor TEXT_COLOR
        PullAll
        .pend

PrintTraceAXY .proc
        PushAll
        

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

        SetTextColor TraceTextColor
pr_loop     
        LDA #0,B,X
        BEQ done
        CALL ScreenPutChar
        INX
        BRA pr_loop

done    
        SetTextColor TraceParameterTextColor
        PrintChar '('
        PrintChar 'A'
        PrintChar '='

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

        PrintChar ','
        PrintChar 'X'
        PrintChar '='

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

        PrintChar ','
        PrintChar 'Y'
        PrintChar '='

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

        PrintChar ')'
        PrintChar 13

        SetTextColor TEXT_COLOR
        PullAll
        .pend



PrintMemory .proc
        PushAll
        SetTextColor TraceMemoryTextColor

        setaxl
        LDA 11,S        ; Get the return address
calc_addr   
        CLC
        ADC #3          ; Add 3 to skip over the following branch
        TAX

        setas
        LDA #`PrintMemory
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

        PrintChar ' '
        LDA TraceMemoryStart + 2
        JSL PRINTAH
        PrintChar ':'
        LDA TraceMemoryStart + 1
        JSL PRINTAH
        LDA TraceMemoryStart
        JSL PRINTAH
        PrintChar ' '

loop
        LDA [TraceMemoryStart], Y
        JSL PRINTAH

        DEX
        BEQ +
        INY
        PrintChar ' '

        BRA loop
+
        SETAS
        LDA #13
        CALL ScreenPutChar

        SetTextColor TEXT_COLOR
        PullAll
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

.endif
