
%{
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

title('(Tang)Optimal placement with N=256, BW eff=82.4, fd=0.2, IBDFE-T3C1, first iteration D=2')
%legend('1st(MMSE)','2nd(MMSE)','3rd(MMSE)','4th(MMSE)','1st(Ideal)','2nd(Ideal)','3rd(Ideal)','4th(Ideal)')
legend('1st iteration(Estimated)','1st iteration(Ideal)','4th iteration(Estimated)','4th iteration(Ideal)')
xlim([0 indv.range(end)]);
ylim([10^-5 0.5]);
xticks(indv.range)
%}

%{
figure(1)
semilogy(indv.range,dv.BER(1,:),'-<');
xlabel('SNR (dB)');
ylabel('average BER');
grid on;
hold on;
semilogy(indv.range,dv2.BER(1,:),'-d');
semilogy(indv.range,dv3.BER(1,:),'-*');
%semilogy(indv.range,dv4.BER(1,:),'-+');
%semilogy(indv.range,dv5.BER(1,:),'-x');
%semilogy(indv.range,dv6.BER(1,:),'->');
%semilogy(indv.range,dv7.BER(1,:),'-o');
title('Optimal placement with N=256, BW eff=82.4, fd=0.2, MMSE-FD-LE (Ideal channel)')
%legend('D = 24','D = 48','D = 96','D = 128','full')
legend('D = 2(With Tang window Q = 2)','D = 4(With Tang window Q = 4)','full(Without window)')
xlim([0 indv.range(end)]);
ylim([10^-5 0.5]);
xticks(indv.range)
%}
%{
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
%semilogy(indv.range,dv7.BER(end,:),'-o');
title('Optimal placement with N=256, BW eff=82.4, fd=0.2, IBDFE-T3C1 (Ideal channel)')
%legend('D = 24','D = 48','D = 96','D = 128','full')
%legend('D = 2(With Tang window Q = 2)','D = 4(With Tang window Q = 4)','full(Without window)')
legend('D=2(Tang) T2C1(Est)','D=4(Tang) T2C1(Est)','T3C1 D=2 1st full(Est)','D=2(Tang) T2C1','D=4(Tang) T2C1','T3C1 D=2 1st full')
xlim([0 indv.range(end)]);
ylim([10^-5 0.5]);
xticks(indv.range)
%}
%{
figure(2)
semilogy(indv.range,dv.BER(end,:),'--*');
xlabel('SNR (dB)');
ylabel('average BER');
grid on;
hold on;
semilogy(indv.range,dv2.BER(end,:),'--o');
semilogy(indv.range,dv3.BER(end,:),'-*');
semilogy(indv.range,dv4.BER(end,:),'-o');
%semilogy(indv.range,dv5.BER(end,:),'-');
%semilogy(indv.range,dv6.BER(end,:),'->');
%semilogy(indv.range,dv7.BER(end,:),'-d');
%semilogy(indv.range,dv8.BER(end,:),'-*');
%semilogy(indv.range,dv9.BER(end,:),'-o');
%semilogy(indv.range,dv10.BER(end,:),'-');
title('Optimal placement with N=256, BW eff=82.4, fd=0.2, IBDFE-T3C1 vs T2C1')
legend('1st banded D=4(Tang) T3C1(Est)','All banded D=4(Tang) T2C1(Est)','1st banded D=4(Tang) T3C1(Ideal)','All banded D=4(Tang) T2C1(Ideal)')
%title('Optimal placement with N=256, BW eff=82.4, fd=0.2, IBDFE-T3C1 vs IBDFE-T2C1 Banded')
%legend('D = 24','D = 48','D = 96','D = 128','full')
%legend('D = 2(With Tang window Q = 2)','D = 4(With Tang window Q = 4)','full(Without window)')
%legend('D=2(Tang) T2C1(Estimated)','D=3(Tang) T2C1(Estimated)','D=4(Tang) T2C1(Estimated)','T3C1 D=2 1st full(Estimated)','T2C1 (Estimated)','D=2(Tang) T2C1','D=3(Tang) T2C1','D=4(Tang) T2C1','T3C1 D=2 1st full','T2C1')
%legend('D=2 T2C1(Estimated)','D=4 T2C1(Estimated)','T3C1 D=2 1st full(Estimated)','T2C1 (Estimated)','D=2 T2C1','D=4 T2C1','T3C1 D=2 1st full','T2C1')
%legend('D=1(Tang) T2C1','D=2(Tang) T2C1','D=3(Tang) T2C1','D=4(Tang) T2C1','T3C1 D=2 1st full')
%legend('1st banded D=1(Tang) T3C1(Ideal)','1st banded D=2(Tang) T3C1(Ideal)','1st banded D=3(Tang) T3C1(Ideal)','1st banded D=4(Tang) T3C1((Ideal))','1st full T3C1((Ideal))')
%legend('1st banded D=1(Tang) T3C1(Est)','1st banded D=2(Tang) T3C1(Est)','1st banded D=3(Tang) T3C1(Est)','1st banded D=4(Tang) T3C1(Est)','1st full T3C1(Est)')
xlim([0 indv.range(end)]);
ylim([10^-5 0.5]);
%ylim([10^-3 0.5])
xticks(indv.range)
%}

%{
figure(2)
semilogy(indv.range,dv.BER(end,:),'-o');
xlabel('SNR (dB)');
ylabel('average BER');
grid on;
hold on;
semilogy(indv.range,dv2.BER(end,:),'-d');
%semilogy(indv.range,dv3.BER(end,:),'-');
title('Optimal placement with N=256, BW eff=89.4, fd=0.02, IBDFE-T3C1 1st Banded, D2=0')
legend('D1=2(Tang) O-GCE','D1=2(Tang) Ideal')
xlim([0 indv.range(end)]);
ylim([10^-7 1]);
xticks(indv.range)
%}

%{
figure(4)
semilogy(indv.range,dv.BER(end,:),'-o');
xlabel('SNR (dB)');
ylabel('average BER');
grid on;
hold on;
semilogy(indv.range,dv2.BER(end,:),'-d');
semilogy(indv.range,dv3.BER(end,:),'-*');
%semilogy(indv.range,dv4.BER(end,:),'-^');
%semilogy(indv.range,dv5.BER(end,:),'-');
%title('Optimal placement with N=256, BW eff=82.4, fd=0.2, IBDFE-T3C1 1st Banded, D2=1, Ideal')
title('Optimal placement with N=256, BW eff=89.4, fd=0.02, IBDFE-T3C1 1st Banded, D2=0, Est')
legend('D1=1(Tang)','D1=2(Tang)','D1 full')
grid on;
hold on;
xlim([0 indv.range(end)]);
ylim([10^-7 1]);
xticks(indv.range)
%}


%{
figure(2)
semilogy(indv.range,dv.BER(end,:),'-o');
xlabel('SNR (dB)');
ylabel('average BER');
grid on;
hold on;
semilogy(indv.range,dv2.BER(end,:),'-d');
semilogy(indv.range,dv3.BER(end,:),'-*');
semilogy(indv.range,dv4.BER_est(end,:),'->');
semilogy(indv.range,dv5.BER_est(end,:),'-^');
semilogy(indv.range,dv6.BER_est(end,:),'-+');
semilogy(indv.range,dv7.BER(end,:),'-');
%title('Optimal placement N=256, BW eff=82.4, fd=0.2, T3C1 vs T4C1 1st Banded D1=2(Tang), D2=2, Ideal')
%title('Optimal placement N=256, BW eff=82.4, fd=0.2, T3C1 vs T4C1 1st Banded D1=2(Tang), D2=1')
title('Optimal placement N=256, BW eff=82.4, fd=0.2, T4C1 1st Banded D1=2(Tang), D2=1, Est channel')
legend('T4C1 D3=2','T4C1 D3=4','T4C1 D3=8','T4C1 D3=16','T4C1 D3=32','T4C1 D3=64','T3C1')
xlim([0 indv.range(end)]);
ylim([10^-5 1]);
xticks(indv.range)
%}

figure(2)
semilogy(indv.range,dv.BER_est(end,:),'-o');
xlabel('SNR (dB)');
ylabel('average BER');
grid on;
hold on;
semilogy(indv.range,dv2.BER(end,:),'-d');
semilogy(indv.range,dv3.BER(end,:),'-*');
semilogy(indv.range,dv4.BER(end,:),'->');
semilogy(indv.range,dv5.BER(end,:),'-');
semilogy(indv.range,dv6.BER_est(end,:),'--');
%semilogy(indv.range,dv7.BER(end,:),'-');
%title('Optimal placement N=256, BW eff=82.4, fd=0.2, T3C1 vs T4C1 1st Banded D1=2(Tang), D2=2, Ideal')
%title('Optimal placement N=256, BW eff=82.4, fd=0.2, T3C1 vs T4C1 1st Banded D1=2(Tang), D2=1')
title('Optimal placement N=256, BW eff=82.4, fd=0.02, T4C1 1st Banded D1=1(Tang), D2=0, Est channel')
legend('T4C1 D3=1','T4C1 D3=2','T4C1 D3=4','T4C1 D3=6','T3C1','T3C1 1st full')
xlim([0 indv.range(end)]);
ylim([10^-6 1]);
xticks(indv.range)



