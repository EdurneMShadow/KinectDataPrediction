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

if nargin<3

model = struct()
model.connectivity = Graph;