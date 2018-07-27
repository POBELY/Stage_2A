function [Lissage,DerivI,DerivJ]=gaussmask(TailleFenetre)
% Fonction qui calcule les 3 filtres suivants : 
% - Lissage : poids gaussiens a appliquer pour ponderer la somme
% - DerivI : filtre de derivation  suivant les lignes
% - DerivJ : filtre de derivation suivant les colonnes


% Calcul de l ecart type qui depend de la taille du filtre, cf. cours
n=floor(TailleFenetre/2);
Sigma=TailleFenetre/4;

% Coordonnees des points pour lesquels on calcule le filtre gaussien qui
% depend egalement de la taille du filtre 
% Utiliser meshgrid
[J,I]=meshgrid(-n:n);

% Calcul filtre gaussien pour lisser le resultat (cf. cours)
% Inutile de multiplier par le coefficient 1/(2pi sigma^2) 
% Ne pas oublier la normalisation (cf. cours)
Lissage=exp(-(I.^2+J.^2)/(2*Sigma^2));
Lissage=Lissage/sum(sum(Lissage));

% Calcul des filtres de derivation suivant les lignes et les colonnes
% Utiliser un filtre gaussien (cf. cours)
% Inutile de multiplier par le coefficient 1/(2pi sigma^4) 
% Ne pas oublier la normalisation (cf. cours)
DerivI=-I.*exp(-(I.^2+J.^2)/(2*Sigma^2));
DerivI=DerivI/sum(sum(DerivI(1:n,:)));
DerivJ=DerivI';
