

%%  Assumption on data
clear all
bits_num = 5*10^5;    % # of bits
fft_size = 64;          % fft size
input = rand(64,bits_num)>0.5;     
X = input*2-1;       % X:Input bits


%% Channel assumption
h = [1 -0.5];          % Multipath channel impulse response
H = fft(h,fft_size);   % Multipath channel frequency response
H_matrix = diag(H);    % Frequency domain matrix  
CP_size = 4;           % Length of CP (must > lenth of h)

%% SNR
OFDM_symbol_power = 1;
SNR = 1:25;            % SNR = symbol power/(noise power on each part)
noise_pow = OFDM_symbol_power./(SNR);  % noise power = 1/(SNR)
BER = zeros(fft_size,length(SNR));
%%
for j=1:length(SNR)
    error_num = zeros(fft_size,1);
    for i = 1:bits_num
        %% TX
        x = ifft(X(:,i),fft_size)*sqrt(fft_size);     % x = ifft(X) (Unitary)
        x = [x(fft_size-CP_size+1:end);x];            % add CP
        %% Channel, y: Received signal, Q: Convolution matrix
        y = conv(h,x);    
        w = sqrt(noise_pow(j))*randn(length(y),1)+sqrt(-1)*sqrt(noise_pow(j))*randn(length(y),1);
        y = y+w;      % w : AWGN noise
        %% RX
        Y = fft(y(CP_size+1:end),fft_size)/sqrt(fft_size);     % Y = fft(y) (Unitary)
        X2 = inv(H_matrix)*Y;      % X2=Y/H (Equalization)
        %% Detection
        Output(X2>=0) = 1;
        Output(X2<0) = -1;
        error_num = error_num + (transpose(Output)~=X(:,i));
    end
    BER(:,j) = error_num/bits_num;  % Simulation BER of each subcarriers
end

average_BER = mean(BER);    % Simulation average BER 
   
SNR_i = transpose(abs(H).^2)*SNR;   % SNR after frequency-selective channel
theoretical_BER = qfunc(sqrt(SNR_i));   % Theoretical BER of each subcarriers
average_theoretical_BER = mean(theoretical_BER);    % Theoretical average BER


figure(1)
semilogy(10*log10(SNR),average_theoretical_BER,'-*');
hold on
semilogy(10*log10(SNR),average_BER,'-o');
semilogy(10*log10(SNR),qfunc(sqrt(SNR)));
legend('Theoretical average BER','Simulation average BER','BER without Multipath')
title('BER curve');
xlabel('SNR(dB)');ylabel('BER');
grid minor
grid on
ylim([10^-4 1]);


figure(2)
semilogy(10*log10(SNR),theoretical_BER([1 20 30 40 50 60],:),'-*');
hold on
semilogy(10*log10(SNR),BER([1 20 30 40 50 60],:),'-o');
legend('Theoretical BER of each subcarriers','Simulation BER of every subcarriers')
title('BER curve of every subcarriers');
xlabel('SNR(dB)');ylabel('BER');
grid minor
grid on
ylim([10^-4 1]);

figure(3)
title('|H| of each subcarrier')
stem((1:fft_size),abs(H))
ylabel('|H|');xlabel('Channel')
xlim([1 64])
figure(4)
title('BER of each subcarrier in fixed SNR')
stem((1:fft_size),BER(:,1));
ylabel('BER');xlabel('Subcarrier')
xlim([1 64])

