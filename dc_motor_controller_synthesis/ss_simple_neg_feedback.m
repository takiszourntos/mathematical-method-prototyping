%% Copyright (C) 2019 Takis Zourntos
## Author: Takis Zourntos <takis@black-machine>
## Created: 2019-05-13
function [SSk] = ss_simple_neg_feedback (SSmod, k)
%%
%% SSk = ss_simple_neg_feedback(SSmod, k)
%%
%% This function assumes that the SISO system SSmod and simple gain k
%% are connected in a simple negative feedback; useful after a 
%% root locus design to close the loop around the loop gain. 
%%
%%          __         
%%      +  /  \ 
%%  r---->|    |--------> SSmod ----------------> y
%%         \__/                            |
%%        -  ^                             |
%%           |                             |
%%           -------------- k  <------------
%%

% extract state information
% N.B.: 1) number of columns of B must equal number of rows of C
%       2) D matrix must be zero
A = SSmod.a;
B = SSmod.b;
C = SSmod.c;
D = SSmod.d;
if ((size(B)(2) == size(C)(1)) && (D == 0))
  % form composite system
  Ak = (A - k*B*C);
  Bk = B;
  Ck = C;
  Dk = D;
  SSk = ss(Ak,Bk,Ck,Dk);
else
 error("system must be square and D must be 0");
endif

endfunction
## This program is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*- 
## @deftypefn {} {@var{retval} =} ss_simple_neg_feedback (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn
