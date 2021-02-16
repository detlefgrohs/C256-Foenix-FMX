
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
                
;;; =========================================================================
;PGX_HEADER      .macro
;;; * = START - 8   ; Preamble to set a PGX
;                .text "PGX"
;                .byte $01
;                .dword START
;                .endm
;;; =========================================================================