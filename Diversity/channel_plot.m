
clear
bitnum = 100;
block_num = bitnum/2;
t=1:bitnum/2;
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
t=t/(Fs*10^6);  
for i = 1:channel_num
    [fade_coeff(i,:),inphase(i,:)] = spfade(velocity,Fc,Fs,N0,block_num,inphase(i,:));
end

db_abs=10*log10(abs(fade_coeff));
plot(t,db_abs(1,:));
hold on
plot(t,db_abs(2,:));
plot(t,db_abs(3,:));
plot(t,db_abs(4,:));
title('Rayleigh fading channel with Doppler shift 100 Hz (velocity = 120km/h)')
xlabel('time(s)')
ylabel('Signal Level(dB about rms)')