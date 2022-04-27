
clear
bitnum = 10^6;
block_num = bitnum/2;
t=1:bitnum/2;
% Flat fading channel
velocity = 30;      % mobile velocity in km/hr
Fc = 900;           % carrier freq in MHz
Fs = 1;      % sampling freq MHZ 
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

db_abs=(abs(fade_coeff));
plot(t,db_abs(1,:));
hold on
plot(t,db_abs(2,:));
plot(t,db_abs(3,:));
%plot(t,db_abs(4,:));
title('Rayleigh fading channels with Doppler shift 25 Hz (velocity = 30km/h)')
xlabel('time(s)')
ylabel('Signal Level(dB about rms)')