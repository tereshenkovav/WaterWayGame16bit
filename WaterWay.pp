program WaterWay ;

uses GameEngine16, Game ;

var
   pal:array[0..29] of byte ;
   tekframe:Word ;
   framen:Cardinal ;
   tekgame:TGame ;

begin

   Screen($13) ;
   ClearScreen(0) ;

   tekgame:=TGame.Create() ;

   pal[0]:=20 ; pal[1]:=20 ; pal[2]:=20 ;
   pal[3]:=30 ; pal[4]:=30 ; pal[5]:=30 ;
   pal[6]:=40 ; pal[7]:=40 ; pal[8]:=40 ;
   SetPaletteData(16,3,pal) ;

   SoundOn() ;
   SoundFreq(1000) ;
 
   framen:=0 ;
   while true do begin
     tekframe:=StartFrame() ;

     tekgame.Render() ;

     if framen = 18 then SoundOff() ;

     if not tekgame.Update() then Break ;
     Inc(framen) ;

     WaitFrameCompleted(tekframe) ;
   end ;
  
   Screen($3) ;
   Writeln(MemAvail()) ;
   tekgame.Free ;
end.
