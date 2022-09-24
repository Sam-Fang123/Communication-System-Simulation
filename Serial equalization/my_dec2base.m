%
% Representing the decimal number dec in terms of base.
% - This is similar to MATLAB's dec2base with two improvements:
%   (1) MATLAB accepts base in the range of [2 36]
%   (2) MATLAB's output is a string.  For example, 'F' = dec2base(15,16)
% - This function that I wrote does not have the limitation mentioned
% above.  That is, num_base is still a vector with entries being numbers.
% For example, 15 = dec2base(15,16).
%
% - INPUT:
%   n: number of digits in the output
% - OUTPUT:
%   [MSB...LSB]

function num_base = my_dec2base(dec,base,n)

if dec<0
  error('input can not be negative!');   
end

tmp = dec;
for ii=1:n
  num_base(n-ii+1) = rem(tmp,base);  
  tmp = (tmp-num_base(n-ii+1))/base;  
end    
    







