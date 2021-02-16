;;; =========================================================================
;;; FBas Implementation
;;; =========================================================================

* = $002000             ; Set the origin for the file

.INCLUDE "../Common/PGX.asm"
.INCLUDE "../Common/Macros.asm"
.INCLUDE "../Common/Kernel.asm"
             
START   
        CALL SETUP

        CALL TOKENIZE

        RTL



.INCLUDE "../Common/Common.asm"
.INCLUDE "Common.asm"
.INCLUDE "Tokenize.asm"
.INCLUDE "Globals.asm"
