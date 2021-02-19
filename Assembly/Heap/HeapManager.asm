

; These will be in the direct page somewhere
; It may be shared with something...
ZP_HEAP_MANAGER_HEADER_POINTER = $A0
ZP_HEAP_MANAGER_BLOCK_POINTER  = $A3



HEAP_MANAGER_HEADER .struct
    HEAP_MANAGER_START      .long ?
    HEAP_MANAGER_END        .long ?
    HEAP_TOTAL_SIZE         .word ?

    HEAP_FIRST_BLOCK_HEADER .long ?

    CURRENT_BLOCK_HEADER    .long ?
    ; CURRENT_BLOCK_DATA      .long ?
.ends

HEAP_MANAGER_BLOCK_HEADER .struct
    PREV_BLOCK_HEADER       .word ?
    NEXT_BLOCK_HEADER       .word ?
    REFERENCE_COUNT         .word ?
    DATA_SIZE               .word ?
.ends


;============================================================================
; Inputs : A - Page for Heap
;          X - Start of Heap
;          Y - End of Heap
; Outputs: Initialized HeapManager @ $A:X
; Notes  : Will create a new HeapManager structure at $A:X and allocate for
;          the provided size.
;============================================================================
HEAP_MANAGER_INIT .proc
    CALL HEAP_MANAGER_SETUP_ZP_HEADER_POINTER

    SETAS
    STA ZP_HEAP_MANAGER_BLOCK_POINTER + 2
    SETAL
    TXA
    CLC
    ADC #SIZE(HEAP_MANAGER_HEADER)
    STA ZP_HEAP_MANAGER_BLOCK_POINTER

    ; Save Y into X temporarily...
    SETAL
    TYA
    TAX

    ; Setup the HEAP_MANAGER_HEADER.HEAP_MANAGER_START
    LDA ZP_HEAP_MANAGER_HEADER_POINTER
    LDY #HEAP_MANAGER_HEADER.HEAP_MANAGER_START        
    STA [ZP_HEAP_MANAGER_HEADER_POINTER], Y
    INY
    INY
    LDA ZP_HEAP_MANAGER_HEADER_POINTER + 2
    STA [ZP_HEAP_MANAGER_HEADER_POINTER], Y

    ; HEAP_MANAGER_HEADER.HEAP_MANAGER_END
    TXA
    LDY #HEAP_MANAGER_HEADER.HEAP_MANAGER_END    
    STA [ZP_HEAP_MANAGER_HEADER_POINTER], Y
    INY
    INY
    LDA ZP_HEAP_MANAGER_HEADER_POINTER + 2
    STA [ZP_HEAP_MANAGER_HEADER_POINTER], Y

    ; Calculate the size of the heap and store in HEAP_MANAGER_HEADER.HEAP_TOTAL_SIZE
    LDY #HEAP_MANAGER_HEADER.HEAP_MANAGER_END
    LDA [ZP_HEAP_MANAGER_HEADER_POINTER], Y
    LDY #HEAP_MANAGER_HEADER.HEAP_MANAGER_START
    SEC
    SBC #SIZE(HEAP_MANAGER_HEADER)
    LDY #HEAP_MANAGER_HEADER.HEAP_TOTAL_SIZE
    STA [ZP_HEAP_MANAGER_HEADER_POINTER], Y

    ; Now Create an unallocated block that encompasses the heap...
    ; Set the HEAP_FIRST_BLOCK_POINTER and HEAP_MANAGER_BLOCK_HEADER
    SETAS
    LDY #HEAP_MANAGER_HEADER.HEAP_FIRST_BLOCK_HEADER + 2
    LDA ZP_HEAP_MANAGER_BLOCK_POINTER + 2
    STA [ZP_HEAP_MANAGER_HEADER_POINTER], Y
    SETAL
    LDY #HEAP_MANAGER_HEADER.HEAP_FIRST_BLOCK_HEADER
    LDA ZP_HEAP_MANAGER_BLOCK_POINTER
    STA [ZP_HEAP_MANAGER_HEADER_POINTER], Y

    ; Now Set the Block Header Parameters
    LDA #0
    LDY #HEAP_MANAGER_BLOCK_HEADER.PREV_BLOCK_HEADER
    STA [ZP_HEAP_MANAGER_BLOCK_POINTER], Y
    LDY #HEAP_MANAGER_BLOCK_HEADER.NEXT_BLOCK_HEADER
    STA [ZP_HEAP_MANAGER_BLOCK_POINTER], Y
    LDY #HEAP_MANAGER_BLOCK_HEADER.REFERENCE_COUNT
    STA [ZP_HEAP_MANAGER_BLOCK_POINTER], Y
    LDY #HEAP_MANAGER_HEADER.HEAP_TOTAL_SIZE
    LDA [ZP_HEAP_MANAGER_HEADER_POINTER], Y
    LDY #HEAP_MANAGER_BLOCK_HEADER.DATA_SIZE
    SEC
    SBC #SIZE(HEAP_MANAGER_BLOCK_HEADER)
    STA [ZP_HEAP_MANAGER_BLOCK_POINTER], Y

    RETURN
.pend
;============================================================================
; Inputs : A - Page for HeapManager
;          X - Address for HeapManager
;          Y - Size of Memory Allocate
; Outputs: HeapManager.CURRENT_BLOCK_HEADER
;          HeapManager.CURRENT_BLOCK_DATA
; Notes  :
;============================================================================
HEAP_MANAGER_ALLOC .proc





.pend
;============================================================================
; Inputs : A - Page for HeapManager
;          X - Address for HeapManager
;          Y - Address of Data to Free
; Outputs: HeapManager.CURRENT_BLOCK_HEADER
;          HeapManager.CURRENT_BLOCK_DATA
; Notes  : Will decrement the REF_COUNTER and if now 0 will call
;          HEAP_MANAGER_MERGE.
;============================================================================
HEAP_MANAGER_FREE .proc





.pend
;============================================================================
; Inputs : A - Page for HeapManager
;          X - Address for HeapManager          
; Outputs: HeapManager.CURRENT_BLOCK_HEADER
;          HeapManager.CURRENT_BLOCK_DATA
; Notes  : Will scan through the Heap Blocks for adjacent unallocated blocks
;          and merge them.
;============================================================================
HEAP_MANAGER_MERGE .proc





.pend
;============================================================================
; Inputs : A - Page for HeapManager
;          X - Address for HeapManager
; Outputs: HeapManager.CURRENT_BLOCK_HEADER
; Notes  :
;============================================================================
HEAP_MANAGER_RESET_CURRENT_BLOCK .proc
    CALL HEAP_MANAGER_SETUP_ZP_HEADER_POINTER

    SETAXL
    LDY #HEAP_MANAGER_HEADER.HEAP_FIRST_BLOCK_HEADER
    LDA [ZP_HEAP_MANAGER_HEADER_POINTER], Y
    STA ZP_HEAP_MANAGER_BLOCK_POINTER
    LDY #HEAP_MANAGER_HEADER.CURRENT_BLOCK_HEADER
    STA [ZP_HEAP_MANAGER_HEADER_POINTER], Y
    
    SETAS
    LDY #HEAP_MANAGER_HEADER.HEAP_FIRST_BLOCK_HEADER + 2
    LDA [ZP_HEAP_MANAGER_HEADER_POINTER], Y
    STA ZP_HEAP_MANAGER_BLOCK_POINTER + 2
    LDY #HEAP_MANAGER_HEADER.CURRENT_BLOCK_HEADER + 2
    STA [ZP_HEAP_MANAGER_HEADER_POINTER], Y

    RETURN
.pend
;============================================================================
; Inputs : A - Page for HeapManager
;          X - Address for HeapManager
; Outputs: HeapManager.CURRENT_BLOCK_HEADER
;          HeapManager.CURRENT_BLOCK_DATA
;          BCS - Moved to Next Block in List
;          BCC - At End of List
; Notes  :
;============================================================================
HEAP_MANAGER_MOVE_NEXT_BLOCK .proc


.pend

;============================================================================
; Inputs : A - Page for HeapManager
;          X - Address for HeapManager
; Outputs: ZP_HEAP_MANAGER_HEADER_POINTER
; Notes  :
;============================================================================
HEAP_MANAGER_SETUP_ZP_HEADER_POINTER .proc
    PHA
    PHP

    SETAS
    STA ZP_HEAP_MANAGER_HEADER_POINTER + 2
    SETAL
    TXA
    STA ZP_HEAP_MANAGER_HEADER_POINTER

    PLP
    PLA
    RETURN
.pend