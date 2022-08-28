clear
clc
bitnum = 10^6;
t=1:bitnum;

%Flat Fading Channel
velocity = 30;      % mobile velocity in km/hr
Fc = 900;           % carrier freq in MHz
Fs = 0.27;      % sampling freq MHZ 
                    % (we have 4 samples per pn chip, thus 1.2288*4)

t=t/(Fs*10^6)*10^3;     % ms       
N0 = 20;
fade_coeff = zeros(1, bitnum);
inphase = zeros(1, N0+1);

% initial phase uniformly distributed in [0,2*pi]
rng('default');
inphase = 2*pi*rand(1, N0+1);

for i=1:bitnum:bitnum*10
    [temp_re temp_im fade_coeff,inphase] = spfade(velocity,Fc,Fs,N0,bitnum,inphase);
    fade_coeff_out(i:bitnum+i-1)=fade_coeff;
end


figure(1)
plot(t,20*log10(abs(fade_coeff)));
title('Rayleigh fading channel when velocity = 30km/h')
xlabel('time(ms)')
ylabel('Signal Level(dB about rms)')
xlim([0 740])
grid on
%ylabel('Attenuation gain |h|')

x1 = -2.5:0.01:2.5;
x2 = 0:0.01:3;
figure(2)
histogram(abs(fade_coeff_out),'Normalization','pdf');
ylabel('Probability Density');
xlabel('X')
title('PDF of X when velocity = 30km/h')
hold on
plot( x2, x2/(1/2).*exp(-x2.^2/2/(1/2)),'b-','LineWidth',2);
hold off

figure(3)
histogram(real(fade_coeff_out),'Normalization','pdf');
ylabel('Probability Density');
xlabel('Xi')
title('PDF of Xi when velocity = 30km/h')
hold on
plot( x1, 1/sqrt(2*pi*(1/2))*exp(-x1.^2/2/(1/2)),'b-','LineWidth',2);
hold off

figure(4)
histogram(imag(fade_coeff_out),'Normalization','pdf');
ylabel('Probability Density');
xlabel('Xq')
title('PDF of Xq when velocity = 30km/h')
hold on
plot(x1, 1/sqrt(2*pi*(1/2))*exp(-x1.^2/2/(1/2)),'b-','LineWidth',2);
hold off
%re_mean=mean(temp_re)
%re_power=mean(temp_re.^2)
%im_mean=mean(temp_im)
%im_power=mean(temp_im.^2)

%channel_power=mean(temp_re.^2+temp_im.^2)
%channel_correlation=mean(temp_re.*temp_im)
