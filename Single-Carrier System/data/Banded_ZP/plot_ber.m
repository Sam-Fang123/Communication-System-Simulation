%{
legend('IBDFE-TV D_F_F=0, D_F_B is full, 1st iteration use banded-MMSE-LE Q=1 [5], 3th iteration'...
    ,'IBDFE-TV D_F_F=1, D_F_B is full, 1st iteration use banded-MMSE-LE Q=1 [5], 3th iteration'...
    ,'IBDFE-TV D_F_F=2, D_F_B is full, 1st iteration use banded-MMSE-LE Q=1 [5], 3th iteration'...
    ,'IBDFE-TV D_F_F=3, D_F_B is full, 1st iteration use banded-MMSE-LE Q=1 [5], 3th iteration')
%}
figure(2)
semilogy(indv.range,dv2.BER_est(1,:),'-*');
xlabel('SNR (dB)');
ylabel('average BER');
grid on;
hold on;
semilogy(indv.range,dv2.BER_est(3,:),'-o');
semilogy(indv.range,dv3.BER_est(3,:),'-d');
semilogy(indv.range,dv2.BER_ideal(1,:),'--*');
semilogy(indv.range,dv2.BER_ideal(3,:),'--s');
semilogy(indv.range,dv3.BER_ideal(3,:),'--d');
title('16QAM BER (Normalized Doppler Frequency = 0.02), IBDFE-TV D_F_F=0')
legend('Banded-MMSE-LE Q=1 [5]', ...
    'IBDFE-TV D_F_B=0, 1st iteration use Banded-MMSE-LE Q=1 [5], 3th iteration',...
    'IBDFE-TV D_F_B is full, 1st iteration use Banded-MMSE-LE Q=1 [5], 3th iteration',...
    'Banded-MMSE-LE Q=1 [5] (Perfect CSI)', ...
    'IBDFE-TV D_F_B=0, 1st iteration use Banded-MMSE-LE Q=1 [5], 3th iteration (Perfect CSI)',...
    'IBDFE-TV D_F_B is full, 1st iteration use Banded-MMSE-LE Q=1 [5], 3th iteration (Perfect CSI)')
xlim([0 indv.range(end)]);
ylim([10^-3 1]);
xticks(indv.range)


%{
figure(2)
semilogy(indv.range,dv.BER_ideal(3,:),'-x');
xlabel('SNR (dB)');
ylabel('average BER');
grid on;
hold on;
semilogy(indv.range,dv2.BER_ideal(1,:),'-h');
semilogy(indv.range,dv3.BER_ideal(1,:),'->');
semilogy(indv.range,dv4.BER_ideal(3,:),'-o');
semilogy(indv.range,dv5.BER_ideal(3,:),'-s');
semilogy(indv.range,dv6.BER_ideal(3,:),'-d');
semilogy(indv.range,dv7.BER_ideal(3,:),'-*');
%title('QPSK BER using Estimated CSI (Normalized Doppler Frequency = 0.2), IBDFE-TV D_F_F=1')
%title('QPSK BER using Perfect CSI (Normalized Doppler Frequency = 0.2), IBDFE-TV D_F_F=1')
%title('16QAM BER using Estimated CSI (Normalized Doppler Frequency = 0.2), IBDFE-TV D_F_F=1')
title('16QAM BER using Perfect CSI (Normalized Doppler Frequency = 0.2), IBDFE-TV D_F_F=1')
legend('IBDFE-TI(Tomasin), 3th iteration, no windowing [3]','Full-MMSE-LE, no windowing', ...
    'Banded-MMSE-LE Q=2 [5]',...
    'IBDFE-TV D_F_B=1, 1st iteration use Banded-MMSE-LE Q=2 [5], 3th iteration',...
    'IBDFE-TV D_F_B=2, 1st iteration use Banded-MMSE-LE Q=2 [5], 3th iteration', ...
    'IBDFE-TV D_F_B=3, 1st iteration use Banded-MMSE-LE Q=2 [5], 3th iteration',...
    'IBDFE-TV D_F_B is full, 1st iteration use Banded-MMSE-LE Q=2 [5], 3th iteration')
xlim([0 indv.range(end)]);
ylim([10^-3 1]);
xticks(indv.range)
%}
%{
figure(2)
semilogy(indv.range,dv.BER_ideal(3,:),'-x');
xlabel('SNR (dB)');
ylabel('average BER');
grid on;
hold on;
semilogy(indv.range,dv2.BER_ideal(1,:),'-h');
semilogy(indv.range,dv3.BER_ideal(1,:),'->');
semilogy(indv.range,dv4.BER_ideal(3,:),'-o');
semilogy(indv.range,dv5.BER_ideal(3,:),'-s');
semilogy(indv.range,dv6.BER_ideal(3,:),'-d');
semilogy(indv.range,dv7.BER_ideal(3,:),'-*');
%title('QPSK BER using Estimated CSI (Normalized Doppler Frequency = 0.2), IBDFE-TV D_F_F=1')
%title('QPSK BER using Perfect CSI (Normalized Doppler Frequency = 0.2), IBDFE-TV D_F_F=1')
%title('16QAM BER using Estimated CSI (Normalized Doppler Frequency = 0.2), IBDFE-TV D_F_F=1')
title('16QAM BER using Perfect CSI (Normalized Doppler Frequency = 0.1), IBDFE-TV D_F_F=1')
legend('IBDFE-TI(Tomasin), 3th iteration, no windowing [3]','Full-MMSE-LE, no windowing', ...
    'Banded-MMSE-LE Q=2 [5]',...
    'IBDFE-TV D_F_B=1, 1st iteration use Banded-MMSE-LE Q=2 [5], 3th iteration',...
    'IBDFE-TV D_F_B=2, 1st iteration use Banded-MMSE-LE Q=2 [5], 3th iteration', ...
    'IBDFE-TV D_F_B=3, 1st iteration use Banded-MMSE-LE Q=2 [5], 3th iteration',...
    'IBDFE-TV D_F_B is full, 1st iteration use Banded-MMSE-LE Q=2 [5], 3th iteration')
xlim([0 indv.range(end)]);
ylim([10^-3 1]);
xticks(indv.range)
%}
%{
figure(2)
semilogy(indv.range,dv.BER_ideal(3,:),'-x');
xlabel('SNR (dB)');
ylabel('average BER');
grid on;
hold on;
semilogy(indv.range,dv2.BER_ideal(1,:),'-h');
semilogy(indv.range,dv3.BER_ideal(1,:),'-*');
semilogy(indv.range,dv4.BER_ideal(3,:),'-o');
semilogy(indv.range,dv5.BER_ideal(3,:),'-s');
semilogy(indv.range,dv6.BER_ideal(3,:),'-d');
%semilogy(indv.range,dv6.BER_est(end,:),'-*');
title('16QAM BER using Perfect CSI (Normalized Doppler Frequency = 0.02), IBDFE-TV D_F_F=0')
legend('IBDFE-TI(Tomasin), 3th iteration, no windowing [3]',...
    'Full-MMSE-LE, no windowing','Banded-MMSE-LE Q=1 [5]', ...
    'IBDFE-TV D_F_B=0, 1st iteration use Banded-MMSE-LE Q=1 [5], 3th iteration',...,
    'IBDFE-TV D_F_B=1, 1st iteration use Banded-MMSE-LE Q=1 [5], 3th iteration' ...
    ,'IBDFE-TV D_F_B is full, 1st iteration use Banded-MMSE-LE Q=1 [5], 3th iteration')
xlim([0 indv.range(end)]);
ylim([10^-3 1]);
xticks(indv.range)
%}


%{
figure(2)
semilogy(indv.range,dv.BER_est(1,:),'-o');
hold on;
xlabel('SNR (dB)');
ylabel('average BER');
grid on;
semilogy(indv.range,dv.BER_ideal(1,:),'--o');
xlim([0 indv.range(end)]);
ylim([10^-3 1]);
xticks(indv.range)
legend('Estimated CSI','Perfect CSI')
title('16QAM BER using full-matrix MMSE-LE (Normalized Doppler Frequency = 0.1)')
%}
%{
figure(2)
semilogy(indv.range,dv.BER_est(1,:),'-h');
xlabel('SNR (dB)');
ylabel('average BER');
grid on;
hold on;
semilogy(indv.range,dv.BER_ideal(1,:),'--h');
semilogy(indv.range,dv2.BER_est(end,:),'-o');
semilogy(indv.range,dv2.BER_ideal(end,:),'--o');
semilogy(indv.range,dv3.BER_est(end,:),'-d');
semilogy(indv.range,dv3.BER_ideal(end,:),'--d');
title('QPSK BER (Normalized Doppler Frequency = 0.02), IBDFE-TV D_F_F=0')
legend('Full-matrix MMSE-LE, no windowing(Estimated)','Full-matrix MMSE-LE, no windowing(Perfect)',...
    'IBDFE-TV D_F_B=0, 1st iteration use banded-matrix MMSE-LE Q=1, 4th iteration(Estimated)', ...
    'IBDFE-TV D_F_B=0, 1st iteration use banded-matrix MMSE-LE Q=1, 4th iteration(Perfect)', ...
    'IBDFE-TV D_F_B is full, 1st iteration use banded-matrix MMSE-LE Q=1, 4th iteration(Estimated)', ...
    'IBDFE-TV D_F_B is full, 1st iteration use banded-matrix MMSE-LE Q=1, 4th iteration(Perfect)');
xlim([0 indv.range(end)]);
ylim([10^-3 1]);
xticks(indv.range)
%}
%{
figure(2)
semilogy(indv.range,dv.BER_est(1,:),'-h');
xlabel('SNR (dB)');
ylabel('average BER');
grid on;
hold on;
semilogy(indv.range,dv.BER_ideal(1,:),'--h');
semilogy(indv.range,dv2.BER_est(3,:),'-d');
semilogy(indv.range,dv2.BER_ideal(3,:),'--d');
semilogy(indv.range,dv3.BER_est(3,:),'-*');
semilogy(indv.range,dv3.BER_ideal(3,:),'--*');
title('16QAM BER (Normalized Doppler Frequency = 0.2), IBDFE-TV D_F_F=1')
legend('Full-matrix MMSE-LE, no windowing(Estimated)','Full-matrix MMSE-LE, no windowing(Perfect)',...
    'IBDFE-TV D_F_B=3, 1st iteration use banded-matrix MMSE-LE Q=2, 3th iteration(Estimated)', ...
    'IBDFE-TV D_F_B=3, 1st iteration use banded-matrix MMSE-LE Q=2, 3th iteration(Perfect)', ...
    'IBDFE-TV D_F_B is full, 1st iteration use banded-matrix MMSE-LE Q=2, 3th iteration(Estimated)', ...
    'IBDFE-TV D_F_B is full, 1st iteration use banded-matrix MMSE-LE Q=2, 3th iteration(Perfect)');
xlim([0 indv.range(end)]);
ylim([10^-3 1]);
xticks(indv.range)
%}
%{
figure(2)
semilogy(indv.range,dv.BER_est(1,:),'-h');
xlabel('SNR (dB)');
ylabel('average BER');
grid on;
hold on;
semilogy(indv.range,dv.BER_est(2,:),'-o');
semilogy(indv.range,dv.BER_est(3,:),'-d');
semilogy(indv.range,dv.BER_est(4,:),'-s');
title('16QAM BER using Estimated CSI (Normalized Doppler Frequency = 0.1), IBDFE-TV D_F_F=1, D_F_B full')
legend('1st iteration, Banded-MMSE-LE Q=2 [5]','2nd iteration','3rd iteration','4th iteration')
xlim([0 indv.range(end)]);
ylim([10^-3 1]);
xticks(indv.range)
%}

%{
figure(2)
semilogy(indv.range,dv.BER_est(1,:),'-h');
xlabel('SNR (dB)');
ylabel('average BER');
grid on;
hold on;
semilogy(indv.range,dv2.BER_est(1,:),'-o');
semilogy(indv.range,dv3.BER_est(1,:),'-d');
semilogy(indv.range,dv4.BER_est(1,:),'-s');
semilogy(indv.range,dv5.BER_est(1,:),'-x');
semilogy(indv.range,dv6.BER_est(1,:),'-*');
semilogy(indv.range,dv7.BER_est(1,:),'-');
title('16QAM BER using Estimated CSI (Normalized Doppler Frequency = 0.2), MMSE-LE')
legend('Banded-matrix MMSE-LE Q=1 (No windowing)','Banded-matrix MMSE-LE Q=2 (No windowing)','Banded-matrix MMSE-LE Q=3 (No windowing)'...
    ,'Banded-matrix MMSE-LE Q=1','Banded-matrix MMSE-LE Q=2','Banded-matrix MMSE-LE Q=3','Full-matrix MMSE-LE (No windowing)')
xlim([0 indv.range(end)]);
ylim([10^-3 1]);
xticks(indv.range)
%}
%{
figure(2)
semilogy(indv.range,dv.BER_est(1,:),'-h');
xlabel('SNR (dB)');
ylabel('average BER');
grid on;
hold on;
semilogy(indv.range,dv2.BER_est(1,:),'-o');
semilogy(indv.range,dv3.BER_est(1,:),'-d');
%semilogy(indv.range,dv4.BER_est(1,:),'-*');
semilogy(indv.range,dv5.BER_est(1,:),'-');
%semilogy(indv.range,dv6.BER_est(1,:),'-*');
%semilogy(indv.range,dv7.BER_est(1,:),'-');
title('16QAM BER using Estimated CSI (Normalized Doppler Frequency = 0.1), MMSE-LE')
legend('Banded-MMSE-LE Q=1 (with windowing) [5]','Banded-MMSE-LE Q=2 (with windowing) [5]'...
    ,'Banded-MMSE-LE Q=3 (with windowing) [5]',...
    'Full-MMSE-LE')
xlim([0 indv.range(end)]);
ylim([10^-3 1]);
xticks(indv.range)
%}
%{
figure(2)
semilogy(indv.range,dv.BER_est(1,:),'-h');
xlabel('SNR (dB)');
ylabel('average BER');
grid on;
hold on;
semilogy(indv.range,dv2.BER_est(1,:),'-o');
semilogy(indv.range,dv3.BER_est(1,:),'-d');
%semilogy(indv.range,dv4.BER_est(1,:),'-s');
title('QPSK BER using Estimated CSI (Normalized Doppler Frequency = 0.1), MMSE-LE')
legend('Banded MMSE-LE Q=1 [5]','Banded MMSE-LE Q=2 [5]','Banded MMSE-LE Q=3 [5]')
xlim([0 indv.range(end)]);
ylim([10^-5 1]);
xticks(indv.range)
%}
%{
figure(2)
semilogy(indv.range,dv.BER_est(1,:),'-h');
xlabel('SNR (dB)');
ylabel('average BER');
grid on;
hold on;
semilogy(indv.range,dv2.BER_est(1,:),'-o');
semilogy(indv.range,dv3.BER_est(1,:),'-d');
semilogy(indv.range,dv4.BER_est(1,:),'-s');
semilogy(indv.range,dv5.BER_est(1,:),'-x');
semilogy(indv.range,dv6.BER_est(1,:),'-*');
semilogy(indv.range,dv7.BER_est(1,:),'-');
title('QPSK BER using Estimated CSI (Normalized Doppler Frequency = 0.02), MMSE-LE')
legend('Banded-matrix MMSE-LE Q=1 (No windowing)','Banded-matrix MMSE-LE Q=2 (No windowing)','Banded-matrix MMSE-LE Q=3 (No windowing)'...
    ,'Banded-matrix MMSE-LE Q=1','Banded-matrix MMSE-LE Q=2','Banded-matrix MMSE-LE Q=3','Full-matrix MMSE-LE (No windowing)')
xlim([0 indv.range(end)]);
ylim([10^-3 1]);
xticks(indv.range)
%}
%{
figure(2)
semilogy(indv.range,dv.BER_ideal(3,:),'-x');
xlabel('SNR (dB)');
ylabel('average BER');
grid on;
hold on;
semilogy(indv.range,dv2.BER_ideal(1,:),'-h');
semilogy(indv.range,dv3.BER_ideal(3,:),'-o');
semilogy(indv.range,dv4.BER_ideal(3,:),'-s');
semilogy(indv.range,dv5.BER_ideal(3,:),'-d');
%semilogy(indv.range,dv6.BER_est(end,:),'-*');
title('16QAM BER using Perfect CSI (Normalized Doppler Frequency = 0.02), IBDFE-TV D_F_F=0')
legend('IBDFE-TI(Tomasin), 3th iteration, no windowing','Full-matrix MMSE-LE, no windowing', ...
    'IBDFE-TV D_F_B=0, 1st iteration use banded-matrix MMSE-LE Q=1(no windowing), 3th iteration',...
    'IBDFE-TV D_F_B=1, 1st iteration use banded-matrix MMSE-LE Q=1(no windowing), 3th iteration' ...
    ,'IBDFE-TV D_F_B is full, 1st iteration use banded-matrix MMSE-LE Q=1(no windowing), 3th iteration')
xlim([0 indv.range(end)]);
ylim([10^-3 1]);
xticks(indv.range)
%}
%{
figure(2)
semilogy(indv.range,dv.BER_ideal(3,:),'-x');
xlabel('SNR (dB)');
ylabel('average BER');
grid on;
hold on;
semilogy(indv.range,dv2.BER_ideal(1,:),'-h');
semilogy(indv.range,dv3.BER_ideal(3,:),'-o');
semilogy(indv.range,dv4.BER_ideal(3,:),'-s');
semilogy(indv.range,dv5.BER_ideal(3,:),'-d');
semilogy(indv.range,dv6.BER_ideal(3,:),'-*');
%title('QPSK BER using Estimated CSI (Normalized Doppler Frequency = 0.2), IBDFE-TV D_F_F=1')
%title('QPSK BER using Perfect CSI (Normalized Doppler Frequency = 0.2), IBDFE-TV D_F_F=1')
%title('16QAM BER using Estimated CSI (Normalized Doppler Frequency = 0.2), IBDFE-TV D_F_F=1')
title('QPSK BER using Perfect CSI (Normalized Doppler Frequency = 0.2)')
legend('IBDFE-TI(Tomasin), 3th iteration, no windowing','Full-matrix MMSE-LE, no windowing', ...
    'IBDFE-TV D_F_F=1 D_F_B=16, 1st iteration use banded-matrix MMSE-LE Q=2, 3th iteration','IBDFE-TV D_F_F=2 D_F_B=4, 1st iteration use banded-matrix MMSE-LE Q=2, 3th iteration' ...
    ,'IBDFE-TV D_F_F=3 D_F_B=5, 1st iteration use banded-matrix MMSE-LE Q=2, 3th iteration','IBDFE-TV D_F_B is full, 1st iteration use banded-matrix MMSE-LE Q=2, 3th iteration')
xlim([0 indv.range(end)]);
ylim([10^-5 1]);
xticks(indv.range)
%}
%{
legend('Banded-MMSE-LE Q=1 (no windowing) [4]','Banded-MMSE-LE Q=2 (no windowing) [4]'...
    ,'Banded-MMSE-LE Q=3 (no windowing) [4]'...
    ,'Banded-MMSE-LE Q=1 (with windowing) [5]'...
    ,'Banded-MMSE-LE Q=2 (with windowing) [5]','Banded-MMSE-LE Q=3 (with windowing) [5]'...
    ,'Full-MMSE-LE (No windowing)')
%}

