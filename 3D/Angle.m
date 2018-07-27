%% Sémantique :
%       Calculer l'angle formé par 2 vecteurs (<=180°)
%% Entrées :
%       - u,v : vecteurs formant l'angle
%% Sortie : 
%       - theta : angle formé par les vecteurs u et v en degré

function theta = Angle(u,v)

colineaire = dot(u/norm(u),v/norm(v));

% Si deux vecteurs sont colinéaires, on étudie leur sens
if (colineaire == 1)
    theta = 0;
elseif (colineaire == -1)
    theta = 180;
% Si u ou v est un vecteur nul, on ne peut pas connaitre l'angle formé
elseif ((sum(u ~= [0 ; 0 ; 0]) == 0) || (sum(v ~= [0 ; 0 ; 0]) == 0))
    theta = NaN;
% Sinon, on calcule l'angle formé par ces deux vecteurs
else
    theta = real(acos(dot(u,v)/(norm(u)*norm(v))))/(2*pi)*360;
end