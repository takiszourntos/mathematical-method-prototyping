function SS0 = series_ss(SS1,SS2)
  
  % this function assumes that the systems SS1 and SS2
  % are connected in series, i.e., 
  %
  %     u1        y1          y2
  %   ----> SS1 ------> SS2 ----->
  %
  %   ---------->  SS0 ---------->
  %       u1               y2
  %
  % author: Takis Zourntos
  % date: May 2019
  %
  
  % define the state-space matrices
  A1 = SS1.a;
  B1 = SS1.b;
  C1 = SS1.c;
  D1 = SS1.d;
  A2 = SS2.a;
  B2 = SS2.b;
  C2 = SS2.c;
  D2 = SS2.d;
  
  % pull the dimensions
  n1 = max(size(A1)); % the number of states for SS1
  m1 = size(B1)(2); % the number of inputs for SS1
  p1 = size(C1)(1); % the number of outputs for SS1
  n2 = max(size(A2)); % the number of states for SS2
  m2 = size(B2)(2); % the number of inputs for SS2
  p2 = size(C2)(1); % the number of outputs for SS2
  
  % assemble the state-space model of the series system
  A0 = [A1    zeros(n1,n2);
        B2*C1 A2];
  B0 = [B1;
        B2*D1];
  C0 = [D2*C1 C2];
  D0 = D2*D1;
  
  % form the SS model for return
  SS0 = ss(A0,B0,C0,D0);
  
  endfunction