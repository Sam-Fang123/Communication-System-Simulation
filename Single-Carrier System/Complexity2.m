
clc;
clear;
N=256;
D1=2;
D2=1;
D3=2;

first_iter_full = N*log2(N) + (7*N^3+12*N^2-7*N)/6+1

first_iter_banded = N*log2(N) + N*(10*D1^2+15*D1+2) - 6*D1+1

other_iter_T2C1 = (19*N^3+12*N^2+11*N)+3+N*log2(N)

other_iter_T3C1 = (N^2)*(4*D2^2+6*D2+3) + N*((4*D2^3+30*D2^2+8*D2)/3+6) + N*log2(N) + 3

other_iter_T4C1 = (N^2)*(4*D2^2+4*D2+1) + N*((4*D2^3+18*D2^2+24*D2)/3+6*D3+8*D2*D3+9) + N*log2(N) +3
