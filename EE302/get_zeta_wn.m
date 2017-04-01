function [rho,wn,pole] = get_zeta_wn(os, set_time)
    rho = sqrt((log(os))^2/(log(os)^2 + pi^2));
    x2 = 4.6/set_time;
    wn = x2/rho;
    pole = -rho*wn + 1i*wn*sqrt(1-rho^2);
end
