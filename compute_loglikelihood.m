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

medias = zeros(num_variables, num_articulaciones);
sigmas = zeros(num_variables, num_articulaciones);

loglikelihood_clase = 0;

if isempty(model.connectivity) %Caso Naïve Bayes
  l = zeros(1,num_clases);
  for ic = 1: num_clases
    for i = 1: num_articulaciones
      for j = 1: num_variables
        media = model.jointparts(i).means(j,ic);
        varianza = model.jointparts(i).sigma(j,ic);
        lp = log(1/sqrt(2*pi*varianza))-(media-instance(i,j))^2/(2*varianza);
      end
      l(ic) = l(ic)+lp;
    end
    l(ic) = l(ic) + log(model.class_priors(ic));
  end
end
      