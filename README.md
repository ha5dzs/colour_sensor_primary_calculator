
# Colour sensor primary CIE 1931 calculator

I originally wrote this to for the [TCS 34725 colour sensor](https://www.adafruit.com/product/1334), but the code can be used for other sensors too.

# Why bother doing this? Why not just use the RGB values as they are coming out the sensor and carry on?

Well, this is going to be a long one.  
First of all, human colour vision is complicated and there is an awful lot of literature about it. This 'introduction' is just the tip of the eisberg, and you should read some textbooks about it if you'd like to know more.  
So, first of all, colours, as we know them is a tiny part of the electromagnetic spectrum, and the actual colour we see may be the result perceiving a single wavelength (think of lasers), or a mixture of wavelengths (think of TVs). For instance, you could have a table light that you think glows yellow, but in reality, it's a mixture of red and green. Your eyes are not just cameras, and your retina is more than just an image sensor with red, green, and blue pixels. There are colour-selective cones in your retina, but their wavelength response is different. The colour sensor I tried to use has colour sensitivity curves that are quite different from a human. Therefore, I had to 'convert' the values from the sensor to their equivalent of human-like responses. The tri-stimulus values had their instensity stripped, and only the colour information is preserved.  

## I'd like to know more!

Read:  
[https://en.wikipedia.org/wiki/Color_vision](https://en.wikipedia.org/wiki/Color_vision)  
[https://en.wikipedia.org/wiki/CIE_1931_color_space](https://en.wikipedia.org/wiki/CIE_1931_color_space)  
[https://medium.com/hipster-color-science/a-beginners-guide-to-colorimetry-401f1830b65a](https://medium.com/hipster-color-science/a-beginners-guide-to-colorimetry-401f1830b65a)  
Google: 'Colour vision book'  
People get PhDs in colour vision even today, so the more you look at it, the more you realise you don't know. This is normal.

# How does your code work?

There are two parts:
`tcs34725_curve_digitiser.m` is the code that allows digitising the wavelength response curves as they appear in the datasheet. I have organised them by wavelength, and normalised the responses between 0 and 1. All the charactersitics are in a common scale, so the fact that the sensor is less sensitive to blue than green will get reflected in subsequent calculations. The code also saves the data as .csv, for your convenience.  
`find_chromaticity_of_primaries.m` is where the fun stuff happens: it reads in the .csv files you just created, and it also reads the included `ciexyz31_1.csv` file, which contains the colour matching functions for the three channels in the retina.  
Since the wavelengths the sensor data gets sampled by you, it will never match with the wavelengths of the human colour matching functions, the sampled data has to get interpolated. The interpolation results are shown in the figure.  
Then, for each primary channel, we perform an integral, which results in the tri-stimulus values of each colour sensor channel. The chromaticity coordinates for these primary colours are calculated and saved.  
Once these chromaticity coordinateas are obtained, the sensor's detected colour can be calculated from the ADC values themselves.

# ...and your references?

I shamelessly stole the colour matching functions and the integration method from here:
[https://www.mathworks.com/matlabcentral/fileexchange/29620-cie-coordinate-calculator](https://www.mathworks.com/matlabcentral/fileexchange/29620-cie-coordinate-calculator)  
Thanks to Stacey Aston, I read this:  
[https://theses.ncl.ac.uk/dspace/bitstream/10443/1438/1/Wolf%2011.pdf](https://theses.ncl.ac.uk/dspace/bitstream/10443/1438/1/Wolf%2011.pdf)  
...and I also read this, which gave an idea on how to do this properly:
[http://hyperphysics.phy-astr.gsu.edu/hbase/vision/cieprim.html#c3](http://hyperphysics.phy-astr.gsu.edu/hbase/vision/cieprim.html#c3)