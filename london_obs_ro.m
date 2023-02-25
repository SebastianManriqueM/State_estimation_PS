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
function [no_mobs_i, no_mobs_j, num_tipo_mobs, tipo_mobs, index_pm_add, num_pm_obs, index_pm_Hfator ] = london_obs_ro( no_l_i, no_l_j, no_m_i, no_m_j, num_tipo_m, tipo_m, num_barras, tipo_pm, no_pm_i, no_pm_j, num_tipo_pm )
%london_obs_ro Summary of this function goes here
%   Restauração de Observabilidade, método de London 2007

no_lobs_i = no_l_i
no_lobs_j = no_l_j

no_mobs_i = no_m_i
no_mobs_j = no_m_j
num_tipo_mobs = num_tipo_m;
tipo_mobs     = tipo_m;
vetor_flag_pm = ones( size(no_pm_i,1), 1 );
%--------------------------------------------------------------------------

z_obs     = zeros( size(no_mobs_i,1), 1);
%----------------
[ H_obs, G_obs ] = montarH_obs( num_barras, num_tipo_mobs, tipo_mobs, no_mobs_i, no_mobs_j, no_lobs_i, no_lobs_j ); %Monta H considerando Xkm=1 com topologia atualizada
%disp(G_obs)
[ Fatores, index_pm_add, num_pm_obs,index_pm_Hfator, num_tipo_pm_add, H_fatorada ] = fatorar_tri_H( num_barras, H_obs', tipo_pm, no_pm_i, no_pm_j, no_l_i, no_l_j, vetor_flag_pm )                           %faz a fatoração e inclui pseudo-medidas atualizando H e z

no_mobs_i     = [no_mobs_i; no_pm_i(index_pm_add)];
no_mobs_j     = [no_mobs_j; no_pm_j(index_pm_add)];
tipo_mobs     = [tipo_mobs; tipo_pm(index_pm_add)];
num_tipo_mobs = num_tipo_mobs + [num_tipo_pm_add;0;0;0;0];


disp( strcat( num2str( num_pm_obs ),' Pseudo_medidas adicionadas para restaurar observabilidade:' ) )

end

