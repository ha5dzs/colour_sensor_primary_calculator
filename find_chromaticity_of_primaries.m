% This script loads the four data files, and creates one big fat lookup table
% 'red.csv', 'green.csv', and 'blue.csv' are created by 'point and click',
% as per in tcs34725_curve_digitiser.m
% 'ciexyz31_1.csv' came from the CIE co-ordinate calculator
clear all;
close all;

colour_matching_functions = csvread('ciexyz31_1.csv');
    % Column 1 is wavelength in nanometres.
    % Column 2 is 'long' cones, i.e. red
    % Column 3 is 'medium' cones, i.e. green
    % Column 4 is 'short' cones, i.e. blue

red_channel = csvread('red.csv', 1); %Ignore the first row
green_channel = csvread('green.csv', 1); %Ignore the first row
blue_channel = csvread('blue.csv', 1); %Ignore the first row
    % Column 1 is wavelength in nanometres
    % Column 2 is normalised response to the appropriate channel.

%Now that all the data is loaded, we need to create a unified response. The
%index is the wavelength in the sensory curves.

%% Interpolate data.

interpolation_method = 'spline';

% We need to make sure interp1 doesn't complain due to duplicate points.
    % Red
[~, red_indices] = unique(red_channel(:, 1));
red_interpolated = interp1(red_channel(red_indices, 1), red_channel(red_indices, 2), colour_matching_functions(:, 1), interpolation_method);
    %Normalise between 0 and 1
%red_interpolated = (red_interpolated - min(red_interpolated)) / (max(red_interpolated) - min(red_interpolated));

    % Green
[~, green_indices] = unique(green_channel(:, 1));
green_interpolated = interp1(green_channel(green_indices, 1), green_channel(green_indices, 2), colour_matching_functions(:, 1), interpolation_method);
    %Normalise between 0 and 1
%green_interpolated = (green_interpolated - min(green_interpolated)) / (max(green_interpolated) - min(green_interpolated));

    % Blue
[~, blue_indices] = unique(blue_channel(:, 1));
blue_interpolated = interp1(blue_channel(blue_indices, 1), blue_channel(blue_indices, 2), colour_matching_functions(:, 1), interpolation_method);
    %Normalise between 0 and 1
%blue_interpolated = (blue_interpolated - min(blue_interpolated)) / (max(blue_interpolated) - min(blue_interpolated));


%Plot.
plot(colour_matching_functions(:, 1), red_interpolated, 'r-');
hold on;
plot(colour_matching_functions(:, 1), green_interpolated, 'g-');
plot(colour_matching_functions(:, 1), blue_interpolated, 'b-');
title('Interpolated normalised sensitivity curves for the three colour channels')
xlabel('Wavelength [nm]')
ylabel('Relative sensitivity')

%% Calculate tristimulus values for the primaries

%First of all, we need to multiply the human sensory curves with the three
%colour channels, and then we do the numerical integration.
    % Red primary:
red.X_ydata = colour_matching_functions(:, 2) .* red_interpolated;
red.Y_ydata = colour_matching_functions(:, 3) .* red_interpolated;
red.Z_ydata = colour_matching_functions(:, 4) .* red_interpolated;
    % Integrate!
red.X = trapz(colour_matching_functions(:, 1), red.X_ydata);
red.Y = trapz(colour_matching_functions(:, 1), red.Y_ydata);
red.Z = trapz(colour_matching_functions(:, 1), red.Z_ydata);


   % Green primary:
green.X_ydata = colour_matching_functions(:, 2) .* green_interpolated;
green.Y_ydata = colour_matching_functions(:, 3) .* green_interpolated;
green.Z_ydata = colour_matching_functions(:, 4) .* green_interpolated;
    % Integrate!
green.X = trapz(colour_matching_functions(:, 1), green.X_ydata);
green.Y = trapz(colour_matching_functions(:, 1), green.Y_ydata);
green.Z = trapz(colour_matching_functions(:, 1), green.Z_ydata);


   % Blue primary:
blue.X_ydata = colour_matching_functions(:, 2) .* blue_interpolated;
blue.Y_ydata = colour_matching_functions(:, 3) .* blue_interpolated;
blue.Z_ydata = colour_matching_functions(:, 4) .* blue_interpolated;
    % Integrate!
blue.X = trapz(colour_matching_functions(:, 1), blue.X_ydata);
blue.Y = trapz(colour_matching_functions(:, 1), blue.Y_ydata);
blue.Z = trapz(colour_matching_functions(:, 1), blue.Z_ydata);

%% Calculate chromaticity for the primaries.

red.x = red.X / (red.X + red.Y + red.Z);
red.y = red.Y / (red.X + red.Y + red.Z);
red.z = red.Z / (red.X + red.Y + red.Z);

green.x = green.X / (green.X + green.Y + green.Z);
green.y = green.Y / (green.X + green.Y + green.Z);
green.z = green.Z / (green.X + green.Y + green.Z);

blue.x = blue.X / (blue.X + blue.Y + blue.Z);
blue.y = blue.Y / (blue.X + blue.Y + blue.Z);
blue.z = blue.Z / (blue.X + blue.Y + blue.Z);

output_string = sprintf("The gamut is as follows:\nRed: X = %f, Y = %f, Z = %f, x = %f, y = %f, z = %f\nGreen: X = %f, Y = %f, Z = %f, x = %f, y = %f, z = %f\nBlue: X = %f, Y = %f, Z = %f, x = %f, y = %f, z = %f\n", red.X, red.Y, red.Z, red.x, red.y, red.z, green.X, green.Y, green.Z, green.x, green.y, green.z, blue.X, blue.Y, blue.Z, blue.x, blue.y, blue.z);
fprintf(output_string);
%Save it to a file too.
file_handle = fopen('primaries.txt', 'w');
fprintf(file_handle, output_string);
fclose(file_handle);
