load('D&E-mode_indv=SNR_No-windowing_ZP_Optiaml_GCE-BEM_MMSE_MMSE_FD_LE_full_16QAM_fd=0.02_N=256_I=3_M=5_Nblock=10000.mat')
dv4=dv;
load('D&E-mode_indv=SNR_Tang_ZP_Optiaml_GCE-BEM_MMSE_MMSE_FD_LE_banded_Q=3_16QAM_fd=0.02_N=256_I=3_M=5_Nblock=10000.mat')
dv3=dv;
load('D&E-mode_indv=SNR_Tang_ZP_Optiaml_GCE-BEM_MMSE_MMSE_FD_LE_banded_Q=2_16QAM_fd=0.02_N=256_I=3_M=5_Nblock=10000.mat')
dv2=dv;
load('D&E-mode_indv=SNR_Tang_ZP_Optiaml_GCE-BEM_MMSE_MMSE_FD_LE_banded_Q=1_16QAM_fd=0.02_N=256_I=3_M=5_Nblock=10000.mat')

figure(1)
semilogy(indv.range,dv.BER_est(1,:),'-h');
xlabel('SNR (dB)');
ylabel('average BER');
grid on;
hold on;
semilogy(indv.range,dv2.BER_est(1,:),'-o');
semilogy(indv.range,dv3.BER_est(1,:),'-d');
semilogy(indv.range,dv4.BER_est(1,:),'-');
title('16QAM BER using Estimated CSI (Normalized Doppler Frequency = 0.02), MMSE-LE')
legend('Banded-MMSE-LE Q=1 (with windowing) [5]','Banded-MMSE-LE Q=2 (with windowing) [5]'...
    ,'Banded-MMSE-LE Q=3 (with windowing) [5]',...
    'Full-MMSE-LE')
xlim([0 indv.range(end)]);
ylim([10^-3 1]);
xticks(indv.range)