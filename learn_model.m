function model = learn_model(dataset, labels, Graph)
%
%  Input:
%    dataset: The data as it is loaded from load_data
%    labels:  The labels as loaded from load_data
%    Graph:   (optional) If empty, this function should compute the naive 
%           bayes model. If it contains a skel description (pe 
%           nui_skeleton_conn, as obtained from skel_model) then it should
%           compute the model using the Linear Gausian Model
%
%  Output: the model
%    a (tentative) structure for the output model is:
%       model.connectivity: the input Graph variable should be stored here 
%                           for later use.
%       model.class_priors: containing a vector with the prior estimations
%                           for each class
%       model.jointparts(i) contains the estimated parameters for the i-th joint
%
%          For joints that only depend on the class model.jointparts(i) has:
%            model.jointparts(i).means: a matrix of 3 x #classes with the
%                   estimated means for each of the x,y,z variables of the 
%                   i-th joint and for each class.
%            model.jointparts(i).sigma: a matrix of 3 x #classes with the
%                   estimated stadar deviations for each of the x,y,z 
%                   variables of the i-th joint and for each class.
%
%          For joints that follow a gausian linear model model.jointparts(i) has:
%            model.jointparts(i).betas: a matrix of 12 x #classes with the
%                   estimated betas for each x,y,z variables (12 in total) 
%                   of the i-th joint and for each class label.
%            model.jointparts(i).sigma: as above
%
%
%NAÏVE BAYES
if nargin<3
  model = struct()
  model.connectivity = [];
  %
  indices = [min(labels):1:max(labels)];
  ocurrencias = histc(labels, indices);
  cont = 1;
  
  for i = 1:length(ocurrencias)
    if ocurrencias(i)!=0
      model.class_priors(cont,1) = ocurrencias(i)/length(labels);
      cont++;
    end
  end
  %
  n_clase = unique(labels);
  for ic = 1: length(n_clase) %CLASES
    for i = 1:size(dataset)(1) %ARTICULACIONES
      for j = 1:size(dataset)(2) %VARIABLES (X,Y,Z)
        [model.jointparts(i).means(j,ic),model.jointparts(i).sigma(j,ic)] = fit_gaussian(dataset(i,j,[labels==n_clase(ic)]));
      end
    end
  end
  %
else
  model.connectivity = Graph;
  %
  indices = [min(labels):1:max(labels)];
  ocurrencias = histc(labels, indices);
  cont =1;
  for i = 1:length(ocurrencias)
    if ocurrencias(i)!=0
      model.class_priors(cont) = ocurrencias(i)/length(labels);
      cont++;
    end
  end
  %
  n_clase = unique(labels);
  Graph = Graph +1;
  size_variables = size(dataset)(2);
  for ic = 1: length(n_clase) %CLASES
    for i = 1:size(dataset)(1) %ARTICULACIONES
      size_betas = 0;
      for j = 1:size_variables %VARIABLES (X,Y,Z)
        if i == 1
          [model.jointparts(i).betas(j,ic),model.jointparts(i).sigma(j,ic)] = fit_gaussian(dataset(i,j,[labels==n_clase(ic)]));
        else
          padre = Graph(i-1,1);
          [model.jointparts(i).sigma(j,ic),aux_beta] = fit_linear_gaussian(squeeze(dataset(i,j,[labels==n_clase(ic)])),squeeze(dataset(padre,:,[labels==n_clase(ic)]))'); 
          model.jointparts(i).betas(size_betas+1:(size_betas+1+size_variables),ic) = aux_beta;
          size_betas = size_betas + size_variables+1;
        end
      end
    end
    
  end

end






