function [protResCode, chains] = pdb2seq(pdb)
%pdb2seq Takes in PDB file from readPDB and outputs 1 letter code sequence
%
% This function uses the mdtoolbox package from https://mdtoolbox.readthedocs.io/en/latest/
%% Usage:
% [protResCode] = pdb2seq(pdb)
% 
% * pdb is the pdb structure obtained by pdb = readpdb('pdb.pdb'). Note
% that other structure files (.gro for example) will not work, as the way
% mdtoolbox names the structure elements is different.
%
% * protResCode is the 1 letter sequence
%
% * chains are the chains belonging to the cells of protResCode
%

chains = unique(pdb.chainid,'stable'); % stable does not reorder the sequence
protResCode = cell(size(chains));

counterChain = 1;
for protChain = chains'
    protRes = unique(pdb.resseq(pdb.chainid==protChain)); % Gives protein residues

    protResName = cell(length(protRes),1);

    counter = 1;
    for i = protRes'
    protResName{counter} = pdb.resname(pdb.resseq == i,:);
    protResName{counter} = protResName{counter}(1,:);
    protResName{counter}(isspace(protResName{counter})) =[];
    if strcmp(protResName{counter},'HSD') % rename histidine
        protResName{counter} = 'HIS';
    end
    counter = counter + 1;
    end

    % turn them to one letter code
    protResCode{counterChain} = aminolookup(protResName);
    protResCode{counterChain} = protResCode{counterChain}{1};
    counterChain = counterChain + 1;
end
end

