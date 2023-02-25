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

function [ no_lobs_i, no_lobs_j, contador ] = remover_lin( tipo_m, no_m_i, no_m_j, no_l_i, no_l_j )
%remover_lin Summary of this function goes here
%   Remove ramos não observáveis - que não possuem medida de fluxo nem de
%   injeção em nenhum dos seus extremos
% 2 REMOVER RAMOS
no_lobs_i = no_l_i;
no_lobs_j = no_l_j;
contador  = 0;
for i = 1 : size(no_l_i,1)
    flag = 0;
   for j = 1 : size(no_m_i,1)
      if ( tipo_m(j) == 1 )
          if (( no_l_i(i) == no_m_i(j) ) && ( no_l_j(i) == no_m_j(j) )) || (( no_l_i(i) == no_m_j(j) ) && ( no_l_j(i) == no_m_i(j) ))
              flag = 1;
              break;
          end
      elseif tipo_m(j) == 2
          if (( no_l_i(i) == no_m_i(j) ) || ( no_l_j(i) == no_m_i(j) ))
              flag = 1;
              break;
          end
      end
   end
   if flag == 0
       no_lobs_i = [no_lobs_i(1:i-contador-1, :) ;no_lobs_i(i-contador+1:size(no_lobs_i,1), :) ];
       no_lobs_j = [no_lobs_j(1:i-contador-1, :) ;no_lobs_j(i-contador+1:size(no_lobs_j,1), :) ];
       contador  = contador + 1;
   end
end

end

