function [file_name] = print2pdf(file_name)
%printpdf Prints your chosen figure to pdf file
%  * file_name is the name of the file

%% print to pdf

set(gcf,'Units','inches');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
% print(file_name,'-dpdf') 
 print(file_name, '-dpdf', '-opengl', '-r0');
end

