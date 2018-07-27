function z = plot_gaussian_mixture(mu,sigma,weights,Isize)
    test = 100;
    [x,y] = meshgrid(1:Isize(2),1:Isize(1));
    
    z = zeros(size(x));
    for k=1:(size(mu,1))
       % sigma(:,:,k)
        if (det(sigma(:,:,k))>0.0001)
            sigma_inv = inv(sigma(:,:,k));
            r_k = sigma_inv(1,1)*(x-mu(k,1)).^2 + sigma_inv(1,2)*(x-mu(k,1)).*(y-mu(k,2)) + sigma_inv(2,2)*(y-mu(k,2)).^2;
            z = z + weights(k)*test*exp(-0.5*r_k);            
        end
    end
    
    % Normalize
    z = (z-min(min(z)))/max(max(z));
    
end