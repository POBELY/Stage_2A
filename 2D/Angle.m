%% Sémantique :
%       Calculer l'angle formé par 3 points (<=180°)
%% Entrées :
%       - p1, p2, p3 : points formant l'angle (p1,p2,p3)
%% Sortie : 
%       - theta : angle formé par les vecteurs p1p2 et p3p2 en degré

function theta = Angle(u,v)

colineaire = dot(u/norm(u),v/norm(v));

if (colineaire == 1)
    theta = 0;
elseif (colineaire == -1)
    theta = 180;
elseif (sum(u ~= [0 ; 0]) == 0 || sum(v ~= [0 ; 0]) == 0)
    theta = NaN;
else
    theta = real(acos(dot(u,v)/(norm(u)*norm(v))))/(2*pi)*360;
end