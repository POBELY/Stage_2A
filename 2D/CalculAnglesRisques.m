%% Sémantique :
%       Déterminer les risques liés à la position du squelette selon les
%       angles qu'il forme au niveau de ses jointures
%% Entré :
%       - angles : valeurs des angles en degré formé par les jointures du
%                  squelette
%% Sortie :
%       - risques : vecteur prenant les valeurs suivantes associés à
%       chaques angles 
%           1 : acceptable sous conditions
%           0 : pas recommandé
%          -1 : doit être évité

function risques = CalculAnglesRisques(angles)
    nb_angles = length(angles);
    risques = zeros(1,nb_angles);
    
    % Dos
    if (angles(1) < 130)
        risques(1) = -1;
    elseif (angles(1) == 180)
        risques(1) = 1;
    elseif isnan(angles(1))
        risques(1) = nan;
    end
    
    % Epaule Droite
    if (angles(2) > 120)
        risques(2) = -1;
    elseif (angles(2) <= 90)
        risques(2) = 1;
    elseif isnan(angles(2))
        risques(2) = nan;
    end
    
    % Epaule Gauche
    if (angles(3) > 120)
        risques(3) = -1;
    elseif (angles(3) <= 90)
        risques(3) = 1;
    elseif isnan(angles(3))
        risques(3) = nan;
    end
    
    % Coude droit
    if (angles(4) == 180)
        risques(4) = -1;
    elseif (75 <= angles(4) && angles(4) <= 140)
        risques(4) = 1;
    elseif isnan(angles(4))
        risques(4) = nan;
    end
    
    % Coude gauche
    if (angles(5) == 180)
        risques(5) = -1;
    elseif (75 <= angles(5) && angles(5) <= 140)
        risques(5) = 1;
    elseif isnan(angles(5))
        risques(5) = nan;
    end
    
    % Poignet droit
    if (angles(6) >= 70)
        risques(6) = -1;
    elseif (angles(6) <= 10)
        risques(6) = 1;
    elseif isnan(angles(6))
        risques(6) = nan;
    end
    
    % Poignet gauche
    if (angles(7) >= 70)
        risques(7) = -1;
    elseif (angles(7) <= 10)
        risques(7) = 1;
    elseif isnan(angles(7))
        risques(7) = nan;
    end
    
    
end

