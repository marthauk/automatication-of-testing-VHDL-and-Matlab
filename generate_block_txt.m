function generate_matrix(m, filename, varargin)
%GENERATE_BLOCK_TXT Generate text-array from pxp matrix
%   GENERATE_BLOCK_TXT(M, FILENAME) outputs a text file with
%   the filename <filename>.txt from the matrix M.
%
%   GENERATE_BLOCK_TXT(M, FILENAME, BIAS) outputs a text file with
%   the filename <filename>.txt from the matrix M, biases specified
%   with BIAS:
%
%       's'     subtract 128 from every pixel

    file = fopen([filename '.txt'], 'w');
    m = double(m);
p = size(m);
    for i = 1:p
        for j = 1:p
            x = j;
            y = i;
            if nargin > 2 %'s'
                str = int2byte(m(y,x)-128);
            else
                if(m(y,x)<= 0)
                    str = sprintf('%x',typecast(int32(m(y,x)),'uint32'));
                    %str = ndec2hex(int32(m(y,x)),32);
                else
                    str = dec2hex(int32(m(y,x)));
                end
            end
            fprintf(file, '%08s ', str);
            %fprintf('%02s ', str);
        end
        fprintf(file, '\n', str);
    end
    fprintf('\n');
    fclose(file);
end

function B = int2byte(i)
assert(i<128 && i>-129)
b = dec2tc(i,8);
u = bin2dec(b);
B = dec2hex(u);
end

function value = dec2tc(dec, N) 
    if(dec<0)
        ndec2hex(dec,N);
    else
    value = dec2bin(mod((dec),2^N),N); 
    end
end

function [hexstring]=ndec2hex(x,n)
% x : input decimal number
% n :   number of bits to perform 2's complements
% hexstring : hex representation of two's complement of x 
x=x + (x<0).*2^n; 
hexstring=dec2hex(x, ceil(n/4));
end

