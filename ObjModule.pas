unit ObjModule ;

interface
uses BlockDescr ;

const arr_ex:array[0..3] of Integer = (0,-1,0,1) ;
      arr_ey:array[0..3] of Integer = (1,0,-1,0) ;

      BLOCKSIZE = 20 ;
      MAPSIZE = 10 ;
      SCREENW = 320 ;
      SCREENH = 200 ;

var bdnull,bdstarthorz,bdfinish,bdhorz,bdvert,
    bdlefttop,bdrighttop,bdleftbottom,bdrightbottom:TBlockDescr ;

implementation

initialization

bdstarthorz:=TBlockDescr.CreateStartHorz() ;
bdfinish:=TBlockDescr.CreateFinish() ;
bdhorz:=TBlockDescr.CreateHorz() ;
bdvert:=TBlockDescr.CreateVert() ;
bdlefttop:=TBlockDescr.CreateLeftTop() ;
bdrighttop:=TBlockDescr.CreateRightTop() ;
bdleftbottom:=TBlockDescr.CreateLeftBottom() ;
bdrightbottom:=TBlockDescr.CreateRightBottom() ;
bdnull:=TBlockDescr.CreateNull() ;

finalization

bdstarthorz.Free ;
bdfinish.Free ;
bdhorz.Free ;
bdvert.Free ;
bdlefttop.Free ;
bdrighttop.Free ;
bdleftbottom.Free ;
bdrightbottom.Free ;
bdnull.Free ;

end.