
function [v] = Encoder_316(u)

% (3,1,6) Convolution code with g1=117=1001111,g2=127=1010111 , g3=155=1101101
% Using Viterbi algorithm

u=[u zeros(1,7)];
g1=[1 0 0 1 1 1 1];
g1=flip(g1);
g2=[1 0 1 0 1 1 1];
g2=flip(g2);
g3=[1 1 0 1 1 0 1];
g3=flip(g3);
s_num=2^(length(g1)-1);
for i=1:s_num
    i_bin=flip(de2bi(i-1,length((g1))));
    i_bin_0=circshift(i_bin,-1);
    i_bin_0(end)=0;
    i_bin_1=circshift(i_bin,-1);
    i_bin_1(end)=1;
    S(i).next_s(1,:)=i_bin_0(2:end);
    S(i).next_s(2,:)=i_bin_1(2:end);
    S(i).next_out(1,:)=[mod(sum(and(i_bin_0,g1)),2) mod(sum(and(i_bin_0,g2)),2) mod(sum(and(i_bin_0,g3)),2)];
    S(i).next_out(2,:)=[mod(sum(and(i_bin_1,g1)),2) mod(sum(and(i_bin_1,g2)),2) mod(sum(and(i_bin_0,g3)),2)];
end

v=zeros(1,3*length(u));
next=0;
for i=1:length(u)
    v(3*i-2:3*i)=S(next+1).next_out(u(i)+1,:);
    next=bi2de(flip(S(next+1).next_s(u(i)+1,:)));
end




