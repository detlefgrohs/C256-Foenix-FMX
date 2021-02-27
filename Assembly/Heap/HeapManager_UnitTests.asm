
UnitTests .block

ExecuteUnitTest .macro unittest
    BCC +
    CALL \unittest
+
.endm

ExecuteAllUnitTests .proc
    SEC

    ExecuteUnitTest HeapManager.UnitTests.Init
    ExecuteUnitTest HeapManager.UnitTests.ResetCurrentBlock
    ExecuteUnitTest HeapManager.UnitTests.EmptyHeapMoves
    ExecuteUnitTest HeapManager.UnitTests.Allocate

    RETURN
.pend

Init .proc
    PRINTS Strings.Init
    PRINTS Strings.Start

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
    PRINTS Strings.ResetCurrentBlock
    PRINTS Strings.Start

    SETAS
    SETXL
    LDA #`HEAP_PAGE_START
    LDX #<>HEAP_PAGE_START
    LDY #<>HEAP_PAGE_END

    PRINTS Strings.ResetCurrentBlock

    ; Check CURRENT_BLOCK_HEADER


    ; CHECK ZP_HEAP_MANAGER_BLOCK_POINTER


    UnitTestEnd
.pend

EmptyHeapMoves .proc   
    PRINTS Strings.EmptyHeapMoves
    PRINTS Strings.Start





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
    UnitTestEnd
.pend

Allocate .proc
    PRINTS Strings.Allocate
    PRINTS Strings.Start

    SETAL
    LDA #0
    SETAS
    SETXL
    LDA #`HEAP_PAGE_START
    LDX #<>HEAP_PAGE_START
    LDY #$00FF
    CALL HeapManager.Allocate

    PRINTS Strings.Allocate

    CheckForCarrySet 0

    UnitTestEnd
.pend


Strings .block
    Strings.Init:                .NULL "HeapManager.Init "
    Strings.ResetCurrentBlock:   .NULL "HeapManager.ResetCurrentBlock "
    Strings.EmptyHeapMoves:      .NULL "HeapManager.EmptyHeapMoves "
    Strings.Allocate             .NULL "HeapManager.Allocate "

    Strings.Passed:              .NULL "Passed", 13, 13
    Strings.Failed:              .NULL " - Failed", 13, 13
    Strings.Start:               .NULL "Start", 13
.bend

FailedUnitTest .proc
    TAX
    PushTextColor
    SetTextColor FailTextColor
    TXA
    JSL PRINTAH
    PRINTS Strings.Failed  
    PullTextColor
    CLC
    RETURN
.pend


.bend