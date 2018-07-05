function [ ] = main_psk()
BER_0=zeros(8,1);
BER_1=zeros(8,1);

    Lin=randsrc(1, 10000, [0 1; 0.5 0.5]);
	  M=8;
    
     	k=0;
     	l=1;
    	for i=0:2:16
    		SNR=i;
            Gray=k;
            [BER_0(l), Pb0(l)]=my_psk(Lin, M, SNR, Gray);
            l = l+1;
        end
    %-------------------------------------------
    	k=1;
        l=1;
    	for i=0:2:16
        	SNR=i;
            Gray=k;
            [BER_1(l), Pb1(l)]=my_psk(Lin, M, SNR, Gray);
        	l = l+1;
        end
Pb1
Pb0
BER_0
BER_1

figure
subplot(1,1,1)
i=[1:9];
plot(i,BER_0, 'k.-', i,BER_1, 'b.--',i,Pb1, 'y.--',i,Pb0, 'g.--');
legend('Without Gray:BER0', 'With gray: BER1', 'Pb0', 'Pb1');
xlabel('i');
ylabel('j');
title('With and Without Gray the BER signal is : ');

end 