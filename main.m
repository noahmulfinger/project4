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

I = im2double(imread('./horse/DSCF4179.jpg'));

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


 
P4190 = compute_camera_matrix(I,X);
P = P4190;


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

B = cat(2, B, ones(36,1))';

D = cat(2, B, C);

x = P * D;
x(1,:) = x(1,:) ./ x(3,:);
x(2,:) = x(2,:) ./ x(3,:);
x(3,:) = x(3,:) ./ x(3,:);


figure, imshow(I)
hold on;
for i = 1:size(x,2)
    plot(x(1,i),x(2,i),'Marker','.','Color',[1 0 0],'MarkerSize',20);
end












