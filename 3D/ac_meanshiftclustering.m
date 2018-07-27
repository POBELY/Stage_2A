% Implementation of the Mean Shift Clustering using an Epanechnikov Kernel
% Axel Carlier, 04-2013
% based on Comaniciu 98
%
% Inputs
%        dataPts : nbPts x dim points to cluster
%        bw : the bandwidth
%        plotFlag : 1 if you want to print visualization
% Outputs
%        clustCent : modes of the points distribution
%        data2cluster : for each point, which cluster it belongs to
function [clustCent,data2cluster] = ac_meanshiftclustering(dataPts,bw,plotFlag)

[nbPts,dim] = size(dataPts);

% To keep track of already visited points, in order to initialize each
% new iteration of mean shift by a non-visited point
visitedPoints = zeros(size(dataPts,1),1);
% current cluster number, incremented at every new cluster
cptCluster = 1;
% modes of the distribution
clustCent = [];
% used to resolve conflicts on cluster membership
clustVotes = zeros(1,nbPts); 

if (plotFlag)
    figure;
    plot(dataPts(:,1),dataPts(:,2),'r.');
    hold on;
end

nbVisited = length(find(visitedPoints>0));
% continue as long as all points were not visited
while nbVisited < size(dataPts,1)
    
    % Current votes
    myClustVotes = zeros(1,nbPts);
    
    % Start on a random non-visited point   
    f = find(visitedPoints==0);
    ind_start = floor(length(f)*rand())+1;
    x_start = dataPts(f(ind_start),:);
    
    % Mark the starting point as visited 
    visitedPoints(f(ind_start)) = cptCluster;
    myClustVotes(f(ind_start)) = 1;
    
    if (plotFlag)
        % Plot starting point in green
        plot(x_start(1),x_start(2),'g.');
    end
    
    % Compute the kernel density estimate on the starting point
    kde_start = EpanechnikovKernel((repmat(x_start,nbPts,1)-dataPts)/bw);
    for k = 1:dim
        aux_meanshift(:,k) = kde_start.*dataPts(:,k);
    end
    % Compute the mean shift
    meanshift = sum(aux_meanshift)/sum(kde_start);
    
    % Find points whose distance to starting point was inferior to bw
    f = find(kde_start);
    % Mark them as visited
    visitedPoints(f) = cptCluster;
    myClustVotes(f) = 1;
    
    while (norm(meanshift-x_start)>0.00000001)
        if (plotFlag)
            % Draw the mean shift
            line([x_start(1) meanshift(1)],[x_start(2) meanshift(2)],'Color','g');
        end
        
        % Compute the kernel density estimate on the starting point
        x_start = meanshift;
        kde_start = EpanechnikovKernel((repmat(x_start,nbPts,1)-dataPts)/bw);
        for k = 1:dim
            aux_meanshift(:,k) = kde_start.*dataPts(:,k);
        end
        % Compute the mean shift
        meanshift = sum(aux_meanshift)/sum(kde_start);
        
        % Find points whose distance to starting point was inferior to bw
        f = find(kde_start);
        % Mark them as visited
        visitedPoints(f) = cptCluster;
        myClustVotes(f) = 1;
    end
    
    if (plotFlag)
        % Draw the mode as a blue cross
        plot(meanshift(1),meanshift(2),'b+')
    end
    
    if cptCluster == 1
        clustCent = meanshift;
        cptCluster = cptCluster+1;
        clustVotes = myClustVotes;
        nbVisited = length(find(visitedPoints>0));
    else
        % Consider merging clusters
        distances = clustCent - repmat(meanshift,cptCluster-1,1);
        distances = sqrt(distances(:,1).^2+distances(:,2).^2);
        f = find(distances<bw);
        % Merge clusters if the new mode is at a near distance of an old
        % one
        if length(f)==1
            indices_current = find(visitedPoints==cptCluster);
            visitedPoints(indices_current) = f;
            % Compute density of clustCent(f,:)
            kde_mode = EpanechnikovKernel((repmat(clustCent(f,:),nbPts,1)-dataPts)/bw);
            % Compute density of meanshift
            kde_meanshift = EpanechnikovKernel((repmat(meanshift,nbPts,1)-dataPts)/bw);
            % if the density of the new mode is superior to the one of the
            % existing mode
            if kde_meanshift > kde_mode
                % then update the mode
                clustCent(f,:) = meanshift;
            end
            clustVotes(f,:) = clustVotes(f,:) + myClustVotes;
        else
            cptCluster = cptCluster+1;
            clustCent = [clustCent ; meanshift];
            clustVotes = [clustVotes ;  myClustVotes];
        end
        
        nbVisited = length(find(visitedPoints>0));
    end
    
end
if (plotFlag)
    color = 'brgkymbrgkymbrgkymbrgkymbrgkymbrgkymbrgkymbrgkymbrgkym';
    figure;
    hold on;
    for k=1:max(visitedPoints)
        f = find(visitedPoints==k);
        plot(dataPts(f,1),dataPts(f,2),[color(k) '.'])
    end
end

[val,data2cluster] = max(clustVotes,[],1);

end