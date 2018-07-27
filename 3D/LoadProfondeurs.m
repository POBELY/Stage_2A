%% Semantique : 
%  Charge les profondeurs des joints associés à chaques heatmaps

%% Paramètres
clear;
close all;

load heatmaps;
lien = 'results/'; % chemin vers le dosier contenant nos resultats
ordre = [1 2 3 4 5 20 19 12 6 13 7 14 8 15 9 16 11 17 10 18];

%% Chargement des Heatmaps
profondeurs = zeros(nb_heatmaps,nb_joints);

% On parcours nos heatmaps
for u = num_heatmap_dep:num_heatmap_dep + nb_heatmaps - 1
    %disp(u)
    result = strcat('result',strcat(num2str(u),'.txt'));
    fid = fopen(strcat(lien,result),'r');
    fgetl(fid);
    text = textscan(fid,'%s %f %f %f');
    k = u - num_heatmap_dep + 1;
    profondeur = (text{4} - min(text{4}))/8;
    profondeurs(k,:) = profondeur(ordre);
    fclose(fid);

end
% On sauvegarde notre workspace
save('heatmaps','profondeurs','-append');