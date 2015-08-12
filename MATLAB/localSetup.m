% -------------------------------------------------------------------------
% localSetup.m
% -------------------------------------------------------------------------
% Paths for the storage of results
ROOTDIR  = './DATABASE/';
COCOPATH = './BBOBResultsIgnore';
addpath('./bbob.v13.09');  % should point to fgeneric.m etc.
% Auxiliary functions
getfromfile = @(filename,varname) getfield(load(filename,varname),varname);
filexists   = @(filename) exist(filename,'file');                   % The file exists
varexists   = @(filename,var) ~isempty(who('-file',filename,var));  % The variable exists
varnonzero  = @(filename,var) all(getfromfile(filename,var)~=0);    % The variable is not all zeros

