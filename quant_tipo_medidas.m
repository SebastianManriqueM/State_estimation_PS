%  <ESTIMADOR DE ESTADOS MQP N?O LINEAR - NON LINEAR WMS STATE ESTIMATION V1.0. 
%  This is the main source of this software that estimates the sates of a power network (complex voltages at nodes) described using an excel input data file >
%     Copyright (C) <2017>  <Sebasti?n de Jes?s Manrique Machado>   <e-mail:sebastiand@utfpr.edu.br>
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

%ESTIMADOR DE ESTADOS N?O LINEAR MQP
%   Sebasti?n de Jes?s Manrique Machado
%   Estudante_Doutorado Em Engenharia El?trica
%   EESC/USP - 2017.
function [ num_tipo_m ] = quant_tipo_medidas( tipo_m )
%quant_tipo_medidas Summary of this function goes here
%   Retorna a quantidade de medidas de cada tipo (Inje??o de P e Q, FLuxo
%   de P e Q e tens?o.
num_tipo_m = zeros( 6 ,1 );
for i = 1 : size(tipo_m, 1)
    if tipo_m(i) == 1
        num_tipo_m(1) = num_tipo_m(1) + 1;
    elseif tipo_m(i) == 2
        num_tipo_m(2) = num_tipo_m(2) + 1;
    elseif tipo_m(i) == 3
        num_tipo_m(3) = num_tipo_m(3) + 1;
    elseif tipo_m(i) == 4
        num_tipo_m(4) = num_tipo_m(4) + 1;
    elseif tipo_m(i) == 5
        num_tipo_m(5) = num_tipo_m(5) + 1;
    else
        num_tipo_m(6) = num_tipo_m(6) + 1;
    end
end

end

