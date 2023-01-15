;hello.asm
;  turns on an LED which is connected to PB5 (digital out 13)

.INCLUDE "./m328Pdef.inc"

.cseg
.org 0x00

.org 0x0016
	jmp TIM1_COMPA

Setup:
	ldi r16, high(RAMEND)
	out SPH, r16
	ldi r16, low(RAMEND)
	out SPL, r16

	; Enable change of Interrupt Vectors
	ldi r16, (1<<IVCE)
	out MCUCR, r16
	; Move interrupts to Boot Flash section
	ldi r16, (1<<IVSEL)
	out MCUCR, r16

	sbi DDRB, DDB5
	cbi PORTB, PB5

	clr r16
	sbr r16, (1<<WGM12) + (1<<CS12) + (1<<CS10)
	sts TCCR1B, r16

	clr r16
	sbr r16, (1<<OCIE1A)
	sts TIMSK1, r16

	clr r16

	ldi r16, 0x09
	ldi r17, 0x3D

	sts OCR1AH, r17
	sts OCR1AL, r16
	
	clr r16
	clr r17

	sei

	rjmp Start


TIM1_COMPA:
	ldi r16, 0x20
	in r17, PINB
	eor r17, r16
	out PORTB, r17

	clr r16
	clr r17

	reti

Start:
	rjmp Start


