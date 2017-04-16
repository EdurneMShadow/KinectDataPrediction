function [model final_probs] = em_pose_clustering(dataset, graph, initial_probs)
%
%  Input:
%    dataset: The data as it is loaded from load_data
%    initial_probs: a matrix os size #instaces x #clusters with the
%          initial probabilities of each instance belonging to each cluster
%    graph:   (optional) If empty, this function should compute the naive 
%           bayes model. If it contains a skel description (pe 
%           nui_skeleton_conn, as obtained from skel_model) then it should
%           compute the model using the Linear Gausian Model
%
%  Output: 
%    model: as defined in learn_model.m
%    initial_probs: a matrix os size #instaces x #clusters with the
%          initial probabilities of each instance belonging to each cluster
%
%

