function l = compute_loglikelihood(instance, model)
%
%  Input
%    instance: a 20x3 matrix defining body positions of one instance
%    model: as given by learn_model
%
%  Output
%    l: a vector of size #classes containing the loglikelihhod of the 
%       instance
%
%

num_clases = length(model.class_priors);
num_variables = size(instance)(2);
num_articulaciones = size(instance)(1);

l = zeros(1,num_clases);

for ic = 1: num_clases
  for i = 1: num_articulaciones
    for j = 1: num_variables
      media = 0;
      if (isempty(model.connectivity)) %Caso Naïve Bayes
        media = model.jointparts(i).means(j,ic);
      elseif i == 1 %Linear Gaussian sin padre
        media = model.jointparts(i).betas(j,ic);
      else %Linear Gaussian con padre
        padre = model.connectivity(i-1,1) + 1;
        for k = 1:(num_variables + 1) %Cálculo de la media
          sumar = model.jointparts(i).betas((j-1)*(num_variables+1)+k,ic);
          if k!=1
            sumar = sumar*instance(padre,(k-1));
          end
          media = media + sumar;          
        end
      end
      varianza = model.jointparts(i).sigma(j,ic);
      lp = -log(sqrt(2*pi*varianza))-(media-instance(i,j))^2/(2*varianza);
      l(ic) = l(ic)+lp;
    end  
  end
  l(ic) = l(ic) + log(model.class_priors(ic));
end
      