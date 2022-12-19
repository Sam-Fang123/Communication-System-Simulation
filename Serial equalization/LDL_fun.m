function [L,D] = LDL_fun(A,Q)

dim = size(A);
N_A = dim(1);
for i = 1:N_A
    for j = 1:N_A
        if A(i,j)~=A(j,i)
            error('The input matrix should be symmetric')
        end
    end
end

L = eye(N_A);
D = A.*eye(N_A);
v = zeros(N_A,1);
for j = 1:N_A
    m = max([1 j-2*Q]);
    M = min([j+2*Q N_A]);
    for i = m:j-1
        v(i) = conj(L(j,i))*D(i,i);
    end
    v(j) = A(j,j)-L(j,m:j-1)*v(m:j-1);
    D(j,j) = v(j);
    L(j+1:M,j) = ()

        