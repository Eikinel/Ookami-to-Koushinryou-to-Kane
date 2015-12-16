echo "== copying main.lua from sources folder =="
cp sources/main.lua Ookami-to-Koushinryou-to-Kane-LINUX/
echo "== creating a .love file for Linux =="
cd Ookami-to-Koushinryou-to-Kane-LINUX/
zip -9rq Ookami-to-Koushinryou-to-Kane.love .
cd ../
echo "== exporting game for Windows =="
cat Ookami-to-Koushinryou-to-Kane-WINDOWS/love.exe Ookami-to-Koushinryou-to-Kane-LINUX/Ookami-to-Koushinryou-to-Kane.love > Ookami-to-Koushinryou-to-Kane-WINDOWS/Ookami-to-Koushinryou-to-Kane.exe
echo "== DONE ! =="
