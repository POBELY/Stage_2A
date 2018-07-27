%% Sémantique :
%  Calculer des taux d'erreurs sur les heatmaps appartenant à l'échantillion de test,
%  pour tous les joints.
clear;
load heatmaps17000;

%% Variables
filtre = [0 1 0 ; 1 1 1 ; 0 1 0];
Erreur = zeros(4,nb_heatmaps*nb_angles); % Matrice des erreurs initialisée
ind_NaN = zeros(1,nb_heatmaps*nb_angles);
BonnePred = zeros(4,nb_heatmaps);

%% Calcul des erreurs de prédictions
 % Parcours de toutes les heatmaps
 for i = num_heatmap_dep:num_heatmap_dep + nb_heatmaps - 1
    disp(i) % affichage de la heatmap observé
    joints_tests = zeros(2,nb_joints);
    joints_max = zeros(2,nb_joints);
    joints_conv = zeros(2,nb_joints);
    joints_soustraction = zeros(2,nb_joints);
    modes = cell([1 nb_joints]);
    heats = cell([1 nb_joints]);
    
    %% Parcours des joints de notre images
    for j = 1:nb_joints
        % Récupérer les heatmaps test et prédiction 
        k = (i-num_heatmap_dep)*nb_joints + j;
        test = tests(:,:,k);
        prediction = predictions(:,:,k);

        % Calcul position joint Test
        [~,ind] = max(test(:));
        [xt,yt] = ind2sub(size(test),ind);
        joints_tests(:,j) = [xt ; yt];

        % Calcul position joint Prédit selon max heatmap
        [~,ind] = max(prediction(:));
        [xp,yp] = ind2sub(size(prediction),ind);
        joints_max(:,j) = [xp ; yp];

        % Calcul position joint Prédit selon max heatmap
        [~,ind] = max(prediction(:));
        [xp,yp] = ind2sub(size(prediction),ind);
        joints_max(:,j) = [xp ; yp];

        % Calcul position joint Prédit selon max de convolution
        [xc,yc] = MaxConvolution(prediction,filtre);
        joints_conv(:,j) = [xc,yc];

        % Calcul position joint Prédit selon soustraction
        [xs,ys] = MaxSoustraction(predictions,joints{j},filtre,k);
        joints_soustraction(:,j) = [xs,ys];

        % Récupérer les modes, correspondant au centres des zones de
        % probabilité de positionnement du joint
        [modes{j}, heats{j}] = GetModes(prediction);
    end

    %% Calcule des modes les plus probables par joint
    k = (i-num_heatmap_dep)*nb_joints;
    joints_modes = BestModeOrdonne(modes, heats, predictions(:,:,k+1:k+nb_joints));
    
    
    %% Calcul des angles prédits entre nos joints
    angles_tests = CalculAnglesJoints(joints_tests);
    angles_max = CalculAnglesJoints(joints_max);
    angles_conv = CalculAnglesJoints(joints_conv);
    angles_soustraction = CalculAnglesJoints(joints_soustraction);
    angles_modes = CalculAnglesJoints(joints_modes);
    
    %% Calcul des risques liés aux angles calculés
    risques_tests = CalculAnglesRisques(angles_tests);
    risques_max = CalculAnglesRisques(angles_max);
    risques_conv = CalculAnglesRisques(angles_conv);
    risques_soustraction = CalculAnglesRisques(angles_soustraction);
    risques_modes = CalculAnglesRisques(angles_modes);
    
    %% Calcul des erreurs angulaires
    erreur = zeros(4,nb_angles);
    
    erreur(1,:) = risques_tests ~= risques_max;
    erreur(2,:) = risques_tests ~= risques_conv;
    erreur(3,:) = risques_tests ~= risques_soustraction;
    erreur(4,:) = risques_tests ~= risques_modes;
    
    k = (i-num_heatmap_dep)*nb_angles;
    ind_NaN(k+1:k+nb_angles) = isnan(risques_tests); 
    Erreur(:,k+1:k+nb_angles) = erreur;
    BonnePred(:,i - num_heatmap_dep + 1) = (max(erreur(:,1:5)') == 0)';
end
 
%% Suppression des erreurs liés à des angles imprédictibles
ind = find(ind_NaN == 0);
Erreur = Erreur(:,ind);
length_err = size(Erreur,2);

  
%% Affichage des résultats

% Affichage de l'erreur maximum
disp(['nombre de NaN tests : ',num2str(sum(ind_NaN))]);
disp('*********************************************');
res = ['Pourcentage Erreurs risques prédiction max : ', num2str(sum(Erreur(1,:))/length_err*100),' %'];
disp(res);
res = ['Pourcentage Erreurs risques prédiction conv : ', num2str(sum(Erreur(2,:))/length_err*100),' %'];
disp(res);
res = ['Pourcentage Erreurs risques prédiction soustraction : ', num2str(sum(Erreur(3,:))/length_err*100),' %'];
disp(res);
res = ['Pourcentage Erreurs risques prédiction modes : ', num2str(sum(Erreur(4,:))/length_err*100),' %'];
disp(res);
disp('*********************************************');

% Affichage de l'erreur moyenne
res = ['Pourcentage de squelette dont tous les risques sont prédits : ', num2str(mean(BonnePred(1,:))*100),'%'];
disp(res);
res = ['Pourcentage de squelette dont tous les risques sont prédits : ', num2str(mean(BonnePred(2,:))*100),'%'];
disp(res);
res = ['Pourcentage de squelette dont tous les risques sont prédits : ', num2str(mean(BonnePred(3,:))*100),'%'];
disp(res);
res = ['Pourcentage de squelette dont tous les risques sont prédits : ', num2str(mean(BonnePred(4,:))*100),'%'];
disp(res);
