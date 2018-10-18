%This is for the TCS34725 colour sensor.
%Datasheet:
%https://cdn-shop.adafruit.com/datasheets/TCS34725.pdf

clear all;
close all;


%Create the strings for the query
strings = {'red', 'green', 'blue', 'clear'};

%Load the image
image_file = 'tcs34725_optical_chars_cropped.png';
image = imread(image_file);
[image_height, image_width, ~] = size(image); %third argument is colour channels, and is ignored
%Assign values to the axes
coordinate_handle = imref2d([image_height, image_width]);
coordinate_handle.XWorldLimits = [300, 1100]; %This is wavelength in nm

clicked_data_points = cell(1, 3) %As the number of points selected might differ, we have to use cells here.

for(i=1:3)
    %Display the image
    imshow(image, coordinate_handle);
    title(sprintf('Click on the %s channel points, and press ENTER when finished.', strings{i}))
    xlabel('Wavelength [nm]')
    ylabel('Relative sensitivity');
    set(gca, 'FontSize', 20); %Increase fonts.
    
    
    %Now we need to collect the data from the user.
    clicked_data_points{i} = ginput;
end

close all;

%% Re-organise data
clear temp red_data_points green_data_points blue_data_points 

%First of all, we normalise the channels. Manually. The wavelengths are totally arbitrarily selected, so can't unify just yet.
temp = clicked_data_points{1}; %Red.
red_data_points(:, 1) = temp(:, 1); %Wavelength
red_data_points(:, 2) = 1 - (temp(:, 2) / image_height); %Normalise sensitivity
clear temp; %We need to clear the variable

temp = clicked_data_points{2}; %Green.
green_data_points(:, 1) = temp(:, 1); %Wavelength
green_data_points(:, 2) = 1 - (temp(:, 2) / image_height); %Normalise sensitivity
clear temp; %We need to clear the variable

temp = clicked_data_points{3}; %Blue
blue_data_points(:, 1) = temp(:, 1); %Wavelength
blue_data_points(:, 2) = 1 - (temp(:, 2) / image_height); %Normalise sensitivity
clear temp; %We need to clear the variable

%% Save data to .csv files

%This is also done manually.

%Red
file_id = fopen('red.csv', 'w'); %Creat file or overwite if it exists.
fprintf(file_id, 'wavelength, response\n'); %Create the header
fclose(file_id);
%Add data.
dlmwrite('red.csv', red_data_points, '-append');


%Green
file_id = fopen('green.csv', 'w'); %Creat file or overwite if it exists.
fprintf(file_id, 'wavelength, response\n'); %Create the header
fclose(file_id);
%Add data.
dlmwrite('green.csv', green_data_points, '-append');

%Blue
file_id = fopen('blue.csv', 'w'); %Creat file or overwite if it exists.
fprintf(file_id, 'wavelength, response\n'); %Create the header
fclose(file_id);
%Add data.
dlmwrite('blue.csv', blue_data_points, '-append');

