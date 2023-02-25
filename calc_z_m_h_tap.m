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
function [ h,z_m_h ] = calc_z_m_h_tap( num_barras, num_linhas, num_medidas, nodo_i, nodo_j, Y_barras, b_shunt, I_inj, V_complejo, v_barras, S_calc, z, tipo_m, no_m_i, no_m_j )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
z_m_h = zeros(num_medidas,1);
h     = zeros(num_medidas,1);

[ S_ij, I_ij, Loses_ij ] = calculo_linhas_tap( num_barras, num_linhas, nodo_i, nodo_j, Y_barras, b_shunt, I_inj, V_complejo, S_calc );

for i = 1 : num_medidas
    if tipo_m(i) == 1
        h(i) = real( S_ij( no_m_i(i), no_m_j(i) ) );
    elseif tipo_m(i) == 2
        h(i) = real( S_ij( no_m_i(i), no_m_i(i) ) );
    elseif tipo_m(i) == 3
        h(i) = imag( S_ij( no_m_i(i), no_m_j(i) ) );
    elseif tipo_m(i) == 4
        h(i) = imag( S_ij( no_m_i(i), no_m_i(i) ) );
    elseif tipo_m(i) == 5
        h(i) = v_barras( no_m_i(i) );
    end
end
z_m_h = z - h;
end

