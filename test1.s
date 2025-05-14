		AREA     RESET, CODE, READONLY
		ENTRY
		
		;#1
		LDR	r0, VALUE1 ;r0<-0x40000000
		LDR	r1, ZERO ;sum
		LDR r4, MAX;;until 9600 pixel
RCOUNT	LDRB r2, [r0], #1       
		CMP	 r2, #128
		ADDGE r1, r1, #1        
		ADD	 r0, r0, #3      
		SUBS r4, r4, #1
		BNE RCOUNT
		
		;#2
		LDR  r0, VALUE1;read address
		LDR	 r1, VALUE2;write address
		LDR r4, MAX
		
INV_IM  LDRB r2, [r0], #1
		RSB  r2, r2, #255 ; r2 = 255 - r2
		STRB r2, [r1], #1
		
		LDRB r2, [r0], #1
		RSB  r2, r2, #255 ; r2 = 255 - r2
		STRB r2, [r1], #1
		
		LDRB r2, [r0], #1
		RSB  r2, r2, #255 ; r2 = 255 - r2
		STRB r2, [r1], #1
		
		;A skip
		ADD  r0, r0, #1
		
		SUBS r4, r4, #1
		BNE  INV_IM
		
		;#3
		LDR  r0, VALUE1;read address
		LDR	 r1, VALUE2;write address
		LDR  r4, MAX
		;r8 IS SUM
		;LDR r8, #0
		;rgb =>r5 r6 r7
GRAY	LDRB r5, [r0], #1
		LDRB r6, [r0], #1
		LDRB r7, [r0], #1
		ADD  r4, r4, #1
		;3*r => r8
		LSL  r8, r5, #1 ; R * 2 -> r8
		ADD  r8, r8, r5 ;
		;6*g =>r9
		LSL r9, r6, #2; g*4
		LSL r6, r6, #1; g*2
		ADD r9, r9, r6; g*6
		;b => r7
		;sum gray
		ADD r8, r8, r9;
		ADD r8, r8, r7;
		
		;half byte store
		STRH r8, [r1], #2;
		SUBS r4, r4, #1
		BNE GRAY
		
		
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;assume that completed memory allocation 
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;#1
		;;not yet
		LDR	r0, VALUE1 ;r0<-0x40000000
		LDR	r1, ZERO ;sum
		LDR r3, ZERO
		LDR r4, MAX;;until 9600 pixel
RCOUNT2	LDR r2, [r0], #4   
SHIFT2	LSL r5, r2, r3
		ADD r3, r3, #8
		CMP	 r2, #128
		ADDGE r1, r1, #1  
		CMP  r3, #32
		BNE  SHIFT2
		SUBS r4, r4, #1
		BNE RCOUNT2
		
		;#2
		LDR  r0, VALUE1;read address
		LDR	 r1, VALUE1;write address
		LDR  r4, MAX
INV_IM2  LDRB r2, [r0], #1
		RSB  r2, r2, #255 ; r2 = 255 - r2
		STRB r2, [r1], #1
		
		LDRB r2, [r0], #1
		RSB  r2, r2, #255 ; r2 = 255 - r2
		STRB r2, [r1], #1
		
		LDRB r2, [r0], #1
		RSB  r2, r2, #255 ; r2 = 255 - r2
		STRB r2, [r1], #1
		
		;A skip
		ADD  r0, r0, #1
		
		SUBS r4, r4, #1
		BNE  INV_IM2
		
		;#3
GRAY2	LDR  r0, VALUE1;read address
		LDR	 r1, VALUE1;write address
		LDR  r4, MAX
		;r8 IS SUM
		;LDR r8, #0
		;rgb =>r5 r6 r7
		LDRB r5, [r0], #1
		LDRB r6, [r0], #1
		LDRB r7, [r0], #1
		ADD  r4, r4, #1
		;3*r => r8
		LSL  r8, r5, #1 ; R * 2 -> r8
		ADD  r8, r8, r5 ;
		;6*g =>r9
		LSL r9, r6, #2; g*4
		LSL r6, r6, #1; g*2
		ADD r9, r9, r6; g*6
		;b => r7
		;sum gray
		ADD r8, r8, r9;
		ADD r8, r8, r7;
		
		;half byte store
		STRH r8, [r1], #2;
		SUBS r4, r4, #1
		BNE GRAY2		
		
VALUE1  DCD &40000036
VALUE2 	DCD &50000000
MAX		DCD 9600 ;; originally 9600 but for debugging
ZERO	DCD 0
        END
