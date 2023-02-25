%  <ESTIMADOR DE ESTADOS MQP N�O LINEAR - NON LINEAR WMS STATE ESTIMATION V1.0. 
%  This is the main source of this software that estimates the sates of a power network (complex voltages at nodes) described using an excel input data file >
%     Copyright (C) <2017>  <Sebasti�n de Jes�s Manrique Machado>   <e-mail:sebastiand@utfpr.edu.br>
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

%ESTIMADOR DE ESTADOS N�O LINEAR MQP
%   Sebasti�n de Jes�s Manrique Machado
%   Estudante_Doutorado Em Engenharia El�trica
%   EESC/USP - 2017.
%AN�LISE OBSERVABILIDADE
function [ no_mobs_i, no_mobs_j, num_tipo_mobs, tipo_mobs, vetor_flag_pm ] = add_pseudo_m_moticelli( num_barras, delt_barras_obs, no_lobs_i, no_lobs_j, tipo_pm, no_pm_i, no_pm_j, no_mobs_i, no_mobs_j, num_tipo_mobs, tipo_mobs, vetor_flag_pm )
%add_pseudo_m_moticelli Summary of this function goes here
%   Detailed explanation goes here
S_ij_obs        = zeros(num_barras, num_barras);

contador        = 0;
%Detectar Ramos com fluxo diferente de zero (N�o observ�veis)�
for i = 1 : size(no_lobs_i,1)                               %Remover da Rede linhas com fluxo != 0
    S_ij_obs(no_lobs_i(i), no_lobs_j(i)) = (delt_barras_obs( no_lobs_i(i) ) - delt_barras_obs( no_lobs_j(i) ));
    if ( abs( S_ij_obs(no_lobs_i(i), no_lobs_j(i)) ) > 1e-10 )      %Adicionar a vetor de pseudomedidas candidatas
        contador                 = contador + 1;
        no_pm_cand_i( contador ) = no_lobs_i(i);
        no_pm_cand_j( contador ) = no_lobs_j(i);        
    end
    
end

barras_candidatas = unique([no_pm_cand_i; no_pm_cand_j]);
contadorb         = 0;
%Tentar Pseudo-medidas de Inje��o
 for i = 1 : size(no_pm_i,1)                       
     if( tipo_pm(i) == 2 ) && any( barras_candidatas == no_pm_i(i) )  && (vetor_flag_pm(i))             % Medida P injetada-- Dar prioridade
         %adicionar medida P injetada atualizar z, H,
         a                = size(no_mobs_i,1) + 1;
         no_mobs_i(a)     = no_pm_i(i);
         no_mobs_j(a)     = no_pm_j(i);
         num_tipo_mobs(2) = num_tipo_mobs(2) + 1;
         tipo_mobs(a)     = 2;
         vetor_flag_pm(i) = 0;
         contadorb = contadorb + 1;
         break;
         
     elseif ( tipo_pm(i) == 1 ) && vetor_flag_pm(i)                     % Medida P fluxo
         for j = 1 : size(no_pm_cand_i, 2)
             if ( ( no_pm_cand_i(j) == no_pm_i(i) ) && ( no_pm_cand_j(j) == no_pm_j(i) ) ) || ( ( no_pm_cand_i(j) == no_pm_j(i) ) && ( no_pm_cand_j(j) == no_pm_i(i) ) )
                a                = size(no_mobs_i,1) + 1;
                no_mobs_i(a)     = no_pm_i(i);                          % Colocar na ordem "ij"que a pseudo medida realmente �, n�o a ordem da candidata
                no_mobs_j(a)     = no_pm_j(i);
                num_tipo_mobs(1) = num_tipo_mobs(1) + 1;
                tipo_mobs(a)     = 1;
                vetor_flag_pm(i) = 0;
                vetor_flag_pm(i) = 0;
                contadorb = contadorb + 1;
                break;
             end
         end
         if contadorb ~= 0
             break;
         end
         
     end
    
end


end

