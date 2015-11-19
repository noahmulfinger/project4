function [ P ] = compute_camera_matrix( I, X )

    num_points = size(X,2);
    
    % Ginput here
    figure, imshow(I)
    [x, y] = ginput(num_points);
    close all
    x = vertcat(x',y',ones(1,num_points));
    
    A = zeros(num_points * 2, 12);
    
    j = 1;
    for i = 1:num_points
        tc = -x(3,i) * X(:,i)';
        tr = x(2,i) * X(:,i)';
        bl = x(3,i) * X(:,i)';
        br = -x(1,i) * X(:,i)';
        A(j,:) = [ 0 0 0 0 tc(1) tc(2) tc(3) tc(4) tr(1) tr(2) tr(3) tr(4) ];
        A(j+1,:) = [ bl(1) bl(2) bl(3) bl(4) 0 0 0 0 br(1) br(2) br(3) br(4) ];
        j = j + 2;
    end
    
    
    [U,S,V] = svd(A);
    P = reshape(V(:,end), [4,3])';
    
end

