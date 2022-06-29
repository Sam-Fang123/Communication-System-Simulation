clear all
clc

% (2,1,7) Convolution code with g1=247=10100111, g2=371=11111001
% Using Viterbi algorithm

g1=[1 0 1 0 0 1 1 1];
g1=flip(g1);
g2=[1 1 1 1 1 0 0 1];
g2=flip(g2);
s_num=2^(length(g1)-1);
S(1).next_s=[1 2];
S(1).next_out=[3 4];
S(2).next_s=[2 3];
S(2).next_out=[5 6];
for i=1:s_num
    i_bin=flip(de2bi(i-1,8));
    i_bin_0=circshift(i_bin,-1);
    i_bin_0(end)=0;
    i_bin_1=circshift(i_bin,-1);
    i_bin_1(end)=1;
    %S(i).next_s(1)=
end