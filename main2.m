function [ ] = main2 ( )

load source.mat
leng = length(x); 
data = zeros(leng,3);
data2 = zeros(3,4);
E_y_2 = zeros(3,4);
for p=4:8
    for num=1:3


    %Number of bits we are going to use

    %Allocating memory
    yn = zeros(leng,1);
    yht = zeros(leng,1);
    yh = zeros(leng,1);
    yt = zeros(leng,1);


    %Calculating a
    a = Calculating_a(p, leng,x );
       
    aq = quantizer(a, 8, -2, 2);

    yn(1:p) = x (1:p);
    yh(1:p) = quantizer(yn(1:p), num, -3, 3);
    yht(1:p) = yt(1:p) + yh(1:p);


    for i = p+1:leng
    yt(i) = sum(aq(1:p).*yht(i-1:-1:i-p));
    yn(i) = x(i) - yt(i);
    yh(i) = quantizer(yn(i), num, -3, 3);
    yht(i) = yt(i) + yh(i);
    %disp('Predicted!')
    end

    data(:,num) = yht;

    disp('The value of N= ')
    num
    disp('The value of p=')
    p

    E_y_2(num,p-3) = mean((x - yt).^2);
    
    
    end
end
%E_y_2
figure
subplot(1,1,1)    
i=[1:10000];
%plot(i,x, 'g.-', i,data(:,1), 'b.--',i,data(:,2),i,data(:,3), 'k.--' );
%legend('the first signal: x', 'prediction:yht 1','prediction:yht 2','prediction:yht 3');
%xlabel('i');
%ylabel('j');
%title('p = 8 & N = 1,2,3');

plot(i,x, 'g.-', i,yh, 'b.--');
legend('the first signal: x', 'anakataskeuasmeno:yh 1');
xlabel('i');
ylabel('j');
title('X and Yh');

%N = [2 4 6];
%figure(3);


end
