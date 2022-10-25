function [U] = BEM_CE_Basis_Matrix(N,Q)
    
    U = zeros(N, 2*Q+1);
    Q_range = -Q:1:Q;
    time_range = 0:N-1;
    base_freq = exp(2*pi*1j*Q_range./N);
    for t = time_range
        U(t+1,:) = base_freq.^t;
    end
    U = orth(U);
    %{
    for q = 1:size(Q_range,2)
        U(:,q) = U(:,q)/norm(U(:,q));
    end
    %}