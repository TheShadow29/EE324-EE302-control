os = 15/100;
set_time = 5;
zeta = sqrt((log(os))^2/(log(os)^2 + pi^2));
x2 = 4.6/set_time;
wn = x2/zeta;

reqd_pole = -zeta*wn + 1i*wn*sqrt(1-zeta^2);
[z,p,k] = zpkdata(sysL);


ret_vec = all_compensator_with_zw(sysL,zeta,wn,'PD');

sys5 = sysL * (70.1216 + 24.9155*s) / s;

ret_vec2 = all_compensator_with_zw(sys5,zeta,wn,'PD');

sys6 = sys5 * (-0.001 + 24.9155*s);
sys6 = (0.0050+24.9200*s)*(s+2.814)*sysL/s;
sys6_1 = feedback(sys6,1);
step(sys6_1);
[Y,T] = step(sys6_1);
stepinfo(Y,T)

% reqd_pole = -rho*wn + 1i*wn*sqrt(1-rho^2);
% 
% x_intercept = -rho*wn;
% y = imag(req_pole);
% x = y/tan(angle_required);
% new_zero = -x_intercept - x; 
% 
% K = (prod(dist_poles)/prod(dist_zeros))/abs(req_pole-new_zero);
% Kp = -K*new_zero;
% Kd = K;  
% ret_vec = [Kp Kd];