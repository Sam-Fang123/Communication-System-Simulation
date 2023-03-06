
figure(1)
semilogy(indv.range,dv.BER(end,:),'-o');
xlabel('SNR (dB)');
ylabel('average BER');
grid on;
hold on;
semilogy(indv.range,dv2.BER(end,:),'--o');
%semilogy(indv.range,dv3.BER(end,:),'-*');
%semilogy(indv.range,dv4.BER(end,:),'--*');
%semilogy(indv.range,dv5.BER(end,:),'-');

%legend('CP (MMSE)','CP (Ideal)','ZP (MMSE)','ZP (Ideal)');
%title('Optimal vs Non-optimal with N=256, BW eff=82.4, fd=0.2, IBDFE-T3C1')
%title('Zero forcing N=64,fd=0');
%legend('LS (Non-optimal)','MMSE(Non-optimal)','Ideal(Non-optimal)','MMSE(Optimal)','Ideal(Optimal)')
%title('Non-Optimal placement with N=256, BW eff=64.8, fd=0.2, IBDFE-T3C1')
%title('Non-optimal vs Optimal placement with N=256, BW eff=82.4, fd=0.02, IBDFE-T3C1');
%title('Optimal placement with N=64, BW eff=75, fd=0.2, IBDFE-T3C1')
%title('Optimal placement with N=64, fd=1, MMSE FD-LE')
%title('Optimal placement with N=64, fd=0, Zero forcing')
%legend('LS estimator(Non-op)','MMSE estimator(Non-op)','Ideal(Non-op)','MMSE estimator(Optimal)','Ideal(Optimal)');
%title('Zero forcing with N=64, fd=0')
%legend('MMSE','Ideal')
%legend('LS estimator','MMSE estimator','Ideal')
%legend('Optimal', 'Equal-powered','Ideal')
title('Optimal placement with N=256, BW eff=82.4, fd=0.2, IBDFE-T3C1')
%legend('LS estimator(Non-op)','MMSE estimator(Non-op)','Ideal(Non-op)','new corr MMSE(Optimal)','new corr ideal(Optimal)');
%title('Optimal vs Non-optimal with N=256, BW eff=82.4, fd=0.2, IBDFE-T3C1')
legend('New est MMSE','old est MMSE')
%legend('New corr MMSE','New corr ideal', 'MMSE','Ideal')
xlim([0 indv.range(end)]);
xticks(indv.range)
