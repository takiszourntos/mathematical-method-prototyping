% demo aperiodicity
% ESE2014
%
%

% initialize
clear all;
close all;
clc;

% definitions
wacktor = pi/3 % represents our closest integer relationship with pi
rho2 = 1 % (5) base factor
rho = wacktor*rho2 % closest pi-based approximation
beta= 0.1; % (0.1) speed-up factor
per_sin=round(2*pi/(beta*rho)); % period
numperiods = 8;
L=numperiods*per_sin;
n=(0:(L-1))';


% functions
y1 = cos(beta*(rho)*n); % this should be periodic
y2 = cos(beta*rho2*n); % this should not be
z = y1-y2;
% plot them
figure;
subplot(211);stem(n,y1);title('y_1=cos(\beta \rho n)');xlabel('n');grid;
subplot(212);stem(n,y2);title('y_1=cos(\beta \rho_2 n)');xlabel('n');grid;

% fourier spectra
figure;
y1bar = y1;% .* hann(max(size(y1)));
y2bar = y2;% .* hann(max(size(y2)));
Y1=20*log10(abs(fft(y1bar)));
Y2=20*log10(abs(fft(y2bar)));
plot(n,Y1,'r-',n,Y2,'g--');title('Y_1 and Y_2 spectra');grid;legend('periodic','not periodic');
% error statistics
figure;
histogram(z);
