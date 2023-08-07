# this script converts audio files to video files with album art as the background cool awesome
echo "Enter the audio data type (eg. "mp3", "wav", "ogg"):"
read audio
echo "Enter the album art file name (eg. image.jpg):"
read image

for i in *.$audio; do ffmpeg -loop 1 -i $image -i "$i" -c:a copy -c:v libx264 -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2,setsar=1"  -shortest "${i%.*}.mp4"; done