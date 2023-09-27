unit GameEngine16 ;

interface

procedure Screen(num:Byte) ;
procedure ClearScreen(color:Byte) ;  
procedure DrawPixel(x,y:Word; color:Byte) ;
procedure FillRect(x1,y1,w,h:Word; color:Byte) ;
procedure DrawLineHorz(x1,x2,y:Word; color:Byte) ;
procedure DrawLineHorzByLen(x1:Word; len:Integer; y:Word; color:Byte) ; 
procedure DrawLineVert(x,y1,y2:Word; color:Byte) ; 
procedure DrawLineVertByLen(x,y1,len:Word; color:Byte) ; 
procedure SetCursorXY(x,y:Byte) ; 
procedure SetPaletteData(start:Byte; count:Byte; data:array of Byte) ; 
procedure SetPaletteColor(color:Byte; r,g,b:Byte) ; 
function IsKeyPressed(var key:Byte; var scan:Byte):Boolean ; 
procedure SoundOff() ; 
procedure SoundFreq(freq:Word) ; 
procedure SoundOn() ; 
function StartFrame():Word ;
procedure WaitFrameCompleted(frame:Word) ;

implementation

const SCREENWIDTH=320 ;
      SCREENHEIGHT=200 ;

procedure Screen(num:Byte) ; assembler ; 
asm
  mov ah,0
  mov al,num
  int 10h
end ;

procedure ClearScreen(color:Byte) ; assembler ; 
asm
  mov ax,SegA000
  mov es,ax
  mov di,0
  mov al,color
  mov ah,color
  mov cx,SCREENWIDTH*SCREENHEIGHT
  rep stosw
end ; 

procedure DrawPixel(x,y:Word; color:Byte) ;
var pos:Word ;
begin
  pos:=SCREENWIDTH*y+x ;
asm
  mov ax,SegA000
  mov es,ax
  mov di,pos
  mov al,color
  stosb
end ;
end ;

procedure FillRect(x1,y1,w,h:Word; color:Byte) ;
var y:Integer ;
begin
  for y:=y1 to y1+h-1 do 
    DrawLineHorzByLen(x1,w,y,color) ;
end ;

procedure DrawLineHorz(x1,x2,y:Word; color:Byte) ; 
begin
  DrawLineHorzByLen(x1,x2-x1+1,y,color) ;
end ;

procedure DrawLineHorzByLen(x1:Word;len:Integer;y:Word; color:Byte) ; 
var pos:Word ;
begin
  if len<0 then begin
    pos:=SCREENWIDTH*y+x1+len+1 ;
    len:=-len ;
  end
  else
    pos:=SCREENWIDTH*y+x1 ;
asm
  mov ax,SegA000
  mov es,ax
  mov di,pos
  mov al,color
  mov cx,len
  rep stosb
end ;
end ;

procedure DrawLineVert(x,y1,y2:Word; color:Byte) ; 
begin
  DrawLineVertByLen(x,y1,y2-y1+1,color) ;
end ;

procedure DrawLineVertByLen(x,y1,len:Word; color:Byte) ; 
var pos:Word ;
label lab ;
begin
  pos:=SCREENWIDTH*y1+x ;
asm
  mov ax,SegA000
  mov es,ax
  mov di,pos
  mov al,color
  mov cx,len
lab:
  stosb
  add di,SCREENWIDTH-1
  loop lab
end ;
end ;

procedure SetCursorXY(x,y:Byte) ; assembler ;
asm
  mov dh, y
  mov dl, x
  mov bh, 0
  mov ah, 2
  int 10h 
end ;

procedure SetPaletteData(start:Byte; count:Byte; data:array of Byte) ; assembler ;
asm
  mov ah,10h
  mov al,12h
  mov bx,start
  mov cx,count
  push cs
  pop es
  mov dx,data
  int 10h
end ;

procedure SetPaletteColor(color:Byte; r,g,b:Byte) ; assembler ;
asm
  mov ah,10h
  mov al,10h
  mov bx,color
  mov dh,r
  mov ch,r
  mov cl,r
  int 10h
end ;

function IsKeyPressed(var key:Byte; var scan:Byte):Boolean ; assembler ;
label nokey ;
asm
  mov @Result,False
  mov ah,01h
  int 16h
  jz nokey
  mov bx,[key]
  mov [bx],al 
  mov bx,[scan]
  mov [bx],ah 
  mov @Result,True
  mov ah,00h
  int 16h
nokey:
end ;

procedure SoundOff() ; assembler ;
asm
  in al,61h
  and al,11111100b
  out 61h,al
end ;

procedure SoundFreq(freq:word) ; assembler ;
asm
  mov cx,freq      
  mov al,10110110b   // Упр.сл.таймера: канал 2, режим 3, дв.слово
  out 43h,al         // Выводим в регистр режима

  mov dx,12h
  mov ax,34DDh       // DX:AX = 1193181
  div cx             // AX = (DX:AX) / СX
  out 42h,al         // Записываем младший байт счетчика
  mov al,ah
  out 42h,al         // Записываем старший байт счетчика
end ;

procedure SoundOn() ; assembler ;
asm
  in al,61H
  or al,11b
  out 61h,al
end ;

function StartFrame():Word ; assembler;
asm
  mov ah,0 
  int 1Ah
  mov @Result,dx
end ;

procedure WaitFrameCompleted(frame:Word) ; assembler;
label lab ;
asm
  mov ah,0 
lab:
  int 1Ah
  cmp frame,dx
  je lab
end;

end.