
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
                SETAXL
                SETDBR `\1 
                LDX #<>\1               ; Point to the message in an ASCIIZ string
                JSL PUTS                 ; And ask the kernel to print it
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