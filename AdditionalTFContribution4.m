function [LedgerD] = AdditionalTFContribution4(LedgerC,TFDCoords,h,RcoordD,CcoordD)
    [RLedgcurr, ~] = size(LedgerC(:,:,h));
    LedgerD = {[],[],[],[],[],[],[],[]};
    c = 1;
    
% e steps through the current Ledger entries
    for e = 1:RLedgcurr
            rowReject = [LedgerC{e,2,h},LedgerC{e,4,h},LedgerC{e,6,h}];
            [rc,~] = size(TFDCoords);
            survivingTFDCoords = [];
            rejects = [];
            for g = 1:rc
                if ~sum(RcoordD(g) == rowReject(:))>0
                    survivingTFDCoords = [survivingTFDCoords; TFDCoords(g,:)];
                else
                    rejects = [rejects;TFDCoords(g,:)];
                end
            end
    % Now we examine each survivingTFDCoords entry; does its column
    % reject it?
            [Rs,~] = size(survivingTFDCoords);
            [Rr,~] = size(rejects);
            dRowRejects = [];
            currRejectsD = [];
            survivingTFDCoords2 = survivingTFDCoords;
            
            % ii steps through survivingTFDCoords
            for ii = 1:Rs
                for iii = 1:Rr
                    if survivingTFDCoords(ii,2) == rejects(iii,2)
                        survivingTFDCoords2(ii,:) = 0;
                    end
                end
            end
            [Rs2,~] = size(survivingTFDCoords2);
            survivingTFDCoords3 = [];
            for q = 1:Rs2
                if survivingTFDCoords2(q,1)~= 0
                    survivingTFDCoords3 = [survivingTFDCoords3; survivingTFDCoords2(q,:)];
                    dRowRejects = [dRowRejects, survivingTFDCoords(q,1)];
                end
                currRejectsD = [currRejectsD; dRowRejects];
                dRowRejects = [];
            end
            [Rs2,~] = size(survivingTFDCoords3);
            for y = 1:Rs2
                k = 2;
                for u = 1:length(CcoordD)
                    if RcoordD(u) ~= survivingTFDCoords3(y,1)
                        if CcoordD(u) == survivingTFDCoords3(y,2)
                            currRejectsD(y,k) = RcoordD(u);
                            k = k + 1;
                        end
                    end
                end
            end

            for q = 1:Rs2
                LedgerD(c,:,h) = LedgerC(e,:,h);
                LedgerD{c,7,h} = survivingTFDCoords3(q,:);
                rejectRow = currRejectsD(q,:);
                rejectRow(rejectRow(:) == 0) = [];
                LedgerD{c,8,h} = rejectRow;
                c = c + 1;
            end
    end