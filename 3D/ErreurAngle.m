%% Sémantique :
%  Calculer des taux d'erreurs angulaire pour un angle donné sur les
%  heatmaps appartenant à l'échantillion de test.
clear;
load heatmaps;

angle = 7; % angle considéré

%% Variables
filtre = [0 1 0 ; 1 1 1 ; 0 1 0];
Erreur = zeros(4,nb_heatmaps); % Matrice des erreurs initialisée

%% Calcul des erreurs de prédictions
 % Parcours de toutes les heatmaps
 for i = num_heatmap_dep:num_heatmap_dep + nb_heatmaps - 1
    disp(i) % affichage de la heatmap observé
    joints_tests = zeros(2,nb_joints);
    %% Initialisation
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
    k = i-num_heatmap_dep + 1;
    angles_tests = CalculAnglesJoints(joints_tests,profondeurs(k,:));
    angles_max = CalculAnglesJoints(joints_max,profondeurs(k,:));
    angles_conv = CalculAnglesJoints(joints_conv,profondeurs(k,:));
    angles_soustraction = CalculAnglesJoints(joints_soustraction,profondeurs(k,:));
    angles_modes = CalculAnglesJoints(joints_modes,profondeurs(k,:));
    
    
    %% Calcul des erreurs angulaires   
    Erreur(:,i - num_heatmap_dep + 1) = [abs(angles_tests(angle) - angles_max(angle)) ; ...
         abs(angles_tests(angle) - angles_conv(angle)) ; ...
         abs(angles_tests(angle) - angles_soustraction(angle)) ; ...
         abs(angles_tests(angle) - angles_modes(angle)) ];
end
 
  %% Suppression des erreurs liés à des angles imprédictibles
 ind_NaN_max = find(~isnan(Erreur(1,:)));
 erreur_max = Erreur(1,ind_NaN_max);
 
 ind_NaN_conv = find(~isnan(Erreur(2,:)));
 erreur_conv = Erreur(2,ind_NaN_conv);
 
 ind_NaN_soustraction = find(~isnan(Erreur(3,:)));
 erreur_soustraction = Erreur(3,ind_NaN_soustraction);
 
 ind_NaN_modes = find(~isnan(Erreur(4,:)));
 erreur_modes = Erreur(4,ind_NaN_modes);
 
 nb_NaN = 4*nb_heatmaps - length(ind_NaN_max) - length(ind_NaN_conv) - length(ind_NaN_soustraction) - length(ind_NaN_modes);
 nb_NaN = [length(find(isnan(angles_tests))), nb_heatmaps - length(ind_NaN_max), nb_heatmaps - length(ind_NaN_conv), nb_heatmaps - length(ind_NaN_soustraction), nb_heatmaps - length(ind_NaN_modes)];
  
%% Affichage des résultats

% Affichage de l'erreur maximum
%disp(['nombre de NaN : ',num2str(nb_NaN)]);
disp(nb_NaN);
disp('*********************************************');
res = ['Erreur angle max prédiction max : ', num2str(max(erreur_max))];
disp(res);
res = ['Erreur angle max prédiction conv : ', num2str(max(erreur_conv))];
disp(res);
res = ['Erreur angle max prédiction soustraction : ', num2str(max(erreur_soustraction))];
disp(res);
res = ['Erreur angle max prédiction modes : ', num2str(max(erreur_modes))];
disp(res);
disp('*********************************************');

% Affichage de l'erreur moyenne
res = ['Erreur angle moyenne prédiction max : ', num2str(mean(erreur_max))];
disp(res);
res = ['Erreur angle moyenne prédiction conv : ', num2str(mean(erreur_conv))];
disp(res);
res = ['Erreur angle moyenne prédiction soustraction : ', num2str(mean(erreur_soustraction))];
disp(res);
res = ['Erreur angle moyenne prédiction modes : ', num2str(mean(erreur_modes))];
disp(res);
disp('*********************************************');

% Affichage de l'erreur moyenne des 10 plus grandes erreurs
Sort_Erreur = sort(erreur_max,'descend');
res = ['Moyenne des 10 + grandes Erreurs predictions max : ', num2str(mean(Sort_Erreur(1:10)))];
disp(res);
Sort_Erreur = sort(erreur_conv,'descend');
res = ['Moyenne des 10 + grandes Erreurs predictions conv : ', num2str(mean(Sort_Erreur(1:10)))];
disp(res);
Sort_Erreur = sort(erreur_soustraction,'descend');
res = ['Moyenne des 10 + grandes Erreurs predictions soustraction : ', num2str(mean(Sort_Erreur(1:10)))];
disp(res);
Sort_Erreur = sort(erreur_modes,'descend');
res = ['Moyenne des 10 + grandes Erreurs predictions modes : ', num2str(mean(Sort_Erreur(1:10)))];
disp(res);
disp('*********************************************');

% Affichage du nombre d'erreurs supérieurs à 25°
Find_Erreur = find(erreur_max > 25);
res = ['Nb erreur >25° predictions max : ', num2str(length(Find_Erreur))];
disp(res);
Find_Erreur = find(erreur_conv > 25);
res = ['Nb erreur >25° predictions conv : ', num2str(length(Find_Erreur))];
disp(res);
Find_Erreur = find(erreur_soustraction > 25);
res = ['Nb erreur >25° predictions soustraction : ', num2str(length(Find_Erreur))];
disp(res);
Find_Erreur = find(erreur_modes > 25);
res = ['Nb erreur >25° predictions modes : ', num2str(length(Find_Erreur))];
disp(res);


