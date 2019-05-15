## Copyright (C) 2019 Takis Zourntos
## author: Takis Zourntos
## date: May 2019
##
function SS0 = ss_miso_series(SS1,SS2)
%%
%% SS0 = ss_miso_series(SS1, SS2)
%%
%% This function assumes that the SISO and MISO systems, 
%% SS1 and SS2, respectively, are connected in series, i.e., 
%%
%%                      w
%%                      | 
%%     u1        y1     V     y2
%%   ----> SS1 ------> SS2 ----->
%%
%% The function returns the state-space model of the 
%% resulting system: 
%%
%%                 w
%%                 |
%%                 V
%%   ---------->  SS0 ---------->
%%       u1               y2
%%

  % define the state-space matrices
  A1 = SS1.a;
  B1 = SS1.b;
  C1 = SS1.c;
  D1 = SS1.d;
  A2 = SS2.a;
  B2 = SS2.b;
  B21 = B2(:,1);
  B22 = B2(:,2);
  C2 = SS2.c;
  D2 = SS2.d;
  D21 = D2(:,1);
  D22 = D2(:,2);
  
  % pull the dimensions
  n1 = max(size(A1)); % the number of states for SS1
  m1 = size(B1)(2); % the number of inputs for SS1
  p1 = size(C1)(1); % the number of outputs for SS1
  n2 = max(size(A2)); % the number of states for SS2
  m2 = size(B2)(2); % the number of inputs for SS2
  p2 = size(C2)(1); % the number of outputs for SS2
  
  % assemble the state-space model of the series system
  A0 = [A1        zeros(n1,n2);
        B21*C1    A2];
  B0 = [B1        zeros(n1,1);
        B21*D1    B22];
  C0 = [D21*C1    C2];
  D0 = [D21*D1     D22];
  
  % form the SS model for return
  SS0 = ss(A0,B0,C0,D0);
  
  endfunction