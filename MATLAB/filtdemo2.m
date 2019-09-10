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
Fs = 115200; % sampling frequency in Hz
Ts = 1/Fs;
A0 = 1;
num_periods = 2^19;
total_time = num_periods*Ts

% % testing the range of human hearing
% F0 = 22e3;
% n=0:num_periods;
% ytest = A0*sin(2*pi*(F0/Fs)*n);
% sound(ytest,Fs);


% cut-off frequency empirically determined to be 17 kHz
%
%   filter specs
        Fpass = 15e3; % passband edge frequency
        Fstop = 17e3;
        Rp = 0.2; % dB passband ripple
        Rstop = -120; % dB stopband gain
        Astop = -Rstop; % dB stopband attenuation
        Frange = linspace(0,2*Fstop,1000); % specify a frequency range
                                            % for plotting
        Wrange = 2*pi*Frange; % plotting domain in rad/s
        
        %% Butterworth
        N = 60; % butterworth filter order
        Wco = 1.03*2*pi*Fpass;
        [numH,denH] = butter(N,Wco,'low','s'); % design a continuous-time 
                                               % LP filter
        [Hresp,Wresp]=freqs(numH,denH,Wrange);
        figure; plot(Wresp/(2*pi),20*log10(abs(Hresp)));
        xlabel('Hz');ylabel('dB');title('Butterworth Design');grid;
        
        %% Elliptical
        N=15;
        Wp=2*pi*Fpass; % set the passband edge frequency in rad/s
        [numH2,denH2] = ellip(N,Rp,Astop,Wp,'low','s'); % design a 
                                                        % continuous-time
                                                        % LP filter
        [Hresp2,Wresp2]=freqs(numH2,denH2,Wrange);
        figure; plot(Wresp2/(2*pi),20*log10(abs(Hresp2)));
        xlabel('Hz');ylabel('dB');title('Elliptical Design');grid;

                                                     