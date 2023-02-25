function [ H_col, i_pm_add ] = busca_pm( i_nulo, H_obs, tipo_pm, no_pm_i, no_pm_j, no_l_i, no_l_j, Fatores, vetor_flag_pm )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%
flag = 1;
cont = 0;
while(flag)
    [ H_col, i_pm_add ] = montar_colH_pm_obs( size(H_obs,1), tipo_pm, no_pm_i, no_pm_j, no_l_i, no_l_j, vetor_flag_pm  );
    %aplicar fatores tri
    [ H_col ] = app_fatores_tri( Fatores, H_col );
    if abs( H_col(i_nulo) ) > 1e-10
        vetor_flag_pm(i_pm_add) = 0;
        flag = 0;
    else
        vetor_flag_pm(i_pm_add) = 2;     %já foi tentada
    end
    if cont > size(no_pm_i,1)
        flag = 0;
    end
    cont = cont + 1;
end
    
for i =1 : size(vetor_flag_pm,1)
    if vetor_flag_pm(i) == 2
        vetor_flag_pm(i) = 1;
    end
end
end

