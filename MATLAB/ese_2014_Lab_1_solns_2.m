%
% Lab 1 solutions
%
% authors: T. Zourntos (13290113)
%
% date: June 2, 2017
%

% initialize
clear all;
clc;
close all;

% Part 1.: create a vector
x = [1 2 3 4 5 6]; % creates a row vector
y = [7; 8; 9; 0; 1; 2; 3]; % creates a column vector
z = x'; % transpose x to create a column vector
av = rand(1,6);
zerovector = zeros(7,1);
onesvector = ones(7,1);

% Part 2.: create a matrix
M0  = [1 2;3 4];
M0t = M0';
Mrand = 100*(rand(5,5)-0.5*ones(5,5));
Mzero = zeros(5,5);
Mones = ones(3,6);

% Part 5.: compute the inner product and cross product of two matrices 
xv = [1;2;3];
yv = [4;5;6];
dotprodxy = xv'*yv; % dot product
e100 = [1;0;0]; % elementary basis vector, x-direction, R^3
e010 = [0;1;0]; % elementary basis vector, y-direction, R^3
crossprodxy = cross(e100,e010);

% Part 7.: concatenate matrices
M4x4 = rand(4,4);
M1x4 = rand(1,4);
M4x1 = rand(4,1);
M1x1 = rand(1,1);
M5 = [M4x4 M4x1; M1x4 M1x1];










