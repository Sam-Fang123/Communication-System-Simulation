
clear all
n = 1:3;
W=[2.9 3.3 3.5];
h=zeros(3,4);
for i=1:3
    h1 = 0.5*(1+cos((2*pi/W(i))*(n-2)));    
    h(i,:) = [zeros(1) h1];
end
%legend('eigenvalue spread=6.0782','eigenvalue spread=21.7132','eigenvalue spread=46.8216')
subplot(3,1,1)
stem(0:length(h(1,:))-1,h(1,:));
axis([0, 5,-inf, inf]);
xticks(0:5);
title('channel 1 with eigenvalue spread=6.0782');
subplot(3,1,2)
stem(0:length(h(2,:))-1,h(2,:));
axis([0, 5,-inf, inf]);
xticks(0:5);
title('channel 2 with eigenvalue spread=21.7132');
subplot(3,1,3)
stem(0:length(h(3,:))-1,h(3,:));
axis([0, 5,-inf, inf]);
xticks(0:5);
title('channel 3 with eigenvalue spread=46.8216');
