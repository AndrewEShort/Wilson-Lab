function [TFsets] = GetTFsets(A,B,C,D,E,F,G,numberOfTFs,antilac)
    if numberOfTFs == 2
        if antilac
    % for two TF with Ia:
            TFsets = {A,B;A,C;A,D;A,E;A,F;G,B;G,C;G,D;G,E;G,F;B,C;B,D;B,E;B,F;C,E;C,F;D,E;D,F;E,F};
        else
            TFsets = {A,B;A,C;A,D;A,E;A,F;B,C;B,D;B,E;B,F;C,E;C,F;D,E;D,F;E,F};
        end

    elseif numberOfTFs == 3
    % for three TF no Ia:
        if ~antilac
            TFsets = {A,B,C;A,B,D;A,B,E;A,B,F;A,C,E;A,C,F;A,D,E;A,D,F;A,E,F;B,C,E;B,C,F;...
                B,D,E;B,D,F;B,E,F;C,E,F;D,E,F};
        else
    % for three TF with Ia:
            TFsets = {A,B,C;A,B,D;A,B,E;A,B,F;A,C,E;A,C,F;A,D,E;A,D,F;A,E,F;B,C,E;B,C,F;...
                B,D,E;B,D,F;B,E,F;C,E,F;D,E,F;G,B,C;G,B,D;G,B,E;G,B,F;G,C,E;G,C,F;G,D,E;G,D,F;G,E,F};
        end
    elseif numberOfTFs == 4
    % for four TF no Ia:
        if ~antilac
            TFsets = {A,B,C,E;A,B,C,F;A,B,D,E;A,B,D,F;A,B,E,F;A,C,E,F;A,D,E,F;B,C,E,F;B,D,E,F};
        else
            % for four TF with Ia:
            TFsets = {A,B,C,E;A,B,C,F;A,B,D,E;A,B,D,F;A,B,E,F;A,C,E,F;A,D,E,F;B,C,E,F;B,D,E,F;...
                G,B,C,E;G,B,C,F;G,B,D,E;G,B,D,F;G,B,E,F;G,C,E,F;G,D,E,F};
        end
    end