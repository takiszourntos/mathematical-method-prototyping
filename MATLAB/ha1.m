% analog filter design
%
%

N = 7;
Rp = 0.25;
Rs = 80;
Wp = 2*pi*8000;

[num,den] = ellip(N,Rp,Rs,Wp,'s');
