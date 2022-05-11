
SNR_db=1:14;
%semilogy(SNR_db,BER_bpsk,'-o');
%hold on
semilogy(SNR_db,BER_wiener,'-+');
ylabel('Bit error rate')
xlabel('SNR(dB)')
title('Error performance using different equalization scheme')
grid on
hold on
semilogy(SNR_db,BER(1,:)/10^7,'-*');
semilogy(SNR_db,BER(2,:)/10^7,'-x');
semilogy(SNR_db,BER(3,:)/10^7,'-d');
%legend('No channel equalization','Wiener filter','LMS,stepsize=0.075','LMS,stepsize=0.025','LMS,stepsize=0.0075');
legend('Wiener filter','LMS,stepsize=0.075','LMS,stepsize=0.025','LMS,stepsize=0.0075');
