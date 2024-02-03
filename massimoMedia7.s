; ricerca del massimo in un array di numeri e media dei valori versione 7
; loop unrolling parziale passo 2

	.data
a:	.double 4.3, 2.1, 5.7, 8.4, 9.0, 2.7, 8.4
n:	.word 6				; contatore dim-1, il primo elemento è il max, mancano 6 confronti (dim=7)

	.text
start:
	LW r1, n(r0)		; carica il numero di elementi dell'array -1 in r1 (r0 == 0) 
	DADDI r2, r0, a 	; carica in r2 il puntatore al primo elemento dell'array 
	L.D f0, 0(r2)		; carica in f0 il valore di a[0] == max
	DADDI r6, r1, 1		; salva per la divisione finale (media) la dimensione dell'array
	MOV.D f2, f0		; sposta a[0] in f2 per la somma di tutti i valori
	MTC1 r6, f3			; sposta il contenuto (dim array) di r6 (INT reg) in f3 (FP reg)
	CVT.D.L f3, f3		; (NB divisione) converti f3 (Long INT) in un Double FP e mettilo in f3
							
loop0:
	SLTI r6, r1, 2			; se mancano meno di due elementi allora r6 = 1 altrimenti r6 = 0
	BEQZ r1, end			; esci se il contatore è 0 (NB ultimi due elementi uguali)
	BNEZ r6, exit			; r6 == 1 allora ultimo loop "a mano"
	
	L.D f1, 8(r2)		; carica in f1 il valore di a[1] indirizzato da r2 + 8
	DADDI r2, r2, 8		; i += 8 -> r2 contiene l'indirizzo di a[i+1]
	DADDI r1, r1, -1	; decrementa contatore ciclo	
	MFC1 r3, f0			; sposta il contenuto di f0 (FP reg)in r3 (INT reg)
	MFC1 r4, f1			; sposta il contenuto di f1 in r4
						; altrimenti errore nell'istruzione BEQ
	SLT r5, r4, r3		; r5 = 1 se r4==f1 < f0==r3 = max altrimenti r5 = 0
						; se r5 = 0 allora r4==f1 > max quindi lo salvo
	ADD.D f2, f2, f1	; carica in f2 la somma di tutti i valori fino all'i-esimo
	BEQ r3, r4, loop1		; se sono uguali vai avanti nell'array (loop)
	BEQZ r5, save0			; salva il nuovo max = f1==r4 se r5 = 0

loop1:
	L.D f1, 8(r2)		; carica in f1 il valore di a[1] indirizzato da r2 + 8
	DADDI r2, r2, 8		; i += 8 -> r2 contiene l'indirizzo di a[i+1]
	DADDI r1, r1, -1	; decrementa contatore ciclo	
	MFC1 r3, f0			; sposta il contenuto di f0 (FP reg)in r3 (INT reg)
	MFC1 r4, f1			; sposta il contenuto di f1 in r4
						; altrimenti errore nell'istruzione BEQ
	SLT r5, r4, r3		; r5 = 1 se r4==f1 < f0==r3 = max altrimenti r5 = 0
						; se r5 = 0 allora r4==f1 > max quindi lo salvo
	ADD.D f2, f2, f1	; carica in f2 la somma di tutti i valori fino all'i-esimo
	BEQ r3, r4, loop0		; se sono uguali vai avanti nell'array (loop)
	BEQZ r5, save1			; salva il nuovo max = f1==r4 se r5 = 0	
	
	BNEZ r1, loop0			; loop finché r1 diverso da 0
	J end					; fine array pari (r1 == 0)
	
save0:
	MOV.D f0, f1		; sovrascrivi (sposta) max = f0 con f1 = nuovo max
	J loop1					; vai avanti nell'array 
						; il massimo è in f0
save1:
	MOV.D f0, f1		; sovrascrivi (sposta) max = f0 con f1 = nuovo max
	J loop0					; vai avanti nell'array
	
exit:						; ultimo loop
	L.D f1, 8(r2)		; carica in f1 il valore di a[1] indirizzato da r2 + 8
	MFC1 r3, f0			; sposta il contenuto di f0 (FP reg)in r3 (INT reg)
	MFC1 r4, f1			; sposta il contenuto di f1 in r4
						; altrimenti errore nell'istruzione BEQ
	SLT r5, r4, r3		; r5 = 1 se r4==f1 < f0==r3 = max altrimenti r5 = 0
						; se r5 = 0 allora r4==f1 > max quindi lo salvo
	ADD.D f2, f2, f1	; carica in f2 la somma di tutti i valori fino all'i-esimo
	BEQ r3, r4, end			; se sono uguali vai avanti nell'array (loop)
	BEQZ r5, save2			; salva il nuovo max = f1==r4 se r5 = 0
	J end					; fine array
	
save2:
	MOV.D f0, f1		; sovrascrivi (sposta) max = f0 con f1 = nuovo max
	
end:
	DIV.D f2, f2, f3	; dividi la somma di tutti i valori per il numero di valori
	HALT				; la media aritmetica è in f2