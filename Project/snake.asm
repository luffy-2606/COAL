[ORG 0x100]
jmp start                    

    title: db 'SNAKE GAME',0 
    
    name1: db 'Saaif Suleman (24L-2606)',0
    name2: db 'Nauman Iqbal  (24L-2565)',0
    
    madeby: db 'Made By:',0
    
    scr: db "SCORE = ",0  
    score: dw 0               
    
    msg3: db "THE END",0 
    
    Location_of_food: dw 0         ; Position of the food
    My_snake: db 2,'ooooooo',0    ; Snake representation
    
    
    delay: dd 0
    curr_delay: dd 90000
    constant_way: db 2
    length: dw 8                 ; Length of the snake
    
    head_of_snake: dw 0          ; Position of the snake's head
    row: dw 0                    ; Current row position
    col: dw 0                    ; Current column position
    
  
    buffer times 512 db 0
    menu1: db 'Press S to START',0
    menu2: db 'Press E to EXIT',0
    menu3: db 'Press D for DIFF',0
    
    diff1: db '1.Normal :)',0
    diff2: db '2.Medium :/',0
    diff3: db '3.Hard ;<',0
    
    return_msg: db 'Press any key to return to menu',0
    men : db 'MENU',0
    
    
    s1: db "              ______",0
    s2: db "         _.-         -._",0
    s3: db "      .-^                `-.",0
    s4: db "    .^      __.----.__      `.",0
    s5: db "   /     .-^          ^-.     \ ",0
    s6: db "  /    .^                 `.    \ ",0
    s7: db " J    /                     \    L",0
    s8: db " F   J                       L    J",0
    s9: db " J   F                        J   L",0
    s10: db "|  J                          L  |",0
    s11: db "|  |                          |  |",0
    s12: db "|  J                          F  |",0
    s13: db "J   L                        J   F",0
    s14: db " L  J   .-^^^^-.             F   J",0
    s15: db " J   \ /        \   __      /   F",0
    s16: db "  \    (|)(|)_   .-^      .^   / ",0
    s17: db "   \    \   /_>-^  .<_.-^     /",0
    s18: db "    `.^   `-^     .^         .^",0
    s19: db "      `--.|___.-^`._    _.-^",0
    s20: db "          ^         ^^^^",0




clrscr:                       ; Clear the screen routine begins
    push ax                  ; Push ax register onto the stack
    push di                  ; Push di register onto the stack
    push es                  ; Push es register onto the stack
    mov ax,0xb800             ; Set ax register with video memory address
    mov es,ax                 ; Set es register with video memory segment
    mov di,0                  ; Set di register to 0

nextloc:
    mov word[es:di],0x0720   ; Set each character on the screen to space with color attribute 0x07 (white on black)
    add di,2                  ; Move to the next character
    cmp di,4000               ; Compare di with the end of the video memory
    jne nextloc               ; Jump to nextloc if di is not equal to 4000

    pop es                       ; Pop es register from the stack
    pop di                       ; Pop di register from the stack
    pop ax                       ; Pop ax register from the stack
    ret                          ; Return from the subroutine


printstr:                    ; Subroutine to print a null-terminated string
    push bp                  ; Push bp register onto the stack
    mov bp,sp                 ; Set bp register as the stack pointer
    push es                  ; Push es register onto the stack
    push ax                  ; Push ax register onto the stack
    push cx                  ; Push cx register onto the stack
    push si                  ; Push si register onto the stack
    push di                  ; Push di register onto the stack

    push ds                  ; Push ds register onto the stack
    pop es                   ; Pop es register with ds register
    mov di,[bp+4]            ; Set di register with the address of the string
    mov cx,0xffff            ; Set cx register with maximum count value
    xor al,al                ; Clear al register
    repne scasb               ; Search for the null terminator in the string
    mov ax,0xffff            ; Set ax register with maximum count value
    sub ax,cx                ; Calculate the length of the string
    sub ax,1                 ; Adjust length by subtracting 1
    cmp ax,0                 ; Check if the length is zero
    jz exit                ; Jump to exitch if the length is zero
    mov cx,ax                ; Set cx register with the length of the string

    mov ax,0xb800            ; Set ax register with video memory address
    mov es,ax                ; Set es register with video memory segment
    mov ax,80                 ; Set ax register with the number of columns in a row
    mul byte[bp+8]           ; Multiply ax by the row value
    add ax,[bp+10]           ; Add the column value to ax
    shl ax,1                 ; Multiply ax by 2 to get the offset in video memory
    mov di,ax                ; Set di register with the offset in video memory
    mov si,[bp+4]            ; Set si register with the address of the string
    mov ah,[bp+6]            ; Set ah register with the color attribute

    cld                       ; Set the constant_way flag to forward
nextchar:
    lodsb                     ; Load the next character from the string into al
    stosw                     ; Store the character and attribute in video memory
    loop nextchar             ; Loop until all characters are processed

exit:  
    pop di                    ; Pop di register from the stack
    pop si                    ; Pop si register from the stack
    pop cx                    ; Pop cx register from the stack
    pop ax                    ; Pop ax register from the stack
    pop es                    ; Pop es register from the stack
    pop bp                    ; Pop bp register from the stack
ret 8                        ; Return from the subroutine, discarding parameters


Printing_The_Score:                   
    push bp                  
    mov bp,sp                 
    push ax                  
    push bx                  
    push cx                  
    push dx                  
    push es                  
    push di                 

    mov ax,[score]           
    mov bx,10                 ; Set bx register with the base for conversion
    mov cx,0                  ; cx is digit count
loop1:
    mov dx,0                  ; Clear dx 
    div bx                    ; ax / bx: result in ax, remainder in dx
    add dl,0x30               ; Convert remainder to ASCII
    push dx                   ; Push the ASCII character 
    
    inc cx                    ; Increment the digit count
    cmp ax,0                  ; termination condition
    jnz loop1                

    mov ax,0xb800             
    mov es,ax                 
    mov ax,80                  ; ax = number of columns in a row
    
    mul byte [bp+6]            ; Multiply ax by the row value
    add ax,[bp+4]             ; Add the column value to ax
    shl ax,1                  ; Multiply ax by 2 to get the offset 
    
    mov di,ax                 ; di = offset
    
nextnum:
    pop dx                    ; Pop the digit from the stack
    mov dh,0x12               ; attribute
    
    mov [es:di],dx            ; Store the digit and attribute in video memory
    add di,2                  ; Move to the next character
    loop nextnum              ; Loop until all digits are processed

    pop di                    
    pop es                    
    pop dx                    
    pop cx
    pop bx
    pop dx                  
    pop bp                    
ret 4                        

Printing_The_Snake:               
        push bp               
        mov bp,sp               
        push ax                
        push bx
        push cx       
        push dx             
        push si          
        push di              
        push es               
        mov si,[bp+6]          ; si = snake string
        mov cx,[bp+8]          ; cx = snake length
        
        sub cx,2               ; Subtract 2 to remove the null 
        
        mov ax,80              ; ax = number of columns in a row
        mov dx,9               ; dx = row offset
        mul dx                 ; ax * dx = row position
        add ax,22              ; column position
        
        shl ax,1               ; times 2 for offset in video memory
        mov di,ax              ; di = offset
        
        mov ax,0xb800
        mov es,ax              
        
        mov bx,[bp+4]          ; color attribute

Snake_loop:
    mov al,[si]           ; Load the next character from the snake string into al
    mov [es:di],ax        ; Store the character and attribute in video memory
    mov [bx],di           ; Store the current position in memory for future use
    inc si                ; Move to the next character
    add bx,2              ; next position in memory
    add di,2              ; next character in video memory
    
    dec cx                ; Decrement the character count
    jnz Snake_loop        ; loop till all characters displayed

    pop es                   
    pop di                   
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 6


board_print:
    push ax                          
    push bx
    push cx
    push dx
    push es
    push di

    mov ax, 0xb800               
    mov es, ax                   
    
    mov di, 320             ; di = starting position (left border)
    mov ax, 0x0DDB                ; pink block for border

left:
    mov word [es:di], ax       
    add di, 160                ; Move to the next row
    
    cmp di, 4000               ; Compare di with the end
    jb left                    
    
    mov di, 478              ; di = starting position (right border)
right:
    mov word [es:di], ax       
    add di, 160   
    
    cmp di, 4000               ; Compare di with the end
    jb right                   
    
    mov al, 0x16               ; Character for the horizontal border
    mov di, 3840            ; di = starting position (bottom border)
down:
    mov word [es:di], ax      
    add di, 2                 
    
    cmp di, 4000               
    jb down                   
    
    mov di, 320            ; di = starting position (top border)
up:
    mov word [es:di], ax       
    add di, 2                  
    
    cmp di, 480                
    jb up                     

    ; Clearing the remaining center space
    mov di, 0                        
    mov ax, 0xb800                   
    mov es, ax                      
    mov ax, 0x0720    ; blank space
    
next_space:
    mov [es:di], ax              ; Move the blank space to the video memory
    add di, 2                    ; Move to the next column
    cmp di, 318                  
    jnz next_space               

    ; Title Message
    mov ax, 33          ; ROW
    push ax                         
    mov ax, 2           ; COLUMN
    push ax                        
    mov ax, 0x0D        ; pink colour
    push ax                          
    mov ax, title       ; "SNAKE GAME"             
    push ax                          
    call printstr                    
    
    ; SCORE on top
    mov ax, 1           ; ROW
    push ax                       
    mov ax, 1           ; COLUMN
    push ax                   
    mov ax, 0x09        ; purple colour
    push ax                          
    mov ax, scr         
    push ax             ; "SCORE = "       
    call printstr           
    
    ; SCORE Number
    mov ax, 1           ; ROW
    push ax                      
    mov ax, 9           ; COLUMN
    push ax                
    call Printing_The_Score
    
    pop di                              
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    ret                             

Ending:
    call clrscr
    
    ; "THE END" message
    mov ax, 34
    push ax
    mov ax, 10
    push ax
    mov ax, 0x0C
    push ax
    mov ax, msg3
    push ax
    call printstr
    
    ; score message
    mov ax, 33
    push ax
    mov ax, 12
    push ax
    mov ax, 0x07
    push ax
    mov ax, scr
    push ax
    call printstr
    
    ; final score number
    mov ax, 12
    push ax
    mov ax, 41
    push ax
    call Printing_The_Score
    
    ; return message
    mov ax, 24
    push ax
    mov ax, 14
    push ax
    mov ax, 0x0e
    push ax
    mov ax, return_msg
    push ax
    call printstr
    
    ; Wait for key press
    mov ah, 0
    int 16h
    
    ; Reset game variables
    mov word [score], 0
    mov word [length], 8
    mov byte [constant_way], 2
    
    ; Return to menu
    jmp S

UPWARD:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push es
    push si
    push di

    mov bx, [bp + 4]
    mov dx, [bx]
    mov cx, [bp + 8]
    sub dx, 160

UP_Collision:
    cmp dx, [bx]
    jne exit_up1
    call Ending
exit_up1:
    add bx, 2
    dec cx
    jnz UP_Collision

upping:
    mov si, [bp + 6]
    mov bx, [bp + 4]
    mov dx, [bx]
    sub dx, 160
    mov di, dx

    mov ax, 0xb800
    mov es, ax

    mov ah, 0x12
    mov al, [si]
    mov [es:di], ax
    mov cx, [bp + 8]
    mov di, [bx]
    inc si

    mov ah, 0x12
    mov al, [si]
    mov [es:di], ax

Printing_UP:
    mov ax, [bx]
    mov [bx], dx
    mov dx, ax
    add bx, 2
    dec cx
    jnz Printing_UP

    mov di, dx
    mov ax, 0x0720
    mov [es:di], ax

    push di
    sub di, 160
    cmp word[es:di], 0x4740
    je a1
    mov [es:di], ax

a1:
    sub di, 160
    cmp word[es:di], 0x4740
    je b1
    mov [es:di], ax

b1:
    pop di
    push di
    add di, 160
    cmp word[es:di], 0x4740
    je c1
    mov [es:di], ax

c1:
    add di, 160
    cmp word[es:di], 0x4740
    je d1
    mov [es:di], ax

d1:
    pop di
    push di
    add di, 2
    cmp word[es:di], 0x4740
    je e1
    mov [es:di], ax

e1:
    add di, 2
    cmp word[es:di], 0x4740
    je f1
    mov [es:di], ax

f1:
    pop di
    push di
    sub di, 2
    cmp word[es:di], 0x4740
    je g1
    mov [es:di], ax

g1:
    sub di, 2
    cmp word[es:di], 0x4740
    je h1
    mov [es:di], ax

h1:
    pop di
    call board_print
    jmp up_exit

up_exit:
    pop di
    pop si
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 6

downward_movement:            
    push bp                   
    mov bp, sp                
    push ax                   
    push bx                   
    push cx                   
    push dx                  
    push es                   
    push si                  
    push di                  
   
    mov bx, [bp+4]            ; bx = snake head pos
    mov dx, [bx]              ; dx = current row snake head
    
    mov cx, [bp+8]            ; cx = snake length
    add dx, 160               ; Move one row down

down_hit:
    cmp dx, [bx]              ; Compare new head with body positions
    jne exit_down1            ; no collision
    call Ending               ; end if collision

exit_down1:
    add bx, 2                 ; next body position
    dec cx                    ; loop through entire length
    jnz down_hit             

down_mov:
    mov si, [bp+6]            ; si = snake pattern
    mov bx, [bp+4]            ; bx = snake head
    mov dx, [bx]              ; dx = current row snake head dx
    
    add dx, 160               ; Move one row down
    mov di, dx                ; Copy the new head position to di

    mov ax, 0xb800            
    mov es, ax                
    
    mov ah, 0x12              ; ah = green on blue background
    mov al, [si]              ; al = character of snake pattern
    mov [es:di], ax           ; complete one snake block 
    
    mov cx, [bp+8]            ; cx = snake length
    mov di, [bx]              ; di = snake head
    inc si                    ; move to next char of snake pattern
   
    mov ah, 0x12              ; ah = green on blue background
    mov al, [si]              ; al = character of snake pattern
    mov [es:di], ax           

down_printing:
    mov ax, [bx]              ; ax = current body position into ax
    mov [bx], dx              ; body position = new head position
    
    mov dx, ax                ; Copy the current body position to dx
    add bx, 2                 ; next body position
    
    dec cx                    ; loop till string length
    jnz down_printing

    mov di, dx                ; Copy the new head position to di
    mov ax, 0x0720            ; blank space
    
    mov [es:di], ax           ; blank space in the old head position

    push di                   
    sub di, 160               ; Move one row up
    cmp word[es:di], 0x4740   ; Compare with the food
    je a2                     ; if food eaten
    mov [es:di], ax           ; blank space in the new head position

a2:
    sub di, 160               ; Move one row up
    cmp word[es:di], 0x4740   ; Compare with the food
    je b2                     ; if food eaten
    mov [es:di], ax           ; blank space in the new head position

b2:
    pop di                    ; Restore di 
    push di                   ; Save di again
    add di, 160               ; Move one row down
    cmp word[es:di], 0x4740   ; Compare with the food
    je c2                     ; if food eaten
    mov [es:di], ax           ; blank space in the new head position

c2:
    add di, 160               ; Move one row down
    cmp word[es:di], 0x4740   ; Compare with the food
    je d2                     ; if food eaten
    mov [es:di], ax           ; blank space in the new head position

d2:
    pop di                    ; Restore di 
    push di                   ; Save di again
    add di, 2               ; Move one column right
    cmp word[es:di], 0x4740   ; Compare with the food
    je e2                     ; if food eaten
    mov [es:di], ax           ; blank space in the new head position

e2:
    add di, 2               ; Move one column right
    cmp word[es:di], 0x4740   ; Compare with the food
    je f2                     ; if food eaten
    mov [es:di], ax           ; blank space in the new head position

f2:
     pop di                    ; Restore di 
    push di                   ; Save di again
    add di, 2               ; Move one column left
    cmp word[es:di], 0x4740   ; Compare with the food
    je g2                     ; if food eaten
    mov [es:di], ax           ; blank space in the new head position

g2:
    sub di, 2                 ; Move one column left
    cmp word[es:di], 0x4740   ; Compare with the food
    je h2                      ; if food eaten
    mov [es:di], ax           ; blank space in the new head position

h2:
    pop di                    
    call board_print          ; redraw border
    jmp down_exit             

down_exit:
    pop di                    
    pop si                    
    pop es                   
    pop dx                    
    pop cx                    
    pop bx                    
    pop ax                    
    pop bp                    
    ret 6

leftward_movement:
    push bp                 
    mov bp, sp               
    push ax                  
    push bx                  
    push cx                 
    push dx                  
    push es                  
    push si                  
    push di                  
   
    mov bx, [bp+4]           ; bx = snake head pos
    mov dx, [bx]             ; dx = current snake head position
    mov cx, [bp+8]           ; cx = snake length
    sub dx, 2                ; Move two columns left
   
left_hit:
    cmp dx, [bx]             ; Compare new head with body positions
    jne exit_left1           ; no collision
    call Ending              ; end if collision

exit_left1:
    add bx, 2                ; next body position
    dec cx                   ; loop through entire length
    jnz left_hit             

left_mov:
    mov si, [bp+6]           ; si = snake pattern
    mov bx, [bp+4]           ; bx = snake head
    mov dx, [bx]             ; dx = current snake head position
    sub dx, 2                ; Move two columns left
    mov di, dx               ; di = new head position

    mov ax, 0xb800           
    mov es, ax               
    mov ah, 0x12             ; green on blue background

    mov al, [si]             ; al = snake pattern character
    mov [es:di], ax          ; draw new head
    mov cx, [bp+8]           ; cx = snake length
    mov di, [bx]             ; di = old head position
    inc si                   ; next char of snake pattern
   
    mov ah, 0x12             ; green on blue background
    mov al, [si]             ; al = snake pattern character
    mov [es:di], ax          ; draw old head as body

left_printing:
    mov ax, [bx]             ; ax = current body position
    mov [bx], dx             ; body position = new head position
    mov dx, ax               ; dx = current body position
    add bx, 2                ; next body position
    dec cx                   ; loop till string length
    jnz left_printing        

    mov di, dx               ; di = tail position
    mov ax, 0x0720           ; blank space
    mov [es:di], ax          ; clear tail

    push di                  
    sub di, 160              ; Move one row up
    cmp word[es:di], 0x4740  ; Compare with food
    je a3                    ; if food eaten
    mov [es:di], ax          ; blank space

a3:
    sub di, 160              ; Move one row up
    cmp word[es:di], 0x4740  ; Compare with food
    je b3                    ; if food eaten
    mov [es:di], ax          ; blank space

b3:
    pop di                   
    push di                  
    add di, 160              ; Move one row down
    cmp word[es:di], 0x4740  ; Compare with food
    je c3                    ; if food eaten
    mov [es:di], ax          ; blank space

c3:
    add di, 160              ; Move one row down
    cmp word[es:di], 0x4740  ; Compare with food
    je d3                    ; if food eaten
    mov [es:di], ax          ; blank space

d3:
    pop di                   
    push di                  
    add di, 2                ; Move one column right
    cmp word[es:di], 0x4740  ; Compare with food
    je e3                    ; if food eaten
    mov [es:di], ax          ; blank space

e3:
    add di, 2                ; Move one column right
    cmp word[es:di], 0x4740  ; Compare with food
    je f3                    ; if food eaten
    mov [es:di], ax          ; blank space

f3:
    pop di                   
    push di                  
    sub di, 2                ; Move one column left
    cmp word[es:di], 0x4740  ; Compare with food
    je g3                    ; if food eaten
    mov [es:di], ax          ; blank space

g3:
    sub di, 2                ; Move one column left
    cmp word[es:di], 0x4740  ; Compare with food
    je h3                    ; if food eaten
    mov [es:di], ax          ; blank space

h3:
    pop di                   
    call board_print         ; redraw border
    jmp left_exit            

left_exit:
    pop di                   
    pop si                   
    pop es                   
    pop dx                   
    pop cx                   
    pop bx                   
    pop ax                   
    pop bp                   
    ret 6                    




rightward_movement:          
    push bp                  
    mov bp, sp               
    push ax                  
    push bx                  
    push cx                  
    push dx                  
    push es                  
    push si                  
    push di                  
   
    mov bx, [bp+4]           ; bx = snake head pos
    mov dx, [bx]             ; dx = current snake head position
    mov cx, [bp+8]           ; cx = snake length
    add dx, 2                ; Move two columns right
   
right_hit:
    cmp dx, [bx]             ; Compare new head with body positions
    jne exit_right1          ; no collision
    call Ending              ; end if collision

exit_right1:
    add bx, 2                ; next body position
    dec cx                   ; loop through entire length
    jnz right_hit            

right_mov:
    mov si, [bp+6]           ; si = snake pattern
    mov bx, [bp+4]           ; bx = snake head
    mov dx, [bx]             ; dx = current snake head position
    add dx, 2                ; Move two columns right
    mov di, dx               ; di = new head position

    mov ax, 0xb800           
    mov es, ax               
    mov ah, 0x12             ; green on blue background

    mov al, [si]             ; al = snake pattern character
    mov [es:di], ax          ; draw new head
    mov cx, [bp+8]           ; cx = snake length
    mov di, [bx]             ; di = old head position
    inc si                   ; next char of snake pattern
   
    mov ah, 0x12             ; green on blue background
    mov al, [si]             ; al = snake pattern character
    mov [es:di], ax          ; draw old head as body

right_printing:
    mov ax, [bx]             ; ax = current body position
    mov [bx], dx             ; body position = new head position
    mov dx, ax               ; dx = current body position
    add bx, 2                ; next body position
    dec cx                   ; loop till string length
    jnz right_printing       

    mov di, dx               ; di = tail position
    mov ax, 0x0720           ; blank space
    mov [es:di], ax          ; clear tail

    push di                  
    sub di, 160              ; Move one row up
    cmp word[es:di], 0x4740  ; Compare with food
    je a4                    ; if food eaten
    mov [es:di], ax          ; blank space

a4:
    sub di, 160              ; Move one row up
    cmp word[es:di], 0x4740  ; Compare with food
    je b4                    ; if food eaten
    mov [es:di], ax          ; blank space

b4:
    pop di                   
    push di                  
    add di, 160              ; Move one row down
    cmp word[es:di], 0x4740  ; Compare with food
    je c4                    ; if food eaten
    mov [es:di], ax          ; blank space

c4:
    add di, 160              ; Move one row down
    cmp word[es:di], 0x4740  ; Compare with food
    je d4                    ; if food eaten
    mov [es:di], ax          ; blank space

d4:
    pop di                   
    push di                  
    add di, 2                ; Move one column right
    cmp word[es:di], 0x4740  ; Compare with food
    je e4                    ; if food eaten
    mov [es:di], ax          ; blank space

e4:
    add di, 2                ; Move one column right
    cmp word[es:di], 0x4740  ; Compare with food
    je f4                    ; if food eaten
    mov [es:di], ax          ; blank space

f4:
    pop di                   
    push di                  
    sub di, 2                ; Move one column left
    cmp word[es:di], 0x4740  ; Compare with food
    je g4                    ; if food eaten
    mov [es:di], ax          ; blank space

g4:
    sub di, 2                ; Move one column left
    cmp word[es:di], 0x4740  ; Compare with food
    je h4                    ; if food eaten
    mov [es:di], ax          ; blank space

h4:
    pop di                   
    call board_print         ; redraw border
    jmp right_exit           

right_exit:
    pop di                   
    pop si                   
    pop es                   
    pop dx                   
    pop cx                   
    pop bx                   
    pop ax                   
    pop bp                   
    ret 6                    








keyboard_print:              
    push ax                  
    push bx                  
    push cx                  
    push dx                  

repeat:
    cmp dword[curr_delay],30000
    je ren
    cmp dword[curr_delay],60000
    je rem
    cmp dword[curr_delay],90000
    je reh
ren:
    mov dword[delay],30000
re1:
    dec dword[delay]
    cmp dword[delay],0
    jne re1
    jmp Press_key
rem:
    mov dword[delay],60000
re2:
    dec dword[delay]
    cmp dword[delay],0
    jne re2
    jmp Press_key
    
reh:
    mov dword[delay],90000
re3:
    dec dword[delay]
    cmp dword[delay],0
    jne re3
Press_key:
    mov ah, 01h
    int 16h
    jz .No_input
    mov ah, 0
    int 16h
    
    ; Check for UP (W key OR Up Arrow)
    cmp ah, 0x11         ; W key scan code
    je .up
    cmp ah, 0x48         ; Up arrow scan code
    je .up
    
    ; Check for LEFT (A key OR Left Arrow)
    cmp ah, 0x1e         ; A key scan code
    je .left
    cmp ah, 0x4B         ; Left arrow scan code
    je .left
    
    ; Check for DOWN (S key OR Down Arrow)
    cmp ah, 0x1f         ; S key scan code
    je .down
    cmp ah, 0x50         ; Down arrow scan code
    je .down
    
    ; Check for RIGHT (D key OR Right Arrow)
    cmp ah, 0x20         ; D key scan code
    je .right
    cmp ah, 0x4D         ; Right arrow scan code
    je .right
    
    ; Check for exit keys
    cmp al, 27           ; ESC key
    je .exit_game
    cmp al, 'b'          ; B key
    je .exit_game
    cmp al, 'B'          ; B key (uppercase)
    je .exit_game
    
    jmp repeat           ; If no valid key, repeat

.exit_game:
    call Ending          
    
.No_input:
    cmp byte[constant_way], 0
    je .up
    cmp byte[constant_way], 1
    je .down
    cmp byte[constant_way], 2
    je .left
    cmp byte[constant_way], 3
    je .right
       
.up:
    mov byte[constant_way], 0
    push word[length]
    mov bx, My_snake
    push bx
    mov bx, head_of_snake
    push bx
    call UPWARD
    jmp checking

.down:
    mov byte[constant_way], 1
    push word[length]
    mov bx, My_snake
    push bx
    mov bx, head_of_snake
    push bx
    call downward_movement
    jmp checking

.left:
    mov byte[constant_way], 2
    push word[length]
    mov bx, My_snake
    push bx
    mov bx, head_of_snake
    push bx
    call leftward_movement
    jmp checking

.right:
    mov byte[constant_way], 3
    push word[length]
    mov bx, My_snake
    push bx
    mov bx, head_of_snake
    push bx
    call rightward_movement
    jmp checking

checking:
    call Chech_if_dead
    push word[Location_of_food]
    push word[length]
    mov ax, My_snake
    push ax
    mov ax, head_of_snake
    push ax
    call check_food
    jmp repeat
;==================================================================================================;




Chech_if_dead:            
    push ax                
    push bx                
    push cx                
    push dx                
    push di                
    push si                
    push es                

r1:
    mov dx, 158            ; dx = right border column
rcoll:
    add dx, 160            ; next row
    cmp dx, 4000           ; Check if right border reached
    jae l1                 
    cmp [head_of_snake], dx ; Compare head with border
    je finish              ; collision detected
    ja rcoll               

l1:
    mov dx, 0              ; dx = left border
lcoll:
    add dx, 160            ; next row
    cmp dx, 4000           ; Check if left border reached
    jae dddd               
    cmp [head_of_snake], dx ; Compare head with border
    je finish              ; collision detected
    ja lcoll               

u1:    
    mov dx, 320            ; dx = top border row
upcoll:
    add dx, 2              ; next column
    cmp dx, 480            ; Check if top border reached
    jae dddd               
    cmp [head_of_snake], dx ; Compare head with border
    je finish              ; collision detected
    ja upcoll              

dddd:
    mov dx, 3840           ; dx = bottom border row
dcoll:
    add dx, 2              ; next column
    cmp dx, 4000           ; Check if bottom border reached
    jae end                
    cmp [head_of_snake], dx ; Compare head with border
    je finish              ; collision detected
    jb dcoll               

finish:
    pop es                 
    pop si                 
    pop di                 
    pop dx                 
    pop cx                 
    pop bx                 
    pop ax                 
    call Ending            

end:
    pop es                 
    pop si                 
    pop di                 
    pop dx                 
    pop cx                 
    pop bx                 
    pop ax                 
    
 
    ret                           






Random_pos_generator:                          
    push ax                     
    push bx                     
    push cx                     
    push dx                     
    push si                     
    push di                     
    push es                     

inloop:
    mov ah, 00h               
    int 1ah

    mov ax, dx
    mov dx, 0                  
    mov cx, 25                 ; max rows
    div cx                     

    mov [row], dx              

    mov ah, 00h
    int 1ah

    mov ax, dx
    mov dx, 0                  
    mov cx, 80                 ; max columns
    div cx                     

    mov [col], dx              

    mov ax, 80
    mov bx, [row]
    mul bx                     
    mov bx, [col]
    add ax, bx
    shl ax, 1                  ; times 2 for video memory offset

not_at_up:
    mov di, 0                  ; di = top border
loop_up:
    cmp di, ax                 
    je inloop                  
    add di, 2                  
    cmp di, 480                
    jb loop_up                 

not_at_down:
    mov di, 3840               ; di = bottom border
loop_down:
    cmp di, ax                 
    je inloop                  
    add di, 2                  
    cmp di, 4000               
    jb loop_down               

not_at_left:
    mov di, 0                  ; di = left border
loop_left:
    cmp di, ax                 
    je inloop                  
    add di, 160                ; next row
    cmp di, 4000               
    jb loop_left               

not_at_right:
    mov di, 158                ; di = right border
loop_right:
    cmp di, ax                 
    je inloop                  
    add di, 160                ; next row
    cmp di, 4000               
    jb loop_right              

cmp ax, 4000                   
jg inloop                      

mov word [Location_of_food], ax   
cmp word [Location_of_food], 0x0f6f 
je inloop                      

pop es                         
pop di                         
pop si                         
pop dx                         
pop cx                         
pop bx                         
pop ax                         
ret                              





food:                                 
    push ax                        
    push bx                        
    push cx                        
    push dx                        
    push di                        
    push es                        
    
    call Random_pos_generator                
    
    mov ax, 80                    
    mov cx, [row]                 
    mul cx                        
    mov cx, [col]                 
    add ax, cx                    
    shl ax, 1                     ; times 2 for video memory offset
    mov di, ax                    
    
    mov ax, 0xb800                
    mov es, ax                    
    
    mov ax, 0x4740                ; food character and attribute
    mov word [es:di], ax          
    
    pop es                           
    pop di                           
    pop dx                           
    pop cx                           
    pop bx                           
    pop ax                           
    
    ret                                 



check_food:                          
    push bp                          
    mov bp, sp                       
    push ax                          
    push bx                          
    push cx                          
    push dx                          
    push es                          
    push di                          
    push si                          

    mov ax, 0xb800                   
    mov es, ax                     
    mov ax, 0x0720                  
    mov di, 0                       

firstline:
    mov word [es:di], ax        
    add di, 2                    
    cmp di, 158                   
    jne firstline                

    mov bx, [bp + 4]                  
    mov dx, [bp + 10]                 

    cmp [bx], dx                      
    jne not_change                    

    add word [score], 1               
    mov ax, 1                   
    push ax                     
    mov ax, 8                   
    push ax                     
    call Printing_The_Score              

    mov cx, [bp + 8]                  
    dec cx
    shl cx, 1                         
    add bx, cx                        
    mov dx, [bx]                      
    sub dx, [bx - 2]                  

    mov ax, [bx]                      
    add ax, dx                        
    mov dx, ax                        

    shr cx, 1                          
    inc cx                             
    add word[length], 1               

    add bx, 2                         
    mov [bx], dx                      
    mov si, [bp + 6]                  

    mov ax, 0xb800                    
    mov es, ax                        
    mov di, dx                        
    mov ah, 0x0f                      
    mov al, [si]                      

    mov [es:di], ax                   


    mov ax, 0xb800                    
    mov es, ax                        

    call food                         

not_change:
    pop si                            
    pop di                            
    pop es                            
    pop dx                            
    pop cx                            
    pop bx                            
    pop ax                            
    pop bp                            
ret 8                            


menu_display:
   call clrscr                              
   call art                                 
   
   mov ax, 35               ; COLUMN
   push ax                                  
   mov ax, 9                ; ROW
   push ax      
   
   mov ax, 0x0d             ; attribute
   push ax                                  
   mov ax, men
   push ax                                  
   
   call printstr
   
   ; Print "Press S to START"
   mov ax, 30                               ; COLUMN
   push ax
   mov ax, 11                               ; ROW
   push ax
   mov ax, 0x0B                             ; BRIGHT GREEN text on BLACK background
   push ax
   mov ax, menu1                            
   push ax
   call printstr
   
    mov ax, 30                               ; COLUMN
   push ax
   mov ax, 12                               ; ROW
   push ax
   mov ax, 0x0A                             ; BRIGHT GREEN text on BLACK background
   push ax
   mov ax, menu3                            
   push ax
   call printstr

   ; Print "Press E to EXIT"
   mov ax, 30                               ; COLUMN
   push ax
   mov ax, 13                               ; ROW
   push ax
   mov ax, 0x0C                             ; BRIGHT RED text on BLACK background
   push ax
   mov ax, menu2                            
   push ax
   call printstr

   ret


; COLOR REFERENCE:
; 0x00 = Black on Black
; 0x01 = Blue on Black
; 0x02 = Green on Black
; 0x03 = Cyan on Black
; 0x04 = Red on Black
; 0x05 = Magenta on Black
; 0x06 = Brown on Black
; 0x07 = Light Gray on Black
; 0x08 = Dark Gray on Black
; 0x09 = Light Blue on Black
; 0x0A = Light Green on Black
; 0x0B = Light Cyan on Black
; 0x0C = Light Red on Black
; 0x0D = Light Magenta on Black
; 0x0E = Yellow on Black
; 0x0F = White on Black

;==================================================================================================;

Starting_the_game:

    call clrscr                              
    call board_print                             
    
    push word[length]                        
    mov ax, My_snake                       
    push ax                                  
    mov ax, head_of_snake                    
    push ax                                  
    call Printing_The_Snake                         
    call food                                
    mov ah, 01h
    int 21h
    call keyboard_print                            


Intro:

    call art

   mov ax, 32               ; x - ROW
   push ax                                  
   mov ax, 9                ; y - COLUMN
   push ax      
   
   mov ax, 0x0d             ; attribute
   push ax                                  
   mov ax, title
   push ax                                  
   
   call printstr                            


   mov ax, 33               ; x - ROW
   push ax                                  
   mov ax, 11               ; y - COLUMN
   push ax                              
   
   mov ax, 0x0f             ; attribute
   push ax                                  
   mov ax, madeby                             
   push ax                                  
   
   call printstr                            


   mov ax, 25                  
   push ax                                  
   mov ax, 13                    
   push ax                                  
   mov ax, 0x0f                             
   push ax                                  
   mov ax, name1                             
   push ax                                  
   
   call printstr                            

   mov ax, 25                  
   push ax                                  
   mov ax, 14                     
   push ax                                  
   mov ax, 0x0f                             
   push ax                                  
   mov ax, name2                       
   push ax                                  
   
   call printstr                             

   
 


   mov ah, 0x1                              
   int 0x21                                 
    ret;
DIFF:
    call clrscr                              
    call art                                 
   
    mov ax, 32               ; COLUMN
    push ax                                  
    mov ax, 11                ; ROW
    push ax      
   
    mov ax, 0x0d             ; attribute
    push ax                                  
    mov ax, diff1
    push ax                                  
    call printstr
   
    ; Print difficulty 2
    mov ax, 32                               ; COLUMN
    push ax
    mov ax, 12                               ; ROW
    push ax
    mov ax, 0x0A                             ; BRIGHT GREEN text on BLACK background
    push ax
    mov ax, diff2                            
    push ax
    call printstr

    ; Print difficulty 3
    mov ax, 32                               ; COLUMN
    push ax
    mov ax, 13                               ; ROW
    push ax
    mov ax, 0x0C                             ; BRIGHT RED text on BLACK background
    push ax
    mov ax, diff3                            
    push ax
    call printstr
   
Loopi_loopi:
    mov ah, 0
    int 16h             ; Get the character
    
    cmp al,'1'
    je normal
    cmp al,'2'
    je medium
    cmp al,'3'
    je hard
    
    jmp Loopi_loopi    ; Invalid key, loop again
    
hard:
    mov dword[curr_delay],30000
    jmp end1
medium:
    mov dword[curr_delay],60000
    jmp end1
normal:
    mov dword[curr_delay],90000
end1:
    jmp S


start:

   call clrscr                              

   call Intro

S:  
    call clrscr         ; Clear the screen
    call menu_display
    mov ah, 0
    int 16h             ; Get the character

    cmp al, 's'
    je Starting_the_game
    
    cmp al,'d'
    je DIFF

    cmp al, 'e'
    je e

    jmp S               ; If the pressed key is not 's', 'i', or 'e', go back to the menu

e:  
    mov ax, 0x4c00                           
    int 0x21
    
; Art function - ROW stays at 20, COLUMN increments from 7 to 26

art:
   ; Print line 1 (s1)
   mov ax, 20               ; x - ROW
   push ax
   mov ax, 3                ; y - COLUMN
   push ax
   mov ax, 0x0b             ; attribute
   push ax
   mov ax, s1
   push ax
   call printstr

   ; Print line 2 (s2)
   mov ax, 20               ; x - ROW
   push ax
   mov ax, 4                ; y - COLUMN
   push ax
   mov ax, 0x0b             ; attribute
   push ax
   mov ax, s2
   push ax
   call printstr

   ; Print line 3 (s3)
   mov ax, 20               ; x - ROW
   push ax
   mov ax, 5                ; y - COLUMN
   push ax
   mov ax, 0x0b             ; attribute
   push ax
   mov ax, s3
   push ax
   call printstr

   ; Print line 4 (s4)
   mov ax, 20               ; x - ROW
   push ax
   mov ax, 6               ; y - COLUMN
   push ax
   mov ax, 0x0b             ; attribute
   push ax
   mov ax, s4
   push ax
   call printstr

   ; Print line 5 (s5)
   mov ax, 20               ; x - ROW
   push ax
   mov ax, 7               ; y - COLUMN
   push ax
   mov ax, 0x0b             ; attribute
   push ax
   mov ax, s5
   push ax
   call printstr

   ; Print line 6 (s6)
   mov ax, 20               ; x - ROW
   push ax
   mov ax, 8              ; y - COLUMN
   push ax
   mov ax, 0x0b             ; attribute
   push ax
   mov ax, s6
   push ax
   call printstr

   ; Print line 7 (s7)
   mov ax, 20               ; x - ROW
   push ax
   mov ax, 9               ; y - COLUMN
   push ax
   mov ax, 0x0b             ; attribute
   push ax
   mov ax, s7
   push ax
   call printstr

   ; Print line 8 (s8)
   mov ax, 20               ; x - ROW
   push ax
   mov ax, 10               ; y - COLUMN
   push ax
   mov ax, 0x0b             ; attribute
   push ax
   mov ax, s8
   push ax
   call printstr

   ; Print line 9 (s9)
   mov ax, 20               ; x - ROW
   push ax
   mov ax, 11               ; y - COLUMN
   push ax
   mov ax, 0x0b             ; attribute
   push ax
   mov ax, s9
   push ax
   call printstr

   ; Print line 10 (s10)
   mov ax, 20               ; x - ROW
   push ax
   mov ax, 12               ; y - COLUMN
   push ax
   mov ax, 0x0b             ; attribute
   push ax
   mov ax, s10
   push ax
   call printstr

   ; Print line 11 (s11)
   mov ax, 20               ; x - ROW
   push ax
   mov ax, 13               ; y - COLUMN
   push ax
   mov ax, 0x0b             ; attribute
   push ax
   mov ax, s11
   push ax
   call printstr

   ; Print line 12 (s12)
   mov ax, 20               ; x - ROW
   push ax
   mov ax, 14               ; y - COLUMN
   push ax
   mov ax, 0x0b             ; attribute
   push ax
   mov ax, s12
   push ax
   call printstr

   ; Print line 13 (s13)
   mov ax, 20               ; x - ROW
   push ax
   mov ax, 15               ; y - COLUMN
   push ax
   mov ax, 0x0b             ; attribute
   push ax
   mov ax, s13
   push ax
   call printstr

   ; Print line 14 (s14)
   mov ax, 20               ; x - ROW
   push ax
   mov ax, 16               ; y - COLUMN
   push ax
   mov ax, 0x0b             ; attribute
   push ax
   mov ax, s14
   push ax
   call printstr

   ; Print line 15 (s15)
   mov ax, 20               ; x - ROW
   push ax
   mov ax, 17               ; y - COLUMN
   push ax
   mov ax, 0x0b             ; attribute
   push ax
   mov ax, s15
   push ax
   call printstr

   ; Print line 16 (s16)
   mov ax, 20               ; x - ROW
   push ax
   mov ax, 18               ; y - COLUMN
   push ax
   mov ax, 0x0b             ; attribute
   push ax
   mov ax, s16
   push ax
   call printstr

   ; Print line 17 (s17)
   mov ax, 20               ; x - ROW
   push ax
   mov ax, 19               ; y - COLUMN
   push ax
   mov ax, 0x0b             ; attribute
   push ax
   mov ax, s17
   push ax
   call printstr

   ; Print line 18 (s18)
   mov ax, 20               ; x - ROW
   push ax
   mov ax, 20               ; y - COLUMN
   push ax
   mov ax, 0x0b             ; attribute
   push ax
   mov ax, s18
   push ax
   call printstr

   ; Print line 19 (s19)
   mov ax, 20               ; x - ROW
   push ax
   mov ax, 21               ; y - COLUMN
   push ax
   mov ax, 0x0b             ; attribute
   push ax
   mov ax, s19
   push ax
   call printstr

   ; Print line 20 (s20)
   mov ax, 20               ; x - ROW
   push ax
   mov ax, 22               ; y - COLUMN
   push ax
   mov ax, 0x0b             ; attribute
   push ax
   mov ax, s20
   push ax
   call printstr

   ret
