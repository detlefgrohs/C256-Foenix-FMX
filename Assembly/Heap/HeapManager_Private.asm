Private .block

;============================================================================
; Inputs : A - Page for HeapManager
;          X - Address for HeapManager
; Outputs: HeapManager.CURRENT_BLOCK_HEADER
; Notes  :
;============================================================================
FindUnallocatedBlock .proc
    ; PUSH_ALL
    ; This will set the current block to the head of the list...
    CALL ResetCurrentBlock 

FindBlockLoop:
    GetBlockHeader RefCount
    BEQ FoundUnallocatedBlock

    CALL MoveNextBlock
    BCC NotFound
    BRA FindBlockLoop

FoundUnallocatedBlock:
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

    RETURN
.pend
;============================================================================
; Inputs : A - Page for HeapManager
;          X - Address for HeapManager
; Outputs: HeapManager.CURRENT_BLOCK_HEADER
; Notes  :
;============================================================================
ConvertBlock .proc

    RETURN
.pend

.bend