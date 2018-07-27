function pts = samplingpoints(Probamap,nbPts)

    distrib = Probamap(:);
    distrib= double(distrib)/sum(sum(Probamap));

    testE = randsample(1:size(Probamap,1)*size(Probamap,2),nbPts,true,distrib);

    [Y,X] = ind2sub(size(Probamap),testE);
    pts = [X ; Y]';


end