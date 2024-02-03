; ricerca del massimo in un array di numeri e media dei valori versione 6
; loop unrolling e register renaming

	.data
a:	.double 4.3, 2.1, 5.7, 8.4, 9.0, 2.7, 8.4
n:	.word 6				; contatore dim-1, il primo elemento è il max, mancano 6 confronti (dim=7)

	.text
start:
	LW r1, n(r0)		; carica il numero di elementi dell'array -1 in r1 (r0 == 0) 
	DADDI r2, r0, a 	; carica in r2 il puntatore al primo elemento dell'array 
	
	L.D f0, 0(r2)		; carica in f0 il valore di a[0] == max
	L.D f1, 8(r2)		; carica in f1 il valore di a[1] 
	L.D f2, 16(r2)		; carica in f2 il valore di a[2] 
	L.D f3, 24(r2)		; carica in f3 il valore di a[3] 
	L.D f4, 32(r2)		; carica in f4 il valore di a[4] 
	L.D f5, 40(r2)		; carica in f5 il valore di a[5] 
	L.D f6, 48(r2)		; carica in f6 il valore di a[6]
	
	ADD.D f9, f1, f0		; NB somma FP latenza 3
	ADD.D f10, f3, f2		
	ADD.D f11, f5, f4		
	ADD.D f12, f9, f6		
	ADD.D f13, f11, f10		; somma tutti valori tranne f12 = f1+f0+f6
	
	DADDI r1, r1, 1		; salva per la divisione finale (media) la dimensione dell'array
	MTC1 r1, f8			; sposta il contenuto (dim array) di r1 (INT reg) in f8 (FP reg)
	CVT.D.L f8, f8		; (NB divisione) converti f8 (Long INT) in un Double FP e mettilo in f8
	
	ADD.D f13, f13, f12		; carica in f13 la somma di tutti i valori	
	
	DIV.D f13, f13, f8		; dividi la somma di tutti i valori per il numero di valori
							; la media è in f13						

; analogo alla versione precedente senza ADD.D
l0:
	MFC1 r3, f0			; all'inizio max == f0
	MFC1 r4, f1			; sposta il contenuto di f1 in r4
	SLT r5, r4, r3		; r5 = 1 se r4==f1 < f0==r3 = max altrimenti r5 = 0
						; se r5 = 0 allora r4==f1 > max quindi lo salvo
	BEQ r3, r4, l1		; se sono uguali vai avanti nell'array (loop)
	BEQZ r5, save0		; salva il nuovo max = f1==r4 se r5 = 0
	
	J l1				; esci ciclo
	
save0:
	MOV.D f0, f1		; sovrascrivi (sposta) f0 (max) con f1 (nuovo max)

l1:
	MFC1 r3, f0			; il massimo attuale è in f14
	MFC1 r4, f2			; sposta il contenuto di f1 in r4
	SLT r5, r4, r3		; r5 = 1 se r4==f1 < f0==r3 = max altrimenti r5 = 0
						; se r5 = 0 allora r4==f1 > max quindi lo salvo
	BEQ r3, r4, l2		; se sono uguali vai avanti nell'array (loop)
	BEQZ r5, save1		; salva il nuovo max = f1==r4 se r5 = 0		
	J l2				; esci ciclo
	
save1:
	MOV.D f0, f2		; sovrascrivi (sposta) f0 (max) con f2 (nuovo max) 
	
l2:
	MFC1 r3, f0			; sposta il contenuto di f0 (FP reg)in r3 (INT reg)
	MFC1 r4, f3			; sposta il contenuto di f1 in r4
	SLT r5, r4, r3		; r5 = 1 se r4==f1 < f0==r3 = max altrimenti r5 = 0
						; se r5 = 0 allora r4==f1 > max quindi lo salvo
	BEQ r3, r4, l3		; se sono uguali vai avanti nell'array (loop)
	BEQZ r5, save2		; salva il nuovo max = f1==r4 se r5 = 0		
	J l3				; esci ciclo
	
save2:
	MOV.D f0, f3		; sovrascrivi (sposta) f0 (max) con f3 (nuovo max) 

l3:
	MFC1 r3, f0			; sposta il contenuto di f0 (FP reg)in r3 (INT reg)
	MFC1 r4, f4			; sposta il contenuto di f1 in r4
	SLT r5, r4, r3		; r5 = 1 se r4==f1 < f0==r3 = max altrimenti r5 = 0
						; se r5 = 0 allora r4==f1 > max quindi lo salvo
	BEQ r3, r4, l4		; se sono uguali vai avanti nell'array (loop)
	BEQZ r5, save3		; salva il nuovo max = f1==r4 se r5 = 0		
	J l4				; esci ciclo
	
save3:
	MOV.D f0, f4		; sovrascrivi (sposta) f0 (max) con f4 (nuovo max) 

l4:
	MFC1 r3, f0			; sposta il contenuto di f0 (FP reg)in r3 (INT reg)
	MFC1 r4, f5			; sposta il contenuto di f1 in r4
	SLT r5, r4, r3		; r5 = 1 se r4==f1 < f0==r3 = max altrimenti r5 = 0
						; se r5 = 0 allora r4==f1 > max quindi lo salvo
	BEQ r3, r4, l5		; se sono uguali vai avanti nell'array (loop)
	BEQZ r5, save4		; salva il nuovo max = f1==r4 se r5 = 0		
	J l5				; esci ciclo
	
save4:
	MOV.D f0, f5		; sovrascrivi (sposta) f0 (max) con f5 (nuovo max) 
	
l5:
	MFC1 r3, f0			; sposta il contenuto di f0 (FP reg)in r3 (INT reg)
	MFC1 r4, f6			; sposta il contenuto di f1 in r4
	SLT r5, r4, r3		; r5 = 1 se r4==f1 < f0==r3 = max altrimenti r5 = 0
						; se r5 = 0 allora r4==f1 > max quindi lo salvo
	BEQ r3, r4, l6		; se sono uguali vai avanti nell'array (loop)
	BEQZ r5, save5		; salva il nuovo max = f1==r4 se r5 = 0		
	HALT
	
save5:
	MOV.D f0, f6		; sovrascrivi (sposta) f0 (max) con f6 (nuovo max) 
l6:	
	HALT				
	
	