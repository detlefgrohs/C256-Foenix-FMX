;;; =========================================================================
;;; My Heap Management Code
;;; =========================================================================

HEAP_PAGE_START = $0F0000
HEAP_PAGE_END   = $0FFFFF

TEXT_COLOR              = $20

* = $0E0000             ; Set the origin for the file

.INCLUDE "../Common/PGX.asm"
.INCLUDE "../Common/Macros.asm"
.INCLUDE "../Common/Kernel.asm"

UNIT_TEST_HEAP_MANAGER_HEADER_COMPARE .macro index, compareTo
    LDY #\index
    LDA [ZP_HEAP_MANAGER_HEADER_POINTER], Y
    CMP #\compareTo
    BNE FAILED
.endm

START:   
    CALL SETUP
    PRINTS MSG_WELCOME
    BRA +

    CALL UNIT_TEST_HEAP_MANAGER_INIT
    CALL UNIT_TEST_HEAP_MANAGER_RESET_CURRENT_BLOCK

+   RTL


UNIT_TEST_HEAP_MANAGER_INIT .proc
    ; Setup My_Heap_Manager
    SETAS
    SETXL
    LDA #`HEAP_PAGE_START
    LDX #<>HEAP_PAGE_START
    LDY #<>HEAP_PAGE_END
    CALL HEAP_MANAGER_INIT

    SETAL
    LDA #<>HEAP_PAGE_START
    STA MY_HEAP_MANAGER
    SETAS
    LDA #`HEAP_PAGE_START
    STA MY_HEAP_MANAGER + 2
    
    PRINTS MSG_UNIT_TEST_HEAP_MANAGER_INIT

    SETAS
    UNIT_TEST_HEAP_MANAGER_HEADER_COMPARE HEAP_MANAGER_HEADER.HEAP_MANAGER_START + 2, `HEAP_PAGE_START

    SETAL
    UNIT_TEST_HEAP_MANAGER_HEADER_COMPARE HEAP_MANAGER_HEADER.HEAP_MANAGER_START, <>HEAP_PAGE_START

    ; Check HEAP_MANAGER_END

    ; Check HEAP_TOTAL_SIZE

    ; Check HEAP_FIRST_BLOCK_HEADER

    PRINTS MSG_PASSED
    BRA +
FAILED:     
    PRINTS MSG_FAILED
+   RETURN
.pend

UNIT_TEST_HEAP_MANAGER_RESET_CURRENT_BLOCK .proc
    SETAS
    SETXL
    LDA MY_HEAP_MANAGER + 2
    LDX MY_HEAP_MANAGER
    CALL HEAP_MANAGER_RESET_CURRENT_BLOCK

    ; Check CURRENT_BLOCK_HEADER


    ; CHECK ZP_HEAP_MANAGER_BLOCK_POINTER


    PRINTS MSG_PASSED
    BRA +
FAILED:
    PRINTS MSG_FAILED
+   RETURN
.pend



.INCLUDE "../Common/Common.asm"

.INCLUDE "HeapManager.asm"


MSG_WELCOME:                        .NULL "HeapManager Unit Tests Ready", 13

MSG_UNIT_TEST_HEAP_MANAGER_INIT:    .NULL "UNIT_TEST_HEAP_MANAGER_INIT "

MSG_PASSED:                         .NULL "Passed", 13
MSG_FAILED:                         .NULL "Failed", 13

MY_HEAP_MANAGER .long ?

