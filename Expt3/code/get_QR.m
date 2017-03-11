function [Q,R,N] = get_QR()
%     Convention:
%      x = [theta alpha d_theta d_alpha]
    Q = zeros(4);
    Q(1,1) = 1/30;
    Q(2,2) = 1/3;
    Q(3,3) = 1/30;
    Q(4,4) = 1/3;
    
    R = 1/12;  
    
    N = zeros(4,1);
end
