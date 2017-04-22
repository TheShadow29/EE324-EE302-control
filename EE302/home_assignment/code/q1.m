s = sym('s');
kw = sym('k_w');
ks = sym('k_s');
b = sym('b');
m1 = sym('m_1');
m2 = sym('m_2');

kw_val = 1000000;
ks_val = 130000;
b_val = 9800;
m1_val = 80;
m2_val = 1500;

A(kw,ks,b,m1,m2) = [0 1 0 0; -(ks + kw)/m1 -b/m1 ks/m1 b/m1; 0 0 0 1; ks/m2 b/m2 -ks/m2 -b/m2];
B(kw,ks,b,m1,m2) = [0;kw/m1; 0; 0];
B2(kw,ks,b,m1,m2) = [0;-1/m1;0; 1/m2];
C = [0 0 1 0];
ts = C*inv(s*eye(4) - A)*B;
A_ccf(kw,ks,b,m1,m2) = -[b*m1 + b*m2 ks*m1+ks*m2+kw*m2 b*kw ks*kw]./(m1*m2);
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

