program testmem ;

uses GameEngine16, Game ;

var i:Integer ;
    mem:array[0..99] of TBlock ;
    msize:Word ;
begin
   msize:=MemAvail() ;
   Writeln(MemAvail()) ;
   for i:=0 to 9 do 
     mem[i]:=TBlockHorz.Create() ;
   Writeln(MemAvail(),' ',msize-MemAvail()) ;
   for i:=0 to 9 do 
     mem[i].Free ;
   Writeln(MemAvail()) ;
end.
