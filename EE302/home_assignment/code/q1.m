s = sym('s');
k_w = sym('k_w');
k_s = sym('k_s');
b = sym('b');
m_1 = sym('m_1');
m_2 = sym('m_2');

kw_val = 1000000;
ks_val = 130000;
b_val = 9800;
m1_val = 80;
m2_val = 1500;

A(k_w,k_s,b,m_1,m_2) = [0 1 0 0; -(k_s + k_w)/m_1 -b/m_1 k_s/m_1 b/m_1; 0 0 0 1; k_s/m_2 b/m_2 -k_s/m_2 -b/m_2];
B(k_w,k_s,b,m_1,m_2) = [0;k_w/m_1; 0; 0];
B2(k_w,k_s,b,m_1,m_2) = [0;-1/m_1;0; 1/m_2];
C = [0 0 1 0];
ts = C*inv(s*eye(4) - A)*B;
ts1 = (k_w*(k_s + b*s))/(m_1*m_2*s^4 + (b*m_1 + b*m_2)*s^3 + (k_s*m_1 + k_s*m_2 + k_w*m_2)*s^2 + b*k_w*s+ k_s*k_w);
A_ccf(k_w,k_s,b,m_1,m_2) = -[b*m_1 + b*m_2 k_s*m_1+k_s*m_2+k_w*m_2 b*k_w k_s*k_w]./(m_1*m_2);
Co = [B2 A*B2 A*A*B2 A*A*A*B2];
I = eye(3);
I = [I zeros(3,1)];
Ac = [A_ccf; I];
Ao = Ac';
B0 = [1;0;0;0];
Co_ccf = [B0 Ac*B0 Ac*Ac*B0 Ac*Ac*Ac*B0];
Tinv = Co_ccf*inv(Co);
pole1 = -11.7949 +10.0450i;
pole2 = conj(pole1);
tfs = poly([pole1,pole2,-60,-100]);

[Areq, Breq,Creq,Dreq] = tf2ss(1,tfs);

A_val = double(A(kw_val,ks_val,b_val,m1_val,m2_val));
B_val = double(B(kw_val,ks_val,b_val,m1_val,m2_val));
B2_val = double(B2(kw_val,ks_val,b_val,m1_val,m2_val));
ts_val = ts(kw_val,ks_val,b_val,m1_val,m2_val);
Ac_val = double(Ac(kw_val,ks_val,b_val,m1_val,m2_val));
Co_val = double(Co(kw_val,ks_val,b_val,m1_val,m2_val));
Co_ccf_val = double(Co_ccf(kw_val,ks_val,b_val,m1_val,m2_val));
Tinv_val = double(Tinv(kw_val,ks_val,b_val,m1_val,m2_val));
Ao_val = Ac_val';

K = Ac_val - Areq;
K_val = K(1,:);
K_actual = K_val*Tinv_val;

A_updated = A_val - B2_val*K_actual;

ts_new = C*inv(s*eye(4) - A_updated)*B;
ts_new_val = ts_new(kw_val,ks_val,b_val,m1_val,m2_val);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% For the observer

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Bobs = C';
Co_obs = [Bobs, A'*Bobs, A'*A'*Bobs, A'*A'*A'*Bobs]; 
Tobs_inv = Co_ccf/Co_obs;

Co_obs_val = double(Co_obs(kw_val,ks_val,b_val,m1_val,m2_val));
Tobs_inv_val = double(Tobs_inv(kw_val,ks_val,b_val,m1_val,m2_val));

[Aobs_req, Bobs_req,Cobs_req,Dobs_req] = tf2ss(1,poly([-60, -100, -300, -400]));

Kobs = Ac_val - Aobs_req;
Kobs_val = Kobs(1,:);
Kobs_actual = (Kobs_val*Tobs_inv_val)';

Aobs_updated = A_val - Kobs_actual*C;

A_big = [A_val , -B2_val*K_actual; Kobs_actual*C, A_val - B2_val*K_actual - Kobs_actual*C];
B_big = [B_val;B_val];
C_big = [C ,zeros(1,4)];
sys_big = ss(A_big, [B_val;B_val], [C ,zeros(1,4)], 0);

figure;
step(sys_big);
[b,a] = ss2tf(A_updated, B_val, C, 0);
step(b,a)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%For LQR

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rho = 2;
G_0 = C*inv(s*eye(4) - A)*B2;
G_0_val = G_0(kw_val,ks_val,b_val,m1_val,m2_val);
[n1,d1] = numden(G_0_val);
g_0_num = sym2poly(n1);
g_0_den = sym2poly(d1);
G_0_tf =tf(g_0_num,g_0_den);
g_0_min_num = sym2poly(subs(n1,-s));
g_0_min_den = sym2poly(subs(d1,-s));
G_0_min_tf = tf(g_0_min_num,g_0_min_den);
rho_g_sym = 1 + rho*n1 * subs(n1,-s)/(d1 * subs(d1,-s));
rho_g_tf = 1 + rho*G_0_tf * G_0_min_tf;
[z1,p1,k1] = zpkdata(rho_g_tf,'v');
pole_reqd = p1(real(p1) < 0);
G_1 = poly(pole_reqd);
[Areq_1, Breq_1,Creq_1,Dreq_1] = tf2ss(1,G_1);

F_lqr1 = Ac_val - Areq_1;
F_lqr_val = F_lqr1(1,:);
F_lqr_actual = F_lqr_val*Tinv_val;

A_lqr = A_val - B2_val*F_lqr_actual;

sys_lqr = ss(A_lqr,B_val,C,0);
figure;
step(sys_lqr)
% [b_lqr,a_lqr] = ss2tf(A_lqr, B_val, C, 0);
% figure;
% step(b_lqr,a_lqr);
figure;
impulse(sys_lqr);




