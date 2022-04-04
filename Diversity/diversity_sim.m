
clear
bitnum = 10^6;
block_num = bitnum/2;

% Flat fading channel
velocity = 90;      % mobile velocity in km/hr
Fc = 900;           % carrier freq in MHz
Fs = 10^(-5);      % sampling freq MHZ 
N0 = 20;

rx_num = 2;
channel_num = rx_num*2;
fade_coeff = zeros(channel_num, block_num);
inphase = zeros(channel_num, N0+1);

% initial phase uniformly distributed in [0,2*pi]
rng('default');
inphase = 2*pi*rand(channel_num, N0+1);

for i = 1:channel_num
    [fade_coeff(i,:),inphase(i,:)] = spfade(velocity,Fc,Fs,N0,block_num,inphase(i,:));
end

inphase_mrrc = 2*pi*rand(4,N0+1);
for i = 1:4
    [fade_coeff_mrrc(i,:),inphase_mrrc(i,:)] = spfade(velocity,Fc,Fs,N0,bitnum,inphase_mrrc(i,:));
end

% AWGN noise
SNR_db = 1:50;
SNR_lin = 10.^(SNR_db/10);  % SNR = symbol power/(noise power on each part)
noise_pow = 1./(SNR_lin);  % noise power = 1/(SNR), assume symbol power = 1
BER_2x1 = zeros(1,length(SNR_db));
BER_2x2 = zeros(1,length(SNR_db));
BER_1x2 = zeros(1,length(SNR_db));
BER_1x4 = zeros(1,length(SNR_db));

input = 2*(rand(1,bitnum)>0.5)-1;
r_mrrc = zeros(4,bitnum)
for i=1:length(SNR_db)
    w = sqrt(noise_pow(i))*randn(1,bitnum)+sqrt(-1)*sqrt(noise_pow(i))*randn(1,bitnum); 
    r_mrrc = fade_coeff_mrrc.*input + w;
    

    
