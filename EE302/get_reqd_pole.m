function [pole, zeta, wn] = get_reqd_pole(os, time,time_type)
    
tan_phi = (-pi/log(os));
if(strcmp(time_type,'settling'))
    x_intercept = 4.6/time;
    zeta = cos(atan(tan_phi));
    wn = x_intercept/zeta;
elseif(strcmp(time_type,'rise'))
    wn = 1.8/time;
    zeta = cos(atan(tan_phi));
    x_intercept = zeta*wn;
end
 

pole = -x_intercept + x_intercept*tan_phi*1i;

end
