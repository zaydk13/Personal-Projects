$MODDE0CV

org  0000H
	ljmp myprogram
	
; For a 33.33MHz clock, one machine cycles takes 30ns

WaitHalfSec:
	mov R2, #90
L3: mov R1, #250
L2: mov R0, #250
L1: djnz R0, L1 ; 3 machine cycles-> 3*30ns*250=22.5us
	djnz R1, L2 ; 22.5us*250=5.625ms
	djnz R2, L3 ; 5.625ms*90=0.506s (approx)
	ret
	
task0: ; Assigning first 6 digs of student# to hex displays	
	
	mov HEX5, #0H
	mov HEX4, #79H
	mov HEX3, #19H
	mov HEX2, #40H
	mov HEX1, #12H
	mov HEX0, #40H
	
	sjmp task0
	
	ret
	
task1: ; Assigning last 2 digs  of student# to hex diplays

	mov HEX5, #0FFH
	mov HEX4, #0FFH
	mov HEX3, #0FFH
	mov HEX2, #0FFH
	mov HEX1, #0H
	mov HEX0, #2H
	
	sjmp task1
	
	ret

task2: ; Scrolling left through student#

	mov HEX5, #0H
	mov HEX4, #79H
	mov HEX3, #19H
	mov HEX2, #40H
	mov HEX1, #12H
	mov HEX0, #40H
	mov X, #0H
	mov Y, #2H
	
	lcall WaitHalfSec
	lcall WaitHalfSec

	top2:
	
	mov switch, SWA
	jb switch.3, scrollFast2
	
	scrollSlow2:
	mov R3, X
	mov X, Y
	mov Y, HEX5
	mov HEX5, HEX4
	mov HEX4, HEX3
	mov HEX3, HEX2
	mov HEX2, HEX1
	mov HEX1, HEX0
	mov HEX0, R3
	
	lcall WaitHalfSec
	lcall WaitHalfSec
	sjmp top2
	
	scrollFast2:
	mov R3, X
	mov X, Y
	mov Y, HEX5
	mov HEX5, HEX4
	mov HEX4, HEX3
	mov HEX3, HEX2
	mov HEX2, HEX1
	mov HEX1, HEX0
	mov HEX0, R3
	
	lcall WaitHalfSec
	sjmp top2
	
	ret
	
task3: ; Scrolling right through student#
	
	mov HEX5, #0H
	mov HEX4, #79H
	mov HEX3, #19H
	mov HEX2, #40H
	mov HEX1, #12H
	mov HEX0, #40H
	mov Y, #0H
	mov X, #2H
	
	lcall WaitHalfSec
	lcall WaitHalfSec

	top3:
	
	mov switch, SWA
	jb switch.3, scrollFast3
	
	scrollSlow3:
	mov R3, X
	mov X, Y
	mov Y, HEX0
	mov HEX0, HEX1
	mov HEX1, HEX2
	mov HEX2, HEX3
	mov HEX3, HEX4
	mov HEX4, HEX5
	mov HEX5, R3
	
	lcall WaitHalfSec
	lcall WaitHalfSec
	sjmp top3
	
	scrollFast3:
	mov R3, X
	mov X, Y
	mov Y, HEX0
	mov HEX0, HEX1
	mov HEX1, HEX2
	mov HEX2, HEX3
	mov HEX3, HEX4
	mov HEX4, HEX5
	mov HEX5, R3
	
	lcall WaitHalfSec
	sjmp top3
	
	ret
	

task4:

	jb SWA.3, blinkFast 
	
	blinkSlow:
	mov HEX5, #19H
	mov HEX4, #40H
	mov HEX3, #12H
	mov HEX2, #40H
	mov HEX1, #0H
	mov HEX0, #2H
	
	lcall WaitHalfSec
	lcall WaitHalfSec
	
	mov HEX5, #0FFH
	mov HEX4, #0FFH
	mov HEX3, #0FFH
	mov HEX2, #0FFH
	mov HEX1, #0FFH
	mov HEX0, #0FFH
	
	lcall WaitHalfSec
	lcall WaitHalfSec
	
	sjmp task4
	
	blinkFast:
	mov HEX5, #19H
	mov HEX4, #40H
	mov HEX3, #12H
	mov HEX2, #40H
	mov HEX1, #0H
	mov HEX0, #2H
	
	lcall WaitHalfSec
	
	mov HEX5, #0FFH
	mov HEX4, #0FFH
	mov HEX3, #0FFH
	mov HEX2, #0FFH
	mov HEX1, #0FFH
	mov HEX0, #0FFH
	
	lcall WaitHalfSec
	
	sjmp task4
	
	ret
	
task5:
	
	mov HEX5, #0FFH
	mov HEX4, #0FFH
	mov HEX3, #0FFH
	mov HEX2, #0FFH
	mov HEX1, #0FFH
	mov HEX0, #0FFH
	
	jb SWA.3, ScrollFast5
	
	lcall WaitHalfSec
	lcall WaitHalfSec
	mov HEX5, #0H
	lcall WaitHalfSec
	lcall WaitHalfSec
	mov HEX4, #79H
	lcall WaitHalfSec
	lcall WaitHalfSec
	mov HEX3, #19H
	lcall WaitHalfSec
	lcall WaitHalfSec
	mov HEX2, #40H
	lcall WaitHalfSec
	lcall WaitHalfSec
	mov HEX1, #12H
	lcall WaitHalfSec
	lcall WaitHalfSec
	mov HEX0, #40H
	lcall WaitHalfSec
	lcall WaitHalfSec
	
	sjmp task5
	
	ScrollFast5:
	
	lcall WaitHalfSec
	mov HEX5, #0H
	lcall WaitHalfSec
	mov HEX4, #79H
	lcall WaitHalfSec
	mov HEX3, #19H
	lcall WaitHalfSec
	mov HEX2, #40H
	lcall WaitHalfSec
	mov HEX1, #12H
	lcall WaitHalfSec
	mov HEX0, #40H
	lcall WaitHalfSec
	
	sjmp task5
	
	ret

task6:

	jb SWA.3, fast
	
	mov HEX5, #9H
	mov HEX4, #6H
	mov HEX3, #47H
	mov HEX2, #47H
	mov HEX1, #40H
	mov HEX0, #0FFH
	
	lcall WaitHalfSec
	lcall WaitHalfSec
	
	mov HEX5, #0H
	mov HEX4, #79H
	mov HEX3, #19H
	mov HEX2, #40H
	mov HEX1, #12H
	mov HEX0, #40H
	
	lcall WaitHalfSec
	lcall WaitHalfSec
	
	mov HEX5, #46H
	mov HEX4, #0CH
	mov HEX3, #48H
	mov HEX2, #30H
	mov HEX1, #79H
	mov HEX0, #24H
	
	lcall WaitHalfSec
	lcall WaitHalfSec
	
	sjmp task6
	
	fast:
	
	mov HEX5, #9H
	mov HEX4, #6H
	mov HEX3, #47H
	mov HEX2, #47H
	mov HEX1, #40H
	mov HEX0, #0FFH

	lcall WaitHalfSec
	
	mov HEX5, #0H
	mov HEX4, #79H
	mov HEX3, #19H
	mov HEX2, #40H
	mov HEX1, #12H
	mov HEX0, #40H

	lcall WaitHalfSec
	
	mov HEX5, #46H
	mov HEX4, #0CH
	mov HEX3, #48H
	mov HEX2, #30H
	mov HEX1, #79H
	mov HEX0, #24H

	lcall WaitHalfSec
	
	ljmp task6
	ret

task7:

	mov Q, #0H
	mov W, #79H
	mov E, #19H
	mov R, #40H
	mov T, #12H
	mov S, #40H
	
	top7:
	
	mov HEX5, Q
	mov HEX4, W
	mov HEX3, E
	mov HEX2, R
	mov HEX1, T
	mov HEX0, S
	
	lcall WaitHalfSec
	lcall WaitHalfSec
	
	mov A, Q
	cpl A
	mov Q, A
	mov A, W
	cpl A
	mov W, A
	mov A, E
	cpl A
	mov E, A
	mov A, R
	cpl A
	mov R, A
	mov A, T
	cpl A
	mov T, A
	mov A, S
	cpl A
	mov S, A
	
	sjmp top7
	
	ret

myprogram:
	mov SP, #7FH ; Set the beginninng of the stack
	mov LEDRA, #0 ; Turn off all unused LEDs
	mov LEDRB, #0
	
	ON equ 1
	;stuNum equ 81405086
	
	DSEG at 20H
	switch: DS 1
	X: DS 1
	Y: DS 1
	Q: DS 1
	W: DS 1
	E: DS 1
	R: DS 1
	T: DS 1
	S: DS 1
	CSEG
	
loop:
	
	mov HEX5, #0H
	mov HEX4, #79H
	mov HEX3, #19H
	mov HEX2, #40H
	mov HEX1, #12H
	mov HEX0, #40H
	mov R4, #0H
	mov R5, #2H	
	
	mov R0, SWA
	jb KEY.3, loop
	;jump if KEY3 is low
		
	;jumps to each task
	jb SWA.0, stateXX1
	jb SWA.1, stateX10
	jb SWA.2, state100
	
	lcall task0
	sjmp loop
	
	stateXX1:
	
	jb SWA.1, stateX11
	
	jb SWA.2, state101
	
	lcall task1
	sjmp loop
		
		stateX11:
	
		jb SWA.2, state111
		
		lcall task3
		sjmp loop
				
			state111:
			
			lcall task7
			sjmp loop
		
		state101:
		
		lcall task5
		sjmp loop
	
	stateX10:
	
		jb SWA.2, state110
		
		lcall task2
		sjmp loop
		
		state110:
		
		lcall task6
		sjmp loop
		
	state100:
	
	lcall task4
	sjmp loop

end