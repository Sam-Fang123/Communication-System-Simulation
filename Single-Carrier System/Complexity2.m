
clc;
clear;
N=256;  % Block size
Q=2;    % Channel Banded BW
D_FF=1; % FF Filter
D_FB=2; % FB Filter
N_I=3;  % Iteration number

IBDFE_TI = (10*N + N*log2(N) + 1)*N_I;

first_iter_full = N*log2(N) + (4*N^3+9*N^2-N)/6;
first_iter_banded = N*log2(N) + N*(10*Q^2+15*Q+2) - 6*Q+1;

iter_T1C1 = (4*N^2 + N*log2(N) + 6*N + 1)*(N_I-1);
iter_T2C1 = ((5*N^3+15*N^2+7*N)/3 + 1 + N*log2(N))*(N_I-1);
iter_T3C1 = ((N^2)*(4*D_FF+4) + N*(5 + (4*D_FF^3+42*D_FF^2+32*D_FF)/3 ) + N*log2(N) + 1)*(N_I-1);
iter_T4C1 = ((N^2)*(2*D_FF+1) + N*(9 + (4*D_FF^3+54*D_FF^2+50*D_FF)/3 + 8*(D_FF^2)*D_FB + 8*D_FB + 12*D_FF*D_FB) + N*log2(N) + 1)*(N_I-1);




