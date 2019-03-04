function [lacI,celR,galR,galS,fruR,rbsR,Ia] = TFinputsRec()

    diag = zeros(7,7);
    for i = 1:7
        diag(i,i) = 1;
    end
    celR = [1,0,0,0,0,0,0;0,0,0,0,0,0,0;0,0,1,0,0,0,0;0,0,1,1,0,1,0;0,0,0,0,1,0,0;0,0,1,0,0,0,0;0,0,0,0,0,0,1];
    lacI = diag;
    galR = diag;
    Ia = diag;
%     Ia(1,1) = 0; % this position is an Is
    galS = diag;
    galS(2,2) = 0;% this position is an Is
    galS(7,7) = 0;%I-
    galS(7,6) = 1;
    rbsR = diag;
    rbsR(2,2)= 0; rbsR(1,3) = 1; rbsR(1,5) = 1; rbsR(4,3) = 1; rbsR(7,6) = 1;
    fruR = diag;
    fruR(2,2)=0; fruR(5,5) = 0; fruR(6,6)= 0;
end
