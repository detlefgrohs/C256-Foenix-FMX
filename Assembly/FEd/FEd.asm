;;; =========================================================================
;;; Fed Implementation
;;; =========================================================================

* = $002000             ; Set the origin for the file

.INCLUDE "../Common/PGX.asm"
.INCLUDE "../Common/Macros.asm"
.INCLUDE "../Common/Kernel.asm"


TEXT_COLOR              = $20

LOADBLOCK               = $010000         ; File loading will start here
FK_LOAD                 = $001118       ; load a binary file into memory, supports multiple file formats
DOS_DST_PTR             = $000354      ; 4 bytes - Pointer for transferring data
DOS_FD_PTR              = $000340      ; 4 bytes - A pointer to a file descriptor                 
SDOS_VARIABLES          = $000320

START   
        CALL SETUP

            PRINTS HELP_TEXT

                CALL SETFILEDESC            ; Set up a file descriptor

                SETAXL
                LDA #<>LOADBLOCK
                STA @l DOS_DST_PTR
                LDA #`LOADBLOCK
                STA @l DOS_DST_PTR+2        ; Set the destination address

                JSL FK_LOAD                 ; Attempt to load the file
                BCS +                       ; If we got it: start tokenizing
                PRINTS FILE_ERROR

                BRA ++
+               PRINTS FILE_LOAD

                ; Place NULL at end of loaded file...
                SETAS
                LDX FD_IN.FILESIZE
                LDA #0
                STA LOADBLOCK, X

                PRINTS LOADBLOCK
+
            RTL




SETFILEDESC:    PHD
                PHP

                SETDP SDOS_VARIABLES

                SETAXL
                LDA #<>FD_IN            ; Point to the file descriptor
                STA DOS_FD_PTR
                LDA #`FD_IN
                STA DOS_FD_PTR+2

                LDY #0                  ; Fille the file descriptor with 0
                SETAS
                LDA #0
-               STA [DOS_FD_PTR],Y
                INY
                CPY #SIZE(FILEDESC)
                BNE -

                SETAL
                LDA #<>CLUSTER_BUFF     ; Point to the cluster buffer
                STA @l FD_IN.BUFFER
                LDA #`CLUSTER_BUFF
                STA @l FD_IN.BUFFER+2

                LDA #<>FILE_NAME        ; Point the file desriptor to the path
                STA @l FD_IN.PATH
                LDA #`FILE_NAME
                STA @l FD_IN.PATH+2

                PLP
                PLD
                RETURN

; File Descriptor -- Used as parameter for higher level DOS functions
FILEDESC            .struct
STATUS              .byte ?             ; The status flags of the file descriptor (open, closed, error, EOF, etc.)
DEV                 .byte ?             ; The ID of the device holding the file
PATH                .dword ?            ; Pointer to a NULL terminated path string
CLUSTER             .dword ?            ; The current cluster of the file.
FIRST_CLUSTER       .dword ?            ; The ID of the first cluster in the file
BUFFER              .dword ?            ; Pointer to a cluster-sized buffer
FILESIZE            .dword ?            ; The size of the file
CREATE_DATE         .word ?             ; The creation date of the file
CREATE_TIME         .word ?             ; The creation time of the file
MODIFIED_DATE       .word ?             ; The modification date of the file
MODIFIED_TIME       .word ?             ; The modification time of the file
                    .ends

CLUSTER_BUFF    .fill 512           ; A buffer for cluster read/write operations
FD_IN           .dstruct FILEDESC   ; A file descriptor for input operations

.INCLUDE "../Common/Common.asm"

FILE_LOAD: .NULL "File loaded.", 13, 13
FILE_ERROR:.NULL "File load error", 13

FILE_NAME:  .NULL "test.txt"

HELP_TEXT:  .TEXT "FEd - C256 Foenix FMX Editor Help", 13
            .TEXT "============================================================================", 13
            .TEXT "Ls-e    List lines. If s and e are missing list entire file. If e is missing", 13
            .TEXT "        list from s to EOF. If s is missing list to e.", 13
            .TEXT "Es      Edit lines. If s is missing edit the 1st line.", 13
            .TEXT "Is      Insert lines. If s is missing insert lines at EOL. If s is 0 or 1", 13
            .TEXT "        insert lines at BOF.", 13
            .TEXT "Ds-e    Delete lines. If s and e are missing delete all lines. If e is missing", 13
            .TEXT "        delete lines from s to EOF. If s is missing delete lines to e.", 13
            .TEXT "", 13
            .TEXT "W       Write the file.", 13
            .TEXT "E       Write the file and exit.", 13
            .TEXT "X       eXit.", 13, 0
