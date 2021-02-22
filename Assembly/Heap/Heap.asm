;;; =========================================================================
;;; My Heap Management Code
;;; =========================================================================

IncludeUnitTests = true
TraceEnabled = true

HEAP_PAGE_START = $0F0000
HEAP_PAGE_END   = $0FFFFF

TEXT_COLOR              = $20

TraceMemoryStart        = $A8

;* = $a0
;.dsection ZeroPage

* = $0E0000             ; Set the origin for the file

;.INCLUDE "../Common/PGX.asm"
.INCLUDE "../Common/Macros.asm"
.INCLUDE "../Common/Kernel.asm"

; .INCLUDE "Macros.asm"



START:   
    CALL SETUP
    PRINTS Strings.Ready
    
    SETAXL
    LDA #$1234
    LDX #$5678
    LDY #$90AB
    TraceAXY "Test TraceAXY"

    CALL HeapManager.UnitTests.Init
    CALL HeapManager.UnitTests.ResetCurrentBlock

    TraceMemory "HeapManager.ZeroPage", $0008A0, 6
    TraceMemory "HeapManager.Header", HEAP_PAGE_START, SIZE(HeapManager.Header)

    SETAL
    LDA HeapManager.ZeroPage.BlockPointer
    TraceMemoryA "HeapManager.Block", `HEAP_PAGE_START, SIZE(HeapManager.BlockHeader)

    RTL

.INCLUDE "HeapManager.asm"




.INCLUDE "../Common/Common.asm"


Strings .block
    Ready:                        .NULL "HeapManager.UnitTests Ready", 13, 13
.bend


MY_HEAP_MANAGER .long ?

