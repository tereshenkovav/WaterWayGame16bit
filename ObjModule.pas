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
    bdtripleleft,bdtripleright,bdtripletop,bdtriplebottom,bdquad:TBlockDescr ;

    arr_linear:array[0..18] of TLink ;
    arr_triple:array[0..27] of TLink ;
    arr_quad:array[0..36] of TLink ;

// leveldata
const
      CODE_STARTVERT = 20 ;
      CODE_STARTHORZ = 21 ;
      CODE_FINISH    = 22 ;
      CODE_WALL      = 23 ;

      levelcount = 5 ;
      levelwatertimes:array[0..LEVELCOUNT-1] of Byte = (50,10,30,40,50) ;
      level1_blocks:array[0..5] of Byte = (
        CODE_STARTHORZ,1,4,
        CODE_FINISH,8,6) ;
      level1_freq_blocks:array[0..5] of Byte = 
        (0,0,0,0,3,4) ;
      level2_blocks:array[0..5] of Byte = (
        CODE_STARTVERT,6,1,
        CODE_FINISH,4,8) ;
      level2_freq_blocks:array[0..5] of Byte = 
        (1,1,1,1,2,5) ;

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

procedure InitQuadLink() ;
var i:Integer ;
begin
  for i:=0 to BLOCKSIZE-2 do
    arr_quad[i]:=NewLink(i,i+1) ;
  for i:=0 to 6 do
    arr_quad[19+i]:=NewLink(BLOCKSIZE+i,BLOCKSIZE+i+1) ;
  for i:=0 to 6 do
    arr_quad[26+i]:=NewLink(BLOCKSIZE+8+i,BLOCKSIZE+i+8+1) ;
  arr_quad[33]:=NewLink(9,BLOCKSIZE+7) ;
  arr_quad[34]:=NewLink(10,BLOCKSIZE+7) ;
  arr_quad[35]:=NewLink(9,BLOCKSIZE+15) ;
  arr_quad[36]:=NewLink(10,BLOCKSIZE+15) ;
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
bdquad:=TBlockDescr.CreateQuad() ;
bdnull:=TBlockDescr.CreateNull() ;
InitLinearLink() ;
InitTripleLink() ;
InitQuadLink() ;

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
bdquad.Free ;
bdnull.Free ;

end.