load('D&E-mode_indv=SNR_Tang_ZP_Optiaml_GCE-BEM_MMSE_IBDFE_TV_1st_banded_Q=2_D_FF=3_D_FB_full_QPSK_fd=0.1_N=256_I=5_M=5_Nblock=10000.mat')
dv4=dv;
load('D&E-mode_indv=SNR_Tang_ZP_Optiaml_GCE-BEM_MMSE_IBDFE_TV_1st_banded_Q=2_D_FF=2_D_FB_full_QPSK_fd=0.1_N=256_I=5_M=5_Nblock=10000.mat')
dv3=dv;
load('D&E-mode_indv=SNR_Tang_ZP_Optiaml_GCE-BEM_MMSE_IBDFE_TV_1st_banded_Q=2_D_FF=1_D_FB_full_QPSK_fd=0.1_N=256_I=5_M=5_Nblock=10000.mat')
dv2=dv;
load('D&E-mode_indv=SNR_Tang_ZP_Optiaml_GCE-BEM_MMSE_IBDFE_TV_1st_banded_Q=2_D_FF=0_D_FB_full_QPSK_fd=0.1_N=256_I=5_M=5_Nblock=10000.mat')

semilogy(indv.range,dv.BER_est(3,:),'-o');
xlabel('SNR (dB)');
ylabel('BER');
grid on;
hold on;
semilogy(indv.range,dv2.BER_est(3,:),'-d');
semilogy(indv.range,dv3.BER_est(3,:),'-s');
semilogy(indv.range,dv4.BER_est(3,:),'-*');
legend('IBDFE-TV D_F_F=0, D_F_B is full, 1st iteration use banded-MMSE-LE Q=2 [5], 3th iteration'...
    ,'IBDFE-TV D_F_F=1, D_F_B is full, 1st iteration use banded-MMSE-LE Q=2 [5], 3th iteration'...
    ,'IBDFE-TV D_F_F=2, D_F_B is full, 1st iteration use banded-MMSE-LE Q=2 [5], 3th iteration'...
    ,'IBDFE-TV D_F_F=3, D_F_B is full, 1st iteration use banded-MMSE-LE Q=2 [5], 3th iteration')
xlim([0 indv.range(end)]);
ylim([10^-6 1]);
xticks(indv.range)
title('QPSK BER using Estimated CSI(Normalized Doppler Frequency=0.1)')

