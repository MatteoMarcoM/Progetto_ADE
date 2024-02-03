; ricerca del massimo in un array di numeri e media dei valori versione 4
; loop unrolling

	.data
a:	.double 4.3, 2.1, 5.7, 8.4, 9.0, 2.7, 8.4
n:	.word 6				; contatore dim-1, il primo elemento è il max, mancano 6 confronti (dim=7)

	.text
start:
	LW r1, n(r0)		; carica il numero di elementi dell'array -1 in r1 (r0 == 0) 
	DADDI r2, r0, a 	; carica in r2 il puntatore al primo elemento dell'array 
	L.D f0, 0(r2)		; carica in f0 il valore di a[0] == max
	
	DADDI r1, r1, 1			; salva per la divisione finale (media) la dimensione dell'array
	MOV.D f2, f0		; sposta a[0] in f2 per la somma di tutti i valori
	MTC1 r1, f3				; sposta il contenuto (dim array) di r1 (INT reg) in f3 (FP reg)
	CVT.D.L f3, f3		; (NB divisione) converti f3 (Long INT) in un Double FP e mettilo in f3
	
l0:
	L.D f1, 8(r2)		; carica in f1 il valore di a[1] indirizzato da r2 + 8
	DADDI r2, r2, 8		; i += 8 -> r2 contiene l'indirizzo di a[i+1]	
	MFC1 r3, f0			; sposta il contenuto di f0 (FP reg)in r3 (INT reg)
	MFC1 r4, f1			; sposta il contenuto di f1 in r4
						; altrimenti errore nell'istruzione BEQ
	SLT r5, r4, r3		; r5 = 1 se r4==f1 < f0==r3 = max altrimenti r5 = 0
						; se r5 = 0 allora r4==f1 > max quindi lo salvo
	ADD.D f2, f2, f1	; carica in f2 la somma di tutti i valori fino all'i-esimo
	BEQ r3, r4, l1			; se sono uguali vai avanti nell'array
	BEQZ r5, save0			; salva il nuovo max = f1==r4 se r5 = 0		
	J l1					; iterazione successiva
	
save0:
	MOV.D f0, f1		; sovrascrivi (sposta) f0 (max) con f1 (nuovo max) 

l1:
	L.D f1, 8(r2)		; carica in f1 il valore di a[1] indirizzato da r2 + 8
	DADDI r2, r2, 8		; i += 8 -> r2 contiene l'indirizzo di a[i+1]
	MFC1 r3, f0			; sposta il contenuto di f0 (FP reg)in r3 (INT reg)
	MFC1 r4, f1			; sposta il contenuto di f1 in r4
						; altrimenti errore nell'istruzione BEQ
	SLT r5, r4, r3		; r5 = 1 se r4==f1 < f0==r3 = max altrimenti r5 = 0
						; se r5 = 0 allora r4==f1 > max quindi lo salvo
	ADD.D f2, f2, f1	; carica in f2 la somma di tutti i valori fino all'i-esimo
	BEQ r3, r4, l2			; se sono uguali vai avanti nell'array
	BEQZ r5, save1			; salva il nuovo max = f1==r4 se r5 = 0		
	J l2					; iterazione successiva
	
save1:
	MOV.D f0, f1		; sovrascrivi (sposta) f0 (max) con f1 (nuovo max) 
	
l2:
	L.D f1, 8(r2)		; carica in f1 il valore di a[1] indirizzato da r2 + 8
	DADDI r2, r2, 8		; i += 8 -> r2 contiene l'indirizzo di a[i+1]
	MFC1 r3, f0			; sposta il contenuto di f0 (FP reg)in r3 (INT reg)
	MFC1 r4, f1			; sposta il contenuto di f1 in r4
						; altrimenti errore nell'istruzione BEQ
	SLT r5, r4, r3		; r5 = 1 se r4==f1 < f0==r3 = max altrimenti r5 = 0
						; se r5 = 0 allora r4==f1 > max quindi lo salvo
	ADD.D f2, f2, f1	; carica in f2 la somma di tutti i valori fino all'i-esimo
	BEQ r3, r4, l3			; se sono uguali vai avanti nell'array
	BEQZ r5, save2			; salva il nuovo max = f1==r4 se r5 = 0		
	J l3					; iterazione successiva
	
save2:
	MOV.D f0, f1		; sovrascrivi (sposta) f0 (max) con f1 (nuovo max) 

l3:
	L.D f1, 8(r2)		; carica in f1 il valore di a[1] indirizzato da r2 + 8
	DADDI r2, r2, 8		; i += 8 -> r2 contiene l'indirizzo di a[i+1]
	MFC1 r3, f0			; sposta il contenuto di f0 (FP reg)in r3 (INT reg)
	MFC1 r4, f1			; sposta il contenuto di f1 in r4
						; altrimenti errore nell'istruzione BEQ
	SLT r5, r4, r3		; r5 = 1 se r4==f1 < f0==r3 = max altrimenti r5 = 0
						; se r5 = 0 allora r4==f1 > max quindi lo salvo
	ADD.D f2, f2, f1	; carica in f2 la somma di tutti i valori fino all'i-esimo
	BEQ r3, r4, l4			; se sono uguali vai avanti nell'array
	BEQZ r5, save3			; salva il nuovo max = f1==r4 se r5 = 0		
	J l4					; iterazione successiva
	
save3:
	MOV.D f0, f1		; sovrascrivi (sposta) f0 (max) con f1 (nuovo max) 

l4:
	L.D f1, 8(r2)		; carica in f1 il valore di a[1] indirizzato da r2 + 8
	DADDI r2, r2, 8		; i += 8 -> r2 contiene l'indirizzo di a[i+1]
	MFC1 r3, f0			; sposta il contenuto di f0 (FP reg)in r3 (INT reg)
	MFC1 r4, f1			; sposta il contenuto di f1 in r4
						; altrimenti errore nell'istruzione BEQ
	SLT r5, r4, r3		; r5 = 1 se r4==f1 < f0==r3 = max altrimenti r5 = 0
						; se r5 = 0 allora r4==f1 > max quindi lo salvo
	ADD.D f2, f2, f1	; carica in f2 la somma di tutti i valori fino all'i-esimo
	BEQ r3, r4, l5			; se sono uguali vai avanti nell'array
	BEQZ r5, save4			; salva il nuovo max = f1==r4 se r5 = 0		
	J l5					; iterazione successiva
	
save4:
	MOV.D f0, f1		; sovrascrivi (sposta) f0 (max) con f1 (nuovo max) 
	
l5:
	L.D f1, 8(r2)		; carica in f1 il valore di a[1] indirizzato da r2 + 8
	DADDI r2, r2, 8		; i += 8 -> r2 contiene l'indirizzo di a[i+1]
	MFC1 r3, f0			; sposta il contenuto di f0 (FP reg)in r3 (INT reg)
	MFC1 r4, f1			; sposta il contenuto di f1 in r4
						; altrimenti errore nell'istruzione BEQ
	SLT r5, r4, r3		; r5 = 1 se r4==f1 < f0==r3 = max altrimenti r5 = 0
						; se r5 = 0 allora r4==f1 > max quindi lo salvo
	ADD.D f2, f2, f1	; carica in f2 la somma di tutti i valori fino all'i-esimo
	BEQ r3, r4, l6			; se sono uguali vai avanti nell'array
	BEQZ r5, save5			; salva il nuovo max = f1==r4 se r5 = 0		
	J l6					; fine iterazione
	
save5:
	MOV.D f0, f1		; sovrascrivi (sposta) f0 (max) con f1 (nuovo max) 
	
l6:	
	DIV.D f2, f2, f3	; dividi la somma di tutti i valori per il numero di valori
	HALT				; la media aritmetica è in f2
	
	