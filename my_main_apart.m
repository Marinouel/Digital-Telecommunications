function [ ] = my_main_apart ( )

load source.mat             % take the data
leng = length(x);           % the length from the data
array1= zeros(leng,3);       % create memory 
data2 = zeros(3,4);

E= zeros(3,4);              % pinakas gia to sfalma

% gia diaforetikes times p kai arithmo bit exoume

for p=4s
    for bit_we_use=1:3


    % dimiourgw ta dianusmata gia tis exiswseis
    y = zeros(leng,1);
    yht = zeros(leng,1);
    yh = zeros(leng,1);
    yt = zeros(leng,1);
    r = zeros(p, 1);
    R = zeros(p, p);

    %ypologizw to  r
    for i = 1:p
        r(i) = 1/(leng - p) * sum(x(p+1:leng).*x(p+1-i:leng-i));
    end

    %ypologizw to R
    for i = 1:p
        for j = 1:p
            R(i, j) =  1/(leng - p + 1) * sum(x(p+1-j:leng-j).*x(p+1-i:leng-i));
        end
    end

    a = R\r; %    %upologizw tous suntelestes a

    aq = quantizer(a, 8, -2, 2); % kvatizw tous suntelestes

    yn(1:p) = x (1:p);
    yh(1:p) = quantizer(yn(1:p), bit_we_use, -3, 3);
    yht(1:p) = yt(1:p) + yh(1:p);


    for i = p+1:leng
    yt(i) = sum(aq(1:p).*yht(i-1:-1:i-p));
    yn(i) = x(i) - yt(i);
    yh(i) = quantizer(yn(i), bit_we_use, -3, 3);
    yht(i) = yt(i) + yh(i);
    end

    array1(:,bit_we_use) = yht;
    
    E(bit_we_use,p-3) = mean((x - yt).^2)
 

    end
end


%figure
%subplot(1,1,1)    
%i=[1:10000];
%plot(i,x, 'r.-', i,array1(:,1), 'c.-',i,array1(:,2),i,array1(:,3), 'm.-' );
%legend('the first signal: x', 'sfalmagia gia 1 bit:yht 1','sfalmagia gia 2 bit:yht 2','sfalmagia gia 3 bit:yht 3');
%xlabel('i');
%ylabel('j');
%title('p = 30 & N = 1,2,3');

%plot(i,x, 'g.-', i,yh, 'b.--');
%legend('the first signal: x', 'anakataskeuasmeno:yh 1');
%xlabel('i');
%ylabel('j');
%title('X and Yh');

end
