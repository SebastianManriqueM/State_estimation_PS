%  <ESTIMADOR DE ESTADOS MQP NÃO LINEAR - NON LINEAR WMS STATE ESTIMATION V1.0. 
%  This is the main source of this software that estimates the sates of a power network (complex voltages at nodes) described using an excel input data file >
%     Copyright (C) <2017>  <Sebastián de Jesús Manrique Machado>   <e-mail:sebastiand@utfpr.edu.br>
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.

%ESTIMADOR DE ESTADOS NÃO LINEAR MQP
%   Sebastián de Jesús Manrique Machado
%   Estudante_Doutorado Em Engenharia Elétrica
%   EESC/USP - 2017.
%ANÁLISE OBSERVABILIDADE
function [ no_lobs_i, no_lobs_j, no_mobs_i, no_mobs_j, num_tipo_mobs, tipo_mobs, cont, vetor_flag_pm  ] = monticelli_obs_ro( no_l_i, no_l_j, no_m_i, no_m_j, num_tipo_m, tipo_m, num_barras, tipo_pm, no_pm_i, no_pm_j, num_tipo_pm )
%monticelli_obs_ro Summary of this function goes here
%   Restauração de Observabilidade, método de Monticelli

no_lobs_i = no_l_i
no_lobs_j = no_l_j

no_mobs_i = no_m_i
no_mobs_j = no_m_j
num_tipo_mobs = num_tipo_m;
tipo_mobs     = tipo_m;
flag          = 1;
cont          = 0;
vetor_flag_pm = ones( size(no_pm_i,1), 1 );
%--------------------------------------------------------------------------
while(flag)
    z_obs     = zeros( size(no_mobs_i,1), 1);
    %----------------
    [ H_obs, G_obs ] = montarH_obs( num_barras, num_tipo_mobs, tipo_mobs, no_mobs_i, no_mobs_j, no_lobs_i, no_lobs_j ); %Monta H considerando Xkm=1 com topologia atualizada
    %disp(G_obs)
    [ Fatores, z_obs, H_obs, num_pm_obs ] = fatorar_tri_m( num_barras, G_obs, H_obs, z_obs );                           %faz a fatoração e inclui pseudo-medidas atualizando H e z
    if (num_pm_obs == 1)
        flag = 0;
        break;
    end
    %RESTAURAÇÃO DE OBSERVABILIDADE
    delt_barras_obs = inv(H_obs'*H_obs) * H_obs' * z_obs
    [ no_mobs_i, no_mobs_j, num_tipo_mobs, tipo_mobs, vetor_flag_pm ] = add_pseudo_m_moticelli( num_barras, delt_barras_obs, no_lobs_i, no_lobs_j, tipo_pm, no_pm_i, no_pm_j, no_mobs_i, no_mobs_j, num_tipo_mobs, tipo_mobs, vetor_flag_pm );
    cont = cont + 1;
end
disp( strcat( num2str( size(unique(cont), 1) ),' Pseudo_medidas adicionadas para restaurar observabilidade:' ) )

end

