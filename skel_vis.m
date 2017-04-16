function h = skel_vis(X, label, show_var_labels, h)
%SKEL_VIS -- Visualize a skeleton in 3D coordinates.
%
% Input
%   X: (T,4*NUI_SKELETON_POSITION_COUNT) matrix from load_file.
%   (parameter removed by GMM) tidx: time index >=1, <=T.
%   label: (optional) to show a title for the plot
%   show_var_labels: (optional) to show the x1...xn
%   h: (optional) axes handle to draw in.
%
% Output 
%   The handle for the figure
%
% Author: Sebastian Nowozin <Sebastian.Nowozin@microsoft.com>
%
% Adapted by Gonzalo Martinez for this prog assignment
%
if nargin < 2
    label = '';
end
if nargin < 3
	show_var_labels=false;
end
if nargin < 4
    figure;
	h=axes;
end

if size(X,1)==80
    xyz_ti=X;
elseif size(X,1)==20 && size(X,2)==3
    idx=1:80;
    idx(mod(idx,4)==0) = [];
    xyz_ti(idx)=reshape(X',1,60);
    xyz_ti(80)=0;
end

skel_model
skel=reshape(xyz_ti, 4, NUI_SKELETON_POSITION_COUNT)';
plot3(skel(:,1), skel(:,2), skel(:,3), 'ro');
axis equal;

for ci=1:size(nui_skeleton_conn,1)
	hold on;
	line([xyz_ti(4*nui_skeleton_conn(ci,1)+1) ; ...
		xyz_ti(4*nui_skeleton_conn(ci,2)+1)], ...
		[xyz_ti(4*nui_skeleton_conn(ci,1)+2) ; ...
		xyz_ti(4*nui_skeleton_conn(ci,2)+2)], ...
		[xyz_ti(4*nui_skeleton_conn(ci,1)+3) ; ...
		xyz_ti(4*nui_skeleton_conn(ci,2)+3)],'LineWidth',4);
end

if show_var_labels==true
    desx=ones(20,1)*0.15;
    desx([5:8 13:16])=-0.05;
    for ci=0:size(nui_skeleton_conn,1)
        text(xyz_ti(4*ci+1)+1*desx(ci+1), ...
            xyz_ti(4*ci+2)+0*desx(ci+1), ...
            xyz_ti(4*ci+3), ...
            ['x_{' num2str(ci) '}'],'FontSize',18);
    end
end

plot3(skel(:,1), skel(:,2), skel(:,3), 'ro','LineWidth',2,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0 0 0],...
                'MarkerSize',8);
            
cpos=skel(HIP_CENTER+1,1:3) + [3, 2, -5];

set(h,'CameraPosition',cpos);
set(h,'CameraTarget',skel(HIP_CENTER+1,1:3));
set(h,'CameraViewAngle',18);
set(h,'CameraUpVector',[0 1 0]);
set(h,'Projection','perspective');

xmin=min(min(X(:,1:4:size(X,2))));
ymin=min(min(X(:,2:4:size(X,2))));
zmin=min(min(X(:,3:4:size(X,2))));
xmax=max(max(X(:,1:4:size(X,2))));
ymax=max(max(X(:,2:4:size(X,2))));
zmax=max(max(X(:,3:4:size(X,2))));

set(h,'XLim', [xmin, xmax]);
set(h,'YLim', [ymin, ymax]);
set(h,'ZLim', [zmin, zmax]);

tpos=[0.5*(xmin+xmax), 0.5*(ymin+ymax), 0.5*(zmin+zmax)];
cpos=tpos + 1.5*[3, 2, -5];
set(h,'CameraPosition',cpos);
set(h,'CameraTarget',tpos);

title(label);

xlim([-1 1])
zlim([1 4])
ylim([-1 1])
