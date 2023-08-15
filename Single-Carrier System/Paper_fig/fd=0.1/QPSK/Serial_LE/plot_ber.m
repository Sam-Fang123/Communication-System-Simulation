clear
load('D&E-mode_indv=SNR_Tang_ZP_Optiaml_GCE-BEM_MMSE_Serial_LE_D=6_QPSK_fd=0.1_N=256_I=5_M=5_Nblock=10000.mat')
dv6=dv;
load('D&E-mode_indv=SNR_Tang_ZP_Optiaml_GCE-BEM_MMSE_Serial_LE_D=5_QPSK_fd=0.1_N=256_I=5_M=5_Nblock=10000.mat')
dv5=dv;
load('D&E-mode_indv=SNR_Tang_ZP_Optiaml_GCE-BEM_MMSE_Serial_LE_D=4_QPSK_fd=0.1_N=256_I=5_M=5_Nblock=10000.mat')
dv4=dv;
load('D&E-mode_indv=SNR_Tang_ZP_Optiaml_GCE-BEM_MMSE_Serial_LE_D=3_QPSK_fd=0.1_N=256_I=5_M=5_Nblock=10000.mat')
dv3=dv;
load('D&E-mode_indv=SNR_Tang_ZP_Optiaml_GCE-BEM_MMSE_Serial_LE_D=2_QPSK_fd=0.1_N=256_I=5_M=5_Nblock=10000.mat')
dv2=dv;
load('D&E-mode_indv=SNR_Tang_ZP_Optiaml_GCE-BEM_MMSE_Serial_LE_D=1_QPSK_fd=0.1_N=256_I=5_M=5_Nblock=10000.mat')

figure(1)
semilogy(indv.range,dv.BER_est(1,:),'-d');
xlabel('SNR (dB)');
ylabel('BER');
grid on;
hold on;
title('Serial-LE, QPSK, fd=0.1, I=5(Est CSI)')
semilogy(indv.range,dv2.BER_est(1,:),'-s')
semilogy(indv.range,dv3.BER_est(1,:),'-o')
semilogy(indv.range,dv4.BER_est(1,:),'-*')
semilogy(indv.range,dv5.BER_est(1,:),'->')
semilogy(indv.range,dv6.BER_est(1,:),'-+')
xlim([0 indv.range(end)]);
ylim([10^-4 1]);
xticks(indv.range)
legend('D=1','D=2','D=3','D=4','D=5','D=6')

figure(2)
semilogy(indv.range,dv.BER_ideal(1,:),'-d');
xlabel('SNR (dB)');
ylabel('BER');
grid on;
hold on;
title('Serial-LE, QPSK, fd=0.1, I=3(Ideal CSI)')
semilogy(indv.range,dv2.BER_ideal(1,:),'-s')
semilogy(indv.range,dv3.BER_ideal(1,:),'-o')
semilogy(indv.range,dv4.BER_ideal(1,:),'-*')
semilogy(indv.range,dv5.BER_ideal(1,:),'->')
semilogy(indv.range,dv6.BER_ideal(1,:),'-+')
xlim([0 indv.range(end)]);
ylim([10^-4 1]);
xticks(indv.range)
legend('D=1','D=2','D=3','D=4','D=5','D=6')
