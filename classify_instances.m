function probs = classify_instances(instances, model)
%
%  Input
%    instance: a 20x3x#instances matrix defining body positions of
%              instances
%    model: as given by learn_model
%
%  Output
%    probs: a matrix of #instances x #classes with the probability of each
%           instance of belonging to each of the classes
%
%  Important: to avoid underflow numerical issues this computations should
%  be performed in log space
%