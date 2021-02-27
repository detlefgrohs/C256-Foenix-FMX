
SetBlockHeader .macro parameter
    LDY #BlockHeader.\parameter
    STA [ZeroPage.BlockPointer], Y
.endm

GetBlockHeader .macro parameter
    LDY #BlockHeader.\parameter
    LDA [ZeroPage.BlockPointer], Y
.endm

SetHeader .macro parameter
    LDY #Header.\parameter
    STA [ZeroPage.HeaderPointer], Y
.endm

GetHeader .macro parameter
    LDY #Header.\parameter
    LDA [ZeroPage.HeaderPointer], Y
.endm

HeaderCompareByte .macro testNumber, index, compareTo
    SETAS
    LDY #\index
    LDA [ZeroPage.HeaderPointer], Y
    CMP #\compareTo
    BEQ +
    SETAS
    LDA #\testNumber
    CALL FailedUnitTest
    RETURN
+   
.endm

HeaderCompareWord .macro testNumber, index, compareTo
    SETAL
    LDY #\index
    LDA [ZeroPage.HeaderPointer], Y
    CMP #\compareTo
    BEQ +
    SETAS
    LDA #\testNumber
    CALL FailedUnitTest
    RETURN
+   
.endm

ZeroPageCompareByte .macro testNumber, zeroPageAddress, compareTo
    SETAS
    LDA \zeroPageAddress
    CMP #\compareTo
    BEQ +
    SETAS
    LDA #\testNumber
    CALL FailedUnitTest
    RETURN
+   
.endm

ZeroPageCompareWord .macro testNumber, zeroPageAddress, compareTo
    SETAL
    LDA \zeroPageAddress
    CMP #\compareTo
    BEQ +
    SETAS
    LDA #\testNumber
    CALL FailedUnitTest
    RETURN
+   
.endm

CheckForCarrySet .macro testNumber
    BCS +
   SETAS
    LDA #\testNumber
    CALL FailedUnitTest
    RETURN
+
.endm

CheckForCarryClear .macro testNumber
    BCC +
   SETAS
    LDA #\testNumber
    CALL FailedUnitTest
    RETURN
+
.endm

UnitTestEnd .macro
    PushTextColor
    SetTextColor PassTextColor
    PRINTS Strings.Passed
    PullTextColor
    SEC
    RETURN 
.endm
