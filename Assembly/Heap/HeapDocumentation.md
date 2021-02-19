

HEAP_MANAGER
    HEAP_MANAGER_START      .long ?
    HEAP_MANAGER_END        .long ?

    CURRENT_BLOCK_HEADER    .long ?
    CURRENT_BLOCK_DATA      .long ?



HEAP_MANAGER_BLOCK_HEADER
    PREV_BLOCK_HEADER       .word ?
    NEXT_BLOCK_HEADER       .word ?
    REFERENCE_COUNT         .word ?
    DATA_SIZE               .word ?



;============================================================================
; Inputs : A - Page for Heap
;          X - Start of Heap
;          Y - End of Heap
; Outputs: Initialized HeapManager @ $A:X
; Notes  : Will create a new HeapManager structure at $A:X and allocate for
;          the provided size.
;============================================================================
HEAP_MANAGER_INIT:



;============================================================================
; Inputs : A - Page for HeapManager
;          X - Address for HeapManager
;          Y - Size of Memory Allocate
; Outputs: HeapManager.CURRENT_BLOCK_HEADER
;          HeapManager.CURRENT_BLOCK_DATA
; Notes  :
;============================================================================
HEAP_MANAGER_ALLOC:



;============================================================================
; Inputs : A - Page for HeapManager
;          X - Address for HeapManager
;          Y - Address of Data to Free
; Outputs: HeapManager.CURRENT_BLOCK_HEADER
;          HeapManager.CURRENT_BLOCK_DATA
; Notes  : Will decrement the REF_COUNTER and if now 0 will call
;          HEAP_MANAGER_MERGE.
;============================================================================
HEAP_MANAGER_FREE:




;============================================================================
; Inputs : A - Page for HeapManager
;          X - Address for HeapManager          
; Outputs: HeapManager.CURRENT_BLOCK_HEADER
;          HeapManager.CURRENT_BLOCK_DATA
; Notes  : Will scan through the Heap Blocks for adjacent unallocated blocks
;          and merge them.
;============================================================================
HEAP_MANAGER_MERGE:



;============================================================================
; Inputs : A - Page for HeapManager
;          X - Address for HeapManager
; Outputs: HeapManager.CURRENT_BLOCK_HEADER
;          HeapManager.CURRENT_BLOCK_DATA
; Notes  :
;============================================================================
HEAP_MANAGER_RESET_CURRENT_BLOCK:
