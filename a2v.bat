@echo off

set /p audio="Enter the audio data type (eg. mp3, wav, ogg): "
echo %audio%
set /p image="Enter the album art file name (eg. image.jpg): "
echo %image%

for %%i in (*.%audio%) do (
    ffmpeg -loop 1 -i %image% -i "%%i" -c:a copy -c:v libx264 -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2,setsar=1" -shortest "%%~ni.mp4"
)

