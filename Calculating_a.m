function [a ] = Calculating_a (p, leng,x )
r = zeros(p, 1);
R = zeros(p, p);
for i = 1:p
   r(i) = 1/(leng - p) * sum(x(p+1:leng).*x(p+1-i:leng-i));
end

%Calculating R
for i = 1:p
   for j = 1:p
      R(i, j) =  1/(leng - p + 1) * sum(x(p+1-j:leng-j).*x(p+1-i:leng-i));
   end
end
a = R\r;
end