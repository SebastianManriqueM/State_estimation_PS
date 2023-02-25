function [ H_col, i ] = montar_colH_pm_obs( len, tipo_pm, no_pm_i, no_pm_j, no_l_i, no_l_j, vetor_flag_pm  )
%montar_colH_pm_obs Summary of this function goes here 
%   Detailed explanation goes here
for i = 1 : size(no_pm_i , 1)
    H_col = zeros(len, 1);
    if vetor_flag_pm(i) == 1
        
        if tipo_pm(i) == 1
            H_col( no_pm_i(i) ) = 1;
            H_col( no_pm_j(i) ) = -1;
            break;
        elseif tipo_pm(i) == 2
            for j = 1 : size(no_l_i , 1)
                if no_l_i(j) == no_pm_i(i)
                    H_col( no_pm_i(i) ) = H_col( no_pm_i(i) ) + 1;
                    H_col( no_l_j(j) ) = -1;
                elseif no_l_j(j) == no_pm_i(i)
                    H_col( no_pm_i(i) ) = H_col( no_pm_i(i) ) + 1;
                    H_col( no_l_i(j) ) = -1;
                end
            end
            break;
        end 
        
    end
end

end

