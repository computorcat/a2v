#!/bin/bash
function a2v(){
    mkdir -p output
    audio="$1"
    image="$2"
    dimensions="$3"
    # if #1 and #2 and #3 are empty, ask for them
    if [ -z "$audio" ] && [ -z "$image" ] && [ -z "$dimensions" ]; then
        read -rp "Enter the audio data type (e.g., mp3, wav, ogg): " audio
        read -rp "Enter the album art file name (e.g., image.jpg): " image

        if [ ! -f "$image" ]; then
            echo "File not found!"
            sleep 0.5
            a2v
        fi

        read -rp "Enter the video dimensions (e.g., 1920x1080): " dimensions
    fi
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
        ffmpeg -loop 1 -i "$image" -i "$audio_file" -c:a copy -c:v libx264 -pix_fmt yuv420p -vf "scale=$vw:$vh:force_original_aspect_ratio=decrease,pad=$vw:$vh:(ow-iw)/2:(oh-ih)/2,setsar=1" -shortest "output/${audio_file%.*}.mp4"
    done
}

function s2v(){
    read -rp "Input a link to a song: " link
    title=$(yt-dlp --get-title "$link" | head -n 1)
    if [ $? -ne 0 ]; then
        echo "Error fetching title from yt-dlp"
        return 1
    fi

    clean_title=$(echo "$title" | tr -d '/\:*?"<>|')
    mkdir -p "$clean_title"
    cd "$clean_title" || exit

    yt-dlp -x --audio-format mp3 "$link"
    if [ $? -ne 0 ]; then
        echo "Error downloading audio with yt-dlp"
        return 1
    fi

    wget -O image.jpg "$(yt-dlp --get-thumbnail "$link")"
    if [ $? -ne 0 ]; then
        echo "Error downloading image with wget"
        return 1
    fi

    a2v mp3 image.jpg 1920x1080
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