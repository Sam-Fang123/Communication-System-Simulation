load('D&E-mode_indv=SNR_No-windowing_ZP_Optiaml_GCE-BEM_MMSE_MMSE_FD_LE_full_QPSK_fd=0.5_N=256_I=9_M=5_Nblock=10000.mat')
dv7=dv;
load('D&E-mode_indv=SNR_Tang_ZP_Optiaml_GCE-BEM_MMSE_MMSE_FD_LE_banded_Q=6_QPSK_fd=0.5_N=256_I=9_M=5_Nblock=10000.mat')
dv6=dv;
load('D&E-mode_indv=SNR_Tang_ZP_Optiaml_GCE-BEM_MMSE_MMSE_FD_LE_banded_Q=5_QPSK_fd=0.5_N=256_I=9_M=5_Nblock=10000.mat')
dv5=dv;
load('D&E-mode_indv=SNR_Tang_ZP_Optiaml_GCE-BEM_MMSE_MMSE_FD_LE_banded_Q=4_QPSK_fd=0.5_N=256_I=9_M=5_Nblock=10000.mat')
dv4=dv;
load('D&E-mode_indv=SNR_Tang_ZP_Optiaml_GCE-BEM_MMSE_MMSE_FD_LE_banded_Q=3_QPSK_fd=0.5_N=256_I=9_M=5_Nblock=10000.mat')
dv3=dv;
load('D&E-mode_indv=SNR_Tang_ZP_Optiaml_GCE-BEM_MMSE_MMSE_FD_LE_banded_Q=2_QPSK_fd=0.5_N=256_I=9_M=5_Nblock=10000.mat')
dv2=dv;
load('D&E-mode_indv=SNR_Tang_ZP_Optiaml_GCE-BEM_MMSE_MMSE_FD_LE_banded_Q=1_QPSK_fd=0.5_N=256_I=9_M=5_Nblock=10000.mat')


figure(2)
semilogy(indv.range,dv.BER_est(end,:),'-d');
xlabel('SNR (dB)');
ylabel('BER');
grid on;
hold on;
semilogy(indv.range,dv2.BER_est(end,:),'-o');
semilogy(indv.range,dv3.BER_est(end,:),'->');
semilogy(indv.range,dv4.BER_est(end,:),'-s');
semilogy(indv.range,dv5.BER_est(end,:),'-x');
semilogy(indv.range,dv6.BER_est(end,:),'-+');
semilogy(indv.range,dv7.BER_est(end,:),'-');
legend('Q=1','Q=2','Q=3','Q=4','Q=5','Q=6','Full')
title('MMSE-FD-LE, fd=0.5, QPSK, Est CSI(I=9)')
xlim([0 indv.range(end)]);
ylim([10^-5 1]);
xticks(indv.range)


