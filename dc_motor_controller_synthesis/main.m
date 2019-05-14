%
% dc motor model & control
%
%     ultimately seeking a stabilizing PCM-based feedback control
%     (will require armature current sensing)
%
% author: Takis Zourntos
% date: May 12, 2019
%
close all;
clear all;
clc;
pkg load control;

% motor parameters
  % off of Pololu spec sheet
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

% state model, x1 = theta; x2 = theta_dot; x3 = i_a

% A-matrix
Am = [0             1             0;
      0             -(b/J)        (KT/J);
      0             -(Ke/La)      -(Ra/La)];
% B-matrix
Bm = [0;
      0;
      (1/La)];
% disturbance (w) coefficient
Rm = [0;
      1;
      0];     
% C-matrix
Cm = [0             0             1]; % we can only measure armature current
% D-matrix
Dm = 0;

% determine observability (we cannot measure x1 and x2)
Mobsv   = obsv(Am, Cm);
rMobsv  = rank(Mobsv); % this rank should be equal to 3 for observability

% check controllability... can we move that unstable eigenvalue?
Mctrb   = ctrb(Am, Bm);
rMctrb  = rank(Mctrb); % this rank should be equal to 3 for controllability

% we don't have an observable system, so our best bet is output-feedback
% control; let's try it --- BTW, rMctrb = 3, therefore it's all we need
Sm = ss(Am, Bm, Cm, Dm); % get a state model of the main system
eigs_Sm = eig(Am);
Hm = tf(Sm);
numHm = cell2mat(Hm.num);
denHm = cell2mat(Hm.den);
zeros_Hm = roots(numHm);
poles_Hm = roots(denHm);

% the system from disturbance, w, to the output y, may be described as:
Sd = ss(Am, Rm, Cm, Dm);
Hd = tf(Sd);
numHd = cell2mat(Hd.num);
denHd = cell2mat(Hd.den);
zeros_Hd = roots(numHd);
poles_Hd = roots(denHd);

% form the loop gain for design, trial with integrator controller
Ac = 0;
Bc = 1;
Cc = 400; % this is actually the gain, k0, to be determined by root locus
Dc = 0;
SSc = ss(Ac,Bc,Cc,Dc); % state-space model of controller
SSL = ss_series(SSc,Sm);
rlocus(SSL); 
% based on root locus, we pick k=100;
SSk = ss_simple_neg_feedback(SSL, 1);

% let's do a simulation
delta = 0.005;
% notable time points with corresponding inputs sizes (steps)
Tstar = [delta   0.5    1.0   3.0   3.5   3.75    4.0   5.0];
Uvals = [0       1.0   -1.0   0.0   0.5   -0.5    0.0   0.0];
T=0;
U=0;
for i = 1:(max(size(Tstar))-1)
  TR = (Tstar(i):delta:(Tstar(i+1)-delta))';
  T = [T; TR];
  U = [U; Uvals(i)*ones(max(size(TR)),1)];
endfor
[Ysim, Tsim, X] = lsim(SSk, U, T);
figure; plot(Tsim,Ysim); title("output and state response"); grid;
figure; 
subplot(411);plot(Tsim,X(:,1),'r-');grid;title("controller state");
subplot(412);plot(Tsim,X(:,2),'g-');grid;title("theta");
subplot(413);plot(Tsim,X(:,3),'b-');grid;title("thetadot");
subplot(414);plot(Tsim,X(:,4),'r-',T,U,'b-');grid;title("i_a and reference");

