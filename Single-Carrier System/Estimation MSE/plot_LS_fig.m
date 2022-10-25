figure;

load('LS fd = 0.02 10dB.mat');
semilogy(indv.range,dv.CH_MSE, 'b-o', 'MarkerSize',10,'linewidth' ,0.5,'DisplayName',('Simulated MSE(LS, fd = 0.02, 10dB)'));hold on;
semilogy(indv.range,dv.Theory_BEM_MSE, 'm-->', 'MarkerSize',5,'linewidth' ,0.5,'DisplayName',('Theoretical MSE(LS, fd = 0.02, 10dB)'));hold on;

load('LS fd = 0.02 20dB.mat');
semilogy(indv.range,dv.CH_MSE, 'b-d', 'MarkerSize',10,'linewidth' ,0.5,'DisplayName',('Simulated MSE(LS, fd = 0.02, 20dB)'));hold on;
semilogy(indv.range,dv.Theory_BEM_MSE, 'm--<', 'MarkerSize',5,'linewidth' ,0.5,'DisplayName',('Theoretical MSE(LS, fd = 0.02, 20dB)'));hold on;

load('LS fd = 0.02 30dB.mat');
semilogy(indv.range,dv.CH_MSE, 'b-s', 'MarkerSize',10,'linewidth' ,0.5,'DisplayName',('Simulated MSE(LS, fd = 0.02, 30dB)'));hold on;
semilogy(indv.range,dv.Theory_BEM_MSE, 'm--v', 'MarkerSize',5,'linewidth' ,0.5,'DisplayName',('Theoretical MSE(LS, fd = 0.02, 30dB)'));hold on;

load('LS fd = 0.02 40dB.mat');
semilogy(indv.range,dv.CH_MSE, 'b-h', 'MarkerSize',10,'linewidth' ,0.5,'DisplayName',('Simulated MSE(LS, fd = 0.02, 40dB)'));hold on;
semilogy(indv.range,dv.Theory_BEM_MSE, 'm--^', 'MarkerSize',5,'linewidth' ,0.5,'DisplayName',('Theoretical MSE(LS, fd = 0.02, 40dB)'));hold on;

grid;
legend('Location','northwest');
xlabel("\gamma");
ylabel("MSE");
ylim([10^-3 10^2]);
title("Simulated LSE MSE Over 10000 Blocks and Theoretical LSE MSE(Normalized Doppler Frequency = 0.02)");