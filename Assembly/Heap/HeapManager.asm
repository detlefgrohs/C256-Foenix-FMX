HeapManager .block

.INCLUDE "HeapManager_Data.asm"
.INCLUDE "HeapManager_Macros.asm"
.INCLUDE "HeapManager_Private.asm"
.if IncludeUnitTests
    .INCLUDE "HeapManager_UnitTests.asm"
.fi

;============================================================================
; Inputs : A - Page for Heap
;          X - Start of Heap
;          Y - End of Heap
; Outputs: Initialized HeapManager @ $A:X
; Notes  : Will create a new HeapManager structure at $A:X and allocate for
;          the provided size.
;============================================================================
Init .proc
    TraceAXY "HeapManager.Init"

    PushAll
    ; Save Y To be used later...
    PHY

    CALL SetupZeroPage

    SETAS
    STA ZeroPage.BlockPointer + 2 ; ZP_HEAP_MANAGER_BLOCK_POINTER + 2
    SETAL
    TXA
    CLC
    ADC #SIZE(Header)
    STA ZeroPage.BlockPointer

    ; Setup the HEAP_MANAGER_HEADER.HEAP_MANAGER_START
    SETAL
    LDA ZeroPage.HeaderPointer ; ZP_HEAP_MANAGER_HEADER_POINTER    
    SetHeader Start    
    SETAS
    LDA ZeroPage.HeaderPointer + 2
    SetHeader Start + 2

    ; HEAP_MANAGER_HEADER.HEAP_MANAGER_END
    SETAL
    PLA
    SetHeader End
    SETAS
    LDA ZeroPage.HeaderPointer + 2
    SetHeader End + 2

    ; Calculate the size of the heap and store in HEAP_MANAGER_HEADER.HEAP_TOTAL_SIZE
    SETAL
    GetHeader End
    Subtract ZeroPage.HeaderPointer
    SubtractConstant SIZE(Header)
    SetHeader TotalSize

    ; Now Create an unallocated block that encompasses the heap...
    ; Set the HEAP_FIRST_BLOCK_POINTER and HEAP_MANAGER_BLOCK_HEADER
    SETAS
    LDA ZeroPage.BlockPointer + 2
    SetHeader FirstBlock + 2
    SetHeader CurrentBlock + 2
    SETAL
    LDA ZeroPage.BlockPointer
    SetHeader FirstBlock
    SetHeader CurrentBlock

    ; Now Set the Block Header Parameters
    LDA #0
    SetBlockHeader PrevBlock
    SetBlockHeader NextBlock
    SetBlockHeader RefCount
    
    GetHeader TotalSize
    SubtractConstant SIZE(BlockHeader)  
    SetBlockHeader Size

    ; TraceMemory "HeapManager.ZeroPage", $0008A0, 6
    ; ;TraceMemoryZPIndirect "HeapManager.Header", ZeroPage.HeaderPointer, SIZE(HeapManager.Header)
    ; TraceMemory "HeapManager.Header", HEAP_PAGE_START, SIZE(HeapManager.Header)
    ; SETAL
    ; LDA HeapManager.ZeroPage.BlockPointer
    ; TraceMemoryA "HeapManager.Block", `HEAP_PAGE_START, SIZE(HeapManager.BlockHeader)

    ; SETAS
    ; SETXL
    ; LDA HeapManager.ZeroPage.BlockPointer + 2
    ; LDX HeapManager.ZeroPage.BlockPointer
        TraceMemory "HeapManager.ZeroPage", $0008A0, 6
    TraceMemoryLong "HeapManager.Header  ", HeapManager.ZeroPage.HeaderPointer, SIZE(HeapManager.Header)
    TraceMemoryLong "HeapManager.Block   ", HeapManager.ZeroPage.BlockPointer, SIZE(HeapManager.BlockHeader)


    PullAll
    RETURN
.pend
;============================================================================
; Inputs : A - Page for HeapManager
;          X - Address for HeapManager
;          Y - Size of Memory Allocate
; Outputs: HeapManager.CURRENT_BLOCK_HEADER
;          BCS - Block Allocated
;          BCC - Block not allocated...
; Notes  :
;============================================================================
Allocate .proc
    TraceAXY "HeapManager.Allocate"

    PUSH_ALL
    CALL SetupZeroPage
    ; So we are going to find the 1st free block and then split the block
    ; to the right (higher) in memory. The free block will still be the
    ; current block and the newly allocated block will be next...
    ;  or
    ; So we are going to find the 1st free block and then split the block
    ; to the left (lower) in memory. The newly allocation block will the
    ; current block and the free blocks will be next...
    
    ;BRA Allocated

    STY ZeroPage.RequestedSize

    ; Find Unallocated Block that is at least Y sized...
    CALL Private.FindUnallocatedBlock
    BCC NotAllocated ; Did not find free block...

    ; IF Data_Size - Size(HEAP_MANAGER_BLOCK_HEADER) < ZP_HEAP_MANAGER_REQUESTED_SIZE
    GetBlockHeader Size
    SubtractConstant SIZE(BlockHeader)
    CMP ZeroPage.RequestedSize
    BCC ConvertBlock
    CALL Private.SplitBlock    
    BRA Allocated
ConvertBlock:
    CALL Private.ConvertBlock
    BRA Allocated
NotAllocated:
    PULL_ALL
    CLC
    RETURN

Allocated:
    PULL_ALL
    SEC
    RETURN
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
Free .proc
    PUSH_ALL
    CALL SetupZeroPage

    BRA Freed

NotFreed:
    PULL_ALL
    CLC
    RETURN

Freed:
    PULL_ALL
    SEC
    RETURN
.pend
;============================================================================
; Inputs : A - Page for HeapManager
;          X - Address for HeapManager          
; Outputs: HeapManager.CURRENT_BLOCK_HEADER
;          HeapManager.CURRENT_BLOCK_DATA
; Notes  : Will scan through the Heap Blocks for adjacent unallocated blocks
;          and merge them.
;============================================================================
Merge .proc
    CALL SetupZeroPage



    RETURN
.pend
;============================================================================
; Inputs : A - Page for HeapManager
;          X - Address for HeapManager
; Outputs: HeapManager.CURRENT_BLOCK_HEADER
; Notes  :
;============================================================================
ResetCurrentBlock .proc
    Trace "HeapManager.ResetCurrentBlock"

    CALL SetupZeroPage

    SETAL
    GetHeader FirstBlock
    SetHeader CurrentBlock
    ;STA ZeroPage.BlockPointer

    SETAS
    GetHeader FirstBlock + 2
    SetHeader CurrentBlock + 2
    ;STA ZeroPage.BlockPointer + 2

    TraceMemory "HeapManager.ZeroPage", $0008A0, 6
    ; ToDo: The next line is causing problems...
    ;TraceMemoryLong "HeapManager.Header  ", HeapManager.ZeroPage.HeaderPointer, SIZE(HeapManager.Header)

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
MoveNextBlock .proc
    ; PUSH_ALL
    CALL SetupZeroPage



    BRA AT_END_OF_LIST

        ; SETAL
        ; GET_HEAP_MANAGER_BLOCK_HEADER NEXT_BLOCK_HEADER
        ; BEQ AT_END_OF_LIST

        ; SET_HEAP_MANAGER_HEADER CURRENT_BLOCK_HEADER
        ; STA ZP_HEAP_MANAGER_BLOCK_POINTER

        ; SETAS
        ; GET_HEAP_MANAGER_HEADER HEAP_MANAGER_START + 2
        ; SET_HEAP_MANAGER_HEADER CURRENT_BLOCK_HEADER + 2
        ; STA ZP_HEAP_MANAGER_BLOCK_POINTER + 2

    ; PULL_ALL

    SEC
    RETURN
AT_END_OF_LIST:

    CLC
    RETURN
.pend
;============================================================================
; Inputs : A - Page for HeapManager
;          X - Address for HeapManager
; Outputs: HeapManager.CURRENT_BLOCK_HEADER
;          HeapManager.CURRENT_BLOCK_DATA
;          BCS - Moved to Prev Block in List
;          BCC - At Start of List
; Notes  :
;============================================================================
MovePrevBlock .proc
    ; PUSH_ALL
    CALL SetupZeroPage

    BRA AT_START_OF_LIST
        ; SETAL
        ; GET_HEAP_MANAGER_BLOCK_HEADER PREV_BLOCK_HEADER
        ; BEQ AT_START_OF_LIST

        ; SET_HEAP_MANAGER_HEADER CURRENT_BLOCK_HEADER
        ; STA ZP_HEAP_MANAGER_BLOCK_POINTER

        ; SETAS
        ; GET_HEAP_MANAGER_HEADER HEAP_MANAGER_START + 2
        ; SET_HEAP_MANAGER_HEADER CURRENT_BLOCK_HEADER + 2
        ; STA ZP_HEAP_MANAGER_BLOCK_POINTER + 2

    ; PULL_ALL

    SEC
    RETURN
AT_START_OF_LIST:
    ; PULL_ALL

    CLC
    RETURN
.pend
;============================================================================
; Inputs : A - Page for HeapManager
;          X - Address for HeapManager
; Outputs: ZP_HEAP_MANAGER_HEADER_POINTER
; Notes  :
;============================================================================
SetupZeroPage .proc
    TraceAX "HeapManager.SetupZeroPage"
    PushAll

    SETAS
    STA ZeroPage.HeaderPointer + 2
    SETAL
    TXA
    STA ZeroPage.HeaderPointer
    
    PullAll
    RETURN
.pend
.bend