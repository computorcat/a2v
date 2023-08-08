
import os
import glob
from bs4 import BeautifulSoup
import requests
import subprocess
import re
import yt_dlp

def a2v(audio=None, image=None, dimensions=None):
    if not all([audio, image, dimensions]):
        audio = input("Enter the audio data type (e.g., mp3, wav, ogg):")
        image = input("Enter the image file name (e.g. image.jpg):")
        # search directory for image file
        if not os.path.isfile(image):
            print("File not found!")
            a2v(0, 0, 0)
        dimensions = input("Enter the video dimensions (e.g., 1920x1080):")
    if not dimensions:
        vh = 1080
        vw = 1920
    else:
        vh = dimensions.split("x")[0]
        vw = dimensions.split("x")[1]
    os.makedirs("output", exist_ok=True)
    audio_files = glob.glob(f"*.{audio}")
    for audio_file in audio_files:
        output_filename = os.path.join("output", os.path.splitext(audio_file)[0] + ".mp4")
        cmd = [
            "ffmpeg",
            "-loop", "1", "-i", image,
            "-i", audio_file,
            "-c:a", "copy",
            "-c:v", "libx264",
            "-pix_fmt", "yuv420p",
            "-vf", f"scale={vw}:{vh}:force_original_aspect_ratio=decrease,pad={vw}:{vh}:(ow-iw)/2:(oh-ih)/2,setsar=1",
            "-shortest",
            output_filename
        ]
        subprocess.run(cmd)

def rfw():
    link = input("Input a link to a song: ")
    title = yt_dlp.YoutubeDL().extract_info(link, download=False)['title']
    if not title:
        print("Error: Can't fetch title.")
        rfw()
    clean_title = re.sub(r'[\/:*?"<>|]', '', title)
    os.makedirs(clean_title, exist_ok=True)
    os.chdir(clean_title)
    cmd = ["yt-dlp", "-x", "--audio-format", "mp3", link]
    subprocess.run(cmd)
    cmd = ["yt-dlp", "--get-thumbnail", link]
    subprocess.run(cmd)
    cmd = ["wget", "-O", "image.jpg", subprocess.run(cmd, capture_output=True).stdout.decode("utf-8")]
    a2v("mp3", "image.jpg", "1920x1080")

def menu():
    print("Main Menu")
    print("---------")
    print("1. Audio to Video")
    print("2. Rip from Web")
    print("3. Exit")
    choice = input("Enter your choice: ")
    if choice == "1":
        a2v(0,0,0)
    elif choice == "2":
        rfw()
    elif choice == "3":
        exit()
    else:
        print("Invalid choice. Please try again.")
        menu()


menu()
