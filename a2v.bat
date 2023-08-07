@echo off
setlocal EnableDelayedExpansion
:: this is only for walls i think i'm going to throw up
:: atp just use WSL im not contributing to this anymore lol
:MENU
cls
echo Main Menu:
echo 1. Audio to Video
echo 2. Download and Convert
echo 3. Exit
set /p choice=Enter your choice: 

if "%choice%"=="1" (
    call :A2V
) else if "%choice%"=="2" (
    call :S2V
) else if "%choice%"=="3" (
    exit /b 0
) else (
    echo Invalid choice
    timeout /t 1 >nul
    goto MENU
)

:A2V
set "audio="
set "image="
set "dimensions="

set /p "audio=Enter the audio data type (e.g., mp3, wav, ogg): "
set /p "image=Enter the album art file name (e.g., image.jpg): "
set /p "dimensions=Enter the video dimensions (e.g., 1920x1080): "

if not exist "%image%" (
    echo File not found!
    timeout /t 0.5 >nul
    goto A2V
)

if "%dimensions%"=="" (
    set "vw=1920"
    set "vh=1080"
) else (
    for /f "tokens=1,2 delims=x" %%a in ("%dimensions%") do (
        set "vw=%%a"
        set "vh=%%b"
    )
)

echo !vw!
echo !vh!
pause

for %%A in (*.%audio%) do (
    ffmpeg -loop 1 -i "%image%" -i "%%A" -c:a copy -c:v libx264 -pix_fmt yuv420p -vf "scale=!vw!:!vh!:force_original_aspect_ratio=decrease,pad=!vw!:!vh!:(ow-iw)/2:(oh-ih)/2,setsar=1" -shortest "output\%%~nA.mp4"
)

goto :EOF

:S2V
set /p "link=Input a link to a song: "
for /f %%T in ('yt-dlp --get-title "%link%" ^| more +1') do set "title=%%T"
if errorlevel 1 (
    echo Error fetching title from yt-dlp
    exit /b 1
)

set "clean_title=!title:/=!"
set "clean_title=!clean_title:\=!"
set "clean_title=!clean_title::=!"
set "clean_title=!clean_title:"=!"
set "clean_title=!clean_title:<?=!"
set "clean_title=!clean_title:>=!"
set "clean_title=!clean_title:|=!"
set "clean_title=!clean_title:?=!"
set "clean_title=!clean_title:<=!"
set "clean_title=!clean_title:>=!"
set "clean_title=!clean_title:|=!"
set "clean_title=!clean_title:^<=!"
set "clean_title=!clean_title:>^=!"
set "clean_title=!clean_title:^|=!"
mkdir "%clean_title%"
cd "%clean_title%" || exit /b

yt-dlp -x --audio-format mp3 "%link%"
if errorlevel 1 (
    echo Error downloading audio with yt-dlp
    exit /b 1
)

for /f %%I in ('yt-dlp --get-thumbnail "%link%"') do set "thumbnail=%%I"
wget -O image.jpg "%thumbnail%"
if errorlevel 1 (
    echo Error downloading image with wget
    exit /b 1
)

call :A2V mp3 image.jpg 1920x1080
exit /b

:EOF