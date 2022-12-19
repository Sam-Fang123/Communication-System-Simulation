function [L,D] = LDL_fun(A,Q)

dim = size(A);
N_A = dim(1);

if A~=conj(A.')
    error('The matrix is not conjugate and symmetric')
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
    L(j+1:M,j) = (A(j+1:M,j)-L(j+1:M,m:j-1)*v(m:j-1))/v(j);
end

        