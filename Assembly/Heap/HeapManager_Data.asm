ZeroPage .block
;.section ZeroPage
    HeaderPointer       = $a0 ;.long ?
    BlockPointer        = $a3 ;.long ?
    RequestedSize       = $a6 ;.word ?
;;.send
.bend

Header .struct
    Start               .long ?
    End                 .long ?
    TotalSize           .word ?
    FirstBlock          .long ?
    CurrentBlock        .long ?
.ends

BlockHeader .struct
    PrevBlock           .word ?
    NextBlock           .word ?
    RefCount            .word ?
    Size                .word ?
.ends