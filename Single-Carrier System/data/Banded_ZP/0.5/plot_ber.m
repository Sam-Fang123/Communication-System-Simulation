%{
figure(2)
semilogy(indv.range,dv.BER_est(1,:),'-d');
xlabel('SNR (dB)');
ylabel('BER');
grid on;
hold on;
semilogy(indv.range,dv2.BER_est(1,:),'-o');
semilogy(indv.range,dv3.BER_est(end,:),'-s');
semilogy(indv.range,dv4.BER_est(end,:),'-*');
semilogy(indv.range,dv5.BER_est(end,:),'->');
semilogy(indv.range,dv6.BER_est(end,:),'-');
legend('Full-MMSE-LE, no windowing','Banded-MMSE-LE Q=5 [6]', ...
    'Schniter Equalizer D=4',...
    'IBDFE-TI 3rd iteration',...
    'IBDFE-TV D_F_F=1, ,D_F_B=2, 1st iteration use Banded-MMSE-LE Q=5, 3th iteration',...
    'IBDFE-TV D_F_F=1, ,D_F_B=Full, 1st iteration use Banded-MMSE-LE Q=5, 3th iteration')
title('QPSK, fd=0.5, I=11(Est CSI)')
xlim([0 indv.range(end)]);
ylim([10^-5 1]);
xticks(indv.range)
%}
%{
figure(2)
semilogy(indv.range,dv.BER_est(1,:),'-d');
xlabel('SNR (dB)');
ylabel('BER');
grid on;
hold on;
semilogy(indv.range,dv2.BER_est(1,:),'-o');
semilogy(indv.range,dv3.BER_est(end,:),'-s');
semilogy(indv.range,dv4.BER_est(end,:),'-*');
semilogy(indv.range,dv5.BER_est(end,:),'->');
semilogy(indv.range,dv6.BER_est(end,:),'-');
legend('Full-MMSE-LE, no windowing','Banded-MMSE-LE Q=2 [6]', ...
    'Schniter Equalizer D=1',...
    'IBDFE-TI 3rd iteration',...
    'IBDFE-TV D_F_F=1, ,D_F_B=2, 1st iteration use Banded-MMSE-LE Q=2, 3th iteration',...
    'IBDFE-TV D_F_F=1, ,D_F_B=Full, 1st iteration use Banded-MMSE-LE Q=2, 3th iteration')
title('QPSK, fd=0.1, I=5(Est CSI)')
xlim([0 indv.range(end)]);
ylim([10^-5 1]);
xticks(indv.range)
%}
figure(2)
semilogy(indv.range,dv.BER_est(1,:),'-d');
xlabel('SNR (dB)');
ylabel('BER');
grid on;
hold on;
semilogy(indv.range,dv2.BER_est(1,:),'-o');
semilogy(indv.range,dv3.BER_est(end,:),'-s');
semilogy(indv.range,dv4.BER_est(end,:),'-*');
semilogy(indv.range,dv5.BER_est(end,:),'->');
semilogy(indv.range,dv6.BER_est(end,:),'-');
legend('Full-MMSE-LE, no windowing','Banded-MMSE-LE Q=1 [6]', ...
    'Schniter Equalizer D=1',...
    'IBDFE-TI 3rd iteration',...
    'IBDFE-TV D_F_F=0, ,D_F_B=0, 1st iteration use Banded-MMSE-LE Q=1, 3th iteration',...
    'IBDFE-TV D_F_F=0, ,D_F_B=Full, 1st iteration use Banded-MMSE-LE Q=1, 3th iteration')
title('QPSK, fd=0.02, I=3(Est CSI)')
xlim([0 indv.range(end)]);
ylim([10^-6 1]);
xticks(indv.range)