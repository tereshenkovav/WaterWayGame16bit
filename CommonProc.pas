unit CommonProc ;

interface

procedure DrawCornerDXDY(x1,y1,dx,dy:Integer; color:byte) ;
procedure DrawCornerDYDX(x1,y1,dy,dx:Integer; color:byte) ;

implementation
uses GameEngine16 ;

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
