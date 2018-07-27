%% Sémantique :
%  Calculer le taux d'erreur de prédiction pour une heatmap

close all;
clear;
i_im = 16032;
load heatmaps16000;

%% Initialisations
joints_tests = zeros(2,nb_joints);
joints_max = zeros(2,nb_joints);
joints_conv = zeros(2,nb_joints);
joints_soustraction = zeros(2,nb_joints);
modes = cell([1 nb_joints]);
heats = cell([1 nb_joints]);
filtre = [0 1 0 ; 1 1 1 ; 0 1 0];

%% Parcours des joints de notre images
for j = 1:nb_joints
    % Récupérer les heatmaps test et prédiction 
    k = (i_im-num_heatmap_dep)*nb_joints + j;
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
k = (i_im-num_heatmap_dep)*nb_joints;
joints_modes = BestModeOrdonne(modes, heats, predictions(:,:,k+1:k+nb_joints));

%% Dessin des squelettes
subplot 221;
axis off;
Squelette(joints_tests,'k'); % Dessin du squelette test en vert
title('Squelette à prédire');

subplot 222;
axis off;
Squelette(joints_max,'r'); % Dessin du squelette prédit par maximum de convolution en rouge
title('Squelette déterminé selon les maximums de nos heatmaps');

subplot 223;
axis off;
Squelette(joints_modes,'g');% Dessin du squelette prédit par modes en noir
title('Squelette déterminé selon les modes nos heatmaps');

subplot 224;
axis off;
Squelette(joints_conv,'b');
title('Squelette déterminé selon les maximums de convolution de nos heatmaps');

%% Calcul des angles formés par les joints prédits
angles_tests = CalculAnglesJoints(joints_tests)
angles_max = CalculAnglesJoints(joints_max)
angles_conv = CalculAnglesJoints(joints_conv)
angles_soustraction = CalculAnglesJoints(joints_soustraction)
angles_modes = CalculAnglesJoints(joints_modes)

%% Calcul des erreurs de Prédiction d'angles
erreur = zeros(4,nb_angles);
erreur(1,:) = abs(angles_tests - angles_max);
erreur(2,:) = abs(angles_tests - angles_conv);
erreur(3,:) = abs(angles_tests - angles_soustraction);
erreur(4,:) = abs(angles_tests - angles_modes);

%% Affichage des résultats
disp(erreur);
disp(['Erreur max prediction angles max : ', num2str(max(erreur(1,:)))]);
disp(['Erreur max prediction angles conv : ', num2str(max(erreur(2,:)))]);
disp(['Erreur max prediction angles soustraction : ', num2str(max(erreur(3,:)))]);
disp(['Erreur max prediction angles modes : ', num2str(max(erreur(4,:)))]);
disp('********************************************************');
disp(['Erreur moyenne prediction angles max : ', num2str(mean(erreur(1,:)))]);
disp(['Erreur moyenne prediction angles conv : ', num2str(mean(erreur(2,:)))]);
disp(['Erreur moyenne prediction angles soustraction : ', num2str(mean(erreur(3,:)))]);
disp(['Erreur moyenne prediction angles modes : ', num2str(mean(erreur(4,:)))]);
