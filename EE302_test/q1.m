s = tf('s');
sysL = 1/(s*(s^3 + 12*s^2 + 44*s + 48));
% impulse(sysL);
% step(sysL);
% tf(sysL);
[num,den] = tfdata(-1/sysL);
syms x;
f = poly2sym(cell2mat(num),x)/poly2sym(cell2mat(den),x);
% d1 = poly2sym(cell2mat(den),x);
% d1 = d1 + 37.1274;
% d11 = double(solve(d1,x));
g = diff(f,x);
g0 = double(solve(g,x));
os = 15/100;
rlocus(sysL);
% hold on
zeta = -log(os)/sqrt(pi^2 + log(os)^2);
sgrid(zeta,100);
% [x1,y1] = ginput(1);
x1 = -0.5638;
y1 = 0.9670;
s1 = x1 + 1i*y1;
pr1 = evalfr(sysL,s1);
K = -1/real(pr1);
% K = 38.2;
% K= 1;
sys3 = feedback(K*sysL,1);
step(feedback(K*sysL,1));
% step(sys3/s);
step(sys3);
[Y,T] = step(sys3);
stepinfo(Y,T)
sys2 = feedback(K*sysL,1);
[z,p,k] = zpkdata(sys3/s^2)

% tan_phi = -pi/log(s);










