%
% dc motor model & control
%
%       ultimately seeking a stabilizing PCM-based feedback control
%       (will require armature current sensing)
%
%       for reference, checkout 08-08-2019 work journal entry
%
% author: Takis Zourntos
% date: August 9, 2019
%
close all;
clear all;
clc;
%% motor parameters (off of Pololu spec sheet)
Vr = 6; % motor rated voltage, [volts]
I_stall_Vr = 1.5; % stall current at rated voltage [amps]
W_free_run_Vr = 68.1; % free-run speed (rad/s) at rated voltage
T_stall = 0.0074; % stall torque [kg m]

% derived from spec sheet parameters and/or estimated (ballparked)
J = 0.0001; % rotor mechanical inertia [N m s^2 / rad]
b = 0.00001; % viscous damping coefficient
Ke = Vr/W_free_run_Vr; % emf constant
KT = T_stall/I_stall_Vr; % torque constant, i.e., torque = KT i_a
Ra = Vr/I_stall_Vr; % armature winding resistance (Ohms)
La = 0.1; % armature winding inductance (Henries)

%% plant dynamics, PM
Ap = [ -(Ra/La)*(J/KT)   -Ke/La; (KT/J)  -b/J ];
Bp = [ (1/La); 0];
Bd = [ 0;   1   ];
Cp_omega = [0 1];
Cp_ia    = [1 0];
Cp = [Cp_omega; Cp_ia];
Dp = 0;
PMss = ss(Ap, Bp, Cp, Dp);

%% controller: CM(s) and state-feedback gain, kC
gam0 = 1; % controller gain
gam1 = 1; % first (optional) controller zero at s = -gam1
gam2 = 1; % second (optional) controller zero at s = -gam2
gam3 = 1; % first (optional) non-zero pole of controller at s = -gam3
gam4 = 1; % second (optional) non-zero pole of controller at s = -gam4
numCM0 = gam0*poly([gam1]);
denCM0 = poly([0; -gam3]);
CM0 = tf(numCM0,denCM0);
CM0ss = ss(CM0); [ACM0, BCM0, CCM0, DCM0] = ssdata(CM0ss);

%% LM: series connection of CM and PM
LM = series(CM0, PMss, 1, 1);
  

%% simulation parameters
TS = 0; % set to 1 for torque (i_a) tracking,
        % set to 0 for speed (\omega) tracking


% % let's do a simulation
% delta = 0.005;
% % notable time points with corresponding inputs sizes (steps)
% Tstar = [delta   0.5    1.0   3.0   3.5   3.75    4.0   5.0];
% Uvals = [0       1.0   -1.0   0.0   0.5   -0.5    0.0   0.0];
% T=0;
% U1=0;
% U2=0;
% for i = 1:(max(size(Tstar))-1)
%   TR  = (Tstar(i):delta:(Tstar(i+1)-delta))';
%   T   = [T; TR];
%   UR  = Uvals(i)*ones(max(size(TR)),1);
%   U1  = [U1; UR]; % stabilizing feedback
%   U2  = [U2; -1*UR]; % disturbance
% end; % for
% 
% U = [U1 U2]; 
% 
% [Ysim, Tsim, X] = lsim(SSk, U, T);
% figure; plot(Tsim,Ysim); title("output and state response"); grid;
% figure; 
% subplot(411);plot(Tsim,X(:,1),'r-');grid;title("controller state");
% subplot(412);plot(Tsim,X(:,2),'g-');grid;title("theta");
% subplot(413);plot(Tsim,X(:,3),'b-');grid;title("thetadot");
% subplot(414);plot(Tsim,X(:,4),'r-',T,U(:,1),'b-',T,U(:,2),'g-');
% grid;title("i_a, reference and disturbance input");
% 
