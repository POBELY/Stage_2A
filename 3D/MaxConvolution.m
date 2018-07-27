%% Sémantique :
%  Détermine le positionnement le plus probable du joints j, sur l'image
%  prédiction i, après convolution par filtre
%% Entrées :
%     - prédiction : matrice de la heatmap prédite
%     - filtre : filtre de convolution à appliquer
%% Sorties :
%     - x : ligne du joint le plus probable
%     - y : colonne du joint le plus probable
%%

function [x,y] = MaxConvolution(prediction,filtre)
    % Convolution de prediction par le filtre
    M = conv2(prediction,filtre,'same');
    % Récupérer la valeur et la position du maximum de M
    [val,ind] = max(M(:));
    % Obtenir la position par rapport à la matrice prediction
    [x,y] = ind2sub(size(prediction),ind);
end
