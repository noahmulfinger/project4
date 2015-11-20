clear all
close all

% Noah's image set:
% 4177, 4178, 4184, 4186, 4181, 4190

I = im2double(imread('./horse/DSCF4177.jpg'));

X = [ 100 200 200   0   0  64  64;
        0  40 200 200   0   0  64;
        0   0   0   0  19  19  19;
        1   1   1   1   1   1   1];


 
P = compute_camera_matrix(I,X);



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

% x = P * a;  
x = P * C;
x(1,:) = x(1,:) ./ x(3,:);
x(2,:) = x(2,:) ./ x(3,:);
x(3,:) = x(3,:) ./ x(3,:);


figure, imshow(I)
hold on;
for j = 1:121
    plot(x(1,j),x(2,j),'Marker','.','Color',[1 0 0],'MarkerSize',20);
end
% figure, imshow(I)
% hold on;
% for i = 1:121
%     plot(x(1,i),x(2,i),'Marker','.','Color',[1 0 0],'MarkerSize',20);
% end


% a = [32; 48; 48; 1];

% b = apply_camera_matrix(P, a);



% x(1) = x(1) / x(3);
% x(2) = x(2) / x(3);
% x(3) =  1;
% x
% plot(x(1),x(2),'Marker','.','Color',[1 0 0],'MarkerSize',20);




% center = zeros(3000, 3000);
% 
% [X, Y] = meshgrid(1:300:3001, 1:300:3001);
% 
% n = 12;
% w = 640;
% h = 480;
% x = [ w 0 ; 0 h ] * rand( 2, n );
% xmeas = [ round( x + randn( 2, n )) ; ones( 1, n ) ]
% xpmeas = [ round( xp(1:2,:) + randn( 2, n )); ones( 1, n ) ];
% return;


% for i = 1:3000
%     for j = 1:3000
%         if mod(i, 300) == 0 && mod(j, 300) == 0
%             center(i,j) = 1;
%         end            
%     end
% end



% Select any number of pairs of points that correspond between images
% moved = cpcorr(moved, fixed, per, center)% moved = cpcorr(moved, fixed, per, center);
