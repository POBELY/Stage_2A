%% Sémantique :
%  Détermine le positionnement le plus probable du joints j, sur l'image
%  prédiction i, après convolution par filtre, sur la heatmap crée en soustrayant
%  la heatmap associée au joint droit, à la heatmap associée au joint
%  gauche
%% Entrées :
%     - prédictions : matrice des heatmaps prédites
%     - filtre : filtre de convolution à appliquer
%     - joint : nom du joint considéré
%     - k : indice de la heatmap dont on recherche la position du joint
%           dans predictions
%% Sorties :
%     - x : ligne du joint le plus probable
%     - y : colonne du joint le plus probable
%%

function [x,y] = MaxSoustraction(predictions,joint,filtre,k)

prediction = predictions(:,:,k);

if (contains(joint,'right'))
    % Créer la heatmap soustraite
    prediction_left = predictions(:,:,k+1);
    new_prediction = prediction - prediction_left*max(max(prediction))/max(max(prediction_left));
    % Récupèrer le maximum
    [x,y] = MaxConvolution(new_prediction,filtre);
    
elseif (contains(joint,'left'))
    % Créer la heatmap soustraite
    prediction_right = predictions(:,:,k-1);
    new_prediction = prediction - prediction_right*max(max(prediction))/max(max(prediction_right));
    % Récupèrer le maximum
    [x,y] = MaxConvolution(new_prediction,filtre);
   
else
    [x,y] = MaxConvolution(prediction,filtre);
end
