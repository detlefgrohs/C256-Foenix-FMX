; Kernel defines
PUTS                    = $00101C              ; Print a string to the currently selected channel
PUTC                    = $001018
PRINTCR                 = $00106C
PRINTAH                 = $001080
PRINTH                  = $001078
LOCATE                  = $001084

;FK_SETSIZES             = $00112C
CUR_COLOR               = $00001E
BORDER_CTRL_REG	        = $AF0004
SCREEN_TEXT_MEM         = $AFA000
SCREEN_TEXT_COL         = $AFC000
NUM_COLS                = 80
NUM_ROWS                = 60




;;;
;;; Kernel Jump Table for C256 Foenix
;;;

FK_GETCHW           = $00104c ; Get a character from the input channel. Waits until data received. A=0 and Carry=1 if no data is wating
FK_PUTC             = $001018 ; Print a character to the currently selected channel
FK_PUTS             = $00101C ; Print a string to the currently selected channel
FK_LOCATE           = $001084 ; Reposition the cursor to row Y column X
FK_IPRINTH          = $001078 ; Print a HEX string
FK_SETOUT           = $00103c ; Select an output channel
FK_SETSIZES         = $00112C ; Set the text screen size variables based on the border and screen resolution.

FK_OPEN             = $0010F0 ; open a file for reading/writing/creating
FK_CREATE           = $0010F4 ; create a new file
FK_CLOSE            = $0010F8 ; close a file (make sure last cluster is written)
FK_WRITE            = $0010FC ; write the current cluster to the file
FK_READ             = $001100 ; read the next cluster from the file
FK_DELETE           = $001104 ; delete a file / directory
FK_DIROPEN          = $001108 ; open a directory and seek the first directory entry
FK_DIRNEXT          = $00110C ; seek to the next directory of an open directory
FK_DIRREAD          = $001110 ; Read the directory entry for the specified file
FK_DIRWRITE         = $001114 ; Write any changes in the current directory cluster back to the drive
FK_LOAD             = $001118 ; load a binary file into memory, supports multiple file formats
FK_SAVE             = $00111C ; Save memory to a binary file
FK_RUN              = $001124 ; Load and run an executable binary file
FK_COPY             = $001130 ; Copy a file
FK_CMDBLOCK         = $001120 ; Send a command to a block device

;;;
;;; Kernel Constants
;;;

CHAN_CONSOLE = 0
CHAN_COM1 = 1
CHAN_COM2 = 2


KEYBOARD_LOCKS   = $000F89 ;  1 Byte, the status of the various lock keys
; Lock Key Flags
KB_SCROLL_LOCK      = $01
KB_NUM_LOCK         = $02
KB_CAPS_LOCK        = $04