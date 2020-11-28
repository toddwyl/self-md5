	.arch armv8-a
	.file	"no-kernel-arm.c"
	
	.align	2
	.global	_start
	.type	_start, %function
_start:
	mov	w0, 8961
	stp	x19, x30, [sp, -48]!
	movk	w0, 0x6745, lsl 16
	mov	w1, -128
	adrp	x12, .LANCHOR0
	adrp	x13, .LANCHOR1
	str	w0, [sp, 32]
	mov	w0, 43913
	movk	w0, 0xefcd, lsl 16
	add	x12, x12, :lo12:.LANCHOR0
	add	x13, x13, :lo12:.LANCHOR1
	mov	x11, 0
	str	w0, [sp, 36]
	mov	w0, 56574
	movk	w0, 0x98ba, lsl 16
	mov	w17, 7
	str	w0, [sp, 40]
	mov	w0, 21622
	movk	w0, 0x1032, lsl 16
	str	w0, [sp, 44]
	mov	x0, 888
	movk	x0, 0x40, lsl 16
	strb	w1, [x0]
	mov	x1, 7104
	ldp	w10, w9, [sp, 32]
	ldp	w8, w7, [sp, 40]
	str	x1, [x0, 64]
.L8:
	mov	w6, w7
	mov	w4, w8
	mov	w5, w9
	mov	w30, w10
	mov	w14, 5
	mov	w15, 1
	mov	x16, 0
	mov	w3, 0
.L7:
	lsr	w18, w3, 4
	cmp	w18, 2
	beq	.L3
	cmp	w18, 3
	beq	.L4
	cmp	w18, 1
	beq	.L5
	eor	w0, w4, w6
	mov	w2, w3
	and	w0, w0, w5
	eor	w0, w0, w6
	b	.L6
.L5:
	eor	w0, w5, w4
	and	w2, w15, 15
	and	w0, w0, w6
	eor	w0, w0, w4
	b	.L6
.L3:
	eor	w0, w5, w4
	and	w2, w14, 15
	eor	w0, w0, w6
	b	.L6
.L4:
	mul	w2, w3, w17
	orn	w0, w5, w6
	eor	w0, w0, w4
	and	w2, w2, 15
.L6:
	add	x2, x11, x2, uxtw 2
	ldr	w1, [x16, x12]
	add	x2, x2, 4194304
	add	x16, x16, 4
	add	w0, w0, w1
	add	w15, w15, 5
	add	w14, w14, 3
	ldr	w1, [x2]
	add	w30, w30, w1
	and	w1, w3, 3
	add	w3, w3, 1
	add	w0, w30, w0
	add	w18, w1, w18, lsl 2
	mov	w30, w6
	uxtb	w3, w3
	sxtw	x18, w18
	cmp	w3, 64
	ldrb	w1, [x13, x18]
	neg	w1, w1
	ror	w0, w0, w1
	add	w0, w0, w5
	beq	.L19
	mov	w6, w4
	mov	w4, w5
	mov	w5, w0
	b	.L7
.L19:
	add	x11, x11, 64
	add	w10, w6, w10
	cmp	x11, 960
	add	w9, w0, w9
	add	w8, w5, w8
	add	w7, w4, w7
	bne	.L8
	mov	w19, 0
	stp	w10, w9, [sp, 32]
	stp	w8, w7, [sp, 40]
.L12:
	sub	x1, sp, #4048
	ubfx	x0, x19, 1, 7
	add	x0, x1, x0
	tst	x19, 1
	cset	w1, eq
	ldrb	w0, [x0, 4080]
	lsl	w1, w1, 2
	asr	w0, w0, w1
	and	w0, w0, 15
	cmp	w0, 9
	add	w1, w0, 48
	bls	.L11
	add	w0, w0, 87
	uxtb	w1, w0
.L11:
	mov	x2, 1
	strb	w1, [sp, 31]
	mov	w0, w2
	add	x1, sp, 31
	add	w19, w19, 1
	mov     w8, #64
  svc     #0 
	uxtb	w19, w19
	cmp	w19, 32
	bne	.L12
	mov	w0, 0
	mov     x0, #0
  mov     w8, #93
  svc     #0 
	
	.global	ss
	.global	KK
	
	.align	3
.LANCHOR1 = . + 0
	.type	ss, %object
	
ss:
	.byte	7
	.byte	12
	.byte	17
	.byte	22
	.byte	5
	.byte	9
	.byte	14
	.byte	20
	.byte	4
	.byte	11
	.byte	16
	.byte	23
	.byte	6
	.byte	10
	.byte	15
	.byte	21
	.data
	.align	3
.LANCHOR0 = . + 0
	.type	KK, %object
	
KK:
	.word	-680876936
	.word	-389564586
	.word	606105819
	.word	-1044525330
	.word	-176418897
	.word	1200080426
	.word	-1473231341
	.word	-45705983
	.word	1770035416
	.word	-1958414417
	.word	-42063
	.word	-1990404162
	.word	1804603682
	.word	-40341101
	.word	-1502002290
	.word	1236535329
	.word	-165796510
	.word	-1069501632
	.word	643717713
	.word	-373897302
	.word	-701558691
	.word	38016083
	.word	-660478335
	.word	-405537848
	.word	568446438
	.word	-1019803690
	.word	-187363961
	.word	1163531501
	.word	-1444681467
	.word	-51403784
	.word	1735328473
	.word	-1926607734
	.word	-378558
	.word	-2022574463
	.word	1839030562
	.word	-35309556
	.word	-1530992060
	.word	1272893353
	.word	-155497632
	.word	-1094730640
	.word	681279174
	.word	-358537222
	.word	-722521979
	.word	76029189
	.word	-640364487
	.word	-421815835
	.word	530742520
	.word	-995338651
	.word	-198630844
	.word	1126891415
	.word	-1416354905
	.word	-57434055
	.word	1700485571
	.word	-1894986606
	.word	-1051523
	.word	-2054922799
	.word	1873313359
	.word	-30611744
	.word	-1560198380
	.word	1309151649
	.word	-145523070
	.word	-1120210379
	.word	718787259
	.word	-343485551
	
	
