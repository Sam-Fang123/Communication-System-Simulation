clc
clear
bitnum = 10^6;
t=1:bitnum;

%Flat Fading Channel
velocity = 90;      % mobile velocity in km/hr
Fc = 900;           % carrier freq in MHz
Fs = 1;      % sampling freq MHZ 
                    % (we have 4 samples per pn chip, thus 1.2288*4)

t=t/(Fs*10^6);       
N0 = 20;
fade_coeff = zeros(1, bitnum);
inphase = zeros(1, N0+1);

% initial phase uniformly distributed in [0,2*pi]
rng('default');
inphase = 2*pi*rand(1, N0+1);

[temp_re temp_im fade_coeff,inphase] = spfade(velocity,Fc,Fs,N0,bitnum,inphase);
db_rms=10*log10(rms(fade_coeff,1));
%db_re=10*log10(rms(temp_re,1));
%db_im=10*log10(rms(temp_im,1));
figure(1)
plot(t,db_rms);
xlabel('time(s)')
ylabel('Signal Level(dB about rms)')
figure(2)
subplot(3,1,1)
histogram(rms(fade_coeff,1));
subplot(3,1,2)
histogram(temp_re);
subplot(3,1,3)
histogram(temp_im);
mean_of_X=mean(rms(fade_coeff,1));
var_of_Xr=var(temp_re);
mean_of_X-sqrt(var_of_Xr)*(sqrt(pi/2))




