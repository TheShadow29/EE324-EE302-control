function [ret_vec] = all_compensator_with_zw(sysL, zeta,wn, str, arg1, arg2)
% This the function to evaluate the constant K and the closed loop poles for the given 
% criteria of overshoot and settling time
% p is a vector containing the poles of the transfer function
% z is a vector containing the zeros of the transfer function
% OS is the percentage overshoot. It is a number in 0 to 1
% ST is the settling time mentioned in seconds
% str is to decide what to give as output
% arg1 and arg2 are required for some cases

% Determine the location of the pole given the specifications
% tan_phi = (-pi/log(OS));
% if(strcmp(time_type,'settling'))
%     x_intercept = 4.6/time;
% elseif(strcmp(time_type,'rise'))
%     wn = 1.8/time;
%     zeta = cos(atan(tan_phi));
%     x_intercept = zeta*wn;
% end
[z,p,k] = zpkdata(sysL);
z = cell2mat(z);
p = cell2mat(p);
x_intercept = zeta*wn;

% req_pole = -x_intercept + x_intercept*tan_phi*1i;
req_pole = -x_intercept + 1i*wn*sqrt(1-zeta^2);

% Determine the angles from the original poles
angle_zeros = zeros(size(z));
angle_poles = zeros(size(p));
if(isempty(z))
    angle_zeros = 0;
    dist_zeros =1;
else
    angle_zeros =  angle(req_pole - z);
    dist_zeros = abs(req_pole -z);
end

if(isempty(p))
    angle_poles = 0;
    dist_poles = 1;
else
    angle_poles = angle(req_pole - p);
    dist_poles = abs(req_pole - p);
end

angle_openloop = sum(angle_zeros) - sum(angle_poles);
angle_required = 0;
% This part computed the angle required assuming that the number of poles are less
% enough to amount to +180 or -180. It can be modified to +-540.
if(angle_openloop > 0)
    angle_required = pi - angle_openloop;
else
    angle_required = -pi - angle_openloop;
end


% We now consider different cases
% Clearly proportional controller would not help as there are two
% conditions so we directly take the cases of differentiator
if (strcmp(str,'PD'))
%     if(angle_required < pi/2)
%         y = imag(req_pole);
%         x = y/tan(angle_required);
%         new_zero = -x_intercept - x;        
%     elseif(angle_required == pi/2)
%         new_zero = -x_intercept;
%     elseif(angle_required > pi/2)
%         y = imag(req_pole);
%         x = y/tan(pi-angle_required);
%         new_zero = -x_intercept + x;
%     end
    y = imag(req_pole);
    x = y/tan(angle_required);
    new_zero = -x_intercept - x; 
% I think the above three lines are equivalent to the commented portion
% above and signs will adjust automatically

    K = (prod(dist_poles)/prod(dist_zeros))/abs(req_pole-new_zero);
    Kp = -K*new_zero;
    Kd = K;  
    ret_vec = [Kp Kd];
end

% ----------------------------------------------- %
if(strcmp(str,'PI'))
    % This is never asked and also does not make a not of sense but pucha
    % toh dekh lenge
end

% ----------------------------------------------- %
if(strcmp(str,'PID'))
    % Copy the code of PD and then add a pole at zero and again apply the
    % PD wala code.  I think this should suffice.
end

% ----------------------------------------------- %
if(strcmp(str,'lead'))
    if(strcmp(arg1,'p'))
        added_pole = arg2;
        angle_required = angle_required + angle(req_pole - added_pole);
        y = imag(req_pole);
        x = y/tan(angle_required);
        new_zero = -x_intercept - x; 
        K = (prod(dist_poles)/prod(dist_zeros))*(abs(req_pole-added_pole)/abs(req_pole-new_zero));
        ret_vec = [new_zero K];
    elseif(strcmp(arg1,'z'))
        added_zero = arg2;
        angle_required = angle_required - angle(req_pole - added_zero);
        % It^ has to be negative
        y = imag(req_pole);
        x = y/tan(angle_required); % x will be negative because angle_required will be negative
        new_pole = -x_intercept + x; 
        K = (prod(dist_poles)/prod(dist_zeros))*(abs(req_pole-new_pole)/abs(req_pole-added_zero));
        ret_vec = [new_pole K];
    end
end


if(strcmp(str,'lag'))
    if(strcmp(arg1,'p'))
        added_pole = arg2;
        angle_required =  angle(req_pole - added_pole) - angle_required;
        y = imag(req_pole);
        x = y/tan(angle_required);
        new_zero = -x_intercept - x; 
        K = (prod(dist_poles)/prod(dist_zeros))*(abs(req_pole-added_pole)/abs(req_pole-new_zero));
        ret_vec = [new_zero K];
    elseif(strcmp(arg1,'z'))
        added_zero = arg2;
        angle_required =  angle(req_pole - added_zero) + angle_required;
        % It^ has to be a large positive value whose tan will be negative
        y = imag(req_pole);
        x = y/tan(angle_required); % x will be negative because angle_required will be large positive
        new_pole = -x_intercept - x; 
        K = (prod(dist_poles)/prod(dist_zeros))*(abs(req_pole-new_pole)/abs(req_pole-added_zero));
        ret_vec = [new_pole K];
    end
end


        

end