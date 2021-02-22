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

;;; =========================================================================
;;; My Heap Management Code
;;; =========================================================================


; .byte     8 bits
; .word     16 bits
; .long     24 bits
; .dword    32 bits

; HEAP_PAGE = $3F
HEAP_PAGE_START = $3F0000
HEAP_PAGE_END   = $3FFFFF

* = $002000             ; Set the origin for the file

.INCLUDE "../Common/PGX.asm"
.INCLUDE "../Common/Macros.asm"
.INCLUDE "../Common/Kernel.asm"

START:   
            CALL SETUP




            RTL

.INCLUDE "../Common/Common.asm"


FILE_ERROR:.NULL "File load error", 13

; ===========================================================================
; Heap Unit Tests
; ===========================================================================


; ===========================================================================
; Heap Subsystem
; ===========================================================================
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
            CLC
            ADC #SIZEOF(HEAP_BLOCK_HEADER)
            STA HEAP_FIRST_BLOCK, X

            ; Set Out Parameters
            LDA HEAP_HEADER.HEAP_FIRST_BLOCK
            STA HEAP_HEADER.CURRENT_BLOCK_HEADER
            CLC
            ADC #SIZEOF(HEAP_BLOCK_HEADER)
            STA HEAP_HEADER.CURRENT_BLOCK_DATA

            PULL_DP_AND_S
            RETURN
            .pend

HEAP_ALLOC: .proc



            .pend

HEAP_FREE:  .proc


            .pend

HEAP_MERGE: .proc


            .pend