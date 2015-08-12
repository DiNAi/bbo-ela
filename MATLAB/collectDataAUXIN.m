function collectDataAUXIN(dim,ssize)

% -------------------------------------------------------------------------
% Preliminaries 
localSetup;                                                 % Run script with local setup
FILENAME = ['_D' num2str(dim) '_C' num2str(ssize) '.mat'];  % Parameters of the experiment
% -------------------------------------------------------------------------
% Test if we have the necessary data to calculate these features
if ~filexists([ROOTDIR 'X' FILENAME]) || ~filexists([ROOTDIR 'I' FILENAME]) 
    warning('Please collect latin hypercube and indexing data. Skipped.');
    return
end
X     = getfromfile([ROOTDIR 'X'  FILENAME],'X');
I     = getfromfile([ROOTDIR 'I' FILENAME],'I');
NBOOT = size(I,1);
% -------------------------------------------------------------------------
% Test if we still need to calculate the LHD data
flagX2 = true;
flagXX = true;
flagHx = true;
% Test for X2
if filexists([ROOTDIR 'X2' FILENAME])                    % The file exists
    if varexists([ROOTDIR 'X2' FILENAME],'X2')           % The variable exists
        if all(varnonzero([ROOTDIR 'X2' FILENAME],'X2'))  % The variable is not all zeros
            disp(['X2' FILENAME ' already processed.']);
            flagX2 = false;
        end
    end
end
% Test for XX
if filexists([ROOTDIR 'XX' FILENAME])                    % The file exists
    if varexists([ROOTDIR 'XX' FILENAME],'XX')           % The variable exists
        if all(varnonzero([ROOTDIR 'XX' FILENAME],'XX'))  % The variable is not all zeros
            disp(['XX' FILENAME ' already processed.']);
            flagXX = false;
        end
    end
end
% Test for Hx
if filexists([ROOTDIR 'Hx' FILENAME])                    % The file exists
    if varexists([ROOTDIR 'Hx' FILENAME],'Hxhat')        % The variable exists
        if all(varnonzero([ROOTDIR 'Hx' FILENAME],'Hxhat'))  % The variable is not all zeros
            disp(['Hx' FILENAME ' already processed.']);
            flagHx = false;
        end
    end
end
% -------------------------------------------------------------------------
% Variables for the experiment
if (flagXX || flagHx), idx = nchoosek(1:dim,2); end
% -------------------------------------------------------------------------

if flagX2
    X2 = X.^2; %#ok<*NASGU>
    save([ROOTDIR 'X2' FILENAME],'X2','-v7.3');
    clear X2;
end
% Calculating the XxX data
if flagXX
    XX = X(idx(:,1),:).*X(idx(:,2),:);
    save([ROOTDIR 'XX' FILENAME],'XX','-v7.3');
    clear XX;
end
% Calculating the Hx data
if flagHx
    Hxhat     = (kdpee(X')+kdpee(flipud(X)'))./2;
    HxhatB    = zeros(1,NBOOT);
    parfor j=1:NBOOT
        HxhatB(j) = (kdpee(X(:,I(j,:))')+kdpee(flipud(X(:,I(j,:)))'))./2; %#ok<*PFBNS,*PFOUS>
    end
    Hx1hat    = zeros(dim,1);
    Hx1hatB   = zeros(dim,NBOOT);
    for i=1:dim
        Hx1hat(i) = kdpee(X(i,:)');
        parfor j=1:NBOOT
            Hx1hatB(i,j) = kdpee(X(i,I(j,:))');
        end
    end
    
    npairs  = size(idx,1);
    Hx2hat  = zeros(npairs,1);
    Hx2hatB = zeros(npairs,NBOOT);
    for i=1:npairs
        aux       = idx(i,:);
        Hx2hat(i) = (kdpee(X(aux,:)') + kdpee(flipud(X(aux,:))'))./2;
        parfor j=1:NBOOT
            Hx2hatB(i,j) = (kdpee(X(aux,I(j,:))') + kdpee(flipud(X(aux,I(j,:)))'))./2;
        end
    end
    save([ROOTDIR 'Hx' FILENAME],'Hxhat','HxhatB','Hx1hat','Hx1hatB','Hx2hat','Hx2hatB');
end
% =========================================================================
