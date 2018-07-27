%% Sémantique :
%  Calculer des taux d'erreurs sur les heatmaps appartenant à l'échantillion de test, 
%  pour tous les joints.
clear;
load heatmaps15000;

%% Variables
filtre = [0 1 0 ; 1 1 1 ; 0 1 0];
Erreur = zeros(4,nb_heatmaps*nb_joints); % Matrice des erreurs initialisée
BonnePred = zeros(4,nb_heatmaps);

%% Calcul des erreurs de prédictions
 % Parcours de toutes les heatmaps
 for i = num_heatmap_dep:num_heatmap_dep + nb_heatmaps - 1
     i % affichage de la heatmap observé
    
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

    %% Calcul des erreurs de Prédiction
    erreur = zeros(4,nb_joints);
    erreur(1,:) = sqrt((joints_tests(1,:) - joints_max(1,:)).^2 + (joints_tests(2,:) - joints_max(2,:)).^2);
    erreur(2,:) = sqrt((joints_tests(1,:) - joints_conv(1,:)).^2 + (joints_tests(2,:) - joints_conv(2,:)).^2);
    erreur(3,:) = sqrt((joints_tests(1,:) - joints_soustraction(1,:)).^2 + (joints_tests(2,:) - joints_soustraction(2,:)).^2);
    erreur(4,:) = sqrt((joints_tests(1,:) - joints_modes(1,:)).^2 + (joints_tests(2,:) - joints_modes(2,:)).^2);

    BonnePred(:,i - num_heatmap_dep + 1) = (max(erreur(:,1:15)') <= 3)';
    Erreur(:,k+1:k+nb_joints) = erreur;
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
res = ['Moyenne des 100 + grandes Erreurs predictions max: ', num2str(mean(Sort_Erreur(1:100)))];
disp(res);
Sort_Erreur = sort(Erreur(2,:),'descend');
res = ['Moyenne des 100 + grandes Erreurs prédiction convolution: ', num2str(mean(Sort_Erreur(1:100)))];
disp(res);
Sort_Erreur = sort(Erreur(3,:),'descend');
res = ['Moyenne des 100 + grandes Erreurs prédiction soustraction: ', num2str(mean(Sort_Erreur(1:100)))];
disp(res);
Sort_Erreur = sort(Erreur(4,:),'descend');
res = ['Moyenne des 100 + grandes Erreurs prédiction modes: ', num2str(mean(Sort_Erreur(1:100)))];
disp(res);
disp('*********************************************');

% Affichage du nombre d'erreurs supérieurs à 4 pixels
Find_Erreur = find(Erreur(1,:) > 4);
res = ['Nb erreur >4 predictions max: ', num2str(length(Find_Erreur))];
disp(res);
Find_Erreur = find(Erreur(2,:) > 4);
res = ['Nb erreur >4 prédictions convolution: ', num2str(length(Find_Erreur))];
disp(res);
Find_Erreur = find(Erreur(3,:) > 4);
res = ['Nb erreur >4 prédictions soustraction: ', num2str(length(Find_Erreur))];
disp(res);
Find_Erreur = find(Erreur(4,:) > 4);
res = ['Nb erreur >4 prédictions modes: ', num2str(length(Find_Erreur))];
disp(res);
disp('*********************************************');

% Affichage de l'erreur moyenne
res = ['Pourcentage de squelette prédits max à 3 pixels près : ', num2str(mean(BonnePred(1,:))*100),'%'];
disp(res);
res = ['Pourcentage de squelette prédits conv à 3 pixels près : ', num2str(mean(BonnePred(2,:))*100),'%'];
disp(res);
res = ['Pourcentage de squelette prédits soustraction à 3 pixels près : ', num2str(mean(BonnePred(3,:))*100),'%'];
disp(res);
res = ['Pourcentage de squelette prédits modes à 3 pixels près : ', num2str(mean(BonnePred(4,:))*100),'%'];
disp(res);

%% Afficher les erreurs sans les doigts
% ind_sans_doigts = [];
% for i = 1:nb_heatmaps
%     ind_deb = (i-1)*nb_joints+1;
%     ind_sans_doigts = [ind_sans_doigts, ind_deb:(ind_deb + 10) (ind_deb + 15):i*nb_joints];
% end
% Erreur = Erreur(:,ind_sans_doigts);
