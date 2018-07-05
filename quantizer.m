function [ x_q ] = quantizer( x, N, min_v, max_v )

if (x > max_v)
        x = max_v;
elseif (x < min_v)
        x = min_v;
end

lvl = 2^N;

D = ( max_v - min_v )/lvl; 
x_q = D * floor((x/D) + 0.5);

end

