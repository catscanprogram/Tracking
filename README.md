# Color Tracking Webcam

Ever wanted Instagram filters in real life? The color tracking webcam uses colors YOU show it to add colorful filters to your
webcam feed. Simply move an object to the color detecting square in the top left corner and watch as the color is applied to your
webcam!

Here's how it works:

Upon start, the program takes a screenshot of your webcam to calculate the average color of the background. It then compares that
color to the current color being displayed in the color detection box and if they're different - presto! A filter is applied.
Of course, it's a little more complicated than magic.

You can find a demo of the color webcam [here](https://vimeo.com/259095753)!

**UPDATE!**

The code has been updated and can be found in the code folder. The duotone becomes a permanent filter once applied. Aditional color comparisions were added in addition to the comparison with the background. 

An attempt was made to implement a more visually accurate color comparison using lab space, however, implementation was not successful. The filter still flickers when an object goes from being held in front of the screen to off screen. Hopefully these persisting problems can soon be solved. 

![logo](https://github.com/catscanprogram/Tracking/blob/master/Tracking_Screenshot_2.png)

