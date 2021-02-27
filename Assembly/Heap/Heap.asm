;;; =========================================================================
;;; My Heap Management Code
;;; =========================================================================

IncludeUnitTests = true
TraceEnabled = true

HEAP_PAGE_START = $0F0000
HEAP_PAGE_END   = $0FFFFF

TEXT_COLOR              = $F0

PassTextColor = $20
FailTextColor = $80
TraceTextColor = $50
TraceParameterTextColor = $90
TraceMemoryTextColor = $40

TraceMemoryStart        = $A8

;* = $a0
;.dsection ZeroPage
; * = $00FFFC
; RESET   .word <>START  


; * = $00e000             ; Set the origin for the file
; START JMP Main

;.INCLUDE "../Common/PGX.asm"
.INCLUDE "../Common/Macros.asm"
.INCLUDE "../Common/Kernel.asm"

; .INCLUDE "Macros.asm"


* = $0e0000             ; Set the origin for the file

Main:   
    CALL SETUP
    PRINTS Strings.Version
    ;PRINTS Strings.Ready
    
    ; SETAXL
    ; LDA #$1234
    ; LDX #$5678
    ; LDY #$90AB
    ; TraceAXY "Test TraceAXY"

    ; CALL HeapManager.UnitTests.Init
    ; CALL HeapManager.UnitTests.ResetCurrentBlock
    ; CALL HeapManager.UnitTests.EmptyHeapMoves
    ; CALL HeapManager.UnitTests.Allocate

    CALL HeapManager.UnitTests.ExecuteAllUnitTests

    ; TraceMemory "HeapManager.ZeroPage", $0008A0, 6
    ; TraceMemory "HeapManager.Header", HEAP_PAGE_START, SIZE(HeapManager.Header)

    ; SETAL
    ; LDA HeapManager.ZeroPage.BlockPointer
    ; TraceMemoryA "HeapManager.Block", `HEAP_PAGE_START, SIZE(HeapManager.BlockHeader)

    RTL

.INCLUDE "HeapManager.asm"




.INCLUDE "../Common/Common.asm"


Strings .block
    .INCLUDE "Version.asm"
    
.bend


MY_HEAP_MANAGER .long ?

