@ECHO OFF
echo Compiling java source files...
javac *.java
echo Creating necessary directory structures...
mkdir compiled
cd compiled
mkdir resources
cd..
echo Copying in resources...
copy *.class compiled\
copy resources\*.jpg compiled\resources\
copy resources\*.rune compiled\resources\
echo Cleaning up...
del *.class
echo Compilation complete! Testing new source
cd compiled
java Runer