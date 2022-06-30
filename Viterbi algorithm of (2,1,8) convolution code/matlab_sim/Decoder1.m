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
for i=1:s_num
    sss(i)=bi2de(flip(S_b(i).prev_s(1,:)));
end
for i=1:s_num
    for j=1:length(r)/2+1
        S(i,j).d=1000000;
        S(i,j).prev=10000*ones(1,8);
    end
end
S(1,1).d=0;
D1=0;
D2=0;

for j=1:length(r)/2
    for i=1:s_num
        D1=sum(abs([r(j) r(j+1)]-S_b(i).prev_out(1)))+S(bi2de(flip(S_b(i).prev_s(1,:)))+1,j).d;
        D2=sum(abs([r(j) r(j+1)]-S_b(i).prev_out(2)))+S(bi2de(flip(S_b(i).prev_s(2,:)))+1,j).d;
        if(D1<D2)
            S(i,j+1).d=D1;
            S(i,j+1).prev=S_b(i).prev_s(1,:);
        else
            S(i,j+1).d=D2;
            S(i,j+1).prev=S_b(i).prev_s(2,:);
        end
        SS(i,j)=bi2de(flip(S(i,j+1).prev));
    end
end

pass_s=zeros(1,(length(r)/2)+1);
for i=length(r)/2:1
    pass_s(i)=bi2de(flip(S(pass_s(i+1),i+1).prev));
end
    
