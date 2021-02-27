
UnitTests .block

ExecuteUnitTest .macro unittest
    BCC +
    CALL \unittest
+
.endm

ExecuteAllUnitTests .proc
    SEC

    PRINTS Strings.UnitTests
    PRINTS Strings.Ready

    ExecuteUnitTest HeapManager.UnitTests.Init
    ExecuteUnitTest HeapManager.UnitTests.ResetCurrentBlock
    ExecuteUnitTest HeapManager.UnitTests.EmptyHeapMoveNext
    ExecuteUnitTest HeapManager.UnitTests.EmptyHeapMovePrev
    ExecuteUnitTest HeapManager.UnitTests.Allocate
    ExecuteUnitTest HeapManager.UnitTests.Free

    PRINTS Strings.UnitTests
    BCC +
    
    PushTextColor
    SetTextColor PassTextColor

    PRINTS Strings.AllPassed

    PullTextColor
    RETURN
+
    PushTextColor
    SetTextColor FailTextColor

    PRINTS Strings.Failed    
    
    PullTextColor
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

    CALL HeapManager.ResetCurrentBlock

    PRINTS Strings.ResetCurrentBlock

    ; Check CURRENT_BLOCK_HEADER
    HeaderCompareByte 0, HeapManager.Header.CurrentBlock + 2, `HEAP_PAGE_START
    HeaderCompareWord 1, HeapManager.Header.CurrentBlock, (<>HEAP_PAGE_START + SIZE(HeapManager.Header))

    ; CHECK ZP_HEAP_MANAGER_BLOCK_POINTER
    ZeroPageCompareByte 2, ZeroPage.BlockPointer + 2, `HEAP_PAGE_START
    ZeroPageCompareWord 3, ZeroPage.BlockPointer, (<>HEAP_PAGE_START + SIZE(HeapManager.Header))

    UnitTestEnd
.pend

EmptyHeapMoveNext .proc   
    PRINTS Strings.EmptyHeapMoveNext
    PRINTS Strings.Start

    ; Setup My_Heap_Manager
    SETAL
    LDA #0
    SETAS
    SETXL
    LDA #`HEAP_PAGE_START
    LDX #<>HEAP_PAGE_START

    CALL HeapManager.MoveNextBlock

    PRINTS Strings.EmptyHeapMoveNext

    CheckForCarryClear 0

    UnitTestEnd
.pend

EmptyHeapMovePrev .proc   
    PRINTS Strings.EmptyHeapMovePrev
    PRINTS Strings.Start

    ; Setup My_Heap_Manager
    SETAL
    LDA #0
    SETAS
    SETXL
    LDA #`HEAP_PAGE_START
    LDX #<>HEAP_PAGE_START

    CALL HeapManager.MovePrevBlock

    PRINTS Strings.EmptyHeapMovePrev

    CheckForCarryClear 0

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

Free .proc
    PRINTS Strings.Free
    PRINTS Strings.Start

    SETAL
    LDA #0
    SETAS
    SETXL
    LDA #`HEAP_PAGE_START
    LDX #<>HEAP_PAGE_START
    LDY #$00FF
    CALL HeapManager.Free

    PRINTS Strings.Free

    CheckForCarrySet 0

    UnitTestEnd
.pend

Strings .block
    Strings.Init:                .NULL "HeapManager.Init "
    Strings.ResetCurrentBlock:   .NULL "HeapManager.ResetCurrentBlock "
    Strings.EmptyHeapMoveNext:   .NULL "HeapManager.EmptyHeapMoveNext "
    Strings.EmptyHeapMovePrev:   .NULL "HeapManager.EmptyHeapMovePrev "
    Strings.Allocate             .NULL "HeapManager.Allocate "
    Strings.Free                 .NULL "HeapManager.Free "

    Strings.UnitTests            .NULL "HeapManager.UnitTests "
    Strings.Ready                .NULL "Ready", 13, 13
    Strings.AllPassed            .NULL "All Passed", 13, 13

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