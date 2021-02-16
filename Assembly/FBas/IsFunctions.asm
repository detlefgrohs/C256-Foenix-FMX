

IS_CHAR:        STA COMPARE_TEMP
                JSR IS_LOWER_CHAR
                BCS +
                LDA COMPARE_TEMP
                JSR IS_UPPER_CHAR
+               RETURN

IS_UPPER_CHAR:  CLC
                ADC #$FF - 'Z'
                ADC #('Z' - 'A') + 1
                RETURN

IS_LOWER_CHAR:  CLC
                ADC #$FF - 'z'
                ADC #('z' - 'a') + 1
                RETURN

IS_PRINTABLE_CHAR:
                SEC
                CMP #13
                BNE +
                CLC
+               RETURN
