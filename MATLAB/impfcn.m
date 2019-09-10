function [delta] = impfcn(n0,nleft,nright)
% generates an impulse function, from n=nleft to n=nright
% places the 1 at the value n=n0

nindex = nleft:nright;
offset = sign(nleft)*nleft+1;
n1index = 1:(nright-nleft+1);
deltainit = zeros(size(nindex));
deltainit(n0-sign(nleft)*offset) = 1;

delta = deltainit;


