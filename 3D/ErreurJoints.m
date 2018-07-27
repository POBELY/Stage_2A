%% Sémantique :
%  Calculer le taux d'erreur de prédiction de positionnement des joints du squelette pour une heatmap

close all;
clear;
i_im = 10; % numéro heatmap considéré
load heatmaps19;

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
    % PB heatmaps Base
    [modes{j}, heats{j}] = GetModes(prediction);
end

%% Calcule des modes les plus probables par joint
k = (i_im-num_heatmap_dep)*nb_joints;
joints_modes = BestModeOrdonne(modes, heats, predictions(:,:,k+1:k+nb_joints));

%% Dessin des squelettes
subplot 221;
axis off;
axis tight;
axis equal;
Squelette(joints_tests,profondeurs(i_im + 1,:),'k'); % Dessin du squelette test en vert
title('Squelette à prédire');

subplot 222;
axis off;
axis tight;
axis equal;
Squelette(joints_max,profondeurs(i_im + 1,:),'r'); % Dessin du squelette prédit par maximum de convolution en rouge
title('Squelette déterminé selon les maximums de nos heatmaps');

subplot 223;
axis off;
axis tight;
axis equal;
Squelette(joints_modes,profondeurs(i_im + 1,:),'g');% Dessin du squelette prédit par modes en noir
title('Squelette déterminé selon les modes nos heatmaps');

subplot 224;
axis off;
axis tight;
axis equal;
Squelette(joints_conv,profondeurs(i_im + 1,:),'b');
title('Squelette déterminé selon les maximums de convolution de nos heatmaps');

%% Calcul des erreurs de Prédiction de positions de joints
erreur = zeros(4,nb_joints);
erreur(1,:) = sqrt((joints_tests(1,:) - joints_max(1,:)).^2 + (joints_tests(2,:) - joints_max(2,:)).^2);
erreur(2,:) = sqrt((joints_tests(1,:) - joints_conv(1,:)).^2 + (joints_tests(2,:) - joints_conv(2,:)).^2);
erreur(3,:) = sqrt((joints_tests(1,:) - joints_soustraction(1,:)).^2 + (joints_tests(2,:) - joints_soustraction(2,:)).^2);
erreur(4,:) = sqrt((joints_tests(1,:) - joints_modes(1,:)).^2 + (joints_tests(2,:) - joints_modes(2,:)).^2);

%% Affichage des résultats
disp(erreur);
disp('********************************************************');
disp(['Erreur moyenne prediction joints max : ', num2str(mean(erreur(1,:)))]);
disp(['Erreur moyenne prediction joints conv : ', num2str(mean(erreur(2,:)))]);
disp(['Erreur moyenne prediction joints soustraction : ', num2str(mean(erreur(3,:)))]);
disp(['Erreur moyenne prediction joints modes : ', num2str(mean(erreur(4,:)))]);
disp('********************************************************');
disp(['Erreur max prediction joints max : ', num2str(max(erreur(1,:)))]);
disp(['Erreur max prediction joints conv : ', num2str(max(erreur(2,:)))]);
disp(['Erreur max prediction joints soustraction : ', num2str(max(erreur(3,:)))]);
disp(['Erreur max prediction joints modes : ', num2str(max(erreur(4,:)))]);
