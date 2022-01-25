function [indexOfCluster_pca, centroid_pca, p, ind_centers] = cluster_traj_pca(trj, kPrinComp, kclusters, find_mean, kmax)
%cluster_traj_pca Cluster trajectories by performing kmeans on the PCA
% This function uses the mdtoolbox package from https://mdtoolbox.readthedocs.io/en/latest/
%
%   Usage:
%   [indexOfCluster_pca] = cluster_traj_pca(trj, kPrinComp)
%   [indexOfCluster_pca, centroid_pca] = cluster_traj_pca(trj, kPrinComp)
%   [indexOfCluster_pca, centroid_pca] = cluster_traj_pca(trj, kPrinComp, kclusters)
%   [indexOfCluster_pca, centroid_pca, p, ind_centers] = cluster_traj_pca(trj, kPrinComp, kclusters, find_mean)
%
% * trj: is the input trajectory: [nframes x 3natoms]
% * kPrinComp: number of principal components to be used in clustering
% * kclusters: number of clusters, if not provided, the default will be
% evaluated using "evalclusters" function, note that this will make the
% function slower
% * find_mean: if this variable equals to 1, mean structure will be determined
% * kmax: maximum k for the algorithm to consider, defaults to square root
% of the number of frames in the trajectory
% * indexOfCluster_pca: indices of the cluster: [nframes x 1]
% * centroid_pca: the centroids of the clusters, kclusters x kPrinComp
% * p (projection):  principal components (projection of the trajectory on to principal modes) [nframes x 3natoms]
% * ind_centers: the index of the frame closest to the centroid of each cluster

if exist('find_mean', 'var') && find_mean == 1
% Find the mean structure of the trajectory
[~, trj] = meanstructure(trj);
end

% Calc the PCA and do the clustering:
[p, ~, ~] = calcpca(trj);

% Find the best number of clusters if the user did not specify
if ~exist('kclusters', 'var') || isempty(kclusters)
    
  nframes = size(trj,1);
  if ~exist('kmax', 'var') % Default kmax to square root of total frames
        kmax = round(sqrt(nframes));
  end
  % Matlab's function for evaluating optimal clustering
  % Evaluate from 1:sqrt(nframes) clusters
%   E = evalclusters((trj),'kmeans','CalinskiHarabasz','klist',1:round(sqrt(nframes)));
  E = evalclusters(real(p(:,1:kPrinComp)),'kmeans','CalinskiHarabasz','klist',1:kmax);
  kclusters = E.OptimalK;
end

 [indexOfCluster_pca, centroid_pca] = kmeans(p(:,1:kPrinComp), kclusters);
 
 % Find the centers  (frames that are closest to the centroids):
 ind_centers = zeros(kclusters,1);
 
for k=1:kclusters % For every centroid
 [~,ind_centers(k)] = min(vecnorm(p(:,1:kPrinComp)-centroid_pca(k,:),2,2));  
end

pcaRange = range(p,'all');

% Plot the data
  figure
  scatter(p(:, 1), p(:, 2), 50, indexOfCluster_pca, 'filled');
  xlabel('PC 1', 'fontsize', 25);
  ylabel('PC 2', 'fontsize', 25);
  title(['Clustering with ' num2str(kPrinComp) ' PCs'])
  
  hold on
  % Plot centroids:
  scatter(centroid_pca(:,1),centroid_pca(:,2),60,'MarkerEdgeColor',[0 .5 .5],...
              'MarkerFaceColor',[0 .7 .7],...
              'LineWidth',1.5)
  legend('Data','Centroids')
  legend boxoff
  
  for i = 1:size(centroid_pca,1)
     % Add text label for runs with proper offset
    text(centroid_pca(i,1)+pcaRange/50,centroid_pca(i,2)+pcaRange/50,['C' num2str(i)],'FontSize',14) 
  end
end

