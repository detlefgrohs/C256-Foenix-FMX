




; SET_HEAP_MANAGER_BLOCK_HEADER .macro parameter
;     LDY #HEAP_MANAGER_BLOCK_HEADER.\parameter
;     STA [ZP_HEAP_MANAGER_BLOCK_POINTER], Y
; .endm

; GET_HEAP_MANAGER_BLOCK_HEADER .macro parameter
;     LDY #HEAP_MANAGER_BLOCK_HEADER.\parameter
;     LDA [ZP_HEAP_MANAGER_BLOCK_POINTER], Y
; .endm

SetBlockHeader .macro parameter
    LDY #BlockHeader.\parameter
    STA [ZeroPage.BlockPointer], Y
.endm

GetBlockHeader .macro parameter
    LDY #BlockHeader.\parameter
    LDA [ZeroPage.BlockPointer], Y
.endm


; SET_HEAP_MANAGER_HEADER .macro parameter
;     LDY #HEAP_MANAGER_HEADER.\parameter
;     STA [ZP_HEAP_MANAGER_HEADER_POINTER], Y
; .endm

; GET_HEAP_MANAGER_HEADER .macro parameter
;     LDY #HEAP_MANAGER_HEADER.\parameter
;     LDA [ZP_HEAP_MANAGER_HEADER_POINTER], Y
; .endm

SetHeader .macro parameter
    LDY #Header.\parameter
    STA [ZeroPage.HeaderPointer], Y
.endm

GetHeader .macro parameter
    LDY #Header.\parameter
    LDA [ZeroPage.HeaderPointer], Y
.endm



; HeaderCompare .macro testNumber, index, compareTo
;     LDY #\index
;     LDA [ZeroPage.HeaderPointer], Y
;     CMP #\compareTo
;     BEQ +
;     SETAS
;     LDA #\testNumber
;     BRA FAILED
; +   
; .endm

HeaderCompareByte .macro testNumber, index, compareTo
    SETAS
    LDY #\index
    LDA [ZeroPage.HeaderPointer], Y
    CMP #\compareTo
    BEQ +
    SETAS
    LDA #\testNumber
    CALL FailedUnitTest
    RETURN
+   
.endm
HeaderCompareWord .macro testNumber, index, compareTo
    SETAL
    LDY #\index
    LDA [ZeroPage.HeaderPointer], Y
    CMP #\compareTo
    BEQ +
    SETAS
    LDA #\testNumber
    CALL FailedUnitTest
    RETURN
+   
.endm



UnitTestEnd .macro
    PRINTS Strings.Passed
    RETURN
; Failed:     
;     JSL PRINTAH
;     PRINTS Strings.Failed    
.endm