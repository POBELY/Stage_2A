%% Sémantique :
%  Calcule les centres des différentes zones de forte probabilité d'une
%  heatmap
%% Entrées :
%     - prédiction : matrice de la heatmap prédite
%% Sorties :
%     - modes : matrices des centres des fortes zones de probabilités
%%

function [modes, heats] = GetModes(prediction)
%% Paramètres
nbPts = 200;
bw = 7;  % Rayon de recherche
plotFlag = 0;
[nlig,ncol] = size(prediction);
filtre = 1/26*[1 1 1 1 1 ; 1 1 1 1 1 ; 1 1 2 1 1 ; 1 1 1 1 1 ; 1 1 1 1 1];

%% Déterminer nos modes (centres)
pts_to_cluster = double(samplingpoints(prediction,nbPts));
[clustCent,data2cluster] = ac_meanshiftclustering(pts_to_cluster,bw,plotFlag);
modes = round(clustCent);
modes = modes(:,[2,1]);
heats = zeros(1,size(modes,1));

%% prendre comme centre, la valeur la plus forte dans le voisinage de nos centres
for ind_modes = 1:size(modes,1) 
    x = modes(ind_modes,1);
    y = modes(ind_modes,2); 
    x_min = min(max(x - 2, 1), nlig - 3);
    x_max = max(min(x + 2, nlig), 3);
    y_min = min(max(y - 2, 1), ncol - 3);
    y_max = max(min(y + 2, ncol), 3);
    vois = prediction(x_min:x_max,y_min:y_max);
    
%     [~,ind] = max(vois(:));
%     [ind_x,ind_y] = ind2sub([3,3],ind);
%     x = x - 2 + ind_x;
%     y = y - 2 + ind_y;
%     x_min = min(max(x - 1, 1), nlig-2);
%     x_max = max(min(x + 1, nlig), 3);
%     y_min = min(max(y - 1, 1), ncol - 2);
%     y_max = max(min(y + 1, ncol), 3);
%     vois = prediction(x_min:x_max,y_min:y_max);
%     modes(ind_modes,1) = x;
%     modes(ind_modes,2) = y; 
    heats(ind_modes) = sum(sum(vois.*filtre));
end