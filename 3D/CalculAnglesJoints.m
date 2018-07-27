%% Sémantique :
%       Calcul des angles nous intéressant, formé par les joints du squelette
%% Entré :
%       - joints : ensemble des points composant notre squelette
%% Sortie :
%       - angles : ensemble des angles recherchés en degré

function angles = CalculAnglesJoints(joints,profondeur)
    nb_angles = 7;
    angles = zeros(1,nb_angles);
    joints = [joints ; profondeur];
    for j = 1:nb_angles
        % Colonne vertebrale
        if (j == 1)
            angles(j) = Angle(joints(:,1) - joints(:,2),joints(:,3) - joints(:,2));
        % Epaule Droite
        elseif (j == 2)
            angles(j) = Angle(joints(:,2) - joints(:,3),joints(:,10) - joints(:,8));
        % Epaule Gauche
        elseif (j == 3)
            angles(j) = Angle(joints(:,2) - joints(:,3),joints(:,11) - joints(:,9));  
        % Coude droit
        elseif (j == 4)
            angles(j) = Angle(joints(:,8) - joints(:,10),joints(:,12) - joints(:,10));
        % Coude gauche
        elseif (j == 5)
            angles(j) = Angle(joints(:,9) - joints(:,11),joints(:,13) - joints(:,11));
        % Poignet droit
        elseif (j == 6)
            angles(j) = Angle(joints(:,12) - joints(:,10),joints(:,14) - joints(:,12));
        % Poignet gauche
        elseif (j == 7)
            angles(j) = Angle(joints(:,13) - joints(:,11),joints(:,15) - joints(:,13));
        end
    end
end