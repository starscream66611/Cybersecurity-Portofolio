# META - Blue Team Labs Online - Digital Forensics

![alt text](<screenshot/Screenshot 2026-08-22 at 9.05.55 AM.png>)

This challenge is about digital forensics. So, the given file is an image file that we need to investigate with 4 questions that we need to answers.

- Tools

    for this challenge im using tools such:
    - Kali Linux --> Operating Sytem
    - Kali Terminal --> Command and control
    - 7zip --> Unzipping the file
    - exiftool --> image information
    - Google --> Search Image

# Extracting The File

After i downloaded the file, im using kali terminal to make sure the file is safe to be unzipped by listing the content of the file before unzipping it.

im using command 'unzip -l file_name.zip':
![alt text](<screenshot/Screenshot 2026-08-22 at 9.11.40 AM.png>)

So, inside the zip there's 2 file with .JPG and .png extension

.JPG --> standart JPEG file format
.png --> Portable Network Graphics is using lossles compression.

- Unzipping the file

    After checking the zip content im going to unzip it using command 'unzip file_name.zip'

    ![alt text](<screenshot/Screenshot 2026-08-22 at 9.20.45 AM.png>)

    and it's not working, im trying to use another tool called 7zip to unzipping the file.

    im unzipping using terminal with command '7z x file_name.zip':

    - x -> extracting the file

    ![alt text](<screenshot/Screenshot 2026-08-22 at 9.27.52 AM.png>)
  
# Image Investigation

It works, so now im going to use exiftool for investigating the images.

ExifTool is a free program used to read, write, and change hidden data (metadata) inside image, audio, video, and document files.

I start by analyzing the .JPG image first. Because, .JPG file stored more EXIF data and information. 

- uploaded_1.JPG

    The result of the first image

    ![alt text](<screenshot/Screenshot 2026-08-22 at 9.35.07 AM.png>)
        
    By using exiftool, i could gather information without clicking or seeing the image.

    the inforamation that we could gather here is: 

    - Modification, access, inode change date
    - File Permission : -rw-rw-r-- -> owner, group, others
    - Camera model : Canon EOS 550D
    - Create Date : 2021:11:02 13:20:23

    and there's also a comment on this image
    ![alt text](<screenshot/Screenshot 2026-08-22 at 9.49.28 AM.png>)
    Comment : "relying on altered metadata to catch me?"

    also i could find a GPS position 
    ![alt text](<screenshot/Screenshot 2026-08-22 at 9.51.11 AM.png>)

    GPS Position: 32 deg 40' 3.87" S, 279 deg 29' 31.87" W

- uploaded_2.png

    This is the result of the .png file after using exif tool

    ![alt text](<screenshot/Screenshot 2026-08-22 at 9.45.32 AM.png>)

    not much information that we could gather here

# Coordinates Investigation

This is the information that we could gather:
- Date created: 2021:11:02 13:20:23
- Camera Model: Canon EOS 550D
- File Permission : -rw-rw-r--
- Comment: "relying on altered metadata to catch me?"
- GPS Position: 32 deg 40' 3.87" S, 279 deg 29' 31.87" W

So im changing the GPS position information into decimal by using exiftool.

Command: 'exiftool -n -GPSPosition uploaded_1.JPG'
![alt text](<screenshot/Screenshot 2026-08-22 at 10.06.59 AM.png>)
- GPS Position: 32.6677411483056 -279.4921875

After that, im using Google Maps to check where this coordinates leads to.

![alt text](<screenshot/Screenshot 2026-08-22 at 10.09.31 AM.png>)

I can't find anyhting with this coordinates. So, im checking the coordinates rules on Google.

![alt text](<screenshot/Screenshot 2026-08-22 at 10.12.01 AM.png>)
![alt text](<screenshot/Screenshot 2026-08-22 at 10.13.33 AM.png>)

So i found the problem with my coordinates. the google maps can't proccess it because, my longitude exceeded the number rules on google. 

so, -279.4921875 + 360 = 80.5078125

- GPS Coordinates now = 32.6677411483056, 80.5078125
Now, i input the result to google maps and here's the result

and still cant find anything and im trying to use apple maps 
and here's where it leads

![alt text](<screenshot/Screenshot 2026-08-22 at 10.39.30 AM.png>)

but, to be sure about whether this is the right location, we need to actually see the image.
![alt text](<screenshot/Screenshot 2026-08-22 at 10.43.12 AM.png>)

and check it using google search and here's what i found 
![alt text](<screenshot/Screenshot 2026-08-22 at 10.45.07 AM.png>)

# Result & Conclusion
Camera model that being use is Canon EOS 550D, the picture was taken at 2021:11:02 13:20:23 in Kathmandu Durbar Square.

The EXIF metadata contains GPS that are incosistent with the actual image.

GPS Position 32.6677411483056, 80.5078125 leads to Ngari,Tibet, China. While, the actual image leads to Kathmandu. This Inconsistency suggest that the GPS metadata has been altered.

![alt text](<screenshot/Screenshot 2026-08-22 at 9.49.28 AM.png>)
This comment, are evidence that we couldn't relying on the Metadata itself.


