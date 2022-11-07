
range = 1:2:15;
figure(1)
semilogy(indv.range(range),dv.BER(1,range),'-d');
title('5 path channel, normalize Doppler Frequency = 0.1, perfect CSI, QPSK');
xlabel('SNR');
ylabel('BER');
xlim([0 indv.range(range(end))]);
grid on;
hold on;
semilogy(indv.range(range),dv2.BER(1,range),'-^');
semilogy(indv.range(range),dv3.BER(1,range),'-o');
semilogy(indv.range(range),dv4.BER(1,range),'-*');
legend('IBDFE-TV-T2C1 Quasibanded D=2','IBDFE-TV-T2C1 Quasibanded D=2, Tang ODM window Q=4','IBDFE-TV-T3C1 D=2','IBDFE-TV-T2C1')

figure(2)
semilogy(indv.range(range),dv.BER(2,range),'-d');
title('5 path channel, normalize Doppler Frequency = 0.1, perfect CSI, QPSK');
xlabel('SNR');
ylabel('BER');
xlim([0 indv.range(range(end))]);
grid on;
hold on;
semilogy(indv.range(range),dv2.BER(2,range),'-^');
semilogy(indv.range(range),dv3.BER(2,range),'-o');
semilogy(indv.range(range),dv4.BER(1,range),'-*');
legend('IBDFE-TV-T2C1 Quasibanded D=4','IBDFE-TV-T2C1 Quasibanded D=4, Tang ODM window Q=8','IBDFE-TV-T3C1 D=4','IBDFE-TV-T2C1')

figure(3)
semilogy(indv.range(range),dv.BER(3,range),'-d');
title('5 path channel, normalize Doppler Frequency = 0.1, perfect CSI, QPSK');
xlabel('SNR');
ylabel('BER');
xlim([0 indv.range(range(end))]);
grid on;
hold on;
semilogy(indv.range(range),dv2.BER(3,range),'-^');
%semilogy(0:4:24,dv5.BER(1:end),'-^');
semilogy(indv.range(range),dv3.BER(3,range),'-o');
semilogy(indv.range(range),dv4.BER(1,range),'-*');
legend('IBDFE-TV-T2C1 Quasibanded D=8','IBDFE-TV-T2C1 Quasibanded D=8, Tang ODM window Q=16','IBDFE-TV-T3C1 D=8','IBDFE-TV-T2C1')


figure(4)
semilogy(indv.range(range),dv.BER(4,range),'-d');
title('5 path channel, normalize Doppler Frequency = 0.1, perfect CSI, QPSK');
xlabel('SNR');
ylabel('BER');
xlim([0 indv.range(range(end))]);
grid on;
hold on;
semilogy(indv.range(range),dv2.BER(4,range),'-^');
semilogy(indv.range(range),dv3.BER(4,range),'-o');
semilogy(indv.range(range),dv4.BER(1,range),'-*');
legend('IBDFE-TV-T2C1 Quasibanded D=12','IBDFE-TV-T2C1 Quasibanded D=12, Tang ODM window Q=24','IBDFE-TV-T3C1 D=12','IBDFE-TV-T2C1')

figure(5)
semilogy(indv.range(range),dv2.BER(1,range),'-d');
title('5 path channel, normalize Doppler Frequency = 0.1, perfect CSI, QPSK');
xlabel('SNR');
ylabel('BER');
xlim([0 indv.range(range(end))]);
grid on;
hold on;
semilogy(indv.range(range),dv2.BER(2,range),'-^');
semilogy(indv.range(range),dv2.BER(3,range),'-o');
%semilogy(0:4:24,dv5.BER(1:end),'-o');
semilogy(indv.range(range),dv2.BER(4,range),'-*');
legend('IBDFE-TV-T2C1 Quasibanded D=2, Tang ODM window Q=4','IBDFE-TV-T2C1 Quasibanded D=4, Tang ODM window Q=8','IBDFE-TV-T2C1 Quasibanded D=8, Tang ODM window Q=16','IBDFE-TV-T2C1 Quasibanded D=12, Tang ODM window Q=24')