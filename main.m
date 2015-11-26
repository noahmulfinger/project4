clear all
close all

% Image set 1:
% 4177, 4178, 4184, 4186, 4181, 4190

% Image set 2: 
% 4179 4183 4187 4189 4198 4201

%% Code for calculating camera matrices and plotting the given calibration points

I = im2double(imread('./horse/DSCF4201.jpg'));

X = [64 0 0 1;
     64 0 29 1;
     0 80 67 1;
     0 80 48 1;
     180 20 0 1;
     20 180 0 1;
     180 140 0 1;
     0, 0, 19, 1;
    ]';

% Get camera matrix
P = compute_camera_matrix(I,X);


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
% 
% 
figure, imshow(I)
hold on;
for i = 1:size(x,2)
     plot(x(1,i),x(2,i),'Marker','.','Color',[1 0 0],'MarkerSize',20);
end


return; 

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

% Noah's image set:
% 4177, 4178, 4184, 4186, 4181, 4190
images = [ './horse/DSCF4177.jpg'; 
           './horse/DSCF4178.jpg'; 
           './horse/DSCF4181.jpg'; 
           './horse/DSCF4184.jpg'; 
           './horse/DSCF4186.jpg'; 
           './horse/DSCF4190.jpg'];      
cameras = [ 'P4177'; 
           'P4178'; 
           'P4181'; 
           'P4184'; 
           'P4186'; 
           'P4190'];
       
       
% Mike's image set: 
% 4179 4183 4187 4189 4198 4201    
images = [ './horse/DSCF4179.jpg'; 
           './horse/DSCF4183.jpg'; 
           './horse/DSCF4187.jpg'; 
           './horse/DSCF4189.jpg'; 
           './horse/DSCF4198.jpg'; 
           './horse/DSCF4201.jpg'];      
cameras = [ 'P4179'; 
           'P4183'; 
           'P4187'; 
           'P4189'; 
           'P4198'; 
           'P4201'];
       
       
list = [];
points = [0 0 0];

for i = 1:size(images,1)
    for j = 1:size(images,1)
        if i ~= j && ismember(j, list) == 0
            first = im2double(imread(images(i,:)));
            second = im2double(imread(images(j,:)));
            [firstPoints, secondPoints] = cpselect(first, second, 'Wait', true);
            %firstPoints = cpcorr(firstPoints, secondPoints, first, second) 
            load([cameras(i,:) '.mat'])
            load([cameras(j,:) '.mat'])
            t1 = 'P1'
            t2 = 'P2';
            eval(sprintf('%s=%s',t1, cameras(i,:)));
            eval(sprintf('%s=%s',t2, cameras(j,:)));
            
            for k = 1:size(firstPoints,1)
                point = get_3d_points(firstPoints(k,:), secondPoints(k,:), P1, P2); 
                points = [points; point];
            end
        end  
    end
    list = [list i];
end

points = points(2:end,:);

C = ones(3,121);
counter = 1;
for i = 0:20:200
    for j = 0:20:200
        C(1,counter) = i;
        C(2,counter) = j;
        C(3,counter) = 0;
        counter = counter + 1;
    end
end

pointsC = [points; C'];


pointsC
scatter3(pointsC(:,1),pointsC(:,2),pointsC(:,3))


%% Display points from both image sets
% Load in pointset file first

C = ones(3,121);
counter = 1;
for i = 0:20:200
    for j = 0:20:200
        C(1,counter) = i;
        C(2,counter) = j;
        C(3,counter) = 0;
        counter = counter + 1;
    end
end


points = [pointset1; pointset2; C'];
color1 = [ones(size(pointset1, 1), 1) zeros(size(pointset1, 1), 1) zeros(size(pointset1, 1), 1)];
color2 = [zeros(size(pointset2, 1), 1) zeros(size(pointset2, 1), 1) ones(size(pointset2, 1), 1)];
color3 = [zeros(size(C', 1), 1) ones(size(C', 1), 1) zeros(size(C', 1), 1)];
colors = [color1; color2; color3];

scatter3(points(:,1),points(:,2),points(:,3), 5, colors, 'filled')



