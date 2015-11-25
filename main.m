clear all
close all

% Noah's image set:
% 4177, 4178, 4184, 4186, 4181, 4190

% Mike's image set: 
% 4179 4183 4187 4189 4198 4201

% 2D: C=sum_i__v [xi yi] / n
% u = sum || vi - C || / n
%Transformation:           A 
% 1) subtract C [1 0 -c; 0 1 -c; 0 0 1]            B
% 2) scale by sqrt(2)/u [sqrt(2)/u 0 0; 0 sqrt(2)/u 0; 0 0 1]
% T = BA



%% Code for calculating camera matrices 

% I = im2double(imread('./horse/DSCF4179.jpg'));

% X = [64 0 29 1; bottom-right red block top 
%     64 0 0 1; bottom-right blue block bottom
%     64 64 29 1; top-right red block corner top
%     32 48 67 1; yellow block top right top  
%     32 80 67 1; yellow block bottom right top
%     32 80 29 1; corner green block bottom-right below-yellow
%     180 20 0 1; 1 in both x,y from lower-right most checkerboard corner 
%     180 180 0 1; 1 in both x,y from upper-right most checkerboard corner 
%     20 180 0 1]'; 1 in both x,y from upper-left most checkerboard corner 


X = [64 0 29 1;
     64 0 0 1;
     64 64 29 1;
     32 48 67 1;
     32 80 67 1;
     32 80 29 1;
     180 20 0 1;
     180 180 0 1;
     20 180 0 1]';


% Get camera matrix
% P = compute_camera_matrix(I,X);


% Checkerboard points
C = ones(4,121);
counter = 1;
for i = 0:20:200
    for j = 0:20:200
        C(1,counter) = i;
        C(2,counter) = j;
        C(3,counter) = 0;
        counter = counter + 1;
    end
end

% Set of points from calibration document
B = [0, 0, 0;
64, 0, 0;
64, 64, 0;
0, 64, 0;
0, 0, 19;
64, 0, 19;
64, 64, 19;
0, 64, 19;
0, 0, 29;
64, 0, 29;
64, 64, 29;
0, 64, 29;
16, 16, 29;
48, 16, 29;
48, 48, 29;
16, 48, 29;
16, 16, 48;
48, 16, 48;
48, 48, 48;
16, 48, 48;
0, 48, 29;
32, 48, 29;
32, 80, 29;
0, 80, 29;
0, 48, 48;
32, 48, 48;
32, 80, 48;
0, 80, 48;
0, 48, 48;
32, 48, 48;
32, 80, 48;
0, 80, 48;
0, 48, 67;
32, 48, 67;
32, 80, 67;
0, 80, 67];

% Attach 1's to end, transpose
% B = cat(2, B, ones(36,1))';

% Add these points to checkerboard points
% D = cat(2, B, C);

% Normalize based on 3rd input
% x = P * D;
% x(1,:) = x(1,:) ./ x(3,:);
% x(2,:) = x(2,:) ./ x(3,:);
% x(3,:) = x(3,:) ./ x(3,:);
% 
% 
% figure, imshow(I)
% hold on;
% for i = 1:size(x,2)
%     plot(x(1,i),x(2,i),'Marker','.','Color',[1 0 0],'MarkerSize',20);
% end




%% Epipolar Line Tool using Image Set 1

%Load in camera matrices for subset 1:
P = load('P4177.mat');
P4177 = P.P4177;
P = load('P4178.mat');
P4178 = P.P4178;
P = load('P4181.mat');
P4181 = P.P4181;
P = load('P4184.mat');
P4184 = P.P4184;
P = load('P4186.mat');
P4186 = P.P4186;
P = load('P4190.mat');
P4190 = P.P4190;


% Reference image to select point from
I = im2double(imread('./horse/DSCF4177.jpg'));

figure, imshow(I)
[x, y] = ginput(1);
close all
input = vertcat(x',y',ones(1,1));

subplot(2,3,1)
imshow(I)
hold on, plot(input(1),input(2),'Marker','.','Color',[1 0 0],'MarkerSize',20), hold off

subplot(2,3,2)
[x, y] = get_epipolar_line(I, P4177, P4178, input);
J = im2double(imread('./horse/DSCF4178.jpg'));
imshow(J), hold on, plot(x, y), hold off

subplot(2,3,3)
[x, y] = get_epipolar_line(I, P4177, P4181, input);
J = im2double(imread('./horse/DSCF4181.jpg'));
imshow(J), hold on, plot(x, y), hold off

subplot(2,3,4)
[x, y] = get_epipolar_line(I, P4177, P4184, input);
J = im2double(imread('./horse/DSCF4184.jpg'));
imshow(J), hold on, plot(x, y), hold off

subplot(2,3,5)
[x, y] = get_epipolar_line(I, P4177, P4186, input);
J = im2double(imread('./horse/DSCF4186.jpg'));
imshow(J), hold on, plot(x, y), hold off

subplot(2,3,6)
[x, y] = get_epipolar_line(I, P4177, P4190, input);
J = im2double(imread('./horse/DSCF4190.jpg'));
imshow(J), hold on, plot(x, y), hold off

%% Select points for 3D reconstruction

images = [ './horse/DSCF4177.jpg'; 
           './horse/DSCF4178.jpg'; 
           './horse/DSCF4178.jpg'; 
           './horse/DSCF4178.jpg'; 
           './horse/DSCF4178.jpg'; 
           './horse/DSCF4181.jpg'];
       
list = [];


 A = get_3d_points([100,1000], [2,2], P4177, P4178);
 return;

for i = 1:size(images,1)
    for j = 1:size(images,1)
        if i ~= j && ismember(j, list) == 0
            first = im2double(imread(images(i,:)));
            second = im2double(imread(images(j,:)));
            [firstPoints, secondPoints] = cpselect(first, second, 'Wait', true);
            %firstPoints = cpcorr(firstPoints, secondPoints, first, second);
            firstPoints
        end  
    end
    list = [list i];
end

%  % Select any number of pairs of points that correspond between images
% [moved, fixed] = cpselect(per, center, 'Wait', true);
% 
% % Refine points using cross-correlation
% moved = cpcorr(moved, fixed, per, center);




