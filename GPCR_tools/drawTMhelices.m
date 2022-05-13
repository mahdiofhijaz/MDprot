function [h] = drawTMhelices(data, helices, protRes)
%drawTMhelices Draws cute little helices at the bottom of your figure/plot 
%   You need to have a figure already plotted before calling this function!
% 
% Usage:
% drawTMhelices(data, helices, protRes)
%
%  * data: your data in the figure, this variable will be used for finding
%  the position for drawing the helices
%
% * helices: the residue numbers of the helices, the form is a double
% column vector, for ex.:
%  helices = [1 26; 37 66; 74 106; 118 145; 156 190; 198 231; 240 263];
%
% * protRes: vector of all the protein residues, foe ex.:
% protRes = 1:278;

%% Draw helices helices

nHelices = size(helices,1); % How many helices do we have?
% Find starting point and size of rectangles:
height = range(data)/20; 
startY = min(data) - 2*height;
startYLine = min(data) - 1.5*height;

ntermLineWidth = max(helices(1,1) - protRes(1),1);
pos_line = [helices(1,1)-1 startYLine ntermLineWidth 0.001];

% Line for Nterm:
rectangle('Position',pos_line,'FaceColor',[ 0 0 0 ],'EdgeColor','k','LineWidth',1)

  for tmh = 1:nHelices % loop over helices
  % x-y w-h
      pos = [helices(tmh,1) startY (helices(tmh,2)-helices(tmh,1)) height];

      % Rectangles for the helices
%       rectangle('Position',pos,'Curvature',[1,0.5],'FaceColor',[0.75 .75 .75],'EdgeColor','k',...
%     'LineWidth',1)
        rectangle('Position',pos,'FaceColor',[1 1 1],'EdgeColor','k',...
    'LineWidth',1)
    % lines for the loops
    if tmh~=nHelices
        pos_line = [helices(tmh,2) startYLine (helices(tmh+1,1)-helices(tmh,2)) 0.001];
    else
        pos_line = [helices(tmh,2) startYLine (protRes(end)-helices(tmh,2)) 0.001];
    end
    rectangle('Position',pos_line,'FaceColor',[ 0 0 0 ],'EdgeColor','k','LineWidth',1)
  end
  
  
  %% add the text!
%   pos_text = helices(tmh,1)+(helices(tmh,2)-helices(tmh,1))/2;
%   
%   text(pos_text, 0.2,'helices7','Color','white','FontSize',14)
%   
%   h=1;
end

