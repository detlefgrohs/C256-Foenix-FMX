Private .block

;============================================================================
; Inputs : A - Page for HeapManager
;          X - Address for HeapManager
; Outputs: HeapManager.CURRENT_BLOCK_HEADER
; Notes  :
;============================================================================
FindUnallocatedBlock .proc
    Trace "HeapManager.Private.FindUnallocatedBlock"
    ; PUSH_ALL
    ; This will set the current block to the head of the list...
    CALL ResetCurrentBlock 

FindBlockLoop:
    SETAL
    GetBlockHeader RefCount
    BEQ FoundUnallocatedBlock

    CALL MoveNextBlock
    BCC NotFound
    BRA FindBlockLoop

FoundUnallocatedBlock:
    Trace "FoundUnallocatedBlock"
    GetBlockHeader Size
    CLC
    ADC #SIZE(BlockHeader)
    CMP ZeroPage.RequestedSize
    BCS Found
    BRA FindBlockLoop

NotFound:
    ; PULL_ALL
    CLC
    RETURN
Found:
    Trace "Found unallocated block."
    TraceMemory "HeapManager.ZeroPage", $0008A0, 6
    ; PULL_ALL
    SEC
    RETURN
.pend

;============================================================================
; Inputs : A - Page for HeapManager
;          X - Address for HeapManager
; Outputs: HeapManager.CURRENT_BLOCK_HEADER
; Notes  :
;============================================================================
SplitBlock .proc
    Trace "HeapManager.Private.SplitBlock"

    RETURN
.pend
;============================================================================
; Inputs : A - Page for HeapManager
;          X - Address for HeapManager
; Outputs: HeapManager.CURRENT_BLOCK_HEADER
; Notes  :
;============================================================================
ConvertBlock .proc
    Trace "HeapManager.Private.ConvertBlock"

    RETURN
.pend

.bend