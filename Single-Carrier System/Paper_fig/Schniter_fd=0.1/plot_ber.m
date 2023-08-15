
load('D&E-mode_indv=SNR_Tang_ZP_Optiaml_GCE-BEM_MMSE_Schniter_D=1_BPSK_fd=0.1_N=256_I=5_M=5_Nblock=3000.mat')
figure(1)
semilogy(indv.range,dv.BER_est(1,:),'-d');
xlabel('SNR (dB)');
ylabel('average BER');
grid on;
hold on;
semilogy(indv.range,dv.BER_est(2,:),'-o');
semilogy(indv.range,dv.BER_est(3,:),'->');
semilogy(indv.range,dv.BER_est(4,:),'-x');
semilogy(indv.range,dv.BER_est(5,:),'-s');
semilogy(indv.range,dv.BER_est(6,:),'-h');
semilogy(indv.range,dv.BER_est(7,:),'-*');
semilogy(indv.range,dv.BER_est(8,:),'-+');
semilogy(indv.range,dv.BER_est(9,:),'-<');
semilogy(indv.range,dv.BER_est(10,:),'-p');
legend('1st iter','2nd iter','3rd iter','4th iter','5th iter','6th iter','7th iter','8th iter','9th iter','10th iter')
title('BPSK BER using Estimated CSI (Normalized Doppler Frequency = 0.1), Schniter''s paper equalizer, D=1')
xlim([0 indv.range(end)]);
ylim([10^-6 1]);
xticks(indv.range)

figure(2)
semilogy(indv.range,dv.BER_ideal(1,:),'-d');
xlabel('SNR (dB)');
ylabel('average BER');
grid on;
hold on;
semilogy(indv.range,dv.BER_ideal(2,:),'-o');
semilogy(indv.range,dv.BER_ideal(3,:),'->');
semilogy(indv.range,dv.BER_ideal(4,:),'-x');
semilogy(indv.range,dv.BER_ideal(5,:),'-s');
semilogy(indv.range,dv.BER_ideal(6,:),'-h');
semilogy(indv.range,dv.BER_ideal(7,:),'-*');
semilogy(indv.range,dv.BER_ideal(8,:),'-+');
semilogy(indv.range,dv.BER_ideal(9,:),'-<');
semilogy(indv.range,dv.BER_ideal(10,:),'-p');
legend('1st iter','2nd iter','3rd iter','4th iter','5th iter','6th iter','7th iter','8th iter','9th iter','10th iter')
title('BPSK BER using Perfect CSI (Normalized Doppler Frequency = 0.1), Schniter''s paper equalizer')
xlim([0 indv.range(end)]);
ylim([10^-6 1]);
xticks(indv.range)