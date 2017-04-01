s=%s
K=1,T=1
OS = 0.30
tr = 0.08
SimpleSys =syslin('c',K/(1+T*s))
t =0:0.01:15;
y1=csim('step',t,SimpleSys);
//plot(t,y1)
zeta = - log(OS)/sqrt(%pi^2 + log(OS) ^2)
wn = (1/(tr*sqrt(1-zeta^2)))*(%pi - atan(sqrt(1-zeta^2))/zeta)
u2 = sin(t);
y2 = csim(u2,t,SimpleSys);
//plot (t, [u2;y2]')
//evans(SimpleSys)
p = s^2+9*s+9
root= roots(p)
fMin = 0.01
fMax = 10
//scf(0)
//bode(SimpleSys, fMin, fMax)
//xs2png(0, 'Bode.png')
//scf(1)
//evans(SimpleSys)
//xs2png(1, 'RL.png')
A = [0 , 1; -1 ,-0.5]
B = [ 0 ; 1]
C = [1 , 0]
D = [0]
x0 = [ 1 ; 0 ]
SSsys = syslin( 'c' , A , B , C , D , x0 )
t =0:0.1:50;
u = 0.5*ones(1,length(t))
[y,x] = csim(u,t,SSsys);
scf(1)
//plot (t,y)
scf(2)
//plot (t, x)
//evans (SSsys)
tf = ss2tf(SSsys)
poles = roots(denom(tf))
evalues  = spec(A)
SubSys1 = syslin( 'c' ,1/s)
SubSys2 = 2
Series = SubSys1 * SubSys2
Parallel = SubSys1 + SubSys2
Feedback = SubSys1/.SubSys2
nyquist(SimpleSys)
