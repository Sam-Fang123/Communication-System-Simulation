
figure(1)
semilogy(indv.range,dv.BER(end,:),'--d');
xlabel('SNR (dB)');
ylabel('average BER');
grid on;
hold on;
semilogy(indv.range,dv2.BER(end,:),'--*');
semilogy(indv.range,dv3.BER(end,:),'-o');
semilogy(indv.range,dv4.BER(end,:),'-*');
semilogy(indv.range,dv5.BER(end,:),'-');

%legend('CP (MMSE)','CP (Ideal)','ZP (MMSE)','ZP (Ideal)');
%title('Optimal vs Non-optimal with N=256, BW eff=82.4, fd=0.2, IBDFE-T3C1')
%title('Zero forcing N=64,fd=0');
%legend('LS (Non-optimal)','MMSE(Non-optimal)','Ideal(Non-optimal)','MMSE(Optimal)','Ideal(Optimal)')
%title('Non-Optimal placement with N=256, BW eff=64.8, fd=0.2, IBDFE-T3C1')
%title('Non-optimal vs Optimal placement with N=256, BW eff=82.4, fd=0.02, IBDFE-T3C1');
%title('Optimal placement with N=64, BW eff=75, fd=0.2, IBDFE-T3C1')
title('Optimal placement with N=256, BW eff=82.4, fd=0.2, IBDFE-T3C1')
%title('Optimal placement with N=64, fd=0, Zero forcing')
%legend('LS estimator(Non-op)','MMSE estimator(Non-op)','Ideal(Non-op)','MMSE estimator(Optimal)','Ideal(Optimal)');
%title('Zero forcing with N=64, fd=0')
%legend('MMSE','Ideal')
%legend('LS estimator','MMSE estimator','Ideal')
legend('No window','Ideal','Tang O-GCE','Tang OW-GCE','Ideal(Tang)')
%legend('Optimal', 'Equal-powered','Ideal')
%title('Optimal placement with N=256, BW eff=82.4, fd=0.2, IBDFE-T3C1')
%title('Optimal placement with N=256, BW eff=82.4, fd=0.2, MMSE-FD-LE')
%legend('LS estimator(Non-op)','MMSE estimator(Non-op)','Ideal(Non-op)','new corr MMSE(Optimal)','new corr ideal(Optimal)');
%title('Optimal vs Non-optimal with N=256, BW eff=82.4, fd=0.2, IBDFE-T3C1')
%legend('New est MMSE','old est MMSE')
%legend('New corr MMSE','New corr ideal', 'MMSE','Ideal')
%legend('MMSE','Ideal', 'MMSE Tang','Ideal Tang')
xlim([0 indv.range(end)]);
xticks(indv.range)

%{
figure(2)
semilogy(indv.range,dv.BER(1,:),'--d');
xlabel('SNR (dB)');
ylabel('average BER');
grid on;
hold on;
semilogy(indv.range,dv2.BER(1,:),'--*');
semilogy(indv.range,dv3.BER(1,:),'-o');
semilogy(indv.range,dv4.BER(1,:),'-*');
semilogy(indv.range,dv5.BER(1,:),'-');
title('Optimal placement with N=256, BW eff=82.4, fd=0.2, MMSE-FD-LE')
%legend('MMSE','Ideal', 'MMSE Tang','Ideal Tang')
legend('No window','Ideal','Tang O-GCE','Tang OW-GCE','Ideal(Tang)')
xlim([0 indv.range(end)]);
xticks(indv.range)
%}
