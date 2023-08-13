load('D&E-mode_indv=SNR_Tang_ZP_Optiaml_GCE-BEM_MMSE_IBDFE_TV_1st_banded_Q=2_D_FF=1_D_FB_full_QPSK_fd=0.1_N=256_I=5_M=5_Nblock=10000.mat')
dv7=dv;
load('D&E-mode_indv=SNR_Tang_ZP_Optiaml_GCE-BEM_MMSE_IBDFE_TV_1st_banded_Q=2_D_FF=1_D_FB=3_QPSK_fd=0.1_N=256_I=5_M=5_Nblock=10000.mat')
dv6=dv;
load('D&E-mode_indv=SNR_Tang_ZP_Optiaml_GCE-BEM_MMSE_IBDFE_TV_1st_banded_Q=2_D_FF=1_D_FB=2_QPSK_fd=0.1_N=256_I=5_M=5_Nblock=10000.mat')
dv5=dv;
load('D&E-mode_indv=SNR_Tang_ZP_Optiaml_GCE-BEM_MMSE_IBDFE_TV_1st_banded_Q=2_D_FF=1_D_FB=1_QPSK_fd=0.1_N=256_I=5_M=5_Nblock=10000.mat')
dv4=dv;
dv3=dv;
load('D&E-mode_indv=SNR_No-windowing_ZP_Optiaml_GCE-BEM_MMSE_MMSE_FD_LE_full_QPSK_fd=0.1_N=256_I=5_M=5_Nblock=10000.mat')
dv2=dv;
load('D&E-mode_indv=SNR_No-windowing_ZP_Optiaml_GCE-BEM_MMSE_IBDFE_TI_QPSK_fd=0.1_N=256_I=5_M=5_Nblock=10000.mat')
figure(2)
semilogy(indv.range,dv.BER_est(3,:),'-x');
xlabel('SNR (dB)');
ylabel('average BER');
grid on;
hold on;
semilogy(indv.range,dv2.BER_est(1,:),'-h');
semilogy(indv.range,dv3.BER_est(1,:),'->');
semilogy(indv.range,dv4.BER_est(3,:),'-o');
semilogy(indv.range,dv5.BER_est(3,:),'-s');
semilogy(indv.range,dv6.BER_est(3,:),'-d');
semilogy(indv.range,dv7.BER_est(3,:),'-*');
title('QPSK BER using Estimated CSI (Normalized Doppler Frequency = 0.1), IBDFE-TV D_F_F=1')
legend('IBDFE-TI(Tomasin), 3th iteration, no windowing [3]','Full-MMSE-LE, no windowing', ...
    'Banded-MMSE-LE Q=2 [5]',...
    'IBDFE-TV D_F_B=1, 1st iteration use Banded-MMSE-LE Q=2 [5], 3th iteration',...
    'IBDFE-TV D_F_B=2, 1st iteration use Banded-MMSE-LE Q=2 [5], 3th iteration', ...
    'IBDFE-TV D_F_B=3, 1st iteration use Banded-MMSE-LE Q=2 [5], 3th iteration',...
    'IBDFE-TV D_F_B is full, 1st iteration use Banded-MMSE-LE Q=2 [5], 3th iteration')
xlim([0 indv.range(end)]);
ylim([10^-6 1]);
xticks(indv.range)