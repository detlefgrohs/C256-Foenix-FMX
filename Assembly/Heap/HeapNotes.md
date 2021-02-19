
; This was a start at implementation a Heap Management Sybsystem based on the
; heam code that is in https://github.com/pweingar/BASIC816
; The best way to understand something is to tear it down and rebuild it from
; the ground up... I thought this was too complicated for what it does and I had
; an epiphany last night and thought of an easier way:
;
; There should be a single doubly linked list of the allocated and unallocated
; blocks and it should start out with a single block of all of the unallocated
; space. This means that there will always be at least 1 block in the list and
; only one list to search. When an unallocated block that has enough space to
; allocate for a new block is found, it will be split (unless it is exactly
; the same as the requested size) into 2 blocks, a new unallocated block and 
; the new requested allocated block. Have not decided if I will split left or
; right; meaning will the new allocated block be higher in memory (to the right)
; or lower in memory (to the left). Not sure if it matters. I am leaning to the
; right because that will always leave unallocated space as the 1st in the list
; and allow for a scratch pad area at HEAP_START + SIZEOF(HEAP_BLOCK_HEADER).
; 
; When a block is allocated it will have a reference count of 1 indicating that
; it is in use. When a block is freed the reference count will be decremented
; and if the reference count becomes 0 it will be considered unallocated. If a
; newly unallocated block is next to another unallocated block they will be
; merged at that time. 1st we will check right and merge and then left and merge.
;
; Need to draw this up with some scenarios to fully flesh out the operations in
; my mind but I think the logic will be much easier since there are less cases to
; deal with as there are less lists and we don't have to worry about running out
; of heap space as it will be tracked by the initial large unallocated block.
;
; I also think that this could support heap space that is non-contiguous and also
; heap space that could be in multiple pages. It would be up to the HEAP_INIT
; function to create the list of blocks with the unallocated spaces in a list,
; but once that is done we are only splitting unallocated blocks and if they are
; in different parts of the memory map, the routines would not care as it only
; has to work with splitting and mergingg of the blocks and the blocks would take
; care of what the allowed memory would be.

; My Heap Management Code

; .byte     8 bits
; .word     16 bits
; .long     24 bits
; .dword    32 bits

; HEAP_PAGE = $3F
HEAP_PAGE_START = $3F0000
HEAP_PAGE_END   = $3FFFFF


HEAP_BLOCK_HEADER     
            .struct
                PREV_BLOCK_HEADER   .word ?
                NEXT_BLOCK_HEADER   .word ?
                REFERENCE_COUNT     .word ?
                BLOCK_SIZE          .word ?
            .ends

* = HEAP_PAGE_START
HEAP_HEADER_STRUCT
                HEAP_START              .word ?
                HEAP_END                .word ?

                HEAP_FIRST_BLOCK        .word ?

            ; Parameters to Heap Subsystem
                BLOCK_SIZE_REQUESTED    .word ?

                CURRENT_BLOCK_HEADER    .long ?
                CURRENT_BLOCK_DATA      .long ?

HEAP_INIT:  .proc
            PUSH_S_AND_DP
            SETDP #HEAP_PAGE_START

            ; Set HEAP_START and HEAP_END
            SETAXL
            STZ HEAP_HEADER.HEAP_START
            LDA #$FFFF
            STA HEAP_HEADER.HEAP_END
            
            ; Create 1st unallocated block at HEAP_START + SIZEOF(HEAP_HEADER)
            LDA HEAP_HEADER.HEAP_START
            CLC
            ADC #SIZEOF(HEAP_HEADER)
            STA HEAP_HEADER.HEAP_FIRST_BLOCK
            LDA #0
            LDX #HEAP_BLOCK_HEADER.PREV_BLOCK_HEADER
            STA HEAP_FIRST_BLOCK, X
            LDX #HEAP_BLOCK_HEADER.NEXT_BLOCK_HEADER
            STA HEAP_FIRST_BLOCK, X
            LDX #HEAP_BLOCK_HEADER.REFERENCE_COUNT
            STA HEAP_FIRST_BLOCK, X
            LDX #HEAP_BLOCK_HEADER.BLOCK_SIZE
            SEC ; Set the Carry because it is the reverse borrow flag...
            LDA HEAP_HEADER.HEAP_END
            SBC HEAP_HEADER.HEAP_FIRST_BLOCK
            ADC #SIZEOF(HEAP_BLOCK_HEADER)

            ; Set Out Parameters
            LDA HEAP_HEADER.HEAP_FIRST_BLOCK
            STA HEAP_HEADER.CURRENT_BLOCK_HEADER
            CLC
            ADC #SIZEOF(HEAP_BLOCK_HEADER)
            STA HEAP_HEADER.CURRENT_BLOCK_DATA

            PULL_DP_AND_S
            RETURN
            .pend



; The stuff below is going to be completely re-imagined but is kept for reference.


; $00:xxxx      Kernel and Basic816
; $01:xxxx
;   1-63 Pages of 64k      
; $3F:xxxx
HEAP_TOP            = $3FFFFF   ; Top of Ram

                                ; Need to check this to make sure nothing is there.
                                ; Where does the 512K flash get loaded?
                                ; Where are the kernel routines



HEAP_HEADER     .struct
                    BLOCK_TYPE          .byte ?
                    REFERENCE_COUNT     .byte ?
                    NEXT_BLOCK          .long ?

                .ends

.section HeapGlobals
HEAP_VARIABLES = *

HEAP_POINTER                .long ?
ALLOCATED_LIST_POINTER      .long ?
FREED_LIST_POINTER          .long ?

NUMBER_OF_ALLOCATED_BLOCKS  .word ?
SIZE_OF_ALLOCATED_BLOCKS    .word ?

NUMBER_OF_FREED_BLOCKS      .word ?
SIZE_OF_FREED_BLOCKS        .word ?

CURRENT_BLOCK_POINTER       .long ?     ; 
CURRENT_HEADER_POINTER      .long ?     ;


.send


; ===========================================================================
; Init the Heap Subsystem
; Inputs    : None
; Outputs   : Initialized HeapGlobals
; ===========================================================================
HEAP_INIT:  .proc
                PUSH_S_AND_DP
                SETDP HEAP_VARIABLES

                SET_LONG_POINTER HEAP_TOP, HEAP_POINTER        ; Set the Heap Pointer to Heap Top

                CLEAR_LONG_POINTER ALLOCATED_LIST_POINTER      ; Clear the Allocated list pointer
                CLEAR_LONG_POINTER FREED_LIST_POINTER          ; Clear the Freed list pointer

                CLEAR_WORD NUMBER_OF_ALLOCATED_BLOCKS
                CLEAR_WORD SIZE_OF_ALLOCATED_BLOCKS
                CLEAR_WORD NUMBER_OF_FREED_BLOCKS
                CLEAR_WORD SIZE_OF_FREED_BLOCKS

                CLEAR_LONG_POINTER CURRENT_BLOCK_POINTER
                CLEAR_LONG_POINTER CURRENT_HEADER_POINTER

                PULL_DP_AND_S
                RETURN
            .pend

; ===========================================================================
; Init the Heap Subsystem
; Inputs    : A - Type of Block to Allocate ?
;             X - The size of the Block to Allocate
; Outputs   : CURRENT_HEADER
;           : CURRENT_BLOCK
;           
; ===========================================================================
HEAP_ALLOCATE_BLOCK:
            .proc



                RETURN
            .pend

; ===========================================================================
; Init the Heap Subsystem
; Inputs    : 
; Outputs   : 
; ===========================================================================
HEAP_ALLOCATE_FROM_FREE_BLOCKS:
            .proc



                RETURN
            .pend

; ===========================================================================
; Init the Heap Subsystem
; Inputs    : 
; Outputs   : 
; ===========================================================================
HEAP_ALLOCATE_FROM_HEAP:
            .proc



                RETURN
            .pend

; ===========================================================================
; Init the Heap Subsystem
; Inputs    : 
; Outputs   : 
; ===========================================================================
HEAP_FREE_BLOCK:
            .proc



                RETURN
            .pend

; ===========================================================================
; Init the Heap Subsystem
; Inputs    : 
; Outputs   : 
; ===========================================================================
HEAP_COLLECTION_FREE_BLOCKS:
            .proc



                RETURN
            .pend

; ===========================================================================
; Init the Heap Subsystem
; Inputs    : 
; Outputs   : 
; ===========================================================================
HEAP_GET_LAST_ALLOCATED_BLOCK:
            .proc



                RETURN
            .pend

; ===========================================================================
; Init the Heap Subsystem
; Inputs    : 
; Outputs   : 
; ===========================================================================
HEAP_GET_HEADER_OF_CURRENT_BLOCK:
            .proc



                RETURN
            .pend

; ===========================================================================
; Init the Heap Subsystem
; Inputs    : CURRENT_BLOCK
; Outputs   : None
; ===========================================================================
HEAP_INC_REF_COUNTER:
            .proc



                RETURN
            .pend

; ===========================================================================
; Init the Heap Subsystem
; Inputs    : CURRENT_BLOCK
; Outputs   : None
; ===========================================================================
HEAP_DEC_REF_COUNTER:
            .proc



                RETURN
            .pend






