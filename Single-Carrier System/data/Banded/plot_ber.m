

figure(1)
semilogy(indv.range,dv.BER(1,:),'--o');
xlabel('SNR (dB)');
ylabel('average BER');
grid on;
hold on;
%semilogy(indv.range,dv.BER(2,:),'-*');
%semilogy(indv.range,dv.BER(3,:),'-o');
semilogy(indv.range,dv2.BER(1,:),'-o');
semilogy(indv.range,dv.BER(4,:),'--d');
%semilogy(indv.range,dv2.BER(2,:),'--*');
%semilogy(indv.range,dv2.BER(3,:),'--o');
semilogy(indv.range,dv2.BER(4,:),'-d');

title('Optimal placement with N=256, BW eff=82.4, fd=0.2, IBDFE-T3C1, first iteration D=12')
%legend('1st(MMSE)','2nd(MMSE)','3rd(MMSE)','4th(MMSE)','1st(Ideal)','2nd(Ideal)','3rd(Ideal)','4th(Ideal)')
legend('1st iteration(Estimated)','1st iteration(Ideal)','4th iteration(Estimated)','4th iteration(Ideal)')
xlim([0 indv.range(end)]);
ylim([10^-5 0.5]);
xticks(indv.range)

%{
figure(1)
semilogy(indv.range,dv.BER(1,:),'-<');
xlabel('SNR (dB)');
ylabel('average BER');
grid on;
hold on;
semilogy(indv.range,dv2.BER(1,:),'-d');
semilogy(indv.range,dv3.BER(1,:),'-*');
semilogy(indv.range,dv4.BER(1,:),'-+');
semilogy(indv.range,dv5.BER(1,:),'-x');
semilogy(indv.range,dv6.BER(1,:),'->');
semilogy(indv.range,dv7.BER(1,:),'-o');
title('Optimal placement with N=256, BW eff=82.4, fd=0.2, MMSE-FD-LE (Ideal channel)')
legend('D = 2','D = 4','D = 6','D = 8','D = 10','D = 12','full')
xlim([0 indv.range(end)]);
ylim([10^-5 0.5]);
xticks(indv.range)

figure(2)
semilogy(indv.range,dv.BER(end,:),'-<');
xlabel('SNR (dB)');
ylabel('average BER');
grid on;
hold on;
semilogy(indv.range,dv2.BER(end,:),'-d');
semilogy(indv.range,dv3.BER(end,:),'-*');
semilogy(indv.range,dv4.BER(end,:),'-+');
semilogy(indv.range,dv5.BER(end,:),'-x');
semilogy(indv.range,dv6.BER(end,:),'->');
semilogy(indv.range,dv7.BER(end,:),'-o');
title('Optimal placement with N=256, BW eff=82.4, fd=0.2, IBDFE-T3C1 (Ideal channel)')
legend('D = 2','D = 4','D = 6','D = 8','D = 10','D = 12','full')
xlim([0 indv.range(end)]);
ylim([10^-5 0.5]);
xticks(indv.range)
%}