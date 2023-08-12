load('D&E-mode_indv=SNR_Tang_ZP_Optiaml_GCE-BEM_MMSE_IBDFE_TV_1st_banded_Q=2_D_FF=1_D_FB_full_QPSK_fd=0.1_N=256_I=5_M=5_Nblock=10000.mat')

figure(2)
semilogy(indv.range,dv.BER_est(1,:),'-h');
xlabel('SNR (dB)');
ylabel('average BER');
grid on;
hold on;
semilogy(indv.range,dv.BER_est(2,:),'-o');
semilogy(indv.range,dv.BER_est(3,:),'-d');
semilogy(indv.range,dv.BER_est(4,:),'-s');
legend('1st iteration, Banded-MMSE-LE Q=2 [5]','2nd iteration','3rd iteration','4th iteration')
title('QPSK BER using Estimated CSI (Normalized Doppler Frequency = 0.1), IBDFE-TV D_F_F=1, D_F_B full')
xlim([0 indv.range(end)]);
ylim([10^-5 1]);
xticks(indv.range)