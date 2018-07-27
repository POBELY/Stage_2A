%% Semantique : 
%  Charge heatmaps  spécifier et sauve ces données

%% Paramètres
clear;
close all;

% nom des joints composant notre squelette
joints = {"_spine_base","_spine_middle","_spine_shoulder", ... % colonne vertébrale
          "_neck", ...                                         % cou
          "_head", ...                                         % tete
          "_hip_right","_hip_left", ...                        % hanche
          "_shoulder_right","_shoulder_left", ...              % épaules
          "_elbow_right","_elbow_left", ...                    % coudes
          "_wrist_right","_wrist_left", ...                    % poignets
          "_hand_right","_hand_left" , ...                     % mains
           "_hand_tip_right","_hand_tip_left", ...             % doigts
           "_thumb_right","_thumb_left", ...                   % pouces
           "_head_direction"                                   % tete
          };

lien = '../heatmaps/'; % chemin vers le dosier contenant nos heatmaps
nlig = 60; % nombre de lignes d'une heatmap
ncol = 80; % nombre de colonnes d'une heatmap
num_heatmap_dep = 10000; % numéro de la première heatmap considéré
nb_heatmaps = 100; % nombre de numéro d'heatmaps considérés
nb_angles = 7; % nombre d'angles entre les jointures considérés
nb_methodes = 4;
nb_joints = length(joints); % nombre de joints

%% Chargement des Heatmaps
predictions = zeros(nlig,ncol,nb_heatmaps*nb_joints);
tests = zeros(nlig,ncol,nb_heatmaps*nb_joints);

% On parcours nos heatmaps
for u = num_heatmap_dep:num_heatmap_dep + nb_heatmaps - 1
    u
    % On parcours nos joints
    for v = 1:nb_joints
        % On crée les noms de nos heatmaps tests et prédictions
        test = strcat('test',strcat(num2str(u),joints{v}));
        prediction = strcat('prediction',strcat(num2str(u),joints{v}));
        % On charge nos heatmaps par leur chemin
        lien_test = strcat(lien , strcat(test, '.mat'));
        load(lien_test);
        lien_prediction = strcat(lien , strcat(prediction, '.mat'));
        load(lien_prediction);
        
        k = (u-num_heatmap_dep)*nb_joints + v; % indice de l'image associé au joint recherché dans la matrice globale
        test = evalin('base',test);
        tests(:,:,k) = test;
        prediction = evalin('base',prediction);
        predictions(:,:,k) = prediction;
    end
end
% On sauvegarde notre workspace
save('heatmaps10000','tests','predictions','joints','lien','nlig','ncol','num_heatmap_dep','nb_heatmaps','nb_angles','nb_joints');
