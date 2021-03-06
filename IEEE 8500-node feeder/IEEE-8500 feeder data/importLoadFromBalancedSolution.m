function [Element,Terminal,PkW,Qkvar] = importLoadFromBalancedSolution(workbookFile,sheetName,startRow,endRow)
%IMPORTFILE Import data from a spreadsheet
%   [Element,Terminal,PkW,Qkvar] = IMPORTFILE(FILE) reads data from the
%   first worksheet in the Microsoft Excel spreadsheet file named FILE and
%   returns the data as column vectors.
%
%   [Element,Terminal,PkW,Qkvar] = IMPORTFILE(FILE,SHEET) reads from the
%   specified worksheet.
%
%   [Element,Terminal,PkW,Qkvar] = IMPORTFILE(FILE,SHEET,STARTROW,ENDROW)
%   reads from the specified worksheet for the specified row interval(s).
%   Specify STARTROW and ENDROW as a pair of scalars or vectors of matching
%   size for dis-contiguous row intervals. To read to the end of the file
%   specify an ENDROW of inf.
%
%	Non-numeric cells are replaced with: NaN
%
% Example:
%   [Element,Terminal,PkW,Qkvar] = importfile('Solution-Balanced.xls','Powers',2,12153);
%
%   See also XLSREAD.

% Auto-generated by MATLAB on 2017/04/21 11:00:31

%% Input handling

% If no sheet is specified, read first sheet
if nargin == 1 || isempty(sheetName)
    sheetName = 1;
end

% If row start and end points are not specified, define defaults
if nargin <= 3
    startRow = 2;
    endRow = 12153;
end

%% Import the data
[~, ~, raw] = xlsread(workbookFile, sheetName, sprintf('A%d:D%d',startRow(1),endRow(1)));
for block=2:length(startRow)
    [~, ~, tmpRawBlock] = xlsread(workbookFile, sheetName, sprintf('A%d:D%d',startRow(block),endRow(block)));
    raw = [raw;tmpRawBlock]; %#ok<AGROW>
end
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
cellVectors = raw(:,1);
raw = raw(:,[2,3,4]);

%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells

%% Create output variable
I = cellfun(@(x) ischar(x), raw);
raw(I) = {NaN};
data = reshape([raw{:}],size(raw));

%% Allocate imported array to column variable names
Element = strtrim(cellVectors(:,1));
Terminal = data(:,1);
PkW = data(:,2);
Qkvar = data(:,3);

