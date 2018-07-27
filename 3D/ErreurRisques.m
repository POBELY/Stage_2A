%% Sémantique :
%  Calculer le pourcentage d'erreur de prédiction de risques pour une heatmap

close all;
clear;
i_im = 4; % numéro heatmap considéré
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
        if (j == 9)
            modes{j} = [20,46];
            heats{j} = 1;
        elseif (j == 19)
            modes{j} = modes{17};
            heats{j} = heats{17};
        elseif (j == 20)
            modes{j} = modes{5};
            heats{j} = heats{5};
        else
            [modes{j}, heats{j}] = GetModes(prediction);
        end

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

%% Calcul des angles formés par les joints prédits
k = i_im-num_heatmap_dep + 1;
angles_tests = CalculAnglesJoints(joints_tests,profondeurs(k,:))
angles_max = CalculAnglesJoints(joints_max,profondeurs(k,:));
angles_conv = CalculAnglesJoints(joints_conv,profondeurs(k,:));
angles_soustraction = CalculAnglesJoints(joints_soustraction,profondeurs(k,:));
angles_modes = CalculAnglesJoints(joints_modes,profondeurs(k,:))

%% Calcul des risques liés aux angles calculés
risques_tests = CalculAnglesRisques(angles_tests)
risques_max = CalculAnglesRisques(angles_max);
risques_conv = CalculAnglesRisques(angles_conv);
risques_soustraction = CalculAnglesRisques(angles_soustraction);
risques_modes = CalculAnglesRisques(angles_modes)

%% Calcul des erreurs de Prédiction
erreur = zeros(1,4);
erreur(1) = sum(risques_tests ~= risques_max);
erreur(2) = sum(risques_tests ~= risques_conv);
erreur(3) = sum(risques_tests ~= risques_soustraction);
erreur(4) = sum(risques_tests ~= risques_modes);

disp(['Nb Erreur risque max : ', num2str(erreur(1))]);
disp(['Nb Erreur risque conv : ', num2str(erreur(2))]);
disp(['Nb Erreur risque soustraction : ', num2str(erreur(3))]);
disp(['Nb Erreur mode ord : ', num2str(erreur(4))]);
