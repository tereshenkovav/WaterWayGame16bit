unit CommonProc ;

interface

procedure DrawCornerDXDY(x1,y1,dx,dy:Integer; color:byte) ;
procedure DrawCornerDYDX(x1,y1,dy,dx:Integer; color:byte) ;
procedure InitRandom() ;
function GetRandom(n:Word):Word ;

implementation
uses GameEngine16 ;

var rndseed:Word ;

procedure InitRandom() ; assembler ;
asm
  mov ah,0 
  int 1Ah
  mov rndseed,dx
end ;

function GetRandom(n:Word):Word ;
begin
  rndseed:=rndseed xor (rndseed shl 7) ;
  rndseed:=rndseed xor (rndseed shr 9) ;
  rndseed:=rndseed xor (rndseed shl 8) ;
  Result:=rndseed mod n ;
end ;

procedure DrawCornerDXDY(x1,y1,dx,dy:Integer; color:byte) ;
var x2:Integer ;
begin
  DrawLineHorzByLen(x1,dx,y1,color) ;
  x2:=x1+dx ;
  if dx<0 then Inc(x2) else Dec(x2) ;

  DrawLineVertByLen(x2,y1,dy,color) ;
end ;

procedure DrawCornerDYDX(x1,y1,dy,dx:Integer; color:byte) ;
begin
  DrawLineVertByLen(x1,y1,dy,color) ;
  DrawLineHorzByLen(x1,dx,y1+dy-1,color) ;
end ;

end.
