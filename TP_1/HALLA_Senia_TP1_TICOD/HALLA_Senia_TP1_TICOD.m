clc; 
clf; 
clear; 

%Mesure de l'information :
m = 2; %m est le Nombre de symboles du code => binaire 1/0
N = 100000;
for i=1:4
    L = i; %L est la longeur du code 
    M = m^L; % M est le nombre de symboles de la source
    x = randi(M,1,N);  
    h=0:0.01:M ;
    subplot(2,2,i); 
    histogram(x,h);
    xlabel('Nombre de symbole de la source');ylabel('fréquence de ce symbole');
    title(['Histo de distibution des symbole L = ' num2str(i)]);
    grid;  
end 

%Mesure d'Entropie : 

for l=1:4
    L = l; %L est la longeur du code 
    M = m^L; % M est le nombre de symboles de la source
    x = randi(M,1,N);  
    h=0:0.01:M ;
    H = 0;
    frequence = histogram(x,h);
    freq = histogram(x);
    freq = freq.Values ; 
    Lf = length(freq) ; 
    P = zeros(1,M);
    I = zeros(1,M) ;
    j=1 ; 
    for i=1:Lf
        if freq(i)>0
            P(j) = freq(i) ; 
            j=j+1 ; 
        end
    end
    P = P/N ;
    Px = P;
    I = -log2(P); 
    H = P*I' ;
    fprintf(" L = %d , H(X) =  %f bits/message \n",l, H)
end 

%La programation d'une Source :
 
M=8; symbols = [0:M-1];
Pz = [0.0078 0.0625 0.2539 0.4713 0.1250 0.060 0.0156 0.0039];
z = randsrc(N,1,[symbols;Pz]);
h=0:0.01:M ;
histogram(z,h);
xlabel('Nombre de symbole de la source');
ylabel('fréquence de ce symbole');
title(['Histo de distibution des symbole L = ' num2str(L)]);
grid; 
frequence = histogram(z);
Lf = frequence.Values;
K = length(Lf);
P = zeros(1,M);   Iz = zeros(1,M);  j=1;
for i=1:K
    if Lf(i)>1
        P(j)=Lf(i);
        Iz(j)=-log2(P(j)/N);%voici le calcul de I = -log2(Pi) 
        j=j+1;
        
    end
end
P;
% Iz = -log2(Pz);
% Hz = Pz * Iz'
%calcul de l'entropie: (Another method)
H2 = 0;
for i=1:K
    H2 = H2+ Pz(i)*Iz(i);
end

fprintf(" Hz(X) =  %f bits/message",H2);


%Codage et Compression : 
% Codage de la Source : 
[Dicoz, LMoyz] = huffmandict(symbols, Pz);
codez = huffmanenco(z, Dicoz);
for i = 1:8 
    symbole = Dicoz(i,1); celldisp(symbole)
    codage = Dicoz(i,2); celldisp(codage)
end 

%Décodage 
decodez = huffmandeco (codez, Dicoz); 
erreur = symerr(z, decodez);
