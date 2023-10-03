unit ObjModule ;

interface
uses BlockDescr, CommonClasses ;

const arr_ex:array[0..3] of Integer = (0,-1,0,1) ;
      arr_ey:array[0..3] of Integer = (1,0,-1,0) ;

      BLOCKSIZE = 20 ;
      MAPSIZE = 10 ;
      SCREENW = 320 ;
      SCREENH = 200 ;
      TICKSINSEC = 18 ;

var bdnull,bdstarthorz,bdstartvert,bdfinish,bdhorz,bdvert,
    bdlefttop,bdrighttop,bdleftbottom,bdrightbottom,
    bdtripleleft,bdtripleright,bdtripletop,bdtriplebottom:TBlockDescr ;

    arr_linear:array[0..18] of TLink ;
    arr_triple:array[0..27] of TLink ;

implementation

procedure InitTripleLink() ;
var i:Integer ;
begin
  for i:=0 to BLOCKSIZE-2 do
    arr_triple[i]:=NewLink(i,i+1) ;
  for i:=0 to 6 do
    arr_triple[BLOCKSIZE+i-1]:=NewLink(BLOCKSIZE+i,BLOCKSIZE+i+1) ;
  arr_triple[26]:=NewLink(9,BLOCKSIZE+7) ;
  arr_triple[27]:=NewLink(10,BLOCKSIZE+7) ;
end ;

procedure InitLinearLink() ;
var i:Integer ;
begin
  for i:=0 to BLOCKSIZE-2 do
    arr_linear[i]:=NewLink(i,i+1) ;
end ;

initialization

bdstarthorz:=TBlockDescr.CreateStartHorz() ;
bdstartvert:=TBlockDescr.CreateStartVert() ;
bdfinish:=TBlockDescr.CreateFinish() ;
bdhorz:=TBlockDescr.CreateHorz() ;
bdvert:=TBlockDescr.CreateVert() ;
bdlefttop:=TBlockDescr.CreateLeftTop() ;
bdrighttop:=TBlockDescr.CreateRightTop() ;
bdleftbottom:=TBlockDescr.CreateLeftBottom() ;
bdrightbottom:=TBlockDescr.CreateRightBottom() ;
bdtripleleft:=TBlockDescr.CreateTripleLeft() ;
bdtripleright:=TBlockDescr.CreateTripleRight() ;
bdtripletop:=TBlockDescr.CreateTripleTop() ;
bdtriplebottom:=TBlockDescr.CreateTripleBottom() ;
bdnull:=TBlockDescr.CreateNull() ;
InitLinearLink() ;
InitTripleLink() ;

finalization

bdstarthorz.Free ;
bdstartvert.Free ;
bdfinish.Free ;
bdhorz.Free ;
bdvert.Free ;
bdlefttop.Free ;
bdrighttop.Free ;
bdleftbottom.Free ;
bdrightbottom.Free ;
bdtripleleft.Free ;
bdtripleright.Free ;
bdtripletop.Free ;
bdtriplebottom.Free ;
bdnull.Free ;

end.