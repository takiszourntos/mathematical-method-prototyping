%
% filter design demonstration
%
%       ESE 2014: DSP, Lambton/Cestar College
%
%       author: Takis Zourntos
%
%       design of various filters through various means,
%       both analog and digital
%

clear all;
close all;
clc;

% definitions
Fs = 76800; % sampling frequency in Hz
Ts = 1/Fs;
A0 = 1;
num_periods = 2^20;
total_time = num_periods*Ts

% testing the range of human hearing
%F0 = 2.5e3/10;
%n=0:num_periods;
%ytest = A0*sin(2*pi*(F0/Fs)*n);
%sound(ytest,Fs);

% cut-off frequency empirically determined to be 17 kHz

%% Filter Designs
%
    % general filter specs
    Fpass = 10e3; % in Hz
    Fstop = 17e3; % in Hz
    Amin = -120; % in dB
    
    % Butterworth design
    N=4; % filter order
    Fco=Fpass;
    [numH, denH] = butter(N,2*pi*Fco,'s');
    H=tf(numH,denH);
    Frange=linspace(0,10*Fstop,1000); % set up plot domain
    [Hresp,Wresp]=freqs(numH,denH,2*pi*Frange); % get frequency response
    Fresp=Wresp/(2*pi); % convert to Hz
    plot(Fresp,20*log10(abs(Hresp))); grid; xlabel('Hz');
    
    
    
    
    
    
    
    
    bode(H);
    grid;
    
    
