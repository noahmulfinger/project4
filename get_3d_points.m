function [ A ] = get_3d_points( x1, x2, P1, P2 )

    
    A = [x1(1) * P1(3,:)' - P1(1,:)';
         x1(2) * P1(3,:)' - P1(2,:)';
         x2(1) * P2(3,:)' - P2(1,:)';
         x2(2) * P2(3,:)' - P2(2,:)'];
     
    A
    
    [U,S,V] = svd(A);
    V

end

