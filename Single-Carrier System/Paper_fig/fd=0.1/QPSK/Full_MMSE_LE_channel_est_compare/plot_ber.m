clear
load('D&E-mode_indv=SNR_No-windowing_ZP_Optiaml_GCE-BEM_MMSE_MMSE_FD_LE_full_QPSK_fd=0.1_N=256_I=5_M=5_Nblock=10000.mat')
semilogy(indv.range,dv.BER_est(1,:),'-o');
xlabel('SNR (dB)');
ylabel('BER');
grid on;
hold on;
title('QPSK BER using Full-MMSE-LE(Normalized Doppler Frequency=0.1)')
semilogy(indv.range,dv.BER_ideal(1,:),'--o');
legend('Estimated CSI','Perfect CSI')
xlim([0 indv.range(end)]);
ylim([10^-5 1]);
xticks(indv.range)