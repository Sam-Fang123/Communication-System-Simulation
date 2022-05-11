

N=10^7;
x=(randn(1,N)>0.5)*2-1;
W=3.5;
n = 1:3;
h1 = 0.5*(1+cos((2*pi/W)*(n-2)));    
h = [zeros(1) h1];

SNR_db=1:14;
SNR_lin=10.^(SNR_db/10); % SNR=symbol power=1/noise_power
noise_pow=1./SNR_lin;
delay=7;
BER=zeros(5,length(noise_pow));
for i=1:length(noise_pow)
    u=conv(h,x);
    u=u+sqrt(noise_pow(i))*randn(1,length(u));
    y_wiener=conv(u,w_opt);
    y_LMS_s075=conv(u,w_LMS(1,:));
    y_LMS_s025=conv(u,w_LMS(2,:));
    y_LMS_s0075=conv(u,w_LMS(3,:));
    Y1=(u>0)*2-1;
    Y2=(y_wiener>0)*2-1;
    Y3=(y_LMS_s075>0)*2-1;
    Y4=(y_LMS_s025>0)*2-1;
    Y5=(y_LMS_s0075>0)*2-1;
    BER(1,i)=sum(Y1(2+1:2+N)~=x)/N;
    BER(2,i)=sum(Y2(delay+1:delay+N)~=x)/N;
    BER(3,i)=sum(Y3(delay+1:delay+N)~=x)/N;
    BER(4,i)=sum(Y4(delay+1:delay+N)~=x)/N;
    BER(5,i)=sum(Y5(delay+1:delay+N)~=x)/N;
end

semilogy(SNR_db,BER(1,:),'-o');
hold on
semilogy(SNR_db,BER(2,:),'-+');
semilogy(SNR_db,BER(3,:),'-*');
semilogy(SNR_db,BER(4,:),'-x');
semilogy(SNR_db,BER(5,:),'-d');
legend('No channel equalization','Wiener filter','LMS,stepsize=0.075','LMS,stepsize=0.025','LMS,stepsize=0.0075');
