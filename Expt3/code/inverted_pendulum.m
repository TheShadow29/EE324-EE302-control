function [] = inverted_pendulum()
    [A,B,C,D] = get_ABCD();
    [Q,R,N] = get_QR();
    
    K = lqr(A,B,Q,R,N);
    
%     states = {'theta' 'alpha' 'd_theta' 'd_alpha'};
%     inputs = {'u'};
%     outputs = {'theta' 'alpha'};
    
    sys_ss = ss(A,B,C,D);
    poles = eig(A)

    
    A_cl = [(A-B*K)];
    B_cl = [B];
    C_cl = [C];
    D_cl = [D];
    
    sys_cl = ss(A_cl,B_cl,C_cl,D_cl);
    
    t = 0:0.01:5;
    r =0.2*ones(size(t));
    
    [y,t,x]=lsim(sys_cl,r,t);
    [AX,H1,H2] = plotyy(t,y(:,1),t,y(:,2),'plot');
    set(get(AX(1),'Ylabel'),'String','cart position (m)')
    set(get(AX(2),'Ylabel'),'String','pendulum angle (radians)')
    title('Step Response with LQR Control')



    
end
