
UnitTests .block

Strings .block
    Strings.Init:                .NULL "HeapManager.Init "
    Strings.ResetCurrentBlock:   .NULL "HeapManager.ResetCurrentBlock "
    Strings.EmptyHeapMoves:      .NULL "HeapManager.EmptyHeapMoves "

    Strings.Passed:              .NULL "Passed", 13
    Strings.Failed:              .NULL " - Failed", 13
.bend

FailedUnitTest .proc
    JSL PRINTAH
    PRINTS Strings.Failed  
    RETURN
.pend

Init .proc
    Trace "HeapManager.UnitTests.Init"
    ; Setup My_Heap_Manager
    SETAL
    LDA #0
    SETAS
    SETXL
    LDA #`HEAP_PAGE_START
    LDX #<>HEAP_PAGE_START
    LDY #<>HEAP_PAGE_END
    CALL HeapManager.Init

        ; SETAL
        ; LDA #<>HEAP_PAGE_START
        ; STA MY_HEAP_MANAGER
        ; SETAS
        ; LDA #`HEAP_PAGE_START
        ; STA MY_HEAP_MANAGER + 2
    
    PRINTS Strings.Init

    ; Check HEAP_PAGE_START
    HeaderCompareByte 0, HeapManager.Header.Start + 2, `HEAP_PAGE_START
    HeaderCompareWord 1, HeapManager.Header.Start, <>HEAP_PAGE_START

    ; Check HEAP_MANAGER_END
    HeaderCompareByte 2, HeapManager.Header.End + 2, `HEAP_PAGE_END
    HeaderCompareWord 3, HeapManager.Header.End, <>HEAP_PAGE_END

    ; Check HEAP_TOTAL_SIZE
    HeaderCompareWord 4, HeapManager.Header.TotalSize, (<>HEAP_PAGE_END - <>HEAP_PAGE_START) - SIZE(HeapManager.Header)

    ; Check HEAP_FIRST_BLOCK_HEADER
    HeaderCompareByte 5, HeapManager.Header.FirstBlock + 2, `HEAP_PAGE_START
    HeaderCompareWord 6, HeapManager.Header.FirstBlock, (<>HEAP_PAGE_START + SIZE(HeapManager.Header))

    UnitTestEnd
;     PRINTS Strings.Passed
;     RETURN
; FAILED:     
;     JSL PRINTAH
;     PRINTS Strings.Failed    
; +   
    RETURN
.pend

ResetCurrentBlock .proc
    SETAS
    SETXL
    LDA #`HEAP_PAGE_START
    LDX #<>HEAP_PAGE_START
    LDY #<>HEAP_PAGE_END

    PRINTS Strings.ResetCurrentBlock

    ; Check CURRENT_BLOCK_HEADER


    ; CHECK ZP_HEAP_MANAGER_BLOCK_POINTER


    ;UNIT_TEST_END
    PRINTS Strings.Passed
    BRA +
FAILED:
    PRINTS Strings.Failed
+   RETURN
.pend

UNIT_TEST_HEAP_MANAGER_EMPTY_HEAP_MOVES .proc    
        PRINTS Strings.EmptyHeapMoves

        ; SETAS
        ; SETXL
        ; LDA MY_HEAP_MANAGER + 2
        ; LDX MY_HEAP_MANAGER
        ; CALL HEAP_MANAGER_MOVE_NEXT_BLOCK
        ; BCC +
        ; STA
        ; LDA #1
        ; BRA FAILED
+
        ; SETAS
        ; SETXL
        ; LDA MY_HEAP_MANAGER + 2
        ; LDX MY_HEAP_MANAGER
        ; CALL HEAP_MANAGER_MOVE_PREV_BLOCK
        ; BCC +
        ; STA
        ; LDA #2
        ; BRA FAILED
+
    ;UNIT_TEST_END
    PRINTS Strings.Passed
    BRA +
FAILED:
    PRINTS Strings.Failed
+   RETURN
.pend

.bend