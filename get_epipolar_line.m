function [ xVals, yVals ] = get_epipolar_line(I, P1, P2, x)
    
%     figure, imshow(I)
%     [x, y] = ginput(1);
%     close all
%     input = vertcat(x',y',ones(1,1));

    
    e1 = P2 * null(P1);
    
    e1x = [ 0 -e1(3) e1(2);
        e1(3) 0 -e1(1);
        -e1(2) e1(1) 0];
    
    P1i = pinv(P1);
    
    F = e1x * (P2 * P1i);
    
    line = F * x;

    sizeX = size(I, 2);

    xVals = 1:sizeX;
    yVals = -line(1)/line(2) * xVals - line(3)/line(2);


end

