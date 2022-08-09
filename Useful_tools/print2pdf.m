function [file_name] = print2pdf(file_name,isOpengl)
%printpdf Prints your chosen figure to pdf file
%
% Usage:
% [file_name] = print2pdf(file_name)
% [file_name] = print2pdf(file_name,isOpengl)
%
% * file_name is the name of the file
% * isOpengl uses opengl renderer, this is not recommended unless you have
% problems rendering otherwise, as it turns the pdf into an image.

%% print to pdf

if nargin < 2 % use normal rendering unless otherwise specified
    isOpengl = 0;
end

set(gcf,'Units','inches');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);

% set(gcf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[screenposition(3), screenposition(4)])

if isOpengl == 1
    print(file_name, '-dpdf', '-opengl', '-r0');

else
    print(file_name,'-dpdf', '-vector')
end

end

