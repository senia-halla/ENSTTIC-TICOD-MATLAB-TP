clc; 
clf; 
clear;

m = 4; %--> Bits du Message
k = 3; % --> Bits de controle de parité
n = m+k; %--> Bits à transmettre 

M = randi(2,m,1) - 1; % --> Le Message  
[H,G] = hammgen(k); 

% H : Matrice de vérification de parité
% G : Matrice Génératrice 

C = zeros(n,1);
C1 = zeros(n,1);
C2 = zeros(n,1);

%% Codage et Décodage :
C = mod(G' * M, 2) ;
C1 = mod(C,2);
C2 = encode(M,7,4,'hamming');
R0 = decode(C2,7,4,'hamming');
%% Détection d'erreur et syndrome :
Z = zeros(k,1);
Zn = zeros(k,n);

Z = H * C; %--> Detection d'erreur 
Z = mod(Z,2); %--> Vecteur Syndrome 
for i=1:length(C1)
    C1(i) = mod(C1(i) + 1, 2); 
    Z = mod(H * C1, 2);
    Zn(:,i) = Z;
    C1(i) = mod(C1(i)+1, 2);
end 

%% Exemple d'Application : Exemple de detection et correction
C = [1 1 1 1 0 1 1];
C_corrected = C; 
Z = mod(H.*C, 2);
for i=1:length(C)
    test = symerr(Z, H(1:k,i));
    if(test==0)
        i
        C_corrected(i) = mod(C_corrected(i)+1,2)
    end
end
C_corrected; 
R = decode(C,7,4,'hamming'); % Vérification




