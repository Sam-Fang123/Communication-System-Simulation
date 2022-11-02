
range = 1:7;
semilogy(indv.range(range),dv.BER(1,range),'-d');
title('5 path channel, normalize Doppler Frequency = 0.3, perfect CSI, QPSK');
xlabel('SNR');
ylabel('BER');
xlim([indv.range(range(1)) indv.range(range(end))])
%ylim ([6*10^-6 0.2])
grid on;
hold on;
semilogy(indv.range(range),dv2.BER(1,range),'-^');
semilogy(indv.range(range),dv3.BER(1,range),'-o');

%semilogy(indv.range(range),dv2.BER(1,range),'--d');
%semilogy(indv.range(range),dv3.BER(1,range),'--^');
%semilogy(indv.range(range),dv4.BER(1,range),'--o');

%legend('IBDFE-TV-T3C1 D=2','IBDFE-TV-T3C1 D=4','IBDFE-TV-T3C1 D=8','IBDFE-TV-T2C1 Quasibanded D=2, Tang ODM window Q=4','IBDFE-TV-T2C1 Quasibanded D=4, Tang ODM window Q=8','IBDFE-TV-T2C1 Quasibanded D=8, Tang ODM window Q=16')
%legend('IBDFE-TV-T2C1 Quasibanded D=2, Tang ODM window Q=4','IBDFE-TV-T2C1 Quasibanded D=4, Tang ODM window Q=8','IBDFE-TV-T2C1 Quasibanded D=8, Tang ODM window Q=16')
%semilogy(indv.range(range),dv.BER(4,range),'-*');
legend('IBDFE-TV-T2C1 Quasibanded D=12','IBDFE-TV-T2C1 Quasibanded D=12, Tang ODM window Q=24','IBDFE-TV-T3C1 D=12')

