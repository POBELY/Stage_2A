%% Sémantique :
%  Détermine les meilleurs modes pour chaques joints d'une image
%% Entrées :
%     - prédictions : matrice 3D des heatmaps prédite pour chaques joints
%     d'une image
%     - modes : listes des modes pour chaques joints
%% Sorties :
%     - modes : matrices des centres des fortes zones de probabilités
%%

function best_modes = BestModeOrdonne(modes, heats, predictions)

  %% Paramètres
  nb_joints = length(modes);
  best_modes = zeros(2,nb_joints);
      
  % On parcours les joints dans un certain ordre
  for j = 1:nb_joints
      modes_j = modes{j};
      heat_j = heats{j};
      dist_min = Inf;
      indice_best_mode = 1;
      
      % Choisir le joint précédent le joint courant selon sa valeur
      if ((j <= 5) || (j == 20)) 
          max_modes_j = zeros(1,size(modes_j,1));
      elseif (j <= 7) 
          mode_vois_prec = best_modes(:,1);
      elseif (j <= 9)
          mode_vois_prec = best_modes(:,3);
      elseif (j <= 17)
          mode_vois_prec = best_modes(:,j-2);
      elseif (j <=19)
          mode_vois_prec = best_modes(:,j-4);
      end
        
      for k = 1:size(modes_j,1)
          % Si le joint appartient à la colonne du squelette, on prend
          % celui ayant la plus grosse chaleur comme valeur
          if ((j <= 5) || (j == 20))
              max_modes_j(k) = predictions(modes_j(k,1),modes_j(k,2),j);
          % Sinon, on prend celui qui réalise le meilleur score,
          % c'est-à-dire minimise le raport de sa distance au joint le
          % précédent dans le sqelette sur sa valeur de chaleur
          else
              chaleur_mode = heat_j(k);
              dist = sqrt((modes_j(k,1) - mode_vois_prec(1))^2 + (modes_j(k,2) - mode_vois_prec(2))^2)/chaleur_mode;
              if (dist <= dist_min )
                  dist_min = dist;
                  indice_best_mode = k;
              end
              %end
          end
      end
         
      % On détermine l'indice du mode ayant la plus forte valeure de
      % chaleur
      if ((j <= 5) || (j == 20))            
          [~,indice_best_mode] = max(max_modes_j);                
      end
      % On donne le mode ayant le meilleur score comme mode associé
      % au joint j regardé
      best_modes(:,j) = modes_j(indice_best_mode,:);
  end
end