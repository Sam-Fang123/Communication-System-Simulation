
function [u] = Decoder_316_soft(r)

% (3,1,6) Convolution code with g1=117=1001111,g2=127=1010111, g3=155=1101101
% Using Viterbi algorithm (Soft decision version)
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
    S_f(i).next_s(1)=bi2de(flip(i_bin_0(2:end)));
    S_f(i).next_s(2)=bi2de(flip(i_bin_1(2:end)));
    S_f(i).next_out(1,:)=[mod(sum(and(i_bin_0,g1)),2) mod(sum(and(i_bin_0,g2)),2) mod(sum(and(i_bin_0,g3)),2)];
    S_f(i).next_out(2,:)=[mod(sum(and(i_bin_1,g1)),2) mod(sum(and(i_bin_1,g2)),2) mod(sum(and(i_bin_1,g3)),2)];
end


for i=1:s_num
    i_bin=flip(de2bi(i-1,length((g1))));
    i_bin_p_0=circshift(i_bin,1);
    i_bin_p_0(2)=0;
    i_bin_p_1=circshift(i_bin,1);
    i_bin_p_1(2)=1;
    S_b(i).prev_s(1)=bi2de(flip(i_bin_p_0(2:end)));
    S_b(i).prev_s(2)=bi2de(flip(i_bin_p_1(2:end)));
    S_b(i).prev_out(1,:)=S_f(S_b(i).prev_s(1)+1).next_out(mod((i-1),2)+1,:);
    S_b(i).prev_out(2,:)=S_f(S_b(i).prev_s(2)+1).next_out(mod((i-1),2)+1,:);
end

for i=1:s_num
    for j=1:length(r)/3+1
        S(i,j).d=1000000;
        S(i,j).prev=1000000;
    end
end
S(1,1).d=0;
D1=0;
D2=0;

for j=1:length(r)/3
    for i=1:s_num
        D1=sum(abs([r(3*j-2) r(3*j-1) r(3*j)]-(S_b(i).prev_out(1,:)*2-1)))+S(S_b(i).prev_s(1)+1,j).d;
        D2=sum(abs([r(3*j-2) r(3*j-1) r(3*j)]-(S_b(i).prev_out(2,:)*2-1)))+S(S_b(i).prev_s(2)+1,j).d;
        if(D1<D2)
            S(i,j+1).d=D1;
            S(i,j+1).prev=S_b(i).prev_s(1);
        else
            S(i,j+1).d=D2;
            S(i,j+1).prev=S_b(i).prev_s(2);
        end
    end
end

pass_s=zeros(1,(length(r)/3)+1);
for i=length(r)/3:-1:1
    pass_s(i)=S(pass_s(i+1)+1,i+1).prev;
end

u=zeros(1,length(r)/3);
for i=1:length(r)/3
    if(pass_s(i+1)==S_f(pass_s(i)+1).next_s(1))
        u(i)=0;
    else
        u(i)=1;
    end
end

u=u(1:end-7);
    
