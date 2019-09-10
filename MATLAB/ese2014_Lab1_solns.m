%
% this is my files
% name: Takis Zourntos
% occupation: philosopher
%
%

% initialization
clc;
clear all;
close all;

% Problem 1.: Create a vector
x = rand(7,1);
xrow = x';

% Problem 2.: Create a matrix

A = rand(7,7); % create a random 7x7 matrix
I5 = eye(5); % create a 5x5 identity matrix

% Problem 3.:   Create a 5x1 vector of zeros.
%               Create a 1x5 vector of random numbers.
z5 = zeros(5,1);
r5row = rand(1,5);

% Problem 4.: Transpose a matrix
Atranspose = A';

% Problem 5.:   Compute the inner product of two matrices
%               Compute the cross product of two matrices
%               Compute the inverse of a matrix
    x = [1 2 3]';
    y = [4;5;6];
    dotxy = x'*y;
    e100 = [1;0;0];
    e010 = [0;1;0];
    crossprod = cross(e100,e010);
    % let's try to invert A
    if (rank(A)==max(size(A)))
        Ainv = inv(A);
    end;

% Problem 6.:   Compute the element-wise multiplication of a matrix and a
%               scalar
emms = pi*ones(4,4);

% Problem 7.:   Concatenate two matrices
zcat = [x;y];
M = 3*ones(6,6);
N = zeros(6,2);
MN = [M N];

% Problem 8.:   Create a vector of complex numbers
j = sqrt(-1); % this is how engineers do it!!
voc = (rand(4,1)-0.5*ones(4,1)) + j*(rand(4,1)-0.5*ones(4,1));

% Problem 9.:   Multiply a row of a matrix with an element of that same
%               matrix
Arow4 = A(4,:);
Arow456 = A(5,6)*Arow4;

% Problem 10.:  Generate a vector of values ranging from 0 to 500 with 100
%               elements
xbigrand500 = 500*rand(100,1);
figure;plot(xbigrand500,'.'); grid;

% Problem 11.:  Create a 2D plot of the sine function between 0 and 2*pi
n = 2*pi*(0:0.001:1); % create our independent variable
ysine = sin(n);
figure;plot(n,ysine);grid;

% Problem 12.:








