
setaxs      .macro
            SEP #$30
            .as
            .xs
            .endm

setas       .macro
            SEP #$20
            .as
            .endm

setxs       .macro
            SEP #$10
            .xs
            .endm

setaxl      .macro
            REP #$30
            .al
            .xl
            .endm

setal       .macro
            REP #$20
            .al
            .endm

setxl       .macro
            REP #$10
            .xl
            .endm

setdp       .macro
            PHP
            setal
            PHA
            LDA #\1
            TCD
            PLA
            PLP
            .dpage \1
            .endm

setdbr      .macro
            PHP
            setas
            PHA
            LDA #\1
            PHA
            PLB
            PLA
            PLP
            .databank \1
            .endm

LDDBR       .macro ; address
            PHP
            setal
            PHA
            setas
            LDA \1
            PHA
            PLB
            setal
            PLA
            PLP
            .endm

CALL        .macro
            JSR \1
            .endm

RETURN      .macro
            RTS
            .endm   

PRINTS          .macro
            ;PushAll
                SETAXL
                SETDBR `\1 
                LDX #<>\1               ; Point to the message in an ASCIIZ string
                JSL PUTS                 ; And ask the kernel to print it
            ;PullAll
                .endm
                
CLEAR_WORD  .macro word
                SETAL
                STZ \word
            .endm

SET_LONG_POINTER .macro value, pointer
                SETAL
                LDA #<>\value
                STA \pointer
                SETAS
                LDA #`\value
                STA \pointer + 2
            .endm

CLEAR_LONG_POINTER .macro pointer
                SETAL
                STZ \pointer
                SETAS
                STZ \pointer + 2
            .endm

PUSH_S_AND_DP .macro
                PHP
                PHD            
            .endm

PULL_DP_AND_S .macro
                PLD
                PLP
            .endm


PUSH_ALL .macro
    PHA
    PHX
    PHY
    PHP
.endm

PULL_ALL .macro
    PLP
    PLY
    PLX
    PLA
.endm

PushAll .macro
        PHP
        SETAXL
        PHA
        PHX
        PHY
        PHB
        PHD
.endm

PullAll .macro
        SETAXL
        PLD
        PLB
        PLY
        PLX
        PLA
        PLP
        RTS
.endm

Trace .macro message
.if TraceEnabled == true
    JSR PrintTrace
    BRA +
    .NULL "   ", \message, 13
+
.endif
.endm

TraceAX .macro message
.if TraceEnabled == true
    JSR PrintTraceAX
    BRA +
    .NULL "   ", \message
+
.endif
.endm

TraceAXY .macro message
.if TraceEnabled == true
    JSR PrintTraceAXY
    BRA +
    .NULL "   ", \message
+
.endif
.endm

TraceMemory .macro message, address, length
.if TraceEnabled == true
    JSR PrintTrace
    BRA +
    .NULL "   ", \message
+    
    JSR PrintMemory
    BRA +
    .LONG \address
    .WORD \length
+
.endif
.endm

TraceMemoryA .macro message, databank, length
.if TraceEnabled == true
    JSR PrintTrace
    BRA +
    .NULL "   ", \message
+    
    STA Address
    JSR PrintMemory
    BRA +
Address
    .WORD 0
    .BYTE \databank
    .WORD \length
+
.endif
.endm

TraceMemoryLong .macro message, longAddress, length
.if TraceEnabled == true
.block
    PHP
    PHA
    SETAS
    LDA \longAddress + 2
    STA Address + 2
    SETAL
    LDA \longAddress
    STA Address
    PLA
    PLP

    JSR PrintTrace
    BRA +
    .NULL "   ", \message
+    
    JSR PrintMemory
    BRA +
Address
    .LONG 0
    .WORD \length
+
.bend
.endif
.endm

PrintChar .macro char
        SETAS
        LDA #\char
        CALL ScreenPutChar
.endm





SubtractConstant .macro value
    SEC
    SBC #\value
.endm

Subtract .macro value
    SEC
    SBC \value
.endm

