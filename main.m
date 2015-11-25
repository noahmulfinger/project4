clear all
close all

% Noah's image set:
% 4177, 4178, 4184, 4186, 4181, 4190

I = im2double(imread('./horse/DSCF4190.jpg'));

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
B = cat(2, B, ones(36,1))';

% Add these points to checkerboard points
D = cat(2, B, C);

% Normalize based on 3rd input
x = P * D;
x(1,:) = x(1,:) ./ x(3,:);
x(2,:) = x(2,:) ./ x(3,:);
x(3,:) = x(3,:) ./ x(3,:);


figure, imshow(I)
hold on;
for i = 1:size(x,2)
    plot(x(1,i),x(2,i),'Marker','.','Color',[1 0 0],'MarkerSize',20);
end












