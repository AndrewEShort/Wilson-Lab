clear
clc

% The user sets solution parameters here
numberOfTFs = 4; 
Xs = 1;
antilac = 1;
combinatorial = 1;
permutational = 0;
operatorDiff = 0;
if permutational
    operatorDiff = 1;
end

if ~Xs
    [A,B,C,D,E,F,G] = TFinputsRec();
else
    [A,B,C,D,E,F,G] = XsInputsRec();
end

TFsets = GetTFsets(A,B,C,D,E,F,G,numberOfTFs,antilac);

[RTFsets,~] = size(TFsets);

%  h steps through different TF groupings, and is used to index the 3rd
%  dimension of the Ledger cell array
for h = 1:RTFsets 
    currTFcombination = TFsets(h,:); 
    Ledger = {[],[],[],[],[],[],[],[]}; % 3D cell array tally of all 2TF combinations
    [rTF, cTF] = size(currTFcombination);
    [numOps, ~] = size(currTFcombination{1});
    n = cTF; % number of TFs in each set
    count = 0;
    bin = @(m,n) factorial(m)/(factorial(n)*(factorial(m-n)));
    perm = @(m,n) factorial(m)/((factorial(m-n)));

    [RcoordA, CcoordA] = find(currTFcombination{1});
    [RcoordB, CcoordB] = find(currTFcombination{2});
    TFACoords = [RcoordA,CcoordA];
    TFBCoords = [RcoordB,CcoordB];
    
    if numberOfTFs > 2
        [RcoordC, CcoordC] = find(currTFcombination{3});
        TFCCoords = [RcoordC,CcoordC];
    end
    if numberOfTFs > 3
        [RcoordD, CcoordD] = find(currTFcombination{4});
        TFDCoords = [RcoordD,CcoordD];
    end

    bCount = 0;
    cCount = 0;
    dCount = 0;

% Compute the combinations of the first two TFs in each
% currTFcombination

    % i steps through each unique TF in currTFcombination{1}, TFA
    for i = 1:length(RcoordA)
        TFA = TFACoords(i,:);
        Ledger{1+bCount,1,h} = TFA; Ledger{1+bCount,2,h} = TFA(1);%storing this TF in the ledger
        [Lr, Lc] = size(Ledger);
        
        % Check to see if any off diags are on this column in TFA, add these to
        % blocked rows
        for t = 1:length(CcoordA)
            if t ~= i % that is, if the entry indexed by t is not the same as TFA
                if CcoordA(t) == CcoordA(i)
                    Ledger{1+bCount,2,h} = [Ledger{1+bCount,2,h}, RcoordA(t)];
                end
            end
        end
        AblockedRows = Ledger{1+bCount,2,h};

        % Add second transcription factor (TFB) combinations to ledger in light of ledger columns 1 and 2
        for t = 1:length(CcoordB) % t will step through all TFBs
            check1 = 0;
            check2 = 1;
            bDiagsTemp = [];
            if sum(TFBCoords(t,:) ~= TFA)>0 % that is, if potential TFB is not the same as TFA
                possTFB = TFBCoords(t,:);
                bDiagsTemp = [bDiagsTemp, possTFB(1)];
                sumTempB = 0;
                
        % Check if potential TFB either:
        % 1. is on row forbidden by TFA, or
        % 2. has an off diagonal on a row forbidden by TFA
        % check1 and check2 determine these conditions. If both pass, 
        % TFB is set to the potential entry and added to the ledger,
        % along with any blocked rows it introduces
        
                if sum(possTFB(1) == AblockedRows(:))==0 % does possTFB not reside on a forbidden row?
                    check1 = 1;
                end
                for u = 1:length(CcoordB)
                    if u ~= t % that is, if the entry indexed by t is not the same as TFA
                        if CcoordB(u) == CcoordB(t)
                            bDiagsTemp = [bDiagsTemp, RcoordB(u)];
                            for p = 1:length(bDiagsTemp)
                                sumTempB = sumTempB + sum(bDiagsTemp(p) == Ledger{Lr,2,h}(:));
                            end
                            if sumTempB >0
                                check2 = 0;
                            end
                        end
                    end
                end

                if check1 && check2
                    TFB = possTFB;
                    Ledger{1+bCount,3,h} = TFB;
                    Ledger{1+bCount,4,h} = bDiagsTemp;
                    Ledger{1+bCount,1,h} = Ledger{Lr,1,h};
                    Ledger{1+bCount,2,h} = Ledger{Lr,2,h};
                    bCount = bCount + 1;
                end
            end
        end
        
 
    end

    if numberOfTFs == 2
        LedgerD = Ledger; 
        [LRD,~] = size(Ledger(:,:,h));
    elseif numberOfTFs == 3
        [LedgerC] = AdditionalTFContribution3(Ledger,TFCCoords,h,RcoordC,CcoordC);
        [LRD,~] = size(LedgerC(:,:,h));
        LedgerD = LedgerC;
    elseif numberOfTFs == 4
        [LedgerC] = AdditionalTFContribution3(Ledger,TFCCoords,h,RcoordC,CcoordC);
        [LedgerD] = AdditionalTFContribution4(LedgerC,TFDCoords,h,RcoordD,CcoordD);
        [LRD,~] = size(LedgerD(:,:,h));
    end
    
    if combinatorial
        % i steps through each entry in Ledger to compare and delete
        % repetitions
        for i = 1:LRD 
            for j = i:LRD
                if ~(isempty(LedgerD{i,1,h})) && ~(isempty(LedgerD{j,1,h})) && ~(i == j)
                    tempi = sort([LedgerD{i,1,h}(:,:), LedgerD{i,3,h}(:,:),LedgerD{i,5,h}(:,:),LedgerD{i,7,h}(:,:)]);
                    tempj = sort([LedgerD{j,1,h}(:,:), LedgerD{j,3,h}(:,:),LedgerD{j,5,h}(:,:),LedgerD{j,7,h}(:,:)]);
                    if tempi == tempj
                        for pp = 1:8
                            LedgerD{j,pp,h} = [];
                        end
                    end
                end
            end
        end

        % Consolidate the Ledger, deleting empty rows
        x = 0;
        standIn = LedgerD(:,:,h);
        [LRD,~] = size(LedgerD(:,:,h));
        for i = 1:LRD
            if isempty(standIn{i-x,1})
                standIn(i-x,:) = [];
                x = x + 1;
            end
        end    
        LedgerConsolidated(h) = {standIn};

    elseif permutational
        LedgerConsolidated(h) = {LedgerD(:,:,h)};
    end

end

%  Now we count up the combinations
if permutational || combinatorial
    for i = 1:length(LedgerConsolidated)
        [r,c] = size(LedgerConsolidated{i});
        count = count + r;
    end
    count
    if operatorDiff
        if numberOfTFs == 2
            countOp = 2*count
        elseif numberOfTFs == 3
            countOp = 6*count
        elseif numberOfTFs == 4
            countOp = 12*count
        end
    end
else 
    fprintf('Counting mode not defined; please set either combinatorial or permutational to 1.\n')
end
