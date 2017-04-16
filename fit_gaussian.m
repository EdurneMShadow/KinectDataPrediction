function [mu sigma] = fit_gaussian(X)
%
%
mu = mean(X);
sigma = var(X);

%if nargin < 2
%    W = ones(size(X));
%end
%
%mu = sum(X.*W)/sum(W);
%sigma = sum(W.*((X-mu).^2)) / sum(W);