%
%
% PCM encoder design for dc motor control based on delta-sigma modulation
%
%   in this script, we design the NTF for a second-order PCM encoder
%   and derive the corresponding discrete-time loop gain
%
%   we use an analog elliptical filter prototype for the NTF with in-band
%   zeros; while a higher-order design is possible, we wanted to have a 
%   stable encoder that was not too computationally costly
%
%   author: Takis Zourntos
%   date: May 2019
% 
%   Copyright (C) 2019 MIT License
%
%

% initialize workspace
clc;
clear all;
close all;


% sample rate of PCM (don't need really high res)
F_s = 250e3;% 2^18 % how fast we expect the clock to go ~ 10kHz - 100kHz
OSR = 512
F_b = F_s/(2*OSR)
F_range = linspace(0,4*F_b,2^20)';


%%% second-order design:
%
% design the NTF as an elliptic high-pass filter
Rs=300;
maxoobg = 1.5; Rp=40*log10(maxoobg);
[numNTF,denNTF] = ellip(2,Rp,Rs,2*pi*F_b,'high','s');
% FYI    [B,A]  = ellip(N,Rp,Rs,Wp) designs an Nth order lowpass
% fix Matlab's normalization:
numNTF=maxoobg*numNTF;
numNTF = single(numNTF);
denNTF = single(denNTF);
NTF = tf(numNTF, denNTF);
[mag, ph] = bode(NTF,2*pi*F_range);
maga(:,1) = mag(1,1,:); pha(:,1) = ph(1,1,:);
figure;plot(F_range, 20*log10(maga));grid;title('2nd-order solution');
max(maga) % confirm max OOBG

% get loop filter
denHs = numNTF;
denHs_corrected = [denHs(1) 0 0];
numHs = denNTF-numNTF;
numHs_corrected = [0 numHs(2) numHs(3)];
Hs_original = tf(numHs, denHs);
Hs = tf(numHs_corrected, denHs_corrected);

% confirm NTF still works after corrections:
numNTFtest = denHs;
denNTFtest = denHs + numHs;
NTFtest = tf(numNTFtest, denNTFtest);
[magtest, phtest] = bode(NTFtest,2*pi*F_range);
magtesta(:,1) = magtest(1,1,:); phtesta(:,1) = phtest(1,1,:);
figure;plot(F_range, 20*log10(maga),'b+',F_range, 20*log10(magtesta),'r-');grid;title('2nd-order solution - corrected');
max(magtesta) % confirm max OOBG


%%% convert discrete-time
Hd = c2d(Hs,1/F_s,'zoh');
[numHd,denHd]=tfdata(Hd, 'v');
[Ad,Bd,Cd,Dd] = tf2ss(numHd, denHd);