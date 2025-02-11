%CORDIV Stochastic Divider design.
function quotient = CORDIV(X,Y,N)
% X is dividend (numerator) - should be scalar
% Y is divisor (denominator) - should be scalar
% N is the bit-stream length.

% Bit-streams are generated based on 1st Sobol sequence

sobol_seq = net(sobolset(10), N);
sobol_seq_new = sobol_seq(:,1);


X1_stream_sobol = zeros(1, N);
X2_stream_sobol = zeros(1, N);

bp_X1 = zeros(1,N);
bp_X2 = zeros(1,N);


Z_CORDIV_sobol = zeros(1, N+1);

        if X < Y
            
            for z=1:N
                if ((Y/N) > sobol_seq_new(z))
                    X2_stream_sobol(z) = 1;                    
                end
                if ((X/N) > sobol_seq_new(z))
                    X1_stream_sobol(z) = 1;
                end
                if (1 + X/N)/2 > sobol_seq_new(z)
                    bp_X1(z) = 1;
                end
                if (1 + Y/N)/2 > sobol_seq_new(z)
                    bp_X2(z) = 1;
                end

                Z_CORDIV_sobol(z+1) = bitor(bitand(not(X2_stream_sobol(z)),Z_CORDIV_sobol(z)),and(X2_stream_sobol(z),X1_stream_sobol(z)));
            end
        else
            error('Numerator should be less than the Denominator!');
        end


    quotient = sum(Z_CORDIV_sobol(1:end-1))/N;
    
end
    


