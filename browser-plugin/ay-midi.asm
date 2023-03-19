    module Midi
sendByte:
;;;; Here begins ROM's copy-paste :-)
    ld l,a
    
    ld bc, #FFFD
    ld a, #0e
    out (c),a

    ld bc, #BFFD
    ld a, #FA
    out (c), a

    ld e, #03
.delay1
    dec e
    jr nz, .delay1

    nop : nop : nop : nop

    ld a, l
    ld d, 8
.sending
    rra
    ld l, a
    jp nc, .sendZero

    ld a, #fe
    out (c), a
    jr  .nextBit
.sendZero
    ld a, #fa
    out (c),a
    jr  .nextBit
.nextBit
    ld e, 2
.delay2
    dec e
    jr nz, .delay2

    nop
    add a, 0
    
    ld a, l
    dec d
    jr nz, .sending

    nop
    nop
    nop
    nop
    add a,0

    ld a, #fe
    out (c),a
    ld e, 6
.delay3
    dec e
    jr nz, .delay3
    ret

; B - byte count
sendBuffer:
    di
    ld hl, buffer
.transmit
    push bc
    push hl
    ld a, (hl): call sendByte
    pop hl
    pop bc
    inc hl
    djnz .transmit
    ei
    ret

    endmodule