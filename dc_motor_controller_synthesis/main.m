%
% dc motor model & control
%
%     ultimately seeking a stabilizing PCM-based feedback control
%     (will require armature current sensing)
%
% author: Takis Zourntos
% date: May 12, 2019
%

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
  J = 0.00001; % rotor mechanical inertia [N m s^2 / rad]
  b = 0.000001; % viscous damping coefficient
  Ke = Vr/W_free_run_Vr; % emf constant
  KT = T_stall/I_stall_Vr; % torque constant, i.e., torque = KT i_a
  Ra = Vr/I_stall_Vr; % armature winding resistance (Ohms)
  La = 0.1; % armature winding inductance (Henries)

% state model, x1 = theta; x2 = theta_dot; x3 = i_a

% A-matrix
Am = [0             1             0;
      0             -(b/J)        (KT/J);
      0             -(Ke/La)      -(Ra/La);];
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

% we don't have an observable system, so our best bet is output-feedback
% control; let's try it
Sm = ss(Am, Bm, Cm, Dm); % get a state model of the main system
Hm = tf(Sm);


