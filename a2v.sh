#!/bin/bash
function a2v(){
    mkdir -p output

    read -rp "Enter the audio data type (e.g., mp3, wav, ogg): " audio
    read -rp "Enter the album art file name (e.g., image.jpg): " image

    if [ ! -f "$image" ]; then
        echo "File not found!"
        sleep 0.5
        a2v
    fi

    read -rp "Enter the video dimensions (e.g., 1920x1080): " dimensions

    # if dimensions is empty, set to 1920x1080
    if [ -z "$dimensions" ]; then
        vw=1920
        vh=1080
    else
        vw=$(echo "$dimensions" | cut -d'x' -f1)
        vh=$(echo "$dimensions" | cut -d'x' -f2)
    fi
    # put in output folder
    echo "$vw"
    echo "$vh"
    pause 

    for audio_file in *."$audio"; do
        ffmpeg -loop 1 -i "$image" -i "$audio_file" -c:a copy -c:v libx264 -vf "scale=$vw:$vh:force_original_aspect_ratio=decrease,pad=$vw:$vh:(ow-iw)/2:(oh-ih)/2,setsar=1" -shortest "output/${audio_file%.*}.mp4"
    done
}

while true; do
    clear
    echo "Main Menu:"
    echo "1. Audio to Video"
    echo "2. idk what to call this but input a link and then it downloads and ummm ummm ummm"
    echo "3. Exit"
    echo "Enter your choice:"
    read -r choice

    case $choice in
        1) a2v;;
        2) s2v;;
        3) exit 0 ;;
        *) echo "Invalid choice" && sleep .5;;
    esac
done