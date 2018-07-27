%% Sémantique :
%  Dessine un squelette connaisant ses joints

function Squelette(joints,Color)
    nb_joints = size(joints,2);
    figure(1);
    axis equal;

    hold on;
    joints(1,:) = 40 - joints(1,:);
    joints = joints([2 1],:);
    
    % Dessine les points correspondant aux joints
    for j = 1:15
        plot(joints(1,j),joints(2,j),strcat('+',Color));
    end
    
    % Relie les joints pour former le squelette
    % Corps
    plot([joints(1,6) , joints(1,1) , joints(1,2) , joints(1,3) , joints(1,4) , joints(1,5)] , ...
         [joints(2,6) , joints(2,1) , joints(2,2) , joints(2,3) , joints(2,4) , joints(2,5)] , Color);
    plot([joints(1,7) , joints(1,1)],[joints(2,7) , joints(2,1)],Color);
   
    % Tete
    %plot([joints(1,5),joints(1,20)],[joints(2,5),joints(2,20)],Color);
    
    % Bras
    plot([joints(1,14) , joints(1,12) , joints(1,10) , joints(1,8) , joints(1,3) , joints(1,9) , joints(1,11) , joints(1,13) , joints(1,15)] , ...
         [joints(2,14) , joints(2,12) , joints(2,10) , joints(2,8) , joints(2,3) , joints(2,9) , joints(2,11) , joints(2,13) , joints(2,15)] , Color);
    
     % Doigts 
    %plot([joints(1,16),joints(1,14),joints(1,18)], [joints(2,16),joints(2,14),joints(2,18)], Color);
    %plot([joints(1,17),joints(1,15),joints(1,19)], [joints(2,17),joints(2,15),joints(2,19)], Color);
end