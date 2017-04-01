m = 1
b = 10
k = 20
s = %s
OS = 0.30
tr = 0.08
System = k/(m*s^2 + b*s + k)
wn = sqrt(k/m)
zeta = (b/m)/(2*wn)
t =0:0.01:3;
y1=csim('step',t,System);
//plot(t,y1)
SystemClosed = System/. 1
yFeedback = csim('step',t,SystemClosed);
//plot(t,yFeeback)
Rs = 1/s
//css1 = horner (s*System*Rs, 0)
zeta = - log(OS)/sqrt(%pi^2 + log(OS) ^2)
wn = (1/(tr*sqrt(1-zeta^2)))*(%pi - atan(sqrt(1-zeta^2))/zeta)
PI = (s+1)/s
evans(PI*System)
sgrid(zeta, wn)
Kpi = -1/real(horner(PI*System,[1 %i]*locate(1)))
PIsystem = Kpi*PI*System/. 1
css2 = horner (s*PIsystem* Rs, 0)
yPI = csim('step',t,PIsystem);
plot (t, yPI)
zoom_rect([0 0 2 1.4])
title(['Root locus for','$L(s)=\frac{s+1}{s+12}\frac{1}{s^2[(s+0.1)^2+6.6^2]}$'],'fontsize',3)
xlabel("t", "fontsize", 2);
ylabel("Output", "fontsize", 6, "color", "blue");

ymax = max(yPI);
y_inf = yPI($);
y_settle = 0.01*y_inf;
t_settle = max(t(yPI > abs(y_inf + y_settle)));
os = (ymax - y_inf)/y_inf;
rise_time = min(t(yPI > 0.9*y_inf)) - min(t(yPI > 0.1*y_inf));
                   
