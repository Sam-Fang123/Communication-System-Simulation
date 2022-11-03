
range = 1:16;
figure(2)
semilogy(indv.range(range),dv.BER(2,range),'-d');
title('5 path channel, normalize Doppler Frequency = 0.3, perfect CSI, QPSK');
xlabel('SNR');
ylabel('BER');
grid on;
hold on;
semilogy(indv.range(range),dv2.BER(2,range),'-^');
semilogy(indv.range(range),dv3.BER(2,range),'-o');
semilogy(indv.range(range),dv4.BER(1,range),'-*');
legend('IBDFE-TV-T2C1 Quasibanded D=4','IBDFE-TV-T2C1 Quasibanded D=4, Tang ODM window Q=8','IBDFE-TV-T3C1 D=4','IBDFE-TV-T2C1')

