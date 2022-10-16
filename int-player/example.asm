    device ZXSPECTRUM128
    org #8000
    jp start
    include "parts/esxdos.asm"
    include "int-player.asm"

;; Int handler
intHandler:
    push af, bc, de, ix
    call BgMidi.tick
    pop ix, de, bc, af
    ei
    ret

;; Install int-handler
im2On
	ld    a, 195       ; JP
	ld    (#bdbd), a
	ld    (#bdbe), hl  ;HL - in handler
	ld    hl, #be00    
	ld    de, #be01
	ld    bc, 256      
	ld    (hl), #bd    
	ld    a, h         
	ldir               
	di                 
	ld    i, a         
	im    2            
	ret


start:
    di
    xor a : out (#fe), a
    ld hl, trackname : call BgMidi.init
    ld hl, intHandler : call im2On
    ei
    jp effect

;; Copy-pasted from some zx press :-)
effect:
    LD      hl,#c000
    LD      de,#c001
    LD      (hl),L
    LD      bc,768+32
    LDIR
flame          LD      ix,#c000+32
               LD      de,#c000   
               LD      bc,768     
begin          LD      a,(DE)     
               CP      (ix)       
               JR      nz,loop1   
               XOR     a          
loop1          ADD     a,(ix)     
               SRL     a          
               LD      (de),A     
               INC     ix         
               INC     de         
               DEC     bc         
               LD      a,B        
               OR      c          
               JR      nz,begin   

               HALT
               LD      hl,#c000   
               LD      de,#5800   
               LD      bc,768     
               LDIR      

               LD      de,#c000   
               LD      a,R        
               AND     %00011111  
               LD      h,A        
               LD      a,R        
               LD      l,A        
               LD      de,#c000+768
               LD      bc,32      
rnd            LD      a,R        
               OR      (hl)       
rang           AND     31         
               LD      (de),A     
               INC     hl         
               INC     de         
               DJNZ    rnd        
               JR      flame      




trackname db "test.nmf", 0
    savetap "nmftest.tap",#8000
    