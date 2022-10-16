    include "parts/ay-midi.asm"
    module BgMidi

; Should be called on init state
; HL - filename
init:
    push hl
    ld a,(f_handle)
    call Dos.fclose
    pop hl
    ld b, Dos.FMODE_READ
    call Dos.fopen
    ld (f_handle), a
    jp reset

; Should be called on int or with disabled interrupts 
tick:
    ld hl, wait_frames : ld a, (hl) : and a : jr z, .play
    dec a : jr z, .play
    ld (hl), a
    ret
.play
    ld a, (f_handle)
    ld bc, 2
    ld hl, frame_size
    call Dos.fread
    ld a,b : or c : ld a, (f_handle) : jp z, Dos.rewind ; If nothing was read

    ld a, (frame_size), c, a, b,0
    ld hl, buffer,  a, (f_handle)
    call Dos.fread
    ld b,c
    jp Midi.sendBuffer

stop:
    ld a,(f_handle)
    call Dos.fclose
reset:
    ld a, #ff : ld (buffer), a
    ld b,1 : call Midi.sendBuffer
    ld a, 10 : ld (wait_frames), a
    ret

frame_size db 0
wait_frames db 0
f_handle    db #ff
buffer ds 128

    endmodule
