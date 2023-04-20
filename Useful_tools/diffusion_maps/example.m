% Testing and playing with diffusion maps with a few toy systems


%% Swiss rollolololololol:
N = 1000;
a = 1;   % swiss roll goes from a*pi to b*pi
b = 4;   
y = rand(2,N);
% uniform distribution along the manifold (in data space)
tt = sqrt((b*b-a*a)*y(1,:)+a*a);
tt = pi*tt;
% now tt should go from a*pi to b*pi
height = y(2,:);
x = [tt.*cos(tt)/b^2; height; tt.*sin(tt)/b^2];
figure; 
tiledlayout('flow')
nexttile
scatter3(x(1,:),x(2,:),x(3,:),10,x(3,:),'filled')
title('A fancy swiss roll')

% Generate affinity matrix:
A = cell(2,1);
A{1} = calcAffinityMat(x','kNN',5, 'selfTuning',0);
A{2} = calcAffinityMat(x','kNN',5, 'selfTuning',6);
labels = ["No self tuning" "Self tuning"];
alpha = 0.5;
t = 1;

for i = 1:length(A)
    [diffMapt, Lambda, D2]= calcDiffusionMap( A{i},'alpha',alpha, 't',t,'dim',3);
    nexttile
    s = scatter3(diffMapt(1,:),diffMapt(2,:),diffMapt(3,:),10,1: length(A{i}),'filled');
    dtRows = dataTipTextRow("Datapt idx",1: length(A{i}));
    s.DataTipTemplate.DataTipRows(end+1) = dtRows;
    title(labels(i));
    colormap turbo
    axis equal
end
sgtitle(['DIffusion maps, \alpha = ' num2str(alpha)]);

