load('D&E-mode_indv=SNR_Tang_ZP_Optiaml_GCE-BEM_MMSE_IBDFE_TV_1st_banded_Q=5_D_FF=4_D_FB_full_QPSK_fd=0.5_N=256_I=11_M=5_Nblock=10000.mat')
dv5=dv;
load('D&E-mode_indv=SNR_Tang_ZP_Optiaml_GCE-BEM_MMSE_IBDFE_TV_1st_banded_Q=5_D_FF=3_D_FB_full_QPSK_fd=0.5_N=256_I=11_M=5_Nblock=10000.mat')
dv4=dv;
load('D&E-mode_indv=SNR_Tang_ZP_Optiaml_GCE-BEM_MMSE_IBDFE_TV_1st_banded_Q=5_D_FF=2_D_FB_full_QPSK_fd=0.5_N=256_I=11_M=5_Nblock=10000.mat')
dv3=dv;
load('D&E-mode_indv=SNR_Tang_ZP_Optiaml_GCE-BEM_MMSE_IBDFE_TV_1st_banded_Q=5_D_FF=1_D_FB_full_QPSK_fd=0.5_N=256_I=11_M=5_Nblock=10000.mat')
dv2=dv;
load('D&E-mode_indv=SNR_Tang_ZP_Optiaml_GCE-BEM_MMSE_IBDFE_TV_1st_banded_Q=5_D_FF=0_D_FB_full_QPSK_fd=0.5_N=256_I=11_M=5_Nblock=10000.mat')

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
legend('D_F_F=0','D_F_F=1','D_F_F=2','D_F_F=3','D_F_F=4')
title('IBDFE-TV, fd=0.5, QPSK, Est CSI(I=11), Q=5, D_F_B full')
xlim([0 indv.range(end)]);
ylim([10^-5 1]);
xticks(indv.range)