function [LedgerC] = AdditionalTFContribution3(Ledger,TFCoords,h,RcoordC,CcoordC)
    [RLedgcurr, ~] = size(Ledger(:,:,h));
    LedgerC = {[],[],[],[],[],[],[],[]};
    c = 1;
    % e steps through the current Ledger entries
    for e = 1:RLedgcurr
            rowReject = [Ledger{e,2,h},Ledger{e,4,h}];
            [rc,~] = size(TFCoords);
            survivingTFCoords = [];
            rejects = [];
            for g = 1:rc
                if ~sum(RcoordC(g) == rowReject(:))>0
                    survivingTFCoords = [survivingTFCoords; TFCoords(g,:)];
                else
                    rejects = [rejects;TFCoords(g,:)];
                end
            end
    % Now we examine each survivingTFCoords entry; does its column
    % reject it?
            [Rs,~] = size(survivingTFCoords);
            [Rr,~] = size(rejects);

            cRowRejects = [];
            currRejectsC = [];
            survivingTFCoords2 = survivingTFCoords;
            % ii steps through survivingTFCoords
            for ii = 1:Rs
                for iii = 1:Rr
                    if survivingTFCoords(ii,2) == rejects(iii,2)
                        survivingTFCoords2(ii,:) = 0;
                    end
                end
            end
            [Rs2,~] = size(survivingTFCoords2);
            survivingTFCoords3 = [];
            for q = 1:Rs2
                if survivingTFCoords2(q,1)~= 0
                    survivingTFCoords3 = [survivingTFCoords3; survivingTFCoords2(q,:)];
                    cRowRejects = [cRowRejects, survivingTFCoords(q,1)];
                end
                currRejectsC = [currRejectsC; cRowRejects];
                cRowRejects = [];
            end
            [Rs2,~] = size(survivingTFCoords3);
            for y = 1:Rs2
                k = 2;
                for u = 1:length(CcoordC)
                    if RcoordC(u) ~= survivingTFCoords3(y,1)
                        if CcoordC(u) == survivingTFCoords3(y,2)
                            currRejectsC(y,k) = RcoordC(u);
                            k = k + 1;
                        end
                    end
                end
            end

            for q = 1:Rs2
                LedgerC(c,:,h) = Ledger(e,:,h);
                LedgerC{c,5,h} = survivingTFCoords3(q,:);
                rejectRow = currRejectsC(q,:);
                rejectRow(rejectRow(:) == 0) = [];
                LedgerC{c,6,h} = rejectRow;
                c = c + 1;
            end
    end