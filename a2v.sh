#!/bin/bash
function a2v(){
    mkdir -p output
    echo "Enter the audio data type (eg. "mp3", "wav", "ogg"):"
    read audio 
    echo "Enter the album art file name (eg. image.jpg):"
    read image
    if [ ! -f "$image" ]; then
        echo "File not found!"
        sleep .5
        a2v
    fi
    echo "Enter the video dimensions. If nothing is entered this will default to 1920x1080 (eg. 1920x1080):"
    read dimensions
    if [ -z "$dimensions" ]; then
        vw=$(echo $dimensions | cut -d'x' -f1)
        vh=$(echo $dimensions | cut -d'x' -f2)
    else
        vw=1920
        vh=1080
    fi
    # put in output folder
    for i in *.$audio do 
    # extract the album art from the audio file
    ffmpeg -i "$i" -map 0:1 -c copy "$image"
    ffmpeg -loop 1 -i $image -i "$i" -c:a copy -c:v libx264 -vf "scale=$vw:$vh:force_original_aspect_ratio=decrease,pad=$vw:$vh:(ow-iw)/2:(oh-ih)/2,setsar=1"  -shortest output/"${i%.*}.mp4"
    done
}

function s2v(){
    # input link
    # y2dlp the audio, get the image via curl, then a2v
    echo "Enter the link:"
    read link
    yt-dlp -x --audio-format mp3 --audio-quality 0 --embed-thumbnail --add-metadata --output "%(title)s.%(ext)s" $link
    
}


while true; do
    clear
    echo "Main Menu:"
    echo "1. Audio to Video"
    echo "2. idk what to call this but input a link and then it downloads and ummm ummm ummm"
    echo "3. Exit"
    echo "Enter your choice:"
    read choice

    case $choice in
        1) a2v;;
        2) s2v;;
        3) exit 0 ;;
        *) echo "Invalid choice" && sleep .5;;
    esac
done