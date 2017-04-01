t = 0:0.01:4;
u = sin(10*t);
lsim(sysL,u,t)   % u,t define the input signal
y_ss = evalfr(sysL,0);
%for ramp or any other signal can directly use step(G/s);
%use evalfr to get the value at a particular point