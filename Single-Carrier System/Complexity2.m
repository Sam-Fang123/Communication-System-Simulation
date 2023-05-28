
clc;
clear;
N=256;
D1=1;
D2=0;
D3=1;
N_I=3;

first_iter_full = N*log2(N) + (7*N^3+12*N^2-7*N)/6+1
first_iter_banded = N*log2(N) + N*(10*D1^2+15*D1+2) - 6*D1+1;

iter_T2C1 = (19*N^3+12*N^2+11*N)/6 + 3 + N*log2(N);
iter_T3C1 = (N^2)*(4*D2+3) + N*(6 + (8*D2^3+60*D2^2+40*D2)/6 ) + N*log2(N) + 3;
%iter_T3C1v2 = (N^2)*(4*D2+3) + N*(24*D2^2+16*D2+7) + 8*D2^3 - 4*D2^2 - 2*D2 + 6 + N*log2(N);
iter_T4C1 = (N^2)*(2*D2+1) + N*(9+(8*D2^3+60*D2^2+64*D2)/6+8*D2*D3+6*D3) + N*log2(N) + 3;

total_T3C1 = first_iter_banded + iter_T3C1*(N_I-1)
total_T4C1 = first_iter_banded + iter_T4C1*(N_I-1)

