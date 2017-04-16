function [betas] = fit_linear_gaussian(Y,X)
%
%  Input:
%     Y: vector Dx1 with the observations for the variable
%     X: matrix DxV with the observations for the parent variables
%               of X. V is the number of parent variables
%
A = zeros(size(X)(2)+1,size(X)(2)+1);
for i = 1:size(X)(2)+1
  for j = 1: size(X)(2)+1
      if i-1<1
        if j-1<1
          A(i,j) = 1;
        else
            A(i,j) = mean(X(:,(j-1)));
        end
      elseif j-1<1
            A(i,j) = mean(X(:,(i-1)));
      else
          A(i,j) = mean(X(:,(i-1)).*X(:,(j-1)));
      end
   end
end
betas = zeros(size(X)(2)+1,1);
b = zeros(size(X)(2)+1,1);
for i = 1:size(X)(2)+1
  if i-1<1
    b(i) = mean(Y);
  else
    b(i) = mean(Y.*X(:,(i-1)));
  end
end
betas = A\b;
   