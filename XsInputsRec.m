function [A,B,C,D,E,F,G] = XsInputsRec()

    diag = zeros(7,7);
    A = diag; C = diag; G = diag; B = diag;
    D = diag; E = diag; F = diag;
    
    D(2,2) = 1; 
    E(6,3) = 1; E(5,5) = 1; E(6,6) = 1;

    [a,b,c,d,e,f,g] = TFinputsRec();

    A = A + a;
    B = B + b;
    C = C + c;
    D = D + d;
    E = E + e;
    F = F + f;
    G = G + g;
    
end