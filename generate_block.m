%delete('../jpeg.sim\sim_1\behav\output.txt');
%if exist('m','var') < 1
    %delete(h)
    %error('Please create a pxp block store it to variable m');
    
    %m = randi(4294967296,dim);
    valid_test_matrix =0;
    while valid_test_matrix == 0
        dim = randi(100);
        m = randi(200,dim);
        m_inv=inv(m);
        % since VHDL-implementation of inverse is working with integer
        % math, it is useful to have inverse-matrices with elements
        % that does not round to zero.
        if any(m_inv>=1)
            valid_test_matrix =1;
        end
    end
    warning('Random block auto-generated');
%end
%generate_block_txt(m,'../jpeg.sim\sim_1\behav\input','s');
[matrix_size,matrix_size_col]=size(m);
matrix_size_file = fopen(['matrix_size.txt'], 'w');
str_size = int2str(matrix_size);
fprintf(matrix_size_file, '%s ', str_size);
fclose(matrix_size_file);

generate_block_txt(m,'input_matrix');
m_inv= floor(m_inv); % making it integer format.
generate_block_txt(m_inv,'input_inverse_matrix_result_matlab');