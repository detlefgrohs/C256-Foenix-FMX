
.INCLUDE "IsFunctions.asm"

TOKENIZE:       .proc
        SETXL
        LDX #0
        STX SOURCE_POS
        ;LDA SOURCE, X
        ; Get the character from the source_pos in the source
        ;;LDX SOURCE_POS
        SETAS
        LDA SOURCE, X
        STA CURRENT_CHAR

TOKENIZE_LOOP:

        ; Print Source_Pos
        SETAL
        LDA SOURCE_POS
        JSL PRINTAH

        SETAS
        LDA #'-'
        JSL PUTC

        ; Print value of character at Source_Pos
        SETAS
        ; SETXL
        ; LDX SOURCE_POS
        ; LDA SOURCE, X
        LDA CURRENT_CHAR
        JSL PRINTAH

        SETAS
        LDA #'-'
        JSL PUTC

        ; Print the character if it is printable (ie not eol)
        SETAS
        ; SETXL
        ; LDX SOURCE_POS
        ; LDA SOURCE, X
        LDA CURRENT_CHAR

        JSR IS_PRINTABLE_CHAR
        BCC +

        SETAS
        LDA #''''
        JSL PUTC

        SETAS
        ; SETXL
        ; LDX SOURCE_POS
        ; LDA SOURCE, X
        LDA CURRENT_CHAR
        JSL PUTC

        SETAS
        LDA #''''
        JSL PUTC

        BRA ++
+       PRINTS NON_PRINTABLE_CHAR
+        
        SETAS
        LDA #'-'
        JSL PUTC

        ; Print a message with the type of character at source_pos
        SETAS
        ; SETXL
        ; LDX SOURCE_POS
        ; LDA SOURCE, X
        LDA CURRENT_CHAR

        JSR IS_CHAR
        BCC +
        PRINTS CHAR_MSG
        BRA ++
+       PRINTS NOT_CHAR_MSG
+
        JSL PRINTCR

        ; While more source keep going...
        SETAL
        INC SOURCE_POS                  ; Update the Counter
        LDX SOURCE_POS
        SETAS
        LDA SOURCE, X        
        BEQ +                           ; Hit NULL
        STA CURRENT_CHAR
        JMP TOKENIZE_LOOP

+       RETURN
                .pend
