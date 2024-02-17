$modde1soc

CSEG at 0
	ljmp mycode

dseg at 30h
	x: ds 4 ; 32-bits for variable ‘x’
	y: ds 4 ; 32-bits for variable ‘y’
	dummy: ds 4 ; 32-bits for operations
	counter: ds 4 ; 32-bits to use in sqrt operation
	bcd: ds 5 ; 10-digit packed BCD (each byte stores 2 digits)

bseg
	mf: dbit 1 ; Math functions flag
	
$include(math32.asm)

	CSEG

; Look-up table for 7-seg displays
myLUT:
    DB 0C0H, 0F9H, 0A4H, 0B0H, 099H        ; 0 TO 4
    DB 092H, 082H, 0F8H, 080H, 090H        ; 4 TO 9

showBCD MAC
	; Display LSD
    mov A, %0
    anl a, #0fh
    movc A, @A+dptr
    mov %1, A
	; Display MSD
    mov A, %0
    swap a
    anl a, #0fh
    movc A, @A+dptr
    mov %2, A
ENDMAC

Display:
	mov dptr, #myLUT
	showBCD(bcd+0, HEX0, HEX1)
	showBCD(bcd+1, HEX2, HEX3)
	showBCD(bcd+2, HEX4, HEX5)
    ret

MYRLC MAC
	mov a, %0
	rlc a
	mov %0, a
ENDMAC

Shift_Digits:
	mov R0, #4 ; shift left four bits
Shift_Digits_L0:
	clr c
	MYRLC(bcd+0)
	MYRLC(bcd+1)
	MYRLC(bcd+2)
	MYRLC(bcd+3)
	MYRLC(bcd+4)
	djnz R0, Shift_Digits_L0
	; R7 has the new bcd digit	
	mov a, R7
	orl a, bcd+0
	mov bcd+0, a
	; bcd+3 and bcd+4 don't fit in the 7-segment displays so make them zero
	clr a
	mov bcd+4, a
	ret

Wait50ms:
;33.33MHz, 1 clk per cycle: 0.03us
	mov R0, #30
L3: mov R1, #74
L2: mov R2, #250
L1: djnz R2, L1 ;3*250*0.03us=22.5us
    djnz R1, L2 ;74*22.5us=1.665ms
    djnz R0, L3 ;1.665ms*30=50ms
    ret

; Check if SW0 to SW9 are toggled up.  Returns the toggled switch in
; R7.  If the carry is not set, no toggling switches were detected.
ReadNumber:
	mov r4, SWA ; Read switches 0 to 7
	mov a, SWB ; Read switches 8 to 9
	anl a, #00000011B ; Only two bits of SWB available
	mov r5, a
	mov a, r4
	orl a, r5
	jz ReadNumber_no_number
	lcall Wait50ms ; debounce
	mov a, SWA
	clr c
	subb a, r4
	jnz ReadNumber_no_number ; it was a bounce
	mov a, SWB
	anl a, #00000011B
	clr c
	subb a, r5
	jnz ReadNumber_no_number ; it was a bounce
	mov r7, #16 ; Loop counter
ReadNumber_L0:
	clr c
	mov a, r4
	rlc a
	mov r4, a
	mov a, r5
	rlc a
	mov r5, a
	jc ReadNumber_decode
	djnz r7, ReadNumber_L0
	sjmp ReadNumber_no_number	
ReadNumber_decode:
	dec r7
	setb c
ReadNumber_L1:
	mov a, SWA
	jnz ReadNumber_L1
ReadNumber_L2:
	mov a, SWB
	jnz ReadNumber_L2
	ret
ReadNumber_no_number:
	clr c
	ret
	
LEDshow:

	mov a, b
	cjne a, #0, F1
	mov LEDRA, #00000001B
F1: cjne a, #1, F2
	mov LEDRA, #00000010B
F2: cjne a, #2, F3
	mov LEDRA, #00000100B
F3: cjne a, #3, F4
	mov LEDRA, #00001000B
F4: cjne a, #4, F5
	mov LEDRA, #00010000B
F5: cjne a, #5, F6
	mov LEDRA, #00100000B
F6: cjne a, #6, F7
	mov LEDRA, #01000000B
F7:
	ret
	
	
mycode:
	mov SP, #7FH
	clr a
	mov LEDRA, a
	mov LEDRB, a
	mov bcd+0, a
	mov bcd+1, a
	mov bcd+2, a
	mov bcd+3, a
	mov bcd+4, a
	lcall Display

forever:
; This is a good spot to set the LEDs for each operation...
	acall LEDshow
	jb KEY.3, no_funct  ; If 'Function' key not pressed, skip
	jnb KEY.3, $		; Wait for release of 'Function' key
	inc b 				; 'b' is used as function select
	mov a, b			; make sure b is not larger than 6
	cjne a, #7, forever ; ^
	mov b, #0			; ^
	ljmp forever 		; Go check for more input
no_funct:
	jb KEY.2, no_load   ; If 'Load' key not pressed, skip
	jnb KEY.2, $ 		; Wait for user to release 'Load' key
	lcall bcd2hex 		; Convert the BCD number to hex in x
	lcall copy_xy 		; Copy x to y
	Load_X(0)			; Clear x (this is a macro)
	lcall hex2bcd 		; Convert result in x to BCD
	lcall Display 		; Display the new BCD number
	ljmp forever 		; Go check for more input
no_load:
	jb KEY.1, no_equal  ; If 'equal' key not pressed, skip
	jnb KEY.1, $ 		; Wait for user to release 'equal' key
	lcall bcd2hex 		; Convert the BCD number to hex in x
	mov a, b 			; Check if we are doing addition
	cjne a, #0, no_add  ; ^
	lcall add32 		; Perform x+y
no_add:
	cjne a, #1, no_sub
	;lcall xchg_xy
	lcall sub32
no_sub:
	cjne a, #2, no_mul
	lcall mul32
no_mul:
	cjne a, #3, no_div
	;lcall xchg_xy
	lcall div32
no_div:
	cjne a, #4, no_mod
	modLoop:
	lcall sub32
	lcall x_gt_y
	jb mf, modLoop
	;lcall add32
no_mod:
	cjne a, #5, no_perc
	;lcall xchg_xy
	lcall mul32
	mov y+0, #100
	mov y+1, #0
	mov y+2, #0
	mov y+3, #0
	lcall div32
no_perc:
	cjne a, #6, next
	mov dummy, y
	mov counter+0, #0
	mov counter+1, #0
	mov counter+2, #0
	mov counter+3, #0
	sqrtLoop:
	inc counter
	mov x, counter
	mov y, x
	lcall mul32
	mov y, dummy
	lcall x_lteq_y
	jb mf, sqrtLoop
	dec counter
	mov x, counter
	
next:
	lcall hex2bcd 		; Convert result in x to BCD
	lcall Display 		; Display the new BCD number
	ljmp forever 		; Go check for more input
no_equal:
; get more numbers
	lcall ReadNumber
	jnc no_new_digit 	; Indirect jump to 'forever'
	lcall Shift_Digits
	lcall Display
	no_new_digit:
	ljmp forever 		; 'forever' is to far away, need to use ljmp

end
