    device ZXSPECTRUM48
    org #2000
    jp start
    include "modules/version.asm"
ver:    
    db "NMF player "
    db VERSION_STRING
    db 13,"by Alex Nihirash",13, 0

    include "modules/ay-midi.asm"
    include "modules/args.asm"
    include "modules/esxdos.asm"
    include "modules/zxbios.asm"
start:
;;; Version number print
    push hl
    print ver
    pop hl

    ld a,l : or h : jp z, noArgs
    
    ld de, buffer : call Args.parseOne
    ld a, b : and a : jp z, noArgs

;;; Preparing filename for opening 
    ld hl, buffer : ld a, '.' : ld bc, #ff : cpir : jp z, openFile
;;; There was no extension - add it
    xor a : ld hl, buffer, bc, 80 : cpir : dec hl
    ld a, '.' : ld (hl), a : inc hl
    ld a, 'n' : ld (hl), a : inc hl
    ld a, 'm' : ld (hl), a : inc hl 
    ld a, 'f' : ld (hl), a : inc hl
    xor a     : ld (hl), a
;;; Open file
openFile:
    ld b, Dos.FMODE_READ, hl, buffer
    call Dos.fopen : jp c, error
    ld (f_handle), a

workingFrame:
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
    ret


error:
    print error_txt
    ret

noArgs:
    print no_args_txt
    ret

;; Data section
error_txt db 13
         db "[ERR] Cannot open file!",13,0
no_args_txt db "Usage:", 13
         db ".playnmf <filename>", 13
         db "File extension can be omitted",13, 0

;; BSS section :-)
frame_size db 0
wait_frames db 0

f_handle db 0
buffer  ds #ff
    savebin "playnmf", #2000, $ - #2000