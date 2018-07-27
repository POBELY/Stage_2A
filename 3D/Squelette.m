%% Sémantique :
%  Dessine un squelette connaisant ses joints

function Squelette(joints,profondeur,Color)
    nb_joints = size(joints,2);
    figure(1);
    axis equal;

    hold on;

    joints(1,:) = 40 - joints(1,:);
    joints = joints([2 1],:);
    
    % Dessine les points correspondant aux joints
    for j = 1:15
        plot3(joints(1,j),joints(2,j),profondeur(j),strcat('+',Color));
    end
    
    % Relie les joints pour former le squelette
    % Corps
    plot3([joints(1,6) , joints(1,1) , joints(1,2) , joints(1,3) , joints(1,4) , joints(1,5)] , ...
          [joints(2,6) , joints(2,1) , joints(2,2) , joints(2,3) , joints(2,4) , joints(2,5)] , ... 
          [profondeur(6) , profondeur(1) , profondeur(2) , profondeur(3) , profondeur(4) , profondeur(5)] , Color);
    plot3([joints(1,7) , joints(1,1)],[joints(2,7) , joints(2,1)],[profondeur(7) , profondeur(1)] , Color);
   
    % Tete
    %plot([joints(1,5),joints(1,20)],[joints(2,5),joints(2,20)],Color);
    
    % Bras
    plot3([joints(1,14) , joints(1,12) , joints(1,10) , joints(1,8) , joints(1,3) , joints(1,9) , joints(1,11) , joints(1,13) , joints(1,15)] , ...
         [joints(2,14) , joints(2,12) , joints(2,10) , joints(2,8) , joints(2,3) , joints(2,9) , joints(2,11) , joints(2,13) , joints(2,15)] , ...
         [profondeur(14) , profondeur(12) , profondeur(10) , profondeur(8) , profondeur(3) , profondeur(9) , profondeur(11) , profondeur(13) , profondeur(15)] , Color);
    
     % Doigts 
    %plot([joints(1,16),joints(1,14),joints(1,18)], [joints(2,16),joints(2,14),joints(2,18)], Color);
    %plot([joints(1,17),joints(1,15),joints(1,19)], [joints(2,17),joints(2,15),joints(2,19)], Color);
    hold off;
end