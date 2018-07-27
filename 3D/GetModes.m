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
nbPts = 200; % Nombre de points
bw = 5;  % Rayon de recherche
plotFlag = 0;
[nlig,ncol] = size(prediction);
filtre = 1/26*[1 1 1 1 1 ; 1 1 1 1 1 ; 1 1 2 1 1 ; 1 1 1 1 1 ; 1 1 1 1 1];
%filtre = 1/16*[1 2 1 ; 2 4 2 ; 1 2 1];

%% Déterminer nos modes (centres)
pts_to_cluster = double(samplingpoints(prediction,nbPts));
[clustCent,data2cluster] = ac_meanshiftclustering(pts_to_cluster,bw,plotFlag);
modes = round(clustCent);
modes = modes(:,[2,1]);
heats = zeros(1,size(modes,1));

%% Calculer une chaleur associé à chaques modes par convolution
for ind_modes = 1:size(modes,1) 
    x = modes(ind_modes,1);
    y = modes(ind_modes,2);
    % Déterminer un voisinage du mode considéré
    x_min = min(max(x - 2, 1), nlig - 3);
    x_max = max(min(x + 2, nlig), 3);
    y_min = min(max(y - 2, 1), ncol - 3);
    y_max = max(min(y + 2, ncol), 3);
    vois = prediction(x_min:x_max,y_min:y_max);
    
    % Si on est pas au bord, on prend comme chaleur une moyenne pondéré du
    % voisinage
    if (sum(size(vois) ~= size(filtre)) == 0)
        heats(ind_modes) = sum(sum(vois.*filtre));
    % Sinon, on prend la chaleur du mode
    else
        heats(ind_modes) = prediction(x,y);
    end
end