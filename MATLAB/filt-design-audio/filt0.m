%%
% analog filter design
%
% specs:
%
% 
% Passband Ripple: 2 dB
% Stopband Attenuation: 80 dB
% Fpass = 16 kHz
% Fstop = 20 kHz

%
clc;
close all;
clear;
spec_pbr_pos = 1; % upper ripple limit as a unitless quantity
spec_pbr_neg = 10^(-2/20); % lower ripple limit as a unitless quantity
spec_sba = 10^(-80/20); % stopband attenuation, converted from dB

Wrange = linspace(0,2*pi*50000,1000000); % linear frequency range for plotting
Frange = (1/(2*pi))*Wrange;
Ypbrpos = spec_pbr_pos*ones(size(Wrange));
Ypbrneg = spec_pbr_neg*ones(size(Wrange));
Ysba = spec_sba*ones(size(Wrange));


%% Butterworth Design
    % design attempt
    Nbw = 43;
    Wnbw = 2*pi*16100;
    [numHbw, denHbw] = butter(Nbw,Wnbw,'s');
    Hbw = tf(numHbw,denHbw);
    [Ybw_mag,Ybw_ph] = bode(Hbw, Wrange);
    Ybw_mag=reshape(Ybw_mag,[1 max(size(Ybw_mag))]);
    Ybw_ph=reshape(Ybw_ph,[1 max(size(Ybw_ph))]);
    
    % plot response with specs superimposed
    figure; plot(Frange, 20*log10(Ybw_mag)); grid;
    title('Butterworth Analog Filter Response (N=43)');
    xlabel('freq (kHz)');
    ylabel('response (dB)');
    % plot specs/constraints for comparison
    hold on; plot(Frange,20*log10(Ypbrpos),'r-', Frange,20*log10(Ypbrneg),'r-',Frange,20*log10(Ysba),'r-');
    xline(16000,'r-'); xline(20000,'r-');
    
    % inspect phase response
    figure; plot(Frange, Ybw_ph); grid;
    title('Butterworth Phase Response (N=43)');
    xlabel('freq (kHz)');
    ylabel('phase (rad)');
    hold on; xline(16000,'r-'); xline(20000,'r-');
    
%% Elliptical Design
    % design attempt
    Ne = 8;
    Rpe = 2;
    Rse = 80;
    Wpe = 2*pi*16000;
    [numHe, denHe] = ellip(Ne,Rpe,Rse,Wpe,'s');
    He = tf(numHe,denHe);
    [Ye_mag,Ye_ph] = bode(He, Wrange);
    Ye_mag=reshape(Ye_mag,[1 max(size(Ye_mag))]);
    Ye_ph=reshape(Ye_ph,[1 max(size(Ye_ph))]);

    % plot response with specs superimposed
    figure; plot(Frange, 20*log10(Ye_mag)); grid;
    title('Elliptical Analog Filter Response (N=8)');
    xlabel('freq (kHz)');
    ylabel('response (dB)');
    % plot specs/constraints for comparison
    hold on; plot(Frange,20*log10(Ypbrpos),'r-', Frange,20*log10(Ypbrneg),'r-',Frange,20*log10(Ysba),'r-');
    xline(16000,'r-'); xline(20000,'r-');

    % inspect phase response
    figure; plot(Frange, Ye_ph); grid;
    title('Elliptical Phase Response (N=8)');
    xlabel('freq (kHz)');
    ylabel('phase (rad)');
    hold on; xline(16000,'r-'); xline(20000,'r-');
    

    



