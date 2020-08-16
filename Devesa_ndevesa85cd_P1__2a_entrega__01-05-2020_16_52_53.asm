section .data               
;Cambiar Nombre y Apellido por vuestros datos.
developer db "Napoleón_Devesa",0

;Constantes que también están definidas en C.
DimMatrix    equ 4      
SizeMatrix   equ 16

section .text            
;Variables definidas en Ensamblador.
global developer                        

;Subrutinas de ensamblador que se llaman des de C.
global showNumberP1, updateBoardP1, calcIndexP1, rotateMatrixRP1, copyMatrixP1
global shiftNumbersRP1, addPairsRP1
global readKeyP1, playP1

;Variables definidas en C.
extern rowScreen, colScreen, charac
extern m, mRotated, number, score, state

;Funciones de C que se llaman desde ensamblador
extern clearScreen_C, printBoardP1_C, gotoxyP1_C, getchP1_C, printchP1_C
extern insertTileP1_C, printMessageP1_C 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ATENCIÓN: Recordad que en ensamblador las variables y los parámetros 
;;   de tipo 'char' se tienen que asignar a registros de tipo
;;   BYTE (1 byte): al, ah, bl, bh, cl, ch, dl, dh, sil, dil, ..., r15b
;;   las de tipo 'short' se tiene que assignar a registros de tipo 
;;   WORD (2 bytes): ax, bx, cx, dx, si, di, ...., r15w
;;   las de tipo 'int' se tiene que assignar a registros de tipo  
;;   DWORD (4 bytes): eax, ebx, ecx, edx, esi, edi, ...., r15d
;;   las de tipo 'long' se tiene que assignar a registros de tipo 
;;   QWORD (8 bytes): rax, rbx, rcx, rdx, rsi, rdi, ...., r15
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Las subrutinas en ensamblador que tenéis que implementar son:
;;   showNumberP1, updateBoardP1, rotateMatrixRP1, 
;;   copyMatrixP1, shiftNumbersRP1, addPairsRP1.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Esta subrutina se da hecha. NO LA PODÉIS MODIFICAR.
; Situar el cursor en una fila indicada por la variable (rowScreen) y en 
; una columna indicada por la variable (colScreen) de pantalla 
; llamando a la función gotoxyP1_C.
; 
; Variables globales utilizadas:	
; rowScreen: Fila de la pantalla donde posicionamos el cursor.
; colScreen: Columna de la pantalla donde posicionamos el cursor.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gotoxyP1:
   push rbp
   mov  rbp, rsp
   ;guardamos el estado de los registros del procesador porque
   ;las funciones de C no mantienen el estado de los registros.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   call gotoxyP1_C
 
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Esta subrutina se da hecha. NO LA PODÉIS MODIFICAR.
; Mostrar un carácter guradado en la varaile (charac) en pantalla, en
; la posición donde está el cursor llamando a la función printchP1_C.
; 
; Variables globales utilizadas:	
; charac   : Carácter que queremos mostrar.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printchP1:
   push rbp
   mov  rbp, rsp
   ;guardamos el estado de los registros del procesador porque
   ;las funciones de C no mantienen el estado de los registros.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   call printchP1_C
 
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret
   

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Esta subrutina se da hecha. NO LA PODÉIS MODIFICAR.
; Leer una tecla y guardar el carácter asociado en la varaible (charac) 
; sin mostrarlo en pantalla, llamando a la función getchP1_C
; 
; Variables globales utilizadas:	
; charac   : Carácter que queremos mostrar.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getchP1:
   push rbp
   mov  rbp, rsp
   ;guardamos el estado de los registros del procesador porque
   ;las funciones de C no mantienen el estado de los registros.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15
   push rbp

   call getchP1_C
 
   pop rbp
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax
   
   mov rsp, rbp
   pop rbp
   ret 
   

;;;;;
; Convierte el número de la variable (number) de tipo int (DWORD) de 6
; dígitos (number <= 999999) a caracteres ASCII que representen su valor.
; Si (number) es más grande de 999999 cambiaremos el valor a 999999.
; Se tiene que dividir el valor entre 10, de forma iterativa, hasta 
; obtener los 6 dígitos. 
; A cada iteración, el residuo de la división que es un valor
; entre (0-9) indica el valor del dígito que tenemos que convertir
; a ASCII ('0' - '9') sumando '0' (48 decimal) para poderlo mostrar.
; Cuando el cociente sea 0 mostraremos espacios en la parte no significativa.
; Por ejemplo, si number=103 mostraremos "   103" y no "000103".
; Se tienen que mostrar los dígitos (carácter ASCII) desde la posición 
; indicada por las variables (rowScreen) y (colScreen), posición de les 
; unidades, hacia la izquierda.
; Como el primer dígito que obtenemos son las unidades, después las decenas,
; ..., para mostrar el valor se tiene que desplazar el cursor una posición
; a la izquierda en cada iteración.
; Para posicionar el cursor se llamada a la función gotoxyP1 y para 
; mostrar los caracteres a la función printchP1.
;
; Variables globales utilizadas:    
; number    : Valor que queremos mostrar.
; rowScreen : Fila para posicionar el cursor a la pantalla.
; colScreen : Columna para posicionar el cursor a la pantalla.
; charac    : Carácter que queremos mostrar
;;;;;
showNumberP1:

push rbp
mov  rbp, rsp

push rax								
push rbx
   
push r14					
push r15	
push rdx	

mov r15, 0

   
mov eax, DWORD [number]					; n = eax
mov r14b, 0								; i = 0
mov r15d,  [charac]		
   
cmp eax, 999999							;cmp n  > 999999
jle For					
mov eax, 999999			

For:
cmp r14b, 6								; i > 6 


jge end_For				
mov r15d, ' '							; charac = ' '
cmp eax, 0				
	
jle end_If				
mov ebx, 10			
mov edx, 0				
	 
div ebx				
	 
mov r15d, 	edx	
add r15d, '0'			
end_If:
   
   
mov DWORD [charac], r15d	
call gotoxyP1
call printchP1
dec DWORD [colScreen]	
   
inc r14b								; i + 1
jmp For					 
end_For:
	
pop rdx
   
pop r15					
pop r14					
   
pop rbx
pop rax					

   
mov rsp, rbp
pop rbp
ret


;;;;;
; Actualizar el contenido del Tablero de Juego con los datos de 
; la matriz (m) y los puntos del marcador (score) que se han hecho.  
; Se tiene que recorrer toda la matriz (m), y para cada elemento de 
; la matriz posicionar el cursor en pantalla y mostrar el número de 
; esa posición de la matriz.
; Para recorrer la matriz en assemblador el indice va de 0 (posició [0][0])
; a 30 (posición [3][3]) con incrementos de 2 porque los datos son de 
; tipo short(WORD) 2 bytes.
; Después, mostrar el marcador (score) en la parte inferior del tablero
; fila 18, columna 26 llamando a la subrutina showNumberP1.
; Finalmente posicionar el cursor en la fila 18, columna 28 llamando a
; la subrutina goroxyP1.
;
; Variables globales utilizadas:    
; rowScreen : Fila para posicionar el cursor en pantalla.
; colScreen : Columna per a posicionar el cursor en pantalla.
; m         : Matriz 4x4 donde hay los números del tablero de juego.
; score     : Puntos acumulados en el marcador hasta el momento.
; number    : Número que queremos mostrar.
;;;;;  
updateBoardP1:

push rbp
mov  rbp, rsp

push rdi
  
   
push rax
push rbx
push rcx
   
push r8
push r9
push r10
   
mov rdi , 0
   							
mov rax , 0
mov rbx , 0
mov rcx , 0						
mov r8 , 0
mov r9 , 0
mov r10 , 0									; r10d = number
   
mov eax , 10								; rowScreenAux = 10	
   
F1:
cmp r8w , DimMatrix							; i < DimMatrix
jge endF1									; jump greater or equal
mov ecx, 17									; ecx = colScreenAux = 17

F2:
cmp r9w, DimMatrix							; r9w = j , j < DimMAtrix
jge endF2									; jump greater or equal

movsx r10d , WORD[m+rdi]					; number = m[i][j]
											; extensión de signo
mov DWORD[number], r10d						; number = m[i][j]
mov DWORD[rowScreen], eax					; eax = rowScreen = rowScreenAux
mov DWORD[colScreen], ecx					; colScreen = colScreenAux

call showNumberP1


add ecx, 9									; colScreenAux + 9
add rdi, 2								
inc r9w										; j ++
jmp F2


endF2:
											; j = 0
add eax , 2									; rowScreenAux + 2
inc r8w
mov r9w, 0									; i ++

jmp F1

endF1:
   
   
mov r10d, DWORD[score]
mov DWORD[number] , r10d
				
mov DWORD[rowScreen], 18
mov DWORD[colScreen], 26
call showNumberP1
mov DWORD[rowScreen] , 18
mov DWORD[colScreen] , 28
call gotoxyP1
   
pop r10
pop r9
pop r8
   
pop rcx
pop rbx
pop rax
  
pop rdi

   
mov rsp, rbp
pop rbp
ret


;;;;;      
; Rotar a la derecha la matriz (m), sobre la matriz (mRotated). 
; La primera fila pasa a ser la cuarta columna, la segunda fila pasa 
; a ser la tercera columna, la tercera fila pasa a ser la segunda
; columna y la cuarta fila pasa a ser la primer columna.
; En el enunciado se explica con más detalle como hacer la rotación.
; NOTA: NO es lo mismo que hacer la matriz traspuesta.
; La matriz (m) no se tiene que modificar, 
; los cambios se tiene que hacer en la matriz (mRotated).
; Para recorrer la matriz en ensamblador el indice va de 0 (posición [0][0])
; a 30 (posición [3][3]) con incrementos de 2 porque los datos son de 
; tipo short(WORD) 2 bytes.
; Para acceder a una posición concreta de la matriz desde ensamblador 
; hay que tener en cuenta que el índice es:(index=(fila*DimMatrix+columna)*2),
; multiplicamos por 2 porque los datos son de tipo short(WORD) 2 bytes.
; Una vez se ha hecho la rotación, copiar la matriz (mRotated) a la 
; matriz (m) llamando a la subrtuina copyMatrixP1.
;
; Variables globales utilizadas:    
; m        : matriz 4x4 donde hay los números del tablero de juego.
; mRotated : Matriz 4x4 para hacer la rotación.
;;;;;  
rotateMatrixRP1:
   
push rbp
mov  rbp, rsp
   
push rsi
push rdi
push r8
push r9
push r10
push r11
   
mov rsi, 0								; indice m
mov r8, 0								; i = r8w 
mov r9, 0								; j = r9w
mov r10, DimMatrix						; columnamR = DimMatrix-1-i
   
lp1:
cmp r8w, DimMatrix
jge endlp1
dec r10									; columnamR =DimMatrix-1-i
lp2:
cmp r9w, DimMatrix
jge endlp2
	
mov rdi, 0
mov r11w, WORD[m+rsi]					; r11w = m[i][j]
add rdi, DimMatrix						; indmR = DimM
imul rdi, r9							; indmR = DimM x fila			;fila = j Col=r10
add rdi, r10							; indmR = DimM xfila + col
imul rdi, 2								; indmR = 2*DimM x fila + 2 x col
mov WORD[mRotated+rdi], r11w
    
    
add rsi, 2
inc r9w									; j++
   
   
jmp lp2
endlp2:
   
mov r9w, 0								; j=0
inc r8w									; i++
jmp lp1
endlp1:
   
call copyMatrixP1

pop r11
pop r10
pop r9
pop r8
pop rdi
pop rsi
   
   
mov rsp, rbp
pop rbp
ret


;;;;;  
; Copiar los valores de la matriz (mRotated) a la matriz (m).
; La matriz (mRotated) no se tiene que modificar, 
; los cambios se tienen que hacer en la matriz (m).
; Para recorrer la matriz en ensamblador el índice va de 0 (posición [0][0])
; a 30 (posición [3][3]) con incrementos de 2 porque los datos son de 
; tipo short(WORD) 2 bytes.
; No se muestra la matriz. 
;
; Variables globales utilizadas:    
; m        : Matriz 4x4 donde hay los números del tablero de juego.
; mRotated : Matriz 4x4 para hacer la rotación.
;;;;;  
copyMatrixP1:
push rbp
mov  rbp, rsp
   

push rax
push rbx
push rcx
push rdx


push rsi
push rdi
    
	

mov ecx, 0 								;i
mov esi, 0 								;j


cmP1_for1:
mov di, 0 
mov di, WORD [mRotated+ecx+esi*2] 		;copy mR en di
mov WORD [m+ecx+esi*2], di 				;copy valor di / m
inc esi
cmp esi, 4 								; 4 xfila
jl cmP1_for1

mov esi, 0
add ecx, 8 								; 8Bytes x fila
cmp ecx, 32 							; matrix
jl cmP1_for1    

mov ecx, 0
mov esi, 0


pop rdi
pop rsi
pop rdx
pop rcx
pop rbx
pop rax

   
mov rsp, rbp
pop rbp
ret


;;;;;  
; Desplazar a la derecha los números de cada fila de la matriz (m), 
; manteniendo el orden de los números y poniendo los ceros a la izquierdaa.
; Recorrer la matriz por filas de derecha a izquierda y de abajo hacia arriba.  
; Si se desplaza un número (NO LOS CEROS) pondremos la variable 
; (state) a '2'.
; Si una fila de la matriz es: [0,2,0,4] y state = '1', quedará [0,0,2,4] 
; y state= '2'.
; En cada fila, si encuentra un 0, mira si hay un número distinto de zero,
; en la misma fila para ponerlo en aquella posición.
; Para recorrer la matriz en ensamblador, en este caso, el índice va de la
; posición 30 (posición [3][3]) a la 0 (posición [0][0]) con decrementos de
; 2 porque los datos son de tipo short(WORD) 2 bytes.
; Per a acceder a una posición concreta de la matriz desde ensamblador 
; hay que tener en cuenta que el índice es:(index=(fila*DimMatrix+columna)*2),
; multiplicamos por 2 porque los datos son de tipo short(WORD) 2 bytes.
; Los cambios se tienen que hacer sobre la misma  matriz.
; No se tiene que mostrar la matriz.
;
; Variables globales utilizadas:    
; state    : Estado del juego. (2: Se han hecho movimientos).
; m        : Matriz 4x4 donde hay los números del tablero de juego.
;;;;;  
shiftNumbersRP1:
   
   
   
push rbp
mov  rbp, rsp

push rax
push rbx

push r15                    
push r14
push r13
push r10



push rsi
push rdi   
   
; int i,j,k;
   
; for (i=DimMatrix-1; i>=0; i--) {
;    for (j=DimMatrix-1; j>0; j--) {
;   if (m[i][j] == 0) {
;     k = j-1;           
;    while (k>=0 && m[i][k]==0) k--;
;    if (k==-1) {
;      j=0;                
;   } else {
;  m[i][j]=m[i][k];
;  m[i][k]= 0; 
;  state='2';      

mov r15,0								;i
mov r14,0  								;j
           
   
mov r13w, DimMatrix
dec r13w
   				

mov r15w, r13w							; i = DimM -1

ff1:
cmp r15w, 0								; i>=0
jl finf1
    					
    
mov r14w, r13w 							; j = DimMatrix-1
    
ff2:
cmp r14w, 0								; j > 0
jle finf2

if:
     
mov rsi, 0								; indice m[i][j]
add si, r15w							; indice = i
imul esi, DimMatrix						; indice = i*DimM
     
add si, r14W							; indice = i*DimM + j
imul rsi, 2								; indice = 2*i*DimM + 2*j = [i][j]
mov ax, WORD[m+rsi]						; ax = m[i][j]


cmp ax, 0
     
     
jne fin_if_1							; m[i][j] != 0 


mov r10w, r14w
dec r10w								; k = j-1

buclew:									; while (k>=0 && m[i][k]==0)
cmp r10w, 0
      
      
      
jl finw									; ? k>=0
       
       
										; m[i][k]
mov rdi, 0								; ind m[i][k]
add di, r15w							; ind = i
imul edi, DimMatrix						; ind = i*DimM
add di, r10W							; ind = i*DimM + k
imul rdi, 2								; ind = 2*i*DimM+ 2*k = [i][k]
mov bx, WORD[m+rdi]						; bx = m[i][k]
       
cmp bx, 0					


jne finw								; ? m[i][k]==0


dec r10w								; k--
jmp buclew
      
      
finw:

cmp r10w, -1
jne else								; k == -1
mov r14w, 0								; j=0
jmp fin_if_1
      
      
      
else:
		 
										; m[i][k]
mov rdi, 0								; ind m[i][k]
add di, r15w							; ind = i
imul edi, DimMatrix						; ind = i*DimM


add di, r10W							; ind = i*DimM + k
imul rdi, 2								; ind = 2*i*DimM + 2*k = [i][k]
mov bx, WORD[m+rdi]						; bx = m[i][k]
      
      
      
mov WORD[m+rsi], bx						; m[i][j] = m[i][k]
mov WORD[m+rdi], 0						; m[i][k] = 0
mov BYTE[state], '2'					; state = 2
fin_if_1:
     
dec r14w								; j--
jmp ff2
finf2:
    
dec r15w								; i--
jmp ff1
finf1:
   
pop rdi
pop rsi
pop r10
   
pop r13   
pop r14
pop r15
   
pop rbx
pop rax
   
mov rsp, rbp
pop rbp
ret
      

;;;;;  
; Emparejar números iguales desde la derecha de la matriz (m) y acumular 
; los puntos en el marcador sumando los puntos de las parejas que se hagan.
; Recorrer la matriz por filas de dercha a izquierda y de abajo hacia arriba. 
; Cuando se encuentre una pareja, dos casillas consecutivas con el mismo 
; número, juntamos la pareja poniendo la suma de los números de la 
; pareja en la casilla de la derechay un 0 en la casilla de la izquierda y 
; acumularemos esta suma (puntos que se ganan).
; Si una fila de la matriz es: [8,4,4,2] y state = 1, quedará [8,0,8,2], 
; p = p + (4+4) y state = '2'.
; Si al final se ha juntado alguna pareja (puntos>0), pondremos la variable 
; (state) a '2' para indicar que se ha movido algún número y actualizaremos
; la variable (score) con los puntos obtenidos de hacer las parejas.
; Para recorrer la matriz en ensamblador, en este caso, el índice va de la
; posición 30 (posición [3][3]) a la 0 (posición [0][0]) con decrementos de
; 2 porque los datos son de tipo short(WORD) 2 bytes.
; Para acceder a una posición concreta de la matriz desde ensamblador 
; hay que tener en cuenta que el índice es:(index=(fila*DimMatrix+columna)*2),
; multiplicamos por 2 porque los datos son de tipo short(WORD) 2 bytes.
; Los cambios se tienen que hacer sobre la misma  matriz.
; No se tiene que mostrar la matriz.
; 
; Variables globales utilizadas:    
; m        : Matriz 4x4 donde hay los números del tablero de juego.
; score    : Puntos acumulados hasta el momento.
; state    : Estado del juego. (2: Se han hecho movimientos).
;;;;;  
addPairsRP1:

push rbp
mov  rbp, rsp
   
push rax


push rdx										; rbx

push r8											


push r15										;i
push r14			

		
push rsi
push rdi

mov rsi, 0										; [i][j] = 0
mov r15, 0
mov r8w, 0										; p   cx
mov r15w, DimMatrix-1							; i = DimMatrix-1  // fila


ffor_11:
cmp r15w, 0
jl end_ffor_11									; i>=0




mov r14w, DimMatrix-1							; j = DimMatrix-1 // columna
ffor_22:
cmp r14w, 0


jle end_ffor_22
										
	  
	  											; [i][j] = 0
mov si, r15W									; [i][j] = i
imul rsi, DimMatrix								; [i][j] = i x DimMatrix
add si, r14w									; [i][j] = i x DimMatrix + j 
imul rsi, 2										; [i][j] = 2 x i xDimMatrix + 2 xj 
mov ax, WORD[m+rsi]								; ax = m[i][j]



cmp ax, 0


je end_iff_1									; m[i][j]!=0

mov rdi, rsi


dec rdi

dec rdi



mov dx, WORD[m+rdi]								;dx = m[i][j-1]  
cmp ax, dx										;m[i][j]  cmp  m[i][j-1]


jne end_iff_1									; m[i][j]== m[i][j-1]


imul ax, 2										; m[i][j] x 2
mov WORD[m+rsi], ax								; m[i][j]  = m[i][j] x2

mov WORD[m+rdi], 0								; m[i][j-1] = 0
add r8w, WORD[m+rsi]							; p = p + m[i][j]


end_iff_1:										;end if
	  
												;end if
	  
	  
dec r14w										; j/columna --


jmp ffor_22
end_ffor_22:


dec r15w										; i/fila--


jmp ffor_11										;fin f 1
end_ffor_11:									;fin f 1
	
cmp r8w, 0										; p > 0
jle endiffp



mov BYTE[state], '2'							; st =  2
add WORD[score], r8w


endiffp:


   
   
pop rdi
pop rsi

pop r14
pop r15

pop r8

pop rdx
pop rax

	  
	  

          
   
mov rsp, rbp
pop rbp
ret
   

;;;;;; 
; Esta subrutina se da hecha. NO LA PODÉIS MODIFICAR.
; Leer una tecla (una sola vez, sin hacer un bucle) llamando a la 
; subrutina getchP1 que la guarda en la variable (charac).
; Según la tecla leída llamaremos a las subrutinas que corresponda.
;    ['i' (arriba),'j'(izquierda),'k' (a bajo) o 'l'(derecha)] 
; Desplazar los números y hacer las parejas según la dirección escogida.
; Según la tecla pulsada, rotar la matriz llamando (rotateMatrixRP1),
; para poder hacer los desplazamientos de los números hacia la derecha
; (shiftNumbersRP1),  hacer las parejas hacia la derecha (addPairsRP1) 
; y volver a desplazar los números hacia la izquierda (shiftNumbersRP1) 
; con las parejas hechas, después seguir rotando llamando (rotateMatrixRP1) 
; hasta dejar la matriz en la posición inicial. 
; Para la tecla 'l' (dercha) no hay que hacer rotaciones, para el
; resto se tienen que hacer 4 rotaciones.
;    '<ESC>' (ASCII 27)  poner (state = '0') para salir del juego.
; Si no es ninguna de estas teclea no hacer nada.
; Los cambios producidos por estas subrutina no se tiene que mostrar en 
; pantalla, por lo tanto, hay que actualizar después el tablero llamando 
; la subrutina UpdateBoardP1.
;
; Variables globales utilizadas: 
; charac   : Carácter que leemos de teclado.
; state    : Indica el estado del juego. '0':salir, '1':jugar
;;;;;  
readKeyP1:
   push rbp
   mov  rbp, rsp

   push rax 
      
   call getchP1    ; Leer una tecla y dejarla en charac.
   mov  al, BYTE[charac]
      
   readKeyP1_i:
   cmp al, 'i'      ; arriba
   jne  readKeyP1_j
      call rotateMatrixRP1
      
      call shiftNumbersRP1
      call addPairsRP1
      call shiftNumbersRP1  
      
      call rotateMatrixRP1
      call rotateMatrixRP1
      call rotateMatrixRP1
      jmp  readKeyP1_End
      
   readKeyP1_j:
   cmp al, 'j'      ; izquierda
   jne  readKeyP1_k
      call rotateMatrixRP1
      call rotateMatrixRP1
      
      call shiftNumbersRP1
      call addPairsRP1
      call shiftNumbersRP1  
      
      call rotateMatrixRP1
      call rotateMatrixRP1
      jmp  readKeyP1_End
      
   readKeyP1_k:
   cmp al, 'k'      ; abajo
   jne  readKeyP1_l
      call rotateMatrixRP1
      call rotateMatrixRP1
      call rotateMatrixRP1
      
      call shiftNumbersRP1
      call addPairsRP1
      call shiftNumbersRP1  
      
      call rotateMatrixRP1
      jmp  readKeyP1_End

   readKeyP1_l:
   cmp al, 'l'      ; derecha
   jne  readKeyP1_ESC
      call shiftNumbersRP1
      call addPairsRP1
      call shiftNumbersRP1  
      jmp  readKeyP1_End

   readKeyP1_ESC:
   cmp al, 27      ; Salir del programa
   jne  readKeyP1_End
      mov BYTE[state], '0'

   readKeyP1_End:
   pop rax
      
   mov rsp, rbp
   pop rbp
   ret


;;;;;
; Juego del 2048
; Función principal del juego
; Permite jugar al juego del 2048 llamando todas las funcionalidades.
; Esta subrutina se da hecha. NO LA PODÉIS MODIFICAR.
;
; Pseudo-código:
; Inicializar estado del juego, (state='1')
; Borrar pantalla (llamar a la función clearScreen_C).
; Mostrar el tablero de juego (llamar a la función PrintBoardP1_C).
; Actualizar el contenido del Tablero de Juego y los puntos que se han 
; hecho (llamar a la función updateBoardP1).
; Mientras (state=='1') hacer
;   Leer una tecla (llamar a la función readKeyP1). Según la tecla 
;     leída llamar a las funciones que corresponda.
;     - ['i','j','k' o 'l'] desplazar los números y hacer las parejas 
;                           según la dirección escogida.
;     - '<ESC>'  (código ASCII 27) poner (state = '0') para salir.   
;   Si hemos movido algún número al hacer los desplazamientos o al hacer
;   las parejas (state==2) generar una nueva ficha (llamando a la función
;   insertTileP1_C) y poner la variable state a '1' (state='1').
;   Actualizar el contenido del Taublero de Juego y los puntos que se han
;   hecho (llamar a la función updateBoardP1).
; Fin mientras.
; Mostrar un mensaje debajo del tablero según el valor de la variable 
; (state). (llamar a la función printMessageP1_C).
; Salir: 
; Se ha terminado el juego.

; Variables globales utilizadas: 
; state  : Indica el estado del juego. '0':salir, '1':jugar
;;;;;  
playP1:
   push rbp
   mov  rbp, rsp
   
   mov BYTE[state], '1'      ;state = '1';  //estado para empezar a jugar   
   
   call clearScreen_C
   call printBoardP1_C
   call updateBoardP1

   playP1_Loop:               ;while  {     //Bucle principal.
   cmp  BYTE[state], '1'     ;(state == '1')
   jne  playP1_End
      
      call readKeyP1          ;readKeyP1_C();
      cmp BYTE[state], '2'   ;state == '2' //Si se ha hecho algun movimiento
      jne playP1_Next 
         call insertTileP1_C   ;insertTileP1_C(); //Añadr ficha (2)
         mov BYTE[state],'1'  ;state = '1';
      playP1_Next
      call updateBoardP1       ;updateBoardP1_C();
      
   jmp playP1_Loop

   playP1_End:
   call printMessageP1_C      ;printMessageP1_C();
                              ;Mostrar el mensaje para indicar como acaba.
   mov rsp, rbp
   pop rbp
   ret
