
clear all
a1 = [-0.195 -0.975 -1.5955 -1.9114];
a2 = 0.95;
Jmin = [0.0965 0.0731 0.0322 0.0038];
u=0.3;
JJ=zeros(4,200);


for j=1:4
    sigma_u=(1+a2)*Jmin(j)/(1-a2)/((1+a2)^2-a1(j)^2);
    r0 = sigma_u;
    r1 = (-a1(j)/(1+a2))*sigma_u;
    e1 = r0 + r1;
    e2 = r0 - r1;
    v= -[a1+a2;a1-a2]/sqrt(2);
    
    for i=1:201
         v(:,i+1)=[(1-u*e1) 0;0 (1-u*e2)]*v(:,i);
         JJ(j,i)=e1*v(1,i)^2+e2*v(2,i)^2;
    end
    
    
    t=0:0.01:2*pi;
    figure(j)
    for i=1:5
         a=1/sqrt(e1/JJ(j,i));
         b=1/sqrt(e2/JJ(j,i));
         x=a*cos(t);
         y=b*sin(t);
         plot(x,y)
         axis([-6 6 -4 4])
         xticks(-6:2:6)
         yticks(-4:1:4)
         grid on
         hold on
    end
    plot(v(1,:),v(2,:),'linewidth',2)
    hold off
    
    
end
figure(5)
plot(0:200,JJ(1,:)+Jmin(1))
hold on
plot(0:200,JJ(2,:)+Jmin(2),':')
plot(0:200,JJ(3,:)+Jmin(3),'--')
plot(0:200,JJ(4,:)+Jmin(4),'-.')
legend('X=1.22','X=3','X=10','X=100')
