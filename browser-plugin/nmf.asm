PLUGIN_ORG  = #8000

RESULT_OK   = 1
RESULT_ERR  = 128

    device zxspectrum48
    org PLUGIN_ORG
    jr start
    db "BP", 0, 0 ;; Browse plugin
    db 0, 0 ;; Flags
    db ".NMF player - nihirash", 0

;; HL - filename
start:
    ld b, Dos.FMODE_READ
    call Dos.fopen : jp c, err
    ld (f_handle), a
    
    di
    ld a, #ff
    call Midi.sendByte
    ld a, #ff
    call Midi.sendByte
    ld a, #ff
    call Midi.sendByte
    ld a, #ff
    call Midi.sendByte
    
workingFrame:
    xor a
    in a, (#fe)
    or %11100000
    inc a
    jp nz, exit

    ld a, (f_handle)
    ld bc, 2
    ld hl, frame_size
    call Dos.fread
    ld a,b : or c : jr z, exit ; If nothing was read

    ld a, (frame_size) : ld c,a : ld b,0
    ld hl, buffer
    ld a, (f_handle)
    call Dos.fread
    ld a,b : or c : jr z, exit ; If nothing was read
;;; Playing it
    ld b,c
    call Midi.sendBuffer
;;; Reading delay between frames
    ld a, (wait_frames)
.delay
    and a : jr z, workingFrame
    ei
    halt
    dec a : jr .delay

exit:
    ld a, (f_handle)
    call Dos.fclose  
    di
    ld a, #ff
    call Midi.sendByte
    ld a, #ff
    call Midi.sendByte
    ld a, #ff
    call Midi.sendByte
    ld a, #ff
    call Midi.sendByte
    
    ei

    ld a, RESULT_OK 
    ret

err:
    ld a, RESULT_ERR
    ret

    include "esxdos.asm"
    include "ay-midi.asm"

frame_size db 0
wait_frames db 0

f_handle db 0
buffer  ds #ff

    savebin "nmf", PLUGIN_ORG, $ - PLUGIN_ORG
    