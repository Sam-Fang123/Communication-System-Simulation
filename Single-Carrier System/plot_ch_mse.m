
figure(1)
semilogy(indv.range,dv.CH_MSE,'-o');
xlabel('SNR (dB)');
ylabel('Channel MSE');
grid on;
hold on;
semilogy(indv.range,dv2.CH_MSE,'-*');
%semilogy(indv.range,dv3.CH_MSE,'-d');
%legend('Optimal MMSE','Non-opt MMSE','Non-opt LS');
legend('MMSE','LS')
%legend('Optimal','Equal power');
title('Channel MSE fd=0.2')
xlim([0 indv.range(end)]);
xticks(indv.range)

figure(2)
semilogy(indv.range,dv.BEM_MSE,'-o');
xlabel('SNR (dB)');
ylabel('BEM MSE');
grid on;
hold on;
semilogy(indv.range,dv2.BEM_MSE,'-*');
%semilogy(indv.range,dv3.BEM_MSE,'-d');
%legend('Optimal MMSE','Non-opt MMSE','Non-opt LS');
legend('MMSE','LS')
%legend('Optimal','Equal power');
title('BEM MSE fd=0.2')
xlim([0 indv.range(end)]);
xticks(indv.range)