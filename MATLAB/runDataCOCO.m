% -------------------------------------------------------------------------
% runDataCOCO.m
% -------------------------------------------------------------------------
% NOTE: Does not require cluster, but that would significantly accelerate
% the performance
FUNCTIONS   = 1:24;
DIMENSIONS  = [2 3 5 8 10 20 40 60 100];
SAMPLE_SIZE = 100.*round(logspace(2,4,11)./100);
% % Calculate the input data
% for dim=DIMENSIONS
%     for ssize=SAMPLE_SIZE
%         collectDataLHD(dim,ssize);
%     end
% end
% % Calculate the function data
% for dim=DIMENSIONS
%     for ssize=SAMPLE_SIZE
%         % Using the ability of running several functions at the time
%         collectFunctionResponse(FUNCTIONS,dim,ssize)
%     end
% end
% % Calculate the input data
% delete(gcp('nocreate'));
% myPool = parpool(10);
% for dim=DIMENSIONS
%     for ssize=SAMPLE_SIZE(1)
%         collectDataAUXIN(dim,ssize);
%     end
% end
% delete(myPool);
% Extract the Sequence data
for dim=DIMENSIONS
    for ssize=SAMPLE_SIZE(6)
        collectDataSequence(dim,ssize);
    end
end

% Extract the ELA data
for dim=DIMENSIONS
    for ssize=SAMPLE_SIZE(6)
        % Using the ability of running several functions at the time
        %collectFeaturesELA(FUNCTIONS,dim,ssize);
        collectFeaturesHTS(FUNCTIONS,dim,ssize);
    end
end