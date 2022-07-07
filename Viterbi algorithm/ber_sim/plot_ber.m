clear all
fid = fopen('u.txt');
fid2 = fopen('u2.txt');
fid3=fopen('u_318.txt')
u = fgetl(fid);
fclose(fid);
u2 = fgetl(fid2);
fclose(fid2);
u3 = fgetl(fid3);
fclose(fid3);
bits_num=length(u);
SNR_num=length(u2)/length(u);
SNR_db=0:SNR_num-1;
SNR=10.^(SNR_db/10);
j=1;
for i=0:SNR_num-1
    BER_218(j)=sum(u2(1+i*bits_num:(i+1)*bits_num)~=u)/bits_num;
    BER_318(j)=sum(u3(1+i*bits_num:(i+1)*bits_num)~=u)/bits_num;
    j=j+1;
end
semilogy(SNR_db(1:5),qfunc(sqrt(SNR(1:5))),'-o');
hold on
semilogy(SNR_db(1:5),BER_218(1:5),'-d');
semilogy(SNR_db(1:5),BER_318(1:5),'-*');
title('Viterbi Algorithm Performance');
legend('Uncoded BPSK','Rate=1/2, m=8, Viterbi, hard decision','Rate=1/3, m=8, Viterbi, hard decision');
xlabel('SNR(dB)');ylabel('BER');
grid minor
grid on




