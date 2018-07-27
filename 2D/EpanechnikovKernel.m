function ke_x = EpanechnikovKernel(x)

    ke_x = zeros(size(x,1),1);

    % Dimension de l'espace
    d = size(x,2);
    
    % Volume de la d-sphère unité
    if (mod(d,2)==0)
        % d est pair
        Cd = (pi^(d/2))/factorial(d/2); 
    else
        % d est impair
        Cd = 2^((d-1)/2)*2^((d+1)/2)*pi^((d-1)/2)*factorial((d-1)/2)/factorial(d); 
        % cf. http://fr.wikipedia.org/wiki/N-sph%C3%A8re
    end
    
    % Norme de x au carré
    norme_x_carre = zeros(size(x,1),1);

    for k = 1:d
        norme_x_carre = norme_x_carre + x(:,k).^2;
    end
    
    f = find(norme_x_carre<=1);

    ke_x(f) = (d+2)*(ones(length(f),1)-norme_x_carre(f))/(2*Cd);

end