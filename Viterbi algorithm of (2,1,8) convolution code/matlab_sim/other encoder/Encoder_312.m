
function [v] = Encoder_312(u)

% (3,1,2) Convolution code with g1=110,g2=101 , g3=111
% Using Viterbi algorithm

u=[u zeros(1,3)];
g1=[1 1 0];
g1=flip(g1);
g2=[1 0 1];
g2=flip(g2);
g3=[1 1 1];
g3=flip(g3);
s_num=2^(length(g1)-1);
for i=1:s_num
    i_bin=flip(de2bi(i-1,length((g1))));
    i_bin_0=circshift(i_bin,-1);
    i_bin_0(end)=0;
    i_bin_1=circshift(i_bin,-1);
    i_bin_1(end)=1;
    S_f(i).next_s(1)=bi2de(flip(i_bin_0(2:end)));
    S_f(i).next_s(2)=bi2de(flip(i_bin_1(2:end)));
    S_f(i).next_out(1,:)=[mod(sum(and(i_bin_0,g1)),2) mod(sum(and(i_bin_0,g2)),2) mod(sum(and(i_bin_0,g3)),2)];
    S_f(i).next_out(2,:)=[mod(sum(and(i_bin_1,g1)),2) mod(sum(and(i_bin_1,g2)),2) mod(sum(and(i_bin_1,g3)),2)];
end

v=zeros(1,3*length(u));
next=0;
for i=1:length(u)
    v(3*i-2:3*i)=S_f(next+1).next_out(u(i)+1,:);
    next=S_f(next+1).next_s(u(i)+1);
end




