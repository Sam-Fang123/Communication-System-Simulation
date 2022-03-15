clc
clear
bitnum = 10^3;
t=1:bitnum;
%Flat Fading Channel
velocity = 100;      % mobile velocity in km/hr
Fc = 900;           % carrier freq in MHz
Fs = 10^(-3);      % sampling freq MHZ 
                    % (we have 4 samples per pn chip, thus 1.2288*4)
N0 = 20;
fade_coeff = zeros(1, bitnum);
inphase = zeros(1, N0+1);

% initial phase uniformly distributed in [0,2*pi]
rng('default');
inphase = 2*pi*rand(1, N0+1);

[fade_coeff,inphase] = spfade(velocity,Fc,Fs,N0,bitnum,inphase);
db_rms=10*log10(rms(fade_coeff,1));
plot(t,db_rms);




