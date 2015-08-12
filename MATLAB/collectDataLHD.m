function collectDataLHD(dim,ssize)

% -------------------------------------------------------------------------
% Preliminaries 
localSetup;                                                     % Run script with local setup
FILENAME     = ['_D' num2str(dim) '_C' num2str(ssize) '.mat'];  % Parameters of the experiment
VAR_LO_BOUND = -5;                                              % Variables for the experiment
VAR_RANGE    = 5 - VAR_LO_BOUND;
NBOOT = 2000;
NOBS  = dim*ssize;
% -------------------------------------------------------------------------
% Test if we still need to calculate the LHD data
flagX = true;
flagI = true;
if filexists([ROOTDIR 'X' FILENAME])                    % The file exists
    if varexists([ROOTDIR 'X' FILENAME],'X')           % The variable exists
        if all(varnonzero([ROOTDIR 'X' FILENAME],'X'))  % The variable is not all zeros
            disp(['X' FILENAME ' already processed.']);
            flagX = false;
        end
    end
end
% Test if we still need to calculate the bootstrap indexes
if filexists([ROOTDIR 'I' FILENAME])                    % The file exists
    if varexists([ROOTDIR 'I' FILENAME],'I')           % The variable exists
        if all(varnonzero([ROOTDIR 'I' FILENAME],'I'))  % The variable is not all zeros
            disp(['I' FILENAME ' already processed.'])
            flagI = false;
        end
    end
end
% -------------------------------------------------------------------------
% Calculating the LHD data
if flagX
    rng('default');
    X = ((VAR_RANGE * lhsdesign(NOBS,dim)) + VAR_LO_BOUND)'; %#ok<*NASGU>
    save([ROOTDIR 'X' FILENAME],'X','-v7.3');
end
% Calculating the bootstrap indexes
if flagI
    rng('default'); 
    I = randi(NOBS,[NBOOT NOBS],'uint32');
    save([ROOTDIR 'I' FILENAME],'I','-v7.3');
end
% =========================================================================
