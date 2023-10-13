SET VERSION=0.5.0

rm -f WaterWayGame16bit-%VERSION%-DOS.zip
cd ..\bin
7z a -mx9 ..\setup\WaterWayGame16bit-%VERSION%-DOS.zip WaterWay.com
cd ..\setup
