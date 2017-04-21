K = 178.8717;
zlag = 8.4e-4;
zlead = 1.99;
plag = 1e-4;
plead = 6.2014;
sysM = K*(s+zlag)*(s+zlead)/((s+plead)*(s+plag));
sysN = sysL*sysM;
sys9 = feedback(sysN,1);
step(sys9);

[Y,T] = step(sys9);
stepinfo(Y,T)