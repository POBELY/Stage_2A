%% Sémantique :
%  Calculer des taux d'erreurs sur les heatmaps appartenant à l'échantillion de test, 
%  pour un joint.
clear;
load heatmaps;

j_im = 19; % joint considéré

%% Variables
filtre = [0 1 0 ; 1 1 1 ; 0 1 0];
Erreur = zeros(4,nb_heatmaps); % Matrice des erreurs initialisée

%% Calcul des erreurs de prédictions
 % Parcours de toutes les heatmaps
 for i = num_heatmap_dep:num_heatmap_dep + nb_heatmaps - 1
     i % affichage de la heatmap observé
    
    modes = cell([1 nb_joints]);
    heats = cell([1 nb_joints]);
    
    %% Parcours des joints de notre images
    for j = 1:nb_joints
        % Récupérer les heatmaps test et prédiction 
        k = (i-num_heatmap_dep)*nb_joints + j;
        prediction = predictions(:,:,k);

        % Récupérer les modes, correspondant au centres des zones de
        % probabilité de positionnement du joint
        [modes{j}, heats{j}] = GetModes(prediction);
    end

    %% Calcule des modes les plus probables par joint
    k = (i-num_heatmap_dep)*nb_joints;
    joints_modes = BestModeOrdonne(modes, heats, predictions(:,:,k+1:k+nb_joints));
    
    k = k + j_im;
    test = tests(:,:,k);
    prediction = predictions(:,:,k);
    
    % Calcul position joint Test
    [~,ind] = max(test(:));
    [xt,yt] = ind2sub(size(test),ind);
    joints_tests = [xt ; yt];
       
    % Calcul position joint Prédit selon max heatmap
    [~,ind] = max(prediction(:));
    [xp,yp] = ind2sub(size(prediction),ind);
    joints_max = [xp ; yp];
    
    % Calcul position joint Prédit selon max de convolution
    [xc,yc] = MaxConvolution(prediction,filtre);
    joints_conv = [xc,yc];
    
    % Calcul position joint Prédit selon soustraction
    [xs,ys] = MaxSoustraction(predictions,joints{j_im},filtre,k);
    joints_soustraction = [xs,ys];

    %% Calcul des erreurs de Prédiction
    Erreur(:,i - num_heatmap_dep + 1) = ...
        [ sqrt((joints_tests(1) - joints_max(1)).^2 + (joints_tests(2) - joints_max(2)).^2) ; ...
          sqrt((joints_tests(1) - joints_conv(1)).^2 + (joints_tests(2) - joints_conv(2)).^2) ; ...
          sqrt((joints_tests(1) - joints_soustraction(1)).^2 + (joints_tests(2) - joints_soustraction(2)).^2) ; ...
          sqrt((joints_tests(1) - joints_modes(1,j_im)).^2 + (joints_tests(2) - joints_modes(2,j_im)).^2) ];
end     
  
%% Affichage des résultats

% Affichage de l'erreur maximum
res = ['Erreur max prédiction max : ', num2str(max(Erreur(1,:)))];
disp(res);
res = ['Erreur max prédiction convolution : ', num2str(max(Erreur(2,:)))];
disp(res);
res = ['Erreur max prédiction soustraction : ', num2str(max(Erreur(3,:)))];
disp(res);
res = ['Erreur max prédiction modes : ', num2str(max(Erreur(4,:)))];
disp(res);
disp('*********************************************');

% Affichage de l'erreur moyenne
res = ['Erreur moyenne prédiction max : ', num2str(mean(Erreur(1,:)))];
disp(res);
res = ['Erreur moyenne prédiction convolution : ', num2str(mean(Erreur(2,:)))];
disp(res);
res = ['Erreur moyenne prédiction soustraction : ', num2str(mean(Erreur(3,:)))];
disp(res);
res = ['Erreur moyenne prédiction modes : ', num2str(mean(Erreur(4,:)))];
disp(res);
disp('*********************************************');

% Affichage de l'erreur moyenne des 100 plus grandes erreurs
Sort_Erreur = sort(Erreur(1,:),'descend');
res = ['Moyenne des 10 + grandes Erreurs predictions max: ', num2str(mean(Sort_Erreur(1:10)))];
disp(res);
Sort_Erreur = sort(Erreur(2,:),'descend');
res = ['Moyenne des 10 + grandes Erreurs prédiction convolution: ', num2str(mean(Sort_Erreur(1:10)))];
disp(res);
Sort_Erreur = sort(Erreur(3,:),'descend');
res = ['Moyenne des 10 + grandes Erreurs prédiction soustraction: ', num2str(mean(Sort_Erreur(1:10)))];
disp(res);
Sort_Erreur = sort(Erreur(4,:),'descend');
res = ['Moyenne des 10 + grandes Erreurs prédiction modes: ', num2str(mean(Sort_Erreur(1:10)))];
disp(res);
disp('*********************************************');

% Affichage du nombre d'erreurs supérieurs à 4 pixels
Find_Erreur = find(Erreur(1,:) > 3);
res = ['Nb erreur >3 predictions max: ', num2str(length(Find_Erreur))];
disp(res);
Find_Erreur = find(Erreur(2,:) > 3);
res = ['Nb erreur >3 prédictions convolution: ', num2str(length(Find_Erreur))];
disp(res);
Find_Erreur = find(Erreur(3,:) > 3);
res = ['Nb erreur >3 prédictions soustraction: ', num2str(length(Find_Erreur))];
disp(res);
Find_Erreur = find(Erreur(4,:) > 3);
res = ['Nb erreur >3 prédictions modes: ', num2str(length(Find_Erreur))];
disp(res);