N = 256;
Q = 2;
BEM.type_str = ["CE-BEM" "GCE-BEM" "P-BEM"];
BEM.type = 3;

U = zeros(N, 2*Q+1);
switch(BEM.type)
    case(1)
        Q_range = -Q:1:Q;
        time_range = 0:N-1;
        base_freq = exp(2*pi*1j*Q_range./N);
        for t = time_range
            U(t+1,:) = base_freq.^t;
        end
    case(2)
        Q_range = -Q:1:Q;
        time_range = 0:N-1;
        base_freq = exp(2*pi*1j*Q_range./(N*2));
        for t = time_range
            U(t+1,:) = base_freq.^t;
        end
    case(3)
        Q_range = 0:1:2*Q;
        time_range = 0:N-1;
        for q = Q_range
            U(:,q+1) = time_range.^q;
            U(:,q+1) = U(:,q+1)/norm(U(:,q+1));
        end
end

figure;
subplot(2*Q+1,1,1);
for ii = 1:2*Q+1
    subplot(1,2*Q+1,ii);
    plot3([1:N],zeros(1,N),real(U(:,ii)));
    hold on;
    plot3([1:N],imag(U(:,ii)),zeros(1,N));
    grid;
    xlim([1 N]);
    xlabel("samples");
    ylabel("imaginary part");
    zlabel("real part");
    title("Basis "+ num2str(ii));
    view(-13,20);
end