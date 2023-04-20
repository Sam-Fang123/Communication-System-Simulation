function w = window_design(N,Q,fd,type)
    
    switch(type)
        case 1
            w = ones(N,1);
        case 2
            Q = Q/2;
            %Basis Matrix
            U = zeros(N, 2*Q+1);
            Q_range = -Q:1:Q;
            time_range = 0:N-1;
            base_freq = exp(2*pi*1j*Q_range./N);
            for t = time_range
                U(t+1,:) = base_freq.^t;
            end
            R_HH = zeros(N,N);
            for m = 1:N
                for n = 1:N
                 R_HH(m,n) = besselj(0,2*pi*fd*(m-n));
                end
            end
            A = zeros(N,N);
            for m=0:N-1
                for n=0:N-1
                    if((n-m)==0)
                        A(m+1,n+1)=1;
                    else
                        A(m+1,n+1) = sin(pi*(2*Q+1)*(n-m)/N)/(N*sin(pi*(n-m)/N));
                    end
                end
            end
            X_N = U'*(R_HH.*A)*U;
            [V,D] = eig(X_N);
            dd = diag(D); 
            [m,i] = max(dd);
            d_hat = V(:,i);
            w = U*d_hat;
            w = w*sqrt(N/sum(w.^2));
        case 3
            w = Tang_ODM_window(N,Q,fd);
    end
    %w = w/sqrt(trace(w*w'))*sqrt(N);
    %{
    F = fft(eye(N),N)/sqrt(N);
    F_H = ifft(eye(N),N)*sqrt(N);
    W = F*diag(w)*F_H;
    figure;
    surf(n_index,m_index,abs(W));
    %}