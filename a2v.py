import os
import subprocess

def audio_to_video():
    audio_type = input("Enter the audio data type (eg. \"mp3\", \"wav\", \"ogg\"): ")
    image_filename = input("Enter the album art file name (eg. image.jpg): ")

    for audio_file in os.listdir():
        if audio_file.endswith('.' + audio_type):
            output_filename = os.path.splitext(audio_file)[0] + '.mp4'
            cmd = [
                'ffmpeg',
                '-loop', '1', '-i', image_filename,
                '-i', audio_file,
                '-c:a', 'copy', '-c:v', 'libx264', '-vf', 'scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2,setsar=1',
                '-shortest', output_filename
            ]
            subprocess.run(cmd)

    print("Conversion completed.")
    
def soundcloud_to_youtube():
    pass

def upload_to_youtube():
    pass

def main_menu():
    print(
        "1. Convert audio to video\n"
        "2. Convert SoundCloud to YouTube\n"
        "3. Upload to YouTube\n")
    selection = input("Enter your selection: ")
    if selection == '1':
        audio_to_video()
    elif selection == '2':
        soundcloud_to_youtube()
    elif selection == '3':
        upload_to_youtube()

def main():
    main_menu()


main()


