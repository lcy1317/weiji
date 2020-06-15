;extrn carsout:far
;extrn carsin:far
;extrn display2:far
;extrn chuzhiset:far
;extrn jinzhi:far
;extrn num1:byte
;extrn num2:byte
;extrn cars:byte
;extrn gen:far

CNTdispP EQU 160*15+60

int08  EQU  08    ;8253 T0 中断型号n
int09  EQU  09    ;Keyboard
irq_mask8_15  equ 0FFH
irq0_mask equ 11111110B   ;启用定时器的掩码
irq1_mask equ 11111101B   ;键盘
KESCDOWN EQU 01H
K1DOWN EQU 02H  ;A口出
K1UP EQU 82H   ;A口出检测1s后是否还在
K2DOWN EQU 03H  ;A口入
K2UP EQU 83H  ;A口入检测1s后是否还在
K3DOWN EQU 04H  ;B口出
K3UP EQU 84H   ;B口出检测1s后是否还在
K4DOWN EQU 05H ;B口入
K4UP EQU 85H   ;B口入出检测1s后是否还在
K5DOWN EQU 06H
K6DOWN EQU 07H
K7DOWN EQU 08H
K8DOWN EQU 09H
LEDposition EQU 160*20+10
jtposition EQU 160*8+2
jtpositionB EQU 160*8+112
systemTimeP EQU 160*2+78 ;系统时间放置位置
recordtimeP EQU 160*4+70
recordkouP EQU 160*4+84

data  segment
cs08  DW 0  ;保存Interrupt vectors 4 INT08 & INT09
ip08  DW 0
cs09  DW 0
ip09  DW 0
flagesc db 0
flagjtfangxiangA db 0 ;0表出，1表进
flagjtfangxiangB db 0
flagAout db 0    ;A出按下后就变为1
flagAout1 db 0  ;延时到了后箭头显示的标志
flagAoutjc db 0 ;1s后再次检测按键是否松开
flagAin db 0
flagAin1 db 0
flagAinjc db 0
flagBout db 0    
flagBout1 db 0  
flagBoutjc db 0
flagBin db 0    
flagBin1 db 0  
flagBinjc db 0
outflagA db 0
outflagB db 0
inflagA db 0
inflagB db 0

nownum db 0
totnum db 0
aAsc db 41H
bAsc db 42H
oAsc db 4FH
iAsc db 49H

CNTdispPA dw 0  ;160*8+2
CNTdispPB dw 0  ;160*8+122

NumPostion dw 0   ;车位数

string1 db ' VRAM:Hit cammand key begin or go on, ESC quit '
t0scnt2s  dw 0       ;for basic counting
t0scnt2sAO dw 0
t0scnt2sAI dw 0
t0scnt2sBO dw 0
t0scnt2sBI dw 0
t0scnt1s  dw 0       ;for basic counting
t0scnt1sAI  dw 0
t0scnt1sBI  dw 0
t0scnt3s  dw 0
t0scnt3sAO  dw 0
t0scnt3sBO  dw 0
t0cntjtA dw 0
t0cntjtB dw 0
t0scnt0  dw 0      ;实时时钟计ms
t0scnt1  db 0      ;实时时钟秒个位
t0scnt2  db 0      ;实时时钟秒十位
t0scnt3  db 0      ;实时时钟分个位
headP_DI DW 0      ;bedining position for VRAM (ES:) DI
recordt0 dw 0
recordt1 dw 0
recordt2 dw 0
recordt3 dw 0
recordt4 dw 0
recordt5 dw 0
recordt6 dw 0
recordt7 dw 0
recordt8 dw 0
recordt9 dw 0
records0 db 0
records1 db 0
records2 db 0
records3 db 0
records4 db 0
records5 db 0
records6 db 0
records7 db 0
records8 db 0
records9 db 0
records00 db 0
records11 db 0
records22 db 0
records33 db 0
records44 db 0
records55 db 0
records66 db 0
records77 db 0
records88 db 0
records99 db 0
records000 db 0
records111 db 0
records222 db 0
records333 db 0
records444 db 0
records555 db 0
records666 db 0
records777 db 0
records888 db 0
records999 db 0
testing1 db 0
testing2 db 0
testing3 db 0
position db 0
wanlea dw 0
flagAII db 0
flagBII db 0
sBF0$ db ' the parking system begins '
sBF1$ db 'Poaorokoionogo osoyosotoeomo ocolooosoeodo.o oCooopoyoroiogohoto@o6o1o5o1o8o1o1o8oCoWoDo o6o1o5o1o8o1o2o8oJoYoHo'
SCLR  DB  0,0  ;clear a char with black color

Ndotmatrix db 000H,000H,000H,0FEH,0FEH,000H,000H,000H   ;'箭头出'
           db 000H,000H,0FEH,0FEH,000H,000H,000H,000H
           db 000H,0FEH,0FEH,000H,000H,000H,000H,000H
           db 0FEH,0FEH,0FEH,0FEH,0FEH,0FEH,0FEH,0FEH
           db 0FEH,0FEH,0FEH,0FEH,0FEH,0FEH,0FEH,0FEH
           db 000H,0FEH,0FEH,000H,000H,000H,000H,000H
           db 000H,000H,0FEH,0FEH,000H,000H,000H,000H
           db 000H,000H,000H,0FEH,0FEH,000H,000H,000H
Nm1 db 000H,000H,000H,0FEH,0FEH,000H,000H,000H   ;'箭头入'
           db 000H,000H,000H,000H,0FEH,0FEH,000H,000H
           db 000H,000H,000H,000H,000H,0FEH,0FEH,000H
           db 0FEH,0FEH,0FEH,0FEH,0FEH,0FEH,0FEH,0FEH
           db 0FEH,0FEH,0FEH,0FEH,0FEH,0FEH,0FEH,0FEH
           db 000H,000H,000H,000H,000H,0FEH,0FEH,000H
           db 000H,000H,000H,000H,0FEH,0FEH,000H,000H
           db 000H,000H,000H,0FEH,0FEH,000H,000H,000H

num1 db 6H
num2 db 7H
cars db 63H
tim dw 50000

setup db 0ah,0dh,0ah,0dh,0ah,0dh
		db '           *********************************************************',0ah,0dh
		db '           *                                                       *',0ah,0dh
		db '           *                 Southeast University                  *',0ah,0dh
		db '           *                                                       *',0ah,0dh
		db '           *             Parking Lot Management System             *',0ah,0dh
		db '           *                                                       *',0ah,0dh
		db '           *                                                       *',0ah,0dh
		db '           *     Copyright@ Chenwendi   61518118                   *',0ah,0dh
		db '           *                Jiangyiheng 61518128                   *',0ah,0dh
		db '           *                                                       *',0ah,0dh
		db '           *           Contact: luochengyu1317@gmail.com           *',0ah,0dh
		db '           *                                                       *',0ah,0dh
		db '           *    Code Resource: https://github.com/lcy1317/weiji    *',0ah,0dh
		db '           *                                                       *',0ah,0dh
		db '           *         1-A cars out         2-A cars in              *',0ah,0dh
		db '           *         3-B cars out         4-B cars in              *',0ah,0dh
		db '           *********************************************************',0ah,0dh
		db 0ah,0dh,0ah,0dh,0ah,0dh
		db '                            please set up the number',0ah,0dh
		db '                            ','$'

fullmessage db 'Tohoeo opoaorokoionogo oloooto oioso oeomopotoyo.o oOonoloyo oiono.o'
emptymessage db 'Tohoeo opoaorokoionogo oloooto oioso ofouololo.o oOonoloyo ooouoto.o'

SCLRR  DB  0,0  ;clear a char with black color
;7*9 dotmatrix for '0'-'9'
Ndotmatrix2 db 00H,0FEH,0FEH,0FEH,0FEH,0FEH,00H   ;'0'
           db 0FEH,00H,00H,00H,00H,00H,0FEH
           db 0FEH,00H,00H,00H,00H,0FEH,0FEH
           db 0FEH,00H,00H,00H,0FEH,00H,0FEH
           db 0FEH,00H,00H,0FEH,00H,00H,0FEH
           db 0FEH,00H,0FEH,00H,00H,00H,0FEH
           db 0FEH,0FEH,00H,00H,00H,00H,0FEH
           db 0FEH,00H,00H,00H,00H,00H,0FEH
           db 00H,0FEH,0FEH,0FEH,0FEH,0FEH,00H
Nm11        db 00H,00H,00H,0FEH,00H,00H,00H    ;'1'
           db 00H,00H,00H,0FEH,00H,00H,00H
           db 00H,00H,0FEH,0FEH,00H,00H,00H
           db 00H,00H,00H,0FEH,00H,00H,00H
           db 00H,00H,00H,0FEH,00H,00H,00H
           db 00H,00H,00H,0FEH,00H,00H,00H
           db 00H,00H,00H,0FEH,00H,00H,00H
           db 00H,00H,00H,0FEH,00H,00H,00H
           db 00H,0FEH,0FEH,0FEH,0FEH,0FEH,00H
Nm2        db 00H,0FEH,0FEH,0FEH,0FEH,0FEH,00H   ;'2'
           db 0FEH,00H,00H,00H,00H,00H,0FEH
           db 00H,00H,00H,00H,00H,00H,0FEH
           db 00H,00H,00H,00H,00H,0FEH,00H
           db 00H,00H,00H,0FEH,0FEH,00H,00H
           db 00H,00H,0FEH,00H,00H,00H,00H
           db 00H,0FEH,00H,00H,00H,00H,00H
           db 0FEH,00H,00H,00H,00H,00H,00H
           db 0FEH,0FEH,0FEH,0FEH,0FEH,0FEH,0FEH
Nm3        db 00H,0FEH,0FEH,0FEH,0FEH,0FEH,00H   ;'3'
           db 0FEH,00H,00H,00H,00H,00H,0FEH
           db 00H,00H,00H,00H,00H,00H,0FEH
           db 00H,00H,00H,00H,00H,00H,0FEH
           db 00H,00H,0FEH,0FEH,0FEH,0FEH,00H
           db 00H,00H,00H,00H,00H,00H,0FEH
           db 00H,00H,00H,00H,00H,00H,0FEH
           db 0FEH,00H,00H,00H,00H,00H,0FEH
           db 00H,0FEH,0FEH,0FEH,0FEH,0FEH,00H
Nm4        db 00H,00H,00H,00H,00H,0FEH,00H    ;'4'
           db 00H,00H,00H,00H,0FEH,0FEH,00H
           db 00H,00H,00H,0FEH,00H,0FEH,00H
           db 00H,00H,0FEH,00H,00H,0FEH,00H
           db 00H,0FEH,00H,00H,00H,0FEH,00H
           db 0FEH,0FEH,0FEH,0FEH,0FEH,0FEH,0FEH
           db 00H,00H,00H,00H,00H,0FEH,00H
           db 00H,00H,00H,00H,00H,0FEH,00H
           db 00H,00H,00H,00H,00H,0FEH,00H
Nm5        db 0FEH,0FEH,0FEH,0FEH,0FEH,0FEH,0FEH   ;'5'
           db 0FEH,00H,00H,00H,00H,00H,00H
           db 0FEH,00H,00H,00H,00H,00H,00H
           db 0FEH,00H,00H,00H,00H,00H,00H
           db 0FEH,0FEH,0FEH,0FEH,0FEH,0FEH,00H
           db 00H,00H,00H,00H,00H,00H,0FEH
           db 00H,00H,00H,00H,00H,00H,0FEH
           db 0FEH,00H,00H,00H,00H,00H,0FEH
           db 00H,0FEH,0FEH,0FEH,0FEH,0FEH,00H
Nm6        db 00H,0FEH,0FEH,0FEH,0FEH,0FEH,00H   ;'6'
           db 0FEH,00H,00H,00H,00H,00H,0FEH
           db 0FEH,00H,00H,00H,00H,00H,00H
           db 0FEH,00H,00H,00H,00H,00H,00H
           db 0FEH,0FEH,0FEH,0FEH,0FEH,0FEH,00H
           db 0FEH,00H,00H,00H,00H,00H,0FEH
           db 0FEH,00H,00H,00H,00H,00H,0FEH
           db 0FEH,00H,00H,00H,00H,00H,0FEH
           db 00H,0FEH,0FEH,0FEH,0FEH,0FEH,00H
Nm7        db 0FEH,0FEH,0FEH,0FEH,0FEH,0FEH,0FEH   ;'7'
           db 0FEH,00H,00H,00H,00H,00H,0FEH
           db 00H,00H,00H,00H,00H,0FEH,00H
           db 00H,00H,00H,00H,0FEH,00H,00H
           db 00H,00H,00H,0FEH,00H,00H,00H
           db 00H,00H,0FEH,00H,00H,00H,00H
           db 00H,00H,0FEH,00H,00H,00H,00H
           db 00H,00H,0FEH,00H,00H,00H,00H
           db 00H,00H,0FEH,00H,00H,00H,00H
Nm8        db 00H,0FEH,0FEH,0FEH,0FEH,0FEH,00H   ;'8'
           db 0FEH,00H,00H,00H,00H,00H,0FEH
           db 0FEH,00H,00H,00H,00H,00H,0FEH
           db 0FEH,00H,00H,00H,00H,00H,0FEH
           db 00H,0FEH,0FEH,0FEH,0FEH,0FEH,00H
           db 0FEH,00H,00H,00H,00H,00H,0FEH
           db 0FEH,00H,00H,00H,00H,00H,0FEH
           db 0FEH,00H,00H,00H,00H,00H,0FEH
           db 00H,0FEH,0FEH,0FEH,0FEH,0FEH,00H
Nm9        db 00H,0FEH,0FEH,0FEH,0FEH,0FEH,0FEH   ;'9'
           db 0FEH,00H,00H,00H,00H,00H,0FEH
           db 0FEH,00H,00H,00H,00H,00H,0FEH
           db 0FEH,00H,00H,00H,00H,00H,0FEH
           db 00H,0FEH,0FEH,0FEH,0FEH,0FEH,0FEH
           db 00H,00H,00H,00H,00H,00H,0FEH
           db 00H,00H,00H,00H,00H,00H,0FEH
           db 0FEH,00H,00H,00H,00H,00H,0FEH
           db 00H,0FEH,0FEH,0FEH,0FEH,0FEH,00H
NmA        db 00H,0FEH,0FEH,0FEH,0FEH,00H,00H   ;'A'--5*7
           db 0FEH,0FEH,00H,00H,0FEH,0FEH,00H
           db 0FEH,0FEH,00H,00H,0FEH,0FEH,00H
           db 0FEH,0FEH,0FEH,0FEH,0FEH,0FEH,00H
           db 0FEH,0FEH,00H,00H,0FEH,0FEH,00H
           db 0FEH,0FEH,00H,00H,0FEH,0FEH,00H
           db 0FEH,0FEH,00H,00H,0FEH,0FEH,00H

NmB        db 0FEH,0FEH,0FEH,0FEH,0FEH,00H,00H   ;'B'--5*7
           db 0FEH,0FEH,00H,00H,0FEH,0FEH,00H
           db 0FEH,0FEH,00H,00H,0FEH,0FEH,00H
           db 0FEH,0FEH,0FEH,0FEH,00H,00H,00H
           db 0FEH,0FEH,00H,00H,0FEH,0FEH,00H
           db 0FEH,0FEH,00H,00H,0FEH,0FEH,00H
           db 0FEH,0FEH,0FEH,0FEH,0FEH,00H,00H



data ends

stacks segment stack
      db 256 dup (?)
stacks ends
code segment
      assume cs:code,ds:data,ss:stacks
main proc far
start:	
	 mov ax,data
        mov ds,ax
	 mov ax,stacks
        mov ss,ax
	 mov sp,256
	 
	 mov dx,offset setup
	 mov ah,09H
    int 21H
	 call chuzhiset	
	 ;call jinzhi
	 mov al,40H 
	 ;mov cars,al
		
		
	 mov CNTdispPA,160*8+2
	 mov CNTdispPB,160*8+112
        mov di,160*9+64
	
;Filling buffers in VRAM B800:0-FFFH(the Page#0)
VRAM0:  mov ah,0
        mov al,03H
        int 10H  ;choose char mode  80*25
	 mov ax,seg sBF0$
        mov es,ax
        lea bp,sBF0$      ;ES:BP=string pointer
        mov dx,0117H      ;DH=Disp Row No. DL=Column No.
        mov bh,0          ;B800 buffers Page No.
        mov cx,sBF1$-SBF0$         ;Total bytes
        mov al,0          ;Choose format:BL=Attrinute byte,string:C1,C2....
        mov bl,00000011B       ;Attribute byte
        mov ah,13H        ;Direct writing Function code
        int 10H
        mov ax,0B800H
        mov es,ax
        mov ah,1
        int 21H
        call display3
        cmp al,1bH
        jnz VRAM1
        JMP VRAMEXIT      ;EXIT
VRAM1:  
        call KBInt0     ;IRQ1 & INT09Hfor KB interrupt Initialization
	 call T0INT0
	
flag1: 
	 call display2
	 
	cmp flagesc,1   ;看是否键盘中断按下了esc
	jz exit1
Aout:cmp flagAout1,0
	jz Ain
	call jtOutdisp
	jmp Bout
Ain:cmp flagAin1,0
	jz Bout
	call jtIndisp
Bout:cmp flagBout1,0
	jz Bin
	call jtOutdispB
	jmp final
Bin:cmp flagBin1,0
	jz final
	call jtIndispB
final:	call delay ;刷新一下
	cmp flagAII,1
	jnz final11
	call jtIndisp
	call jtIndispB
	mov flagAII,0
	
final11:cmp flagBII,1
	jnz final111
	call jtIndisp
	call jtIndispB
	mov flagBII,0
final111:jmp flag1
	

	
	
exit1:
	mov ax,seg sBF1$
        mov ds,ax
        mov si,offset sBF1$
        mov di,160*24+24
        mov cx,SCLR-sBF1$
        cld
        rep movsB

        call INT09_RST         ;;Restore old INT 09 interrupt Vector
        mov ah,0
        int 16H      ;any key
VRAMEXIT:mov ah,6    ;clear screen or page scrolling up (to next page)
        mov al,0    ;scroll up lines
        mov bh,7    ;widows bottom lines attr. 
        mov cx,0    ;windows up-left conner position: CH=Row,CL=Column No
        mov dx,184FH;right bottom conner
        int 10H
        mov AX,4C00H
        int 21H
main endp

jtOutdisp  proc
         push es
         push di
         push cx
         mov ax,0B800H
         mov es,ax
         mov al,0      ;箭头出就是data段起始位置
         mov ah,8*8
         mul ah
         mov bx,offset Ndotmatrix
         add bx,ax    ;point to 0-9 matrix   bx指向了data定义里的数字几的矩阵     
dispq:cmp CNTdispPA,jtposition+30   ;若是第一个起始位置，则要清空最后位置的
	  jz qing1
	  mov ax,0B800H
         mov es,ax
	  add CNTdispPA,6
	  mov di,CNTdispPA     ;CntdispPosition   点阵起始位置
	  call qing0dotmatrix
	  sub CNTdispPA,6
	  
	  mov ax,0B800H
         mov es,ax
	  mov bx,offset Ndotmatrix
	  
	 mov ah,02H          ;attr.byte  0100红色  0010绿色
	 mov di,CNTdispPA
	  call dispdotmatrix
	  jmp exit2
qing1:
	  mov ax,0B800H
         mov es,ax
	  sub CNTdispPA,30
	  mov di,CNTdispPA
	  call qing0dotmatrix
	  add CNTdispPA,30
  
	  mov ax,0B800H
         mov es,ax
	  mov bx,offset Ndotmatrix
	  
	 mov ah,02H 
	 mov di,CNTdispPA
         call dispdotmatrix   ;disp the dot matrix
exit2:		 
	  pop cx
         pop di
         pop es
         ret
jtOutdisp endp

jtIndisp  proc
         push es
         push di
         push cx
         mov ax,0B800H
         mov es,ax
         mov al,1      ;箭头出就是data段起始位置
         mov ah,8*8
         mul ah
         mov bx,offset Ndotmatrix
         add bx,ax    ;point to 0-9 matrix   bx指向了data定义里的数字几的矩阵
         
dispq1:
         cmp CNTdispPA,jtposition   ;若是第五个，则要清空最后位置的
	  jz qing2
	  mov ax,0B800H
         mov es,ax
	  sub CNTdispPA,6
	  mov di,CNTdispPA     ;CNTdispPAosition   点阵起始位置
	  call qing0dotmatrix
	  add CNTdispPA,6
	  
	  mov ax,0B800H
         mov es,ax
	  ;mov bx,offset Ndotmatrix
	  cmp cars,0
	 jnz lvse1
	 mov ah,04H
	 jmp dispqq1	 
lvse1:mov ah,02H          ;attr.byte  0100红色  0010绿色
dispqq1:mov di,CNTdispPA
	  call dispdotmatrix
	  jmp exit3
qing2:
	  mov ax,0B800H
         mov es,ax
	  add CNTdispPA,30
	  mov di,CNTdispPA
	  call qing0dotmatrix
	  sub CNTdispPA,30
  
	  mov ax,0B800H
         mov es,ax
	  ;mov bx,offset Ndotmatrix
	  cmp cars,0
	 jnz lvsee1
	 mov ah,04H
	 jmp dispqqq1	 
lvsee1:mov ah,02H          ;attr.byte  0100红色  0010绿色
dispqqq1:mov di,CNTdispPA
         call dispdotmatrix   ;disp the dot matrix
exit3:		 
	  pop cx
         pop di
         pop es
         ret
jtIndisp endp

jtOutdispB  proc
         push es
         push di
         push cx
         mov ax,0B800H
         mov es,ax
         mov al,0      ;箭头出就是data段起始位置
         mov ah,8*8
         mul ah
         mov bx,offset Ndotmatrix
         add bx,ax    ;point to 0-9 matrix   bx指向了data定义里的数字几的矩阵
         
dispqB:
         cmp CNTdispPB,jtpositionB+30   ;若是第一个起始位置，则要清空最后位置的
	  jz qing1B
	  mov ax,0B800H
         mov es,ax
	  add CNTdispPB,6
	  mov di,CNTdispPB     ;CntdispPosition   点阵起始位置
	  call qing0dotmatrix
	  sub CNTdispPB,6
	  
	  mov ax,0B800H
         mov es,ax
	  mov bx,offset Ndotmatrix
	  mov ah,02H 
	  mov di,CNTdispPB
	  call dispdotmatrix
	  jmp exit2B
qing1B:
	  mov ax,0B800H
         mov es,ax
	  sub CNTdispPB,30
	  mov di,CNTdispPB
	  call qing0dotmatrix
	  add CNTdispPB,30
  
	  mov ax,0B800H
         mov es,ax
	  mov bx,offset Ndotmatrix
	  mov ah,02H 
	  mov di,CNTdispPB
         call dispdotmatrix   ;disp the dot matrix
exit2B:		 
	  pop cx
         pop di
         pop es
         ret
jtOutdispB endp

jtIndispB  proc
         push es
         push di
         push cx
         mov ax,0B800H
         mov es,ax
         mov al,1      ;箭头出就是data段起始位置
         mov ah,8*8
         mul ah
         mov bx,offset Ndotmatrix
         add bx,ax    ;point to 0-9 matrix   bx指向了data定义里的数字几的矩阵
         
dispq1B:
         cmp CNTdispPB,jtpositionB   ;若是第五个，则要清空最后位置的
	  jz qing2B
	  mov ax,0B800H
         mov es,ax
	  sub CNTdispPB,6
	  mov di,CNTdispPB     ;CNTdispPAosition   点阵起始位置
	  call qing0dotmatrix
	  add CNTdispPB,6
	  
	  mov ax,0B800H
         mov es,ax
	  ;mov bx,offset Ndotmatrix
	  mov ah,02H 
	  cmp cars,0
	  jnz lvse111
	  mov ah,04H
	  jmp dispq11B 
lvse111:mov ah,02H          ;attr.byte  0100红色  0010绿色
dispq11B:mov di,CNTdispPB
	  call dispdotmatrix
	  jmp exit3B
qing2B:
	  mov ax,0B800H
         mov es,ax
	  add CNTdispPB,30
	  mov di,CNTdispPB
	  call qing0dotmatrix
	  sub CNTdispPB,30
  
	  mov ax,0B800H
         mov es,ax
	  ;mov bx,offset Ndotmatrix
	  cmp cars,0
	  jnz lvse1111
	  mov ah,04H
	  jmp dispq111B 
lvse1111:mov ah,02H          ;attr.byte  0100红色  0010绿色
dispq111B:mov di,CNTdispPB
         call dispdotmatrix   ;disp the dot matrix
exit3B:		 
	  pop cx
         pop di
         pop es
         ret
jtIndispB endp

dispdotmatrix proc
         push cx
         push di
         push bx
         push ax
         mov cl,8   ;lines
dispdotm1:mov ch,8
          push di
dispdotm2:mov al,[bx]
          mov es:[di],ax       ;one dot character   放一个点
          add di,2
          inc bx
          dec ch   ;一行只有8个，减到0换下一行，共8行
          jnz dispdotm2
          pop di
          add di,160           ;to next line
          dec cl
          jnz dispdotm1
          pop ax
          pop bx
          pop di
          pop cx
          ret
dispdotmatrix endp

qing0dotmatrix proc
         push cx
         push di
         push bx
         push ax
         mov cl,8   ;lines
qing0dotm1:mov ch,8
          push di
qing0dotm2:mov ax,00H      ;上面程序改为0即为清0
          mov es:[di],ax       ;one dot character   放一个点
          add di,2
          dec ch   ;一行只有8个，减到0换下一行，共8行
          jnz qing0dotm2
          pop di
          add di,160           ;to next line
          dec cl
          jnz qing0dotm1
          pop ax
          pop bx
          pop di
          pop cx
          ret
qing0dotmatrix endp

;键盘中断服务程序
INT09_proc proc far
	sti
       push ax
       push ds
       push es
       push di
       mov ax,data
       mov ds,ax
       mov ax,0B800H
       mov es,ax
       ;mov di,160*9+64   ;current VRAM address
       in al,60H         ;get key scancode
	 cmp al,KESCDOWN
	 jz INT09_exit
       cmp al,K1DOWN  ;A口车出
       jz INT09_1
	 cmp al,K2DOWN ;A口车入
	 jz INT09_3
	 cmp al,K3DOWN ;B口车出
	 jz INT09_5
	 cmp al,K4DOWN ;B口车入
	 jz INT09_7
	;cmp一直8个数	
	jmp exit
INT09_1:
        mov flagAout,1
	 jmp exit
INT09_3:
	 mov flagAin,1
	 jmp exit
INT09_5:
	 mov flagBout,1
	 jmp exit
INT09_7:
	 mov flagBin,1
	 jmp exit
INT09_exit:
	 mov flagesc,1
exit:
        mov al,20h ;Send EOI   
        out 0a0h,al
        out 20h,al
        pop di
        pop es
        pop ds
        pop ax
        iret
INT09_proc endp

;T0 中断服务程序：计数器+1
INT08_proc proc far
       sti
       push ax
	 push di
       push ds
       mov ax,data
       mov ds,ax
xitongtime:    ;每1s显示下系统时间
	 mov ax,t0scnt0
	 cmp ax,25
	 jnz xitongtime1
	 cmp t0scnt1,10					;到1s了先判断下超10了没
	 jnz timesdisp
	 mov t0scnt1,0	
	 inc t0scnt2
	 cmp t0scnt2,6
	 jnz timesdisp
	 mov t0scnt2,0
	 inc t0scnt3
	 cmp t0scnt3,10
	 jnz timesdisp
	 mov t0scnt3,0
	 
timesdisp:
	 mov cx,systemTimeP
	 call timedisplay
	 mov t0scnt0,0
	 inc t0scnt1
	 jmp ifAout
xitongtime1:
	 inc t0scnt0
	 
	 
ifAout:                 ;每次记得都要清一下所有标志
	 cmp flagAout,1
	 jz czbeginAO      ;A出信号有按下则出操作开始
ifAin: 
	 cmp flagAin,1
	 jz tiaobanAI
ifBout:
	 cmp flagBout,1
	 jz tiaobanbo
ifBin:
	 cmp flagBin,1
	 jz tiaobanbin
	 
	 jmp INT08P_E
tiaobanAI:jmp czbeginAI
czbeginAO:	 
	 mov ax,t0scnt2sAO
       cmp ax,50    ;2s定时，之后打开栏杆
	 jnz time2sAO ;timerA2s	 
	 
	 cmp outflagA,1
	 jz carAout
	 cmp cars,99
	 jz tiaoban4
	 call carsout
	 mov outflagA,1
carAout:
	 
	 mov flagAout1,1  ;2s定时结束后把箭头开始标志置为1
	 mov flagjtfangxiangA,0
	 mov ah,02H   ;亮绿灯
	 mov al,0FEH
	 mov di,LEDposition
	 mov es:[di],ax
yanshi3sO: ;延迟3s	 	 
	 mov ax,t0scnt3sAO
	 cmp ax,75    ;3s定时
	 jnz tiaoban3ssss
	 
	 mov dl,aAsc
	 mov dh,oAsc
	 call recordtimeandio
	 inc nownum
	 inc totnum
	 cmp nownum,10
	 jnz liangao
	 mov nownum,0
liangao:	  
	 jmp liangRedA     ;抬起就倒计三秒
time2sAO:
	 inc t0scnt2sAO
	 jmp ifBout
tiaoban4:call carsout
mov outflagA,1
jmp qing0A
tiaobanbo:jmp czbeginBO	 
tiaoban3ssss:jmp tiaoban3ss
tiaobanbin:	jmp czbeginBI 
czbeginAI:
	 mov ax,t0scnt2sAI
       cmp ax,50    ;2s定时，之后打开栏杆
	 jnz time2sAI  ;timerA2s
	 
	 
	 cmp inflagA,1  ;每次只调用一次，防止一直中断一直爆减
	 jz carAin
	 cmp cars,0   ;当车位没有时直接清标志位
	 jz tiaobanqing0A
	 call carsin
	 mov inflagA,1
carAin:	 
	 
	 mov flagAin1,1  ;2s定时结束后把箭头开始标志置为1
	  mov flagjtfangxiangA,1
	 mov ah,02H   ;亮绿灯
	 mov al,0FEH
	 mov di,LEDposition
	 mov es:[di],ax
yanshi1sI: ;延迟1s 	 
	 mov ax,t0scnt1sAI
	 cmp ax,25    ;3s定时
	 jnz tiaoban1sss
	 
	 mov dl,aAsc
	 mov dh,iAsc
	 call recordtimeandio
	 inc nownum
	 inc totnum
	 cmp nownum,10
	 jnz liangai
	 mov nownum,0
liangai:
	 ;call carsout
	 jmp liangRedA     ;抬起就倒计三秒

time2sAI:
	 inc t0scnt2sAI
	 jmp ifBout
tiaoban1sss:jmp tiaoban1ss
tiaoban3ss:jmp tiaoban3sA
tiaobanqing0A: mov flagAII,1
call carsin
mov inflagA,1
jmp qing0A
czbeginBO:
	 mov ax,t0scnt2sBO
       cmp ax,50    ;2s定时，之后打开栏杆
	 jnz time2sBO ;timerA2s
	 
	 cmp outflagB,1
	 jz carBout
	 cmp cars,99
	 jz tiaoban5
	 call carsout
	 mov outflagB,1
carBout:
	 
	 mov flagBout1,1  ;2s定时结束后把箭头开始标志置为1
	 mov flagjtfangxiangB,0
	 mov ah,02H   ;亮绿灯
	 mov al,0FEH
	 mov di,LEDposition+110
	 mov es:[di],ax
yanshi3sBO: ;延迟3s	 
	 mov ax,t0scnt3sBO
	 cmp ax,75    ;3s定时
	 jnz tiaoban3sss
	 

	 mov dl,bAsc
	 mov dh,oAsc
	 call recordtimeandio
	 inc nownum
	 inc totnum
	 cmp nownum,10
	 jnz liangbo
	 mov nownum,0
liangbo:	 
	 jmp liangRedB     ;抬起就倒计三秒
	 
time2sBO:
	 inc t0scnt2sBO
	 jmp INT08P_E
tiaoban5:call carsout
mov outflagB,1
jmp qing0B
tiaoban1ss:jmp tiaoban1sA
tiaoban3sss:jmp tiaoban3sB
czbeginBI:
	 mov ax,t0scnt2sBI
       cmp ax,50    ;2s定时，之后打开栏杆
	 jnz time2sBI  ;timerA2s 
	 
	 cmp inflagB,1
	 jz carBin
	 cmp cars,0   ;当车位没有时直接清标志位
	 jz tiaobanqing0B
	 call carsin
	 mov inflagB,1
carBin:
	 
	 mov flagBin1,1  ;2s定时结束后把箭头开始标志置为1
	  mov flagjtfangxiangB,1
	 mov ah,02H   ;亮绿灯
	 mov al,0FEH
	 mov di,LEDposition+110
	 mov es:[di],ax
yanshi1sBI: ;延迟1s 	 
	 mov ax,t0scnt1sBI
	 cmp ax,25    ;1s定时
	 jnz tiaoban1sB
	 
	 mov dl,bAsc
	 mov dh,iAsc
	 call recordtimeandio
	 inc nownum
	 inc totnum
	 cmp nownum,10
	 jnz liangbi
	 mov nownum,0
liangbi:	 
	 ;call carsout
	 jmp liangRedB     ;抬起就倒计三秒

time2sBI:
	 inc t0scnt2sBI
	 jmp INT08P_E
tiaobanqing0B:mov flagBII,1
call carsin
mov inflagB,1
jmp qing0B	 
tiaoban1sA:inc t0scnt1sAI
	jmp jtxianshiA
tiaoban1sB:inc t0scnt1sBI
	jmp jtxianshiB
tiaoban3sA:inc t0scnt3sAO
	jmp jtxianshiA
tiaoban3sB:inc t0scnt3sBO
	jmp jtxianshiB

	:
	 mov ah,04H   ;亮红灯
	 mov al,0FEH
	 mov di,LEDposition
	 mov es:[di],ax
qing0A:	 mov flagAout,0 ;亮完红灯把箭头取消不显示
	 mov flagAin,0
	 mov flagAout1,0
	 mov flagAin1,0
	 mov t0scnt2sAI,0 ;注意把这些计数的都清0，避免后面的延时受到影响
	 mov t0scnt2sAO,0
	 mov t0scnt1sAI,0
	 mov t0scnt3sAO,0
	 mov t0cntjtA,0
	 mov outflagA,0
	 mov inflagA,0
	 jmp ifBout
liangRedB:	 
	 mov ah,04H   ;亮红灯
	 mov al,0FEH
	 mov di,LEDposition+110
	 mov es:[di],ax
qing0B: mov flagBout,0
	 mov flagBin,0
	 mov flagBout1,0
	 mov flagBin1,0
	 mov t0scnt2sBO,0
	 mov t0scnt2sBI,0
	 mov t0scnt1sBI,0
	 mov t0scnt3sBO,0
	 mov t0cntjtB,0
	 mov outflagB,0
	 mov inflagB,0
	 jmp INT08P_E

jtxianshiA:	
	 mov ax,t0cntjtA
	 cmp ax,5       ; 1、40ms周期，是否到0.2s 再+1    用于箭头动画特效
        jz INT08P_0
	 inc t0cntjtA
	 jmp ifBout
INT08P_0:  ;箭头
	 mov t0cntjtA,0   ;
	 cmp flagjtfangxiangA,0
	 jz INT08P_2   ;箭头出
INT08P_1:  ;箭头入
	 cmp CNTdispPA,160*8+32
	 jz INT08P_11
	 add CNTdispPA,6
	 jmp ifBout
INT08P_11:
	 mov CNTdispPA,160*8+2
	 jmp ifBout
INT08P_2:  ;箭头出
	 cmp CNTdispPA,160*8+2
	 jz INT08P_22
	 sub CNTdispPA,6
	 jmp ifBout
INT08P_22:
	 mov CNTdispPA,160*8+32
	 jmp ifBout

jtxianshiB:	
	 mov ax,t0cntjtB
	 cmp ax,5       ; 1、40ms周期，是否到0.2s 再+1    用于箭头动画特效
        jz INT08P_0B
	 inc t0cntjtB
	 jmp INT08P_E
INT08P_0B:  ;箭头
	 mov t0cntjtB,0   ;
	 cmp flagjtfangxiangB,0
	 jz INT08P_2B   ;箭头出
INT08P_1B:  ;箭头入
	 cmp CNTdispPB,160*8+142
	 jz INT08P_11B
	 add CNTdispPB,6
	 jmp INT08P_E
INT08P_11B:
	 mov CNTdispPB,160*8+112
	 jmp INT08P_E
INT08P_2B:  ;箭头出
	 cmp CNTdispPB,160*8+112
	 jz INT08P_22B
	 sub CNTdispPB,6
	 jmp INT08P_E
INT08P_22B:
	 mov CNTdispPB,160*8+142
	 jmp INT08P_E
	
	 
INT08P_E:mov al,20h ;Send EOI
        out 0a0h,al
        out 20h,al
        pop ds
	 pop di
        pop ax
        iret
INT08_proc endp

;；键盘按键/抬起变化中断--IRQ1-INT 09H，初始化
;；扫描码端口：60H,中断服务程序INT09_PROC
KBINT0  proc
        push ds
	 push es
       cli
       mov al,int09;保存原中断向量
       mov ah,35h
       int 21h
       mov ax,es
       mov cs09,ax
       mov ip09,bx
       mov ax,cs ;设置新中断向量
       mov ds,ax
       mov dx,offset int09_proc
       mov al,int09
       mov ah,25h
       int 21h
       in al, 21h ;设置中断掩码
       and al,irq1_mask
       out 21h, al
       in al, 0a1h
       and al, irq_mask8_15
       out 0a1h, al
       pop es
	 pop ds
       sti
       ret
KBint0  endp

;；T0--IRQ0-INT 08H 系统定时器8253（地址40-43H）初始化
;；方式2，40/20ms,中断服务程序INT08_PROC
T0INT0  proc
       push es
       cli
       mov al,36H
       out 43h,al
       mov AX,47600   ;1.19*40000=47600,40ms,25Hz;1.19*20000=23800,20ms,50Hz
       out 40H,al
       mov al,ah
       out 40H,al    ;先低后高赋定时初值
       mov ax,0       ;直接读写中断矢量 0:20H
       mov es,ax
       mov al,int08;保存原中断向量
       mov ah,4    
       mul ah         ;中断矢量偏移量地址4×类型号n开始
       mov si,ax
       mov ax,es:[si+2]  ;segment address   后两个给cs
       mov cs08,ax
       mov bx,es:[si]   ;0:20H   前两个给ip
       mov ip08,bx
	 ;保存中断矢量  
       mov ax,cs ;设置新中断向量
       mov es:[si+2],ax
       mov dx,offset int08_proc    ;指向自写的中断服务程序
       mov es:[si],dx
       in al, 21h ;设置中断掩码
       and al, irq0_mask
       out 21h, al
       in al, 0a1h
       and al, irq_mask8_15
       out 0a1h, al
       pop es
       sti
       ret
T0int0  endp

;;恢复Int09 原来的中断矢量
INT09_Rst PROC 
         cli
         mov bl, irq1_mask ;恢复中断掩码
         not bl
         in al, 21h
         or al, bl
;         out 21h, al    ;not needed
         mov bl, irq_mask8_15
         not bl
         in al, 0a1h
         or al, bl
         out 0a1h, al
         mov dx,ip09 ;恢复原中断向量
         mov ax,cs09
         mov ds,ax
         mov ah,25h
         mov al,int09
         int 21h
         sti
         RET
INT09_RST ENDP

;restore Int08 原来的中断矢量
INT08_Rst PROC 
         cli
         mov bl, irq0_mask ;恢复中断掩码
         not bl
         in al, 21h
         or al, bl
         out 21h, al
         mov bl, irq_mask8_15
         not bl
         in al, 0a1h
         or al, bl
;         out 0a1h, al   ;not needed
         mov ax,0
         mov es,ax
         mov si,20H
         mov dx,ip08 ;恢复原中断向量
         mov es:[si],dx      ;V offset restore
         mov ax,cs08
         mov es:[si+2],ax    ;V seg restore
         sti
         RET
INT08_RST ENDP

delay proc
        push cx
        mov cx,50000            ;延时
delay1:  dec cx
        jnz delay1
        pop cx
        ret
delay   endp

timedisplay proc 
	 push cx
	 mov ax,0B800H        ;Charater disp
        mov es,ax
	 
	 mov di,cx     ;CNT0 disp posiotion 
	 mov ah,02
	 cmp t0scnt1,10
	 jnz moval
	 mov al,0
	 jmp addal
moval:	 
	 mov al,t0scnt1
addal:	 
	 add al,30H
	 mov es:[di],ax
	 
	 sub cx,2
	 mov di,cx
	 cmp t0scnt1,10
	 jnz moval1
	 mov al,1
	 add al,t0scnt2
	 jmp addal1
moval1:	 
	 mov al,t0scnt2
addal1:
	 add al,30H
	 mov es:[di],ax
	 
	 sub cx,2
	 mov di,cx    ;冒号
	 mov al,3AH
	 mov es:[di],ax
	 
	 sub cx,2
	 mov di,cx
	 mov al,t0scnt3
	 add al,30H
	 mov es:[di],ax
	 
	 sub cx,2
	 mov di,cx
	 mov al,30H
	 mov es:[di],ax
	 
	 pop cx
	 ret
timedisplay endp

recordtimeandioo proc
	 ;call model_record
	 push cx
	 mov ah,0
	 mov al,nownum
	 mov cl,160
	 mul cl
	 add ax,recordtimeP
	 mov cx,ax
	 ;mov bx,recordtimeP+160*nownum    ;记录时间
	 call timedisplay
	 
	 mov ah,0
	 mov cl,160
	 mov al,nownum
	 mul cl
	 add ax,recordkouP
	 mov di,ax
	 mov ah,02
	 mov al,dl
	 mov es:[di],ax
	 
	 mov ah,0
	 mov cl,160
	 mov al,nownum
	 mul cl
	 add ax,recordkouP+2
	 mov di,ax
	 mov ah,02
	 mov al,dh
	 mov es:[di],ax
	 
	 pop cx
	 ret
recordtimeandioo endp
recordtimeandio proc
	call model_record
push cx
push ax
	mov cl,0
	mov position,cl
	mov cl,records0
	mov testing1,cl
	mov cl,records00
	mov testing2,cl
	mov cl,records000
	mov testing3,cl
	mov cx,recordt0
	mov wanlea,cx
	call timedisplay2
	cmp totnum,0
	jbe cmp1
	
	mov cl,1
	mov position,cl
	mov cl,records1
	mov testing1,cl
	mov cl,records11
	mov testing2,cl
	mov cl,records111
	mov testing3,cl
	mov cx,recordt1
	mov wanlea,cx
	call timedisplay2
cmp1:cmp totnum,1
	jbe cmp2
	
	mov cl,2
	mov position,cl
	mov cl,records2
	mov testing1,cl
	mov cl,records22
	mov testing2,cl
	mov cl,records222
	mov testing3,cl
	mov cx,recordt2
	mov wanlea,cx
	call timedisplay2
cmp2:cmp totnum,2
	jbe cmp3

	mov cl,3
	mov position,cl
	mov cl,records3
	mov testing1,cl
	mov cl,records33
	mov testing2,cl
	mov cl,records333
	mov testing3,cl
	mov cx,recordt3
	mov wanlea,cx
	call timedisplay2
cmp3:cmp totnum,3
	jbe cmp4
	
	mov cl,4
	mov position,cl
	mov cl,records4
	mov testing1,cl
	mov cl,records44
	mov testing2,cl
	mov cl,records444
	mov testing3,cl
	mov cx,recordt4
	mov wanlea,cx
	call timedisplay2
cmp4:cmp totnum,4
	jbe cmp5

	mov cl,5
	mov position,cl
	mov cl,records5
	mov testing1,cl
	mov cl,records55
	mov testing2,cl
	mov cl,records555
	mov testing3,cl
	mov cx,recordt5
	mov wanlea,cx
	call timedisplay2
cmp5:cmp totnum,5
	jbe buxianshi

	mov cl,6
	mov position,cl
	mov cl,6
	mov testing1,cl
	mov cl,records66
	mov testing2,cl
	mov cl,records666
	mov testing3,cl
	mov cx,recordt6
	mov wanlea,cx
	call timedisplay2

buxianshi: pop ax
pop cx
ret
recordtimeandio endp

timedisplay2 proc 
	 push cx
	 push ax
	 push dx
	 mov dx,wanlea
	 mov ah,0
	 mov al,position
	 mov cl,160
	 mul cl
	 add ax,recordtimeP
	 mov cx,ax
	 ;mov bx,recordtimeP+160*nownum    ;记录时间
	 
	 mov ax,0B800H        ;Charater disp
    mov es,ax
	 
	 mov di,cx     ;CNT0 disp posiotion 
	 mov ah,02
	 cmp testing1,10
	 jnz movall
	 mov al,0
	 jmp addall
movall:	 
	 mov al,testing1
addall:	 
	 add al,30H
	 mov es:[di],ax
	 
	 sub cx,2
	 mov di,cx
	 cmp testing1,10
	 jnz movall1
	 mov al,1
	 add al,testing2
	 jmp addall1
movall1:	 
	 mov al,testing2
addall1:
	 add al,30H
	 mov es:[di],ax
	 
	 sub cx,2
	 mov di,cx    ;冒号
	 mov al,3AH
	 mov es:[di],ax
	 
	 sub cx,2
	 mov di,cx
	 mov al,testing3
	 add al,30H
	 mov es:[di],ax
	 
	 sub cx,2
	 mov di,cx
	 mov al,30H
	 mov es:[di],ax

	 
	 mov ah,0
	 mov cl,160
	 mov al,position
	 mul cl
	 add ax,recordkouP
	 mov di,ax
	 mov ah,02
	 mov al,dl
	 mov es:[di],ax
	 
	 mov ah,0
	 mov cl,160
	 mov al,position
	 mul cl
	 add ax,recordkouP+2
	 mov di,ax
	 mov ah,02
	 mov al,dh
	 mov es:[di],ax
	 
	 pop dx
	 pop ax
	 pop cx
	 ret
timedisplay2 endp

model_record proc
push ax

	mov ax,recordt8
	mov recordt9,ax
	mov ax,recordt7
	mov recordt8,ax
	mov ax,recordt6
	mov recordt7,ax
	mov ax,recordt5
	mov recordt6,ax
	mov ax,recordt4
	mov recordt5,ax
	mov ax,recordt3
	mov recordt4,ax
	mov ax,recordt2
	mov recordt3,ax
	mov ax,recordt1
	mov recordt2,ax
	mov ax,recordt0
	mov recordt1,ax
	mov recordt0,dx

	
	mov ah,records8
	mov records9,ah
	mov ah,records7
	mov records8,ah
	mov ah,records6
	mov records7,ah
	mov ah,records5
	mov records6,ah
	mov ah,records4
	mov records5,ah
	mov ah,records3
	mov records4,ah
	mov ah,records2
	mov records3,ah
	mov ah,records1
	mov records2,ah
	mov ah,records0
	mov records1,ah
	mov ah,t0scnt1
	mov records0,ah

	mov ah,records88
	mov records99,ah
	mov ah,records77
	mov records88,ah
	mov ah,records66
	mov records77,ah
	mov ah,records55
	mov records66,ah
	mov ah,records44
	mov records55,ah
	mov ah,records33
	mov records44,ah
	mov ah,records22
	mov records33,ah
	mov ah,records11
	mov records22,ah
	mov ah,records00
	mov records11,ah
	mov ah,t0scnt2
	mov records00,ah

	mov ah,records888
	mov records999,ah
	mov ah,records777
	mov records888,ah
	mov ah,records666
	mov records777,ah
	mov ah,records555
	mov records666,ah
	mov ah,records444
	mov records555,ah
	mov ah,records333
	mov records444,ah
	mov ah,records222
	mov records333,ah
	mov ah,records111
	mov records222,ah
	mov ah,records000
	mov records111,ah
	mov ah,t0scnt3
	mov records000,ah
	
pop ax
ret
model_record endp

chuzhiset proc
push ax
push es
push dx
push di
buhuia:in al,60h
cmp al,1CH
jnz buhuia
mov cx,2;max number 65535
xor bx,bx
l1:	mov ah,01h
	   int 21h
	cmp al,0dh
	je carry
	cmp al,30h
	jb l1
	cmp al,39h
	ja l1
	and ax,1111b
	xchg ax,bx
	mov di,10
	mul di
	jc carry
	add bx,ax
	jc carry
	loop l1
	
carry: mov cars,bl

pop di
pop dx
pop es
pop ax
chuzhiset endp
Hex proc near
	;in bx !
	mov ch,4
l2:	
	mov cl,4
	rol bx,cl
	mov dl,bl
	and dl,1111b
	add dl,30h
	
	cmp dl,39h
	jbe l3
	add dl,7h
l3:
	mov ah,02h
	int 21h
	
	dec ch
	jnz l2
ret 
Hex endp



dispdotmatrix2 proc
         push cx
         push di
         push bx
         push ax
         mov cl,9   ;lines
dispdotm11:mov ch,7
          push di
dispdotm22:mov al,[bx]
          mov es:[di],ax       ;one dot character
          add di,2
          inc bx
          dec ch
          jnz dispdotm22
          pop di
          add di,160           ;to next line
          dec cl
          jnz dispdotm11
          pop ax
          pop bx
          pop di
          pop cx
          ret
dispdotmatrix2 endp

jinzhi proc
push ax
push bx
mov al,0
mov bl,0
mov bh,cars
cmp bh,0AH
jb numcl
lop:sub bh,0AH
	 add al,1H
	 cmp bh,0AH
	 jae lop
numcl: mov num1,al
		 mov bl,bh
		 mov num2,bl
pop bx
pop ax
ret
jinzhi endp


display2 proc

hh:      
         mov al,num1
         mov ah,7*9
         mul ah
         mov bx,offset Ndotmatrix2
         add bx,ax    ;point to 0-9 matrix
         mov di,CNTdispP     ;CntdispPosition
         mov ah,03H          ;attr.byte
         call dispdotmatrix2   ;disp the dot matrix

         mov al,num2
         mov ah,7*9
         mul ah
         mov bx,offset Ndotmatrix2
         add bx,ax    ;point to 0-9 matrix
         mov di,CNTdispP+18     ;CntdispPosition
         mov ah,03H          ;attr.byte
         call dispdotmatrix2   ;disp the dot matrix
        
        call jinzhi
exitt: ret
display2 endp

display3 proc
  
         mov bx,offset NmA
         mov di,1*160+24     ;CntdispPosition
         mov ah,05H          ;attr.byte
         call dispdotmatrix3   ;disp the dot matrix

         mov bx,offset NmB
         mov di,1*160+124     ;CntdispPosition
         mov ah,05H          ;attr.byte
         call dispdotmatrix3   ;disp the dot matrix
        
        call jinzhi
ret
display3 endp
dispdotmatrix3 proc
         push cx
         push di
         push bx
         push ax
         mov cl,7   ;lines
dispdotm111:mov ch,7
          push di
dispdotm222:mov al,[bx]
          mov es:[di],ax       ;one dot character
          add di,2
          inc bx
          dec ch
          jnz dispdotm222
          pop di
          add di,160           ;to next line
          dec cl
          jnz dispdotm111
          pop ax
          pop bx
          pop di
          pop cx
          ret
dispdotmatrix3 endp
carsout proc 

push cx
push ds
push ax
push di
		mov di,587
		;call gen		
		mov di,698
		;call gen		
		mov di,494
		;call gen
cmp cars,63H
jb addcar
mov ax,seg fullmessage
        mov ds,ax
        mov si,offset fullmessage
        mov di,160*24+40
        mov cx,emptymessage-fullmessage
        cld
        rep movsB

        jmp jieshu
addcar: add cars,1
		  mov ax,00H
        mov di,160*24+40
        mov cx,emptymessage-fullmessage
        cld
loop1:  mov es:[di],ax
		  add di,2
		  loop loop1
	 mov di,160*24+2
        mov ax,00H
        mov es:[di],ax
        mov ah,0
jieshu: pop di
pop ax
pop ds
pop cx
ret
carsout endp

carsin proc 
push cx
push ds
push ax
push di
		mov di,494
		;call gen
		mov di,698
		;call gen
		mov di,587
		;call gen
cmp cars,0H
ja subcar
carsempty: mov ax,seg emptymessage
        mov ds,ax
        mov si,offset emptymessage
        mov di,160*24+40
        mov cx,SCLRR-emptymessage
        cld
        rep movsB
	 mov di,160*24+2
        mov ah,010000010B
        mov al,0FEH
        mov es:[di],ax
        jmp jieshu2
subcar: sub cars,1
		  mov ax,00H
        mov di,160*24+40
        mov cx,emptymessage-fullmessage
        cld
loop2:  mov es:[di],ax
		  add di,2
		  loop loop2
		  mov di,160*24+2
        mov ax,00H
        mov es:[di],ax
        mov ah,0
jieshu2: pop di
pop ax
pop ds
pop cx
ret
carsin endp
gen  proc
push ax
push di
push cx
push bx
		mov cx,tim
      mov al,0b6h    ;设置8253通道2方式3二进制计数
      out 43h,al
      mov dx,12h
      mov ax,12928   ; DX AX=896*533h=18*65536+12928=1.19M
      div di
      out 42h,al     ;8253通道2口设置初值
      mov al,ah
      out 42h,al
      in al,61h       ;读8255PB口
      mov ah,al
      or al,3
      out 61h,al
wait1:  mov cx,01h
delay21:  mov ax,10    ;延时子程序
delay22: dec ax
      jnz delay22
      loop delay21
      dec bx
      jnz wait1
      mov al,ah
      out 61h,al
pop bx
pop cx
pop di
pop ax

      ret
gen   endp


code ends
end start