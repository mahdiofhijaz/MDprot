% Load test pdb:
dirHere = 'D:\Telework_library\dopamine_phase_3\1-d2_dop_WT\md2pathdev\pca';
[pdb, crd] = readpdb(fullfile(dirHere,'prot_highestDenpca_CA_d2-dop-WT.pdb'));

morphTraj = morph(crd(1,:),crd(2,:),'saveDir',dirHere,'saveName','morphTrajProtPCA.pdb','pdb',pdb);

function morphTraj = morph(crd1,crd2,options)
    arguments
        crd1
        crd2
        options.nsteps = 10
        options.saveDir = ""
        options.saveName = []
        options.pdb = []
    end
    Ndofs = size(crd1,2);
    Ndofs2 = size(crd2,2);
    assert(Ndofs==Ndofs2, ...
        sprintf("Input coordinates do not have the same size! Sizes are %i and %i",Ndofs,Ndofs2))

    crdStep = (crd2 - crd1)/(options.nsteps-1);
    morphTraj = zeros(options.nsteps,Ndofs);

    for i = 1:options.nsteps
        morphTraj(i,:) = crd1+(i-1)*crdStep;
    end

    if ~isempty(options.saveName)
        writepdb(fullfile(options.saveDir,options.saveName), options.pdb, morphTraj);
%         writedcd(fullfile(options.saveDir,options.saveName), morphTraj)
    end
end