function [Bus1,Bus2,Length,LineCode] = importlines(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as column vectors.
%   [BUS1,BUS2,LENGTH,LINECODE] = IMPORTFILE(FILENAME) Reads data from text
%   file FILENAME for the default selection.
%
%   [BUS1,BUS2,LENGTH,LINECODE] = IMPORTFILE(FILENAME, STARTROW, ENDROW)
%   Reads data from rows STARTROW through ENDROW of text file FILENAME.
%
% Example:
%   [Bus1,Bus2,Length,LineCode] = importfile('Lines.csv',3, 907);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2017/05/13 21:19:40

%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 3;
    endRow = inf;
end

%% Format for each line of text:
%   column2: double (%f)
%	column3: double (%f)
%   column5: double (%f)
%	column7: text (%s)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%*s%f%f%*s%f%*s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Allocate imported array to column variable names
Bus1 = dataArray{:, 1};
Bus2 = dataArray{:, 2};
Length = dataArray{:, 3};
LineCode = dataArray{:, 4};

