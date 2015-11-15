clear all
close all

% Read in images (center and peripherals)
resize = .5;
center = imresize(im2double(imread('./edmunds/center.JPG')), resize);
per1 = imresize(im2double(imread('./edmunds/top.JPG')), resize);
per2 = imresize(im2double(imread('./edmunds/bottom.JPG')), resize);



% Select any number of pairs of points that correspond between images
[moved, fixed] = cpselect(per, center, 'Wait', true);
moved = cpcorr(moved, fixed, per, center);
