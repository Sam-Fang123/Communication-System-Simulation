load('D&E-mode_indv=SNR_No-windowing_ZP_Optiaml_GCE-BEM_MMSE_MMSE_FD_LE_full_QPSK_fd=0.5_N=256_I=11_M=5_Nblock=10000.mat')
dv7=dv;
load('D&E-mode_indv=SNR_No-windowing_ZP_Optiaml_GCE-BEM_MMSE_MMSE_FD_LE_full_QPSK_fd=0.5_N=256_I=9_M=5_Nblock=10000.mat')
dv6=dv;
load('D&E-mode_indv=SNR_No-windowing_ZP_Optiaml_GCE-BEM_MMSE_MMSE_FD_LE_full_QPSK_fd=0.5_N=256_I=7_M=5_Nblock=10000.mat')
dv5=dv;
load('D&E-mode_indv=SNR_No-windowing_ZP_Optiaml_GCE-BEM_MMSE_MMSE_FD_LE_full_QPSK_fd=0.5_N=256_I=5_M=5_Nblock=10000.mat')
dv4=dv;
load('D&E-mode_indv=SNR_No-windowing_ZP_Optiaml_GCE-BEM_MMSE_MMSE_FD_LE_full_QPSK_fd=0.5_N=256_I=3_M=5_Nblock=10000.mat')
dv3=dv;
figure(2)
semilogy(indv.range,dv3.BER_est(end,:),'-o');
xlabel('SNR (dB)');
ylabel('BER');
grid on;
hold on;
semilogy(indv.range,dv4.BER_est(end,:),'-d');
semilogy(indv.range,dv5.BER_est(end,:),'->');
semilogy(indv.range,dv6.BER_est(end,:),'-+');
semilogy(indv.range,dv7.BER_est(end,:),'-s');
semilogy(indv.range,dv7.BER_ideal(end,:),'--');
legend('Est I=3','Est I=5','Est I=7','Est I=9','Est I=11','Ideal')
title('Full-MMSE-FD-LE using QPSK, fd=0.5')
xlim([0 indv.range(end)]);
ylim([10^-5 1]);
xticks(indv.range)


