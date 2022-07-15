clear
bitnum = 10^6;
t=1:bitnum;
% Flat fading channel
velocity = 120;      % mobile velocity in km/hr
Fc = 900;           % carrier freq in MHz
Fs = 10^(-3);      % sampling freq MHZ 
N0 = 20;

channel_num = 4
fade_coeff = zeros(channel_num, bitnum);
inphase = zeros(channel_num, N0+1);
temp_re = zeros(channel_num, bitnum);
temp_im = zeros(channel_num, bitnum);
% initial phase uniformly distributed in [0,2*pi]
rng('default');
inphase = 2*pi*rand(channel_num, N0+1);
t=t/(Fs*10^6);  
for i = 1:channel_num
    [temp_re(i,:),temp_im(i,:),fade_coeff(i,:),inphase(i,:)] = spfade(velocity,Fc,Fs,N0,bitnum,inphase(i,:));
end

Chi_n_2 = abs(fade_coeff(1,:)).^2;
Chi_n_4 = sum(abs(fade_coeff(1:2,:)).^2);
Chi_n_8 = sum(abs(fade_coeff(1:4,:)).^2);

grid = 0:0.01:10;
figure(1)
subplot(3,1,1)
histogram(Chi_n_2,'Normalization','pdf');
ylabel('Probability Density');
xlabel('X')
title('PDF of 2 degree of freedom Chi-Square (1 channel power)')
ylim([0 1])
xlim([0 8])
hold on
plot( grid, exp(-grid/2/(1/2))/gamma(1)/(1/2)/2 ,'b-','LineWidth',2);
hold off

%figure(2)
subplot(3,1,2)
histogram(Chi_n_4,'Normalization','pdf');
ylabel('Probability Density');
xlabel('X')
title('PDF of 4 degree of freedom Chi-Square (Sum of 2 channel power)')
ylim([0 1])
xlim([0 8])
hold on
plot( grid, exp(-grid/2/(1/2)).*grid.^(4/2-1)/(2^(4/2))/gamma(4/2)/sqrt(1/2)^4 ,'b-','LineWidth',2);
hold off

%figure(3)
subplot(3,1,3)
histogram(Chi_n_8,'Normalization','pdf');
ylabel('Probability Density');
xlabel('X')
title('PDF of 8 degree of freedom Chi-Square (Sum of 4 channel power)')
ylim([0 1])
xlim([0 8])
hold on
plot( grid, exp(-grid/2/(1/2)).*grid.^(8/2-1)/(2^(8/2))/gamma(8/2)/sqrt(1/2)^8 ,'b-','LineWidth',2);
hold off
