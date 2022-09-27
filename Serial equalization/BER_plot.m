
indv.range = 1:30;
semilogy(indv.range,dv.BER(1,:),'-d');
title('Two path channel(Same as paper), normalize Doppler Frequency = 0.3');
xlabel('SNR');
ylabel('BER');
grid on;
hold on;
semilogy(indv.range,dv.BER(2,:),'-^');
semilogy(indv.range,dv.BER(3,:),'-*');
semilogy(indv.range,dv.BER(4,:),'-o');

semilogy(indv.range,dv2.BER(1,:),'--d');
semilogy(indv.range,dv2.BER(2,:),'--^');
semilogy(indv.range,dv2.BER(3,:),'--*');
semilogy(indv.range,dv2.BER(4,:),'--o');
legend('1 tap MMSE','5 tap MMSE','15 tap MMSE','25 tap MMSE','1 tap DFE','5 tap DFE','15 tap DFE','25 tap DFE')