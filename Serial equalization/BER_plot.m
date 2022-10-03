
range = 11:23;
semilogy(indv.range(range),dv.BER(1,range),'-d');
title('Five path channel, normalize Doppler Frequency = 0.2');
xlabel('SNR');
ylabel('BER');
%xlim([plot_snr(1) plot_snr(end)])
ylim ([8*10^-5 10^-1])
grid on;
hold on;
semilogy(indv.range(range),dv.BER(2,range),'-^');
semilogy(indv.range(range),dv.BER(3,range),'-o');
%semilogy(indv.range,dv.BER(4,:),'-o');

semilogy(indv.range(range),dv2.BER(1,range),'--d');
semilogy(indv.range(range),dv2.BER(2,range),'--^');
semilogy(indv.range(range),dv2.BER(3,range),'--o');
%semilogy(indv.range,dv2.BER(4,:),'--o');
%legend('1 tap MMSE','5 tap MMSE','15 tap MMSE','25 tap MMSE','1 tap DFE','5 tap DFE','15 tap DFE','25 tap DFE')
legend('1 tap MMSE','5 tap MMSE','25 tap MMSE','1 tap DFE','5 tap DFE','25 tap DFE')