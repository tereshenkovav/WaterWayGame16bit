SET VERSION=0.5.0

rm -f WaterWayGame16bit-%VERSION%-DOSBox-Win32.zip
7z a -mx9 WaterWayGame16bit-%VERSION%-DOSBox-Win32.zip ..\bin
cd dosbox
7z a -mx9 ..\WaterWayGame16bit-%VERSION%-DOSBox-Win32.zip *
cd ..
