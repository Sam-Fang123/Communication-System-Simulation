clear
clc
bitnum = 10^6;
t=1:bitnum;

%Flat Fading Channel
velocity = 120;      % mobile velocity in km/hr
Fc = 900;           % carrier freq in MHz
Fs = 10^-3;      % sampling freq MHZ 
                    % (we have 4 samples per pn chip, thus 1.2288*4)

t=t/(Fs*10^6)*10^3;     % ms       
N0 = 20;
fade_coeff = zeros(1, bitnum);
inphase = zeros(1, N0+1);

% initial phase uniformly distributed in [0,2*pi]
rng('default');
inphase = 2*pi*rand(1, N0+1);

[temp_re temp_im fade_coeff,inphase] = spfade(velocity,Fc,Fs,N0,bitnum,inphase);
%db_re=10*log10(rms(temp_re,1));
%db_im=10*log10(rms(temp_im,1));
figure(1)
plot(t,20*log10(abs(fade_coeff)));
title('Rayleigh fading channel when vehicle velocity = 120km/h)')
xlabel('time(ms)')
ylabel('Signal Level(dB about rms)')
grid on
%ylabel('Attenuation gain |h|')

grid = -2.5:0.01:2.5;
grid2 = 0:0.01:3;
figure(2)
histogram(abs(fade_coeff),'Normalization','pdf');
ylabel('Probability Density');
xlabel('X')
title('PDF of X')
hold on
plot( grid2, grid2/(1/2).*exp(-grid2.^2/2/(1/2)),'b-','LineWidth',2);
hold off

figure(3)
histogram(temp_re,'Normalization','pdf');
ylabel('Probability Density');
xlabel('Xi')
title('PDF of Xi')
hold on
plot( grid, 1/sqrt(2*pi*(1/2))*exp(-grid.^2/2/(1/2)),'b-','LineWidth',2);
hold off

figure(4)
histogram(temp_im,'Normalization','pdf');
ylabel('Probability Density');
xlabel('Xq')
title('PDF of Xq')
hold on
plot(grid, 1/sqrt(2*pi*(1/2))*exp(-grid.^2/2/(1/2)),'b-','LineWidth',2);
hold off
%re_mean=mean(temp_re)
%re_power=mean(temp_re.^2)
%im_mean=mean(temp_im)
%im_power=mean(temp_im.^2)

channel_power=mean(temp_re.^2+temp_im.^2)
