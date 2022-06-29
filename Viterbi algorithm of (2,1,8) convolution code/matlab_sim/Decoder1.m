clear all
clc

% (2,1,8) Convolution code with g1=561=101110001, g2=753=111101011
% Using Viterbi algorithm
r=[0,0,0,0,1,1,1,0,1,0,0,0,0,1,1,1,0,1,0,1,1,0,1,1,0,0];
g1=[1 0 1 1 1 0 0 0 1];
g1=flip(g1);
g2=[1 1 1 1 0 1 0 1 1];
g2=flip(g2);
s_num=2^(length(g1)-1);
for i=1:s_num
    i_bin=flip(de2bi(i-1,length((g1))));
    i_bin_0=circshift(i_bin,-1);
    i_bin_0(end)=0;
    i_bin_1=circshift(i_bin,-1);
    i_bin_1(end)=1;
    S_f(i).next_s(1,:)=i_bin_0(2:end);
    S_f(i).next_s(2,:)=i_bin_1(2:end);
    S_f(i).next_out(1,:)=[mod(sum(and(i_bin_0,g1)),2) mod(sum(and(i_bin_0,g2)),2)]
    S_f(i).next_out(2,:)=[mod(sum(and(i_bin_1,g1)),2) mod(sum(and(i_bin_1,g2)),2)]
end

for i=1:s_num
    i_bin=flip(de2bi(i-1,length((g1))));
    i_bin_p_0=circshift(i_bin,1);
    i_bin_p_0(2)=0;
    i_bin_p_1=circshift(i_bin,1);
    i_bin_p_1(2)=1;
    S_b(i).prev_s(1,:)=i_bin_p_0(2:end);
    S_b(i).prev_s(2,:)=i_bin_p_1(2:end);
    S_b(i).prev_out(1,:)=S_f(bi2de(flip(S_b(i).prev_s(1)))+1).next_out(mod((i-1),2)+1,:);
    S_b(i).prev_out(2,:)=S_f(bi2de(flip(S_b(i).prev_s(2)))+1).next_out(mod((i-1),2)+1,:);
end

