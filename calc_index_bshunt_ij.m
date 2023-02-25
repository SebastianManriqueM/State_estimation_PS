function [ ind_b_shunt_ij ] = calc_index_bshunt_ij( no_l_i, no_l_j, no_m_i, no_m_j, tipo_m, num_linhas, num_medidas )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
ind_b_shunt_ij = zeros(size(no_m_i));

for i=1 : num_medidas
    if tipo_m(i) == 1 || tipo_m(i) == 3
        for j = 1 : num_linhas
            if (no_m_i(i) == no_l_i(j)) && (no_m_j(i) == no_l_j(j))
                ind_b_shunt_ij(i) = j;
                break;
            elseif(no_m_i(i) == no_l_j(j)) && (no_m_i(i) == no_l_j(j))
                ind_b_shunt_ij(i) = j;
                break;
            end
        end
    end
end
    

end

