close all;

s = tf('s');
sysG = 1/((s^2 + 20*s + 101)*(s+20));
k = 7899;
sysD = (s-10.36)/(s+15);
sysL = sysD * sysG;

% rho = 5;
% wn = 5;

% sysL = (s+2)^2/((s^2)*(s+10)*(s^2 + 6*s+25));
% sysL = (s^2 + s + 2)/(s*(s+5)*(s+6)*(s+1)^2);
% sysL = (s+2)/(s*(s+1)*(s+5));
% sysL = (s^2 + 9)/(s*(s^2 + 144));
% sysL = (85.0000 + 9.0000*s)/((s+3)*(s+5));
% sysL =  1/((s+3)*(s+5));
% sysL = 0.072*(s+23)*(s^2 + 0.05*s + 0.04)/((s-0.7)*(s+1.7)*(s^2+ 0.08*s+0.04));
sysL = 1/((s+4)*(s+15));
[x,f] = tf2sym(-1/sysL);
g = diff(f,x);
g0 = solve(g,x);
rlocus(sysL);
% a = ginput(1);

sgrid(rho,wn);

k1 = -1/real(evalfr(sysL,[1 1i]*ginput(1)'));
y_ss1 = evalfr(s*feedback((k1*sysL/s),1),0);

[z,p,k] = zpkdata(sysL);
z = cell2mat(z);
m = size(z,1);
p = cell2mat(p);
n = size(p,1);
alpha = (sum(p) - sum(z))/(n-m);
asymptodes = 360/(n-m);
% z = cell2mat(z);
figure;
% step(sysL/(1+sysL));
sys_cl = feedback(sysL,1);
% step(sys_cl);
[Y,T] = step(sys_cl);
[Y1,T1] = step(sysL);
step(sysL,'b',sys_cl,'r');
legend('open_loop','close_loop');
% plot(T,Y,Y1);
ymax = max(Y);
% y_inf = Y(end);
y_inf = evalfr(sysL,0);

y_settle = 0.01*y_inf;
% t_settle = (T(Y>abs(y_inf + y_settle) & Y>abs(y_inf-y_settle)));
t_settle = max(T(Y > abs(y_inf + y_settle)));
os = (ymax - y_inf)/y_inf;
rise_time = min(T(Y > 0.9*y_inf)) - min(T(Y > 0.1*y_inf));
disp(t_settle);
disp(os);
tmax = T(Y == ymax);
% plot(T,Y);
% step(k*sysL/(1+k*sysL));
% step(sysG/(1+sysG));