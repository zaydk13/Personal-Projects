$MODDE1SOC

ORG 0
	ljmp main

T_7seg:
	DB 40h, 79h, 24h, 30h, 19h, 12h, 02h, 78h
	db 00h, 10h, 08h, 03h, 46h, 21h, 06h, 0eh

;Converts the hex number in R0-R1 to BCD
;in R2-R3-R4
hex2bcd:
    mov R2, #0  ;Set BCD result to 00000 
    mov R3, #0
    mov R4, #0
    mov R5, #16 ;Loop counter.
L0:
    mov a, R1 ;Shift R0-R1 left through carry
    rlc a
    mov R1, a
    mov a, R0
    rlc a
    mov R0, a
    
	; Perform bcd + bcd + carry
	; using BCD numbers
	mov a, R4
	addc a, R4
	da a
	mov R4, a
	mov a, R3
	addc a, R3
	da a
	mov R3, a
	mov a, R2
	addc a, R2
	mov R2, a
	djnz R5, L0
	ret

; This subroutine display the hex number passed in
; register r0
Display_Byte_01:
	mov a, R0
	anl a, #00001111b	
	movc a, @a+dptr
	mov hex0, a
	
	mov a, R0
	anl a, #11110000b ; same as anl a, #0xf0
	swap a
	movc a, @a+dptr
	mov hex1, a

	ret

Display_Byte_23:
	mov a, R0
	anl a, #00001111b	
	movc a, @a+dptr
	mov hex2, a
	
	mov a, R0
	anl a, #11110000b ; same as anl a, #0xf0
	swap a
	movc a, @a+dptr
	mov hex3, a

	ret
	
Display_Byte_45:
	mov a, R0
	anl a, #00001111b	
	movc a, @a+dptr
	mov hex4, a
	
	mov a, R0
	anl a, #11110000b ; same as anl a, #0xf0
	swap a
	movc a, @a+dptr
	mov hex5, a

	ret

main:
	mov sp, #7fH ; Trust me bro for now!
	
	mov dptr, #T_7seg

	; Load to [R0,R1]
	mov R0, #0x5
	mov R1, #0x12
	
	; Convert to bcd
	lcall hex2bcd
	
	mov a, R2
	mov R0, a
	lcall Display_Byte_45

	mov a, R3
	mov R0, a
	lcall Display_Byte_23

	mov a, R4
	mov R0, a
	lcall Display_Byte_01
	
forever:
	sjmp forever	


end