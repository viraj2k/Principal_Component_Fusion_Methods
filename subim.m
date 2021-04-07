% Demo to divide a color image up into blocks.
function ca=subim(rgbImage,blockSizeR,blockSizeC)
% clc;    % Clear the command window.
% close all;  % Close all figures (except those of imtool.)
% Read in a standard MATLAB color demo image.
% folder = fullfile(matlabroot, '\toolbox\images\imdemos');
% baseFileName = 'peppers.png';
% % Get the full filename, with path prepended.
% fullFileName = fullfile(folder, baseFileName);
% if ~exist(fullFileName, 'file')
% 	% Didn't find it there.  Check the search path for it.
% 	fullFileName = baseFileName; % No path this time.
% 	if ~exist(fullFileName, 'file')
% 		% Still didn't find it.  Alert user.
% 		errorMessage = sprintf('Error: %s does not exist.', fullFileName);
% 		uiwait(warndlg(errorMessage));
% 		return;
% 	end
% end
% Read the image from disk.

% rgbImage = imread('F:\matlab codes\images\OCT\glaucoma\14gs\14gs3.jpg');
% Test code if you want to try it with a gray scale image.
% Uncomment line below if you want to see how it works with a gray scale image.
% rgbImage = rgb2gray(rgbImage);
% Display image full screen.
% imshow(rgbImage);
% Enlarge figure to full screen.
% set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
% drawnow;
% Get the dimensions of the image.  numberOfColorBands should be = 3.
[rows columns numberOfColorBands] = size(rgbImage)% The first way to divide an image up into blocks is by using mat2cell().
% blockSizeR = 150; % Rows in block.
% blockSizeC = 100; % Columns in block.
% Figure out the size of each block in rows. 
% Most will be blockSizeR but there may be a remainder amount of less than that.
wholeBlockRows = floor(rows / blockSizeR);
blockVectorR = [blockSizeR * ones(1, wholeBlockRows), rem(rows, blockSizeR)];
% Figure out the size of each block in columns. 
wholeBlockCols = floor(columns / blockSizeC);
blockVectorC = [blockSizeC * ones(1, wholeBlockCols), rem(columns, blockSizeC)];
% Create the cell array, ca.  
% Each cell (except for the remainder cells at the end of the image)
% in the array contains a blockSizeR by blockSizeC by 3 color array.
% This line is where the image is actually divided up into blocks.
if numberOfColorBands > 1
	% It's a color image.
	ca = mat2cell(rgbImage, blockVectorR, blockVectorC, numberOfColorBands);
else
	ca = mat2cell(rgbImage, blockVectorR, blockVectorC);
end
% Now display all the blocks.
% plotIndex = 1;
% numPlotsR = size(ca, 1);
% numPlotsC = size(ca, 2);
% for r = 1 : numPlotsR
% 	for c = 1 : numPlotsC
% % 		fprintf('plotindex = %d,   c=%d, r=%d\n', plotIndex, c, r);
% % 		% Specify the location for display of the image.
% % 		subplot(numPlotsR, numPlotsC, plotIndex);
% 		% Extract the numerical array out of the cell
% 		% just for tutorial purposes.
% 		rgbBlock = ca{r,c};
% % 		imshow(rgbBlock); % Could call imshow(ca{r,c}) if you wanted to.
% 		[rowsB columnsB numberOfColorBandsB] = size(rgbBlock);
% 		% Make the caption the block number.
% 		caption = sprintf('Block #%d of %d\n%d rows by %d columns', ...
% 			plotIndex, numPlotsR*numPlotsC, rowsB, columnsB);
% 		title(caption);
% 		drawnow;
% 		% Increment the subplot to the next location.
% 		plotIndex = plotIndex + 1;
% 	end
% end
% Display the original image in the upper left.
% subplot(4, 6, 1);
% imshow(rgbImage);
% title('Original Image');
end