%% Sémantique :
%  Affichage d'une heatmap et calcul des erreurs de prédictions
%% Entrées :
%      - i : numéro de la heatmap à afficher
%      - j : numéro du joint de la heatmap considéré
%%

function AfficheHeatmap(i,j)
    %% Récupérer les heatmaps et nos paramètres
    load heatmaps10000;
    
    %% Load Heatmaps
    % indice de l'image associé au joint recherché dans la matrice globale
    k = (i-num_heatmap_dep)*nb_joints + j;
    % Récupérer les heatmaps qui nous intéresse
    test = tests(:,:,k);
    prediction = predictions(:,:,k);

    %% Affichage Heatmap
    subplot 121;
    imshow(test./max(test(:)), 'Colormap',jet(256));
    title('Heatmap Test')
    subplot 122;
    imshow(prediction./max(prediction(:)), 'Colormap',jet(256));
    title('Heatmap Prédite')

    %% Calcul des maximums
    % Max Test
    [~,ind] = max(test(:));
    [xt,yt] = ind2sub(size(test),ind);
    disp(['Maximum Test : (',num2str(xt),',',num2str(yt),')']);
    % Max Prediction
    [~,ind] = max(prediction(:));
    [xp,yp] = ind2sub(size(prediction),ind);
    disp(['Maximum Prédit : (',num2str(xp),',',num2str(yp),') -> Erreur : ',num2str(sqrt((xt - xp)^2+ (yt - yp)^2))]);
    % Max Convolution
    filtre = [0 1 0 ; 1 1 1 ; 0 1 0];
    [xm,ym] = MaxConvolution(prediction,filtre);
    disp(['Maximum Convolution : (',num2str(xm),',',num2str(ym),') -> Erreur : ',num2str(sqrt((xt - xm)^2+ (yt - ym)^2))]);
    % Max Soustraction
    [xs,ys] = MaxSoustraction(predictions,joints{j},filtre,k);
    disp(['Maximum Soustraction : (',num2str(xs),',',num2str(ys),') -> Erreur : ',num2str(sqrt((xt - xs)^2+ (yt - ys)^2))]);
end








