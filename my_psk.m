function [BER, Pb] = my_psk(Lin, M, SNR, Gray)
% M - PSK
%	Lin: dianusma symvolwn pou tha xrhsimopoiithei gia metadosh
%	M: to plithos twn symvolwn tou alfavhtou
%	SNR: o logos isxuos pros thoryvo ana bit
%	Gray: 1 gia kwdikopoihsh Gray, alliws 0
%	BER: to bit error rate
%   Pb: thewrhtikh pithanothta sfalmatos


    if M ~= 8 && M ~= 4
        fprintf('Wrong input\n')
        return
    end    

    % MAPPER
    Lb = length(Lin); % Mhkos ths arxikhs akolouthias
    out = zeros(Lb / log2(M), 1); % Arxikopoihsh tou pinaka pou tha periexei ta sumvola pros metadosh
    if M == 8 % Se auth thn periptwsh kathe stoixeio ths akolouthias eisodou antistoixei se sumvolo
        out = Lin;
    elseif M == 4 % Se auth thn periptwsh 2 stoixeia ths akolouthias eisodou antistoixoun se sumvolo
        for a = 0 : length(out) - 1
            out(a+1) = bin2dec(num2str(Lin(2*a+1 : 2*a+2))); % Sairnoume 2 sunexomena stoixeia kai ta metatrepoume se sumvolo me thn bin2dec
        end
        if Gray == 1
            out = gray2bin(out, 'psk', M); % Metatroph ths akolouthias se gray kwdikopoihsh an zhteitai
        end
    end

    
    % Modulation PSK
    Es = 1;
    Tsymbol = 40;
    Tc = 4;
    Tsample = Tc / 4;
    fc = 1 / Tc;
    g = sqrt(2 * Es / Tsymbol); % Orthogwnios palmos
    samples = Tsymbol / Tsample; % Ypologismos tou arithmou twn deigmatwn
    s = zeros(length(out), samples); % Arxikopoihsh tou pinaka pou tha periexei ta deigmata gia kathe sumvolo
    for i = 1 : length(out) 
        m = out(i);
        for j = 1 : samples
            s(i, j) = cos(2 * pi * m / M) * g * cos(2 * pi * fc * j) + sin(2 * pi * m / M) * g * sin(2 * pi * fc * j);
        end
    end


    % AWGN
    No = Es / (log2(M) * power(10, SNR / 10)); % Sunarthsh No(SNR), opou to SNR(ana bit) dinetai sthn eisodo
    s2 = No / 2;
    noise = sqrt(s2) * randn(length(out) * 40, 1); % Paragwgh twn deigmatwn thoruvou
    noise = reshape(noise, length(out), samples); % Metatroph tou dianusmatos se disdiastato pinaka gia kateutheian prosthesh me to arxiko mhtrwo
    r = s + noise; % Paragwgh tou mhtrwou pou tha stalei sto dekth


    % Demodulation PSK
    siz = size(r);
    r_  = zeros(siz(1), 2); % To siz(1) dinei ton arithmo twn grammwn tou dianusmatos r, dld to plithos twn sumvolwn. Gia kathe sumvolo exoume 2 sunistwses
    for i = 1 : siz(1) % Kathe sumvolo pollaplasiazetai me th ferousa kai ton orthogwnio palmo ki ustera athroizontai ta deigmata
        for j = 1 : samples
            r_(i, 1) = r_(i, 1) + r(i, j) * g * cos(2 * pi * fc * j);
            r_(i, 2) = r_(i, 2) + r(i, j) * g * sin(2 * pi * fc * j);
        end
    end


    % Fwraths
    s1 = zeros(M, 1); % Oi sunistwses(suntagmenes) kathe sumvolou tou alfavhtou
    s2 = zeros(M, 1);
    for m = 1 : M
        s1(m) = sqrt(Es) * cos(2 * pi * (m - 1) / M);
        s2(m) = sqrt(Es) * sin(2 * pi * (m - 1) / M);
    end
    dist = zeros(M, 1); % Arxikopoihsh pinaka pou tha periexei gia kathe sumvolo thn apostash tou apo 
    symb = zeros(1, siz(1)); % To siz(1) dinei ton arithmo twn grammwn tou dianusmatos r_
    for i = 1 : siz(1) % Gia kathe symvolo eisodou
        for j = 1 : M %Ypologismos ths apostashs tou apo to kathe symvolo tou alfavhtou 
            dist(j) = sqrt((r_(i, 1) - s1(j))^2 + (r_(i, 2) - s2(j))^2); %Xrhsimopoieitai h eukleidia apostash
        end
        [a, b] = min(dist); % Euresh tou elaxistou, dhladh tou symvolou pou apexei ligotero apo thn eisodo tou dekth
        symb(i) = b - 1; % Apothikeush tou stoixeiou me thn elaxisth apostash meiwmenou kata 1 gt to m pairnei times [0, M-1]
    end


    % Demapper
    if Gray == 1
        symb = bin2gray(symb, 'psk', M); % Metatroph apo gray se duadiko se periptwsh pou exei ginei kwdikopoihsh Gray
    end
    Lout = zeros(1, length(symb) * log2(M)); % Arxikopoihsh pinaka pou tha periexei ta bits ths ektimwmenhs akolouthias
    if M == 8 % Se auth thn periptwsh kathe sumvolo antistoixizetai se stoixeio ths akolouthias eksodou
        Lout = symb;
    elseif M == 4 % Se auth thn periptwsh ena sumvolo antistoixizetai se 2 stoixeia ths akolouthias eksodou
        for i = 1 : length(symb)
            if symb(i) == 0
                Lout(2*(i-1)+1) = 0;
                Lout(2*i) = 0;
            elseif symb(i) == 1
                Lout(2*(i-1)+1) = 0;
                Lout(2*i) = 1;
            elseif symb(i) == 2
                Lout(2*(i-1)+1) = 1;
                Lout(2*i) = 0;
            elseif symb(i) == 3
                Lout(2*(i-1)+1) = 1;
                Lout(2*i) = 1;
            end
        end
    end
    
    v = Lin(Lin ~= Lout); % To dianusma v periexei osa stoixeia einai diaforetika metaksu twn Lin,Lout
    BER = length(v)/Lb; % Diairesh tou plithous twn diaforetikwn stoixeiwn me to sunoliko arithmo stoixeiwn wste na prokupsei to BER
    Eb = Es/ log2(M);
    Pb = 1/2*erfc(sqrt(Eb/No)); % Ypologismos ths pithanothtas sfalmatos

end
