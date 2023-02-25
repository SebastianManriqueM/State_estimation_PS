%  <CÁLCULO DO FLUXO DE POTÊNCIA - LOAD FLOW APPLYING NEWTON-RAPHSON METHOD V1.0. 
%  This is the main source of this software that calculates the power flow of a power network described using an excel input data file >
%     Copyright (C) <2014>  <Sebastián de Jesús Manrique Machado>   <e-mail:sebajmanrique747@gmail.com>
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

%Cálculo_Fluxo_de_Potência_ Newton Raphson
%   Sebastián de Jesús Manrique Machado
%   Estudante_Mestrado Em Engenharia Elétrica
%   UEL - 2014.
%Função para achar Y barras.

function [Y_barras, b_shunt_m, a_tap_m] = calculo_Yb_tap(Ys_linha, b_shunt, num_barras, num_linhas, nodo_i, nodo_j, a_tap)

Y_barras = zeros(num_barras,num_barras);        %O tamanho desta matriz é igual ao número de barras
b_shunt_m = zeros(num_barras,num_barras);
a_tap_m   = zeros(num_barras,num_barras);

for i = 1 : num_linhas
    a_tap_m( nodo_i(i), nodo_j(i) )  = 1/a_tap(i);
    a_tap_m( nodo_j(i), nodo_i(i) )  = 1;
    
    % Elementos fora da diagonal
    Y_barras( nodo_i(i), nodo_j(i) ) = Y_barras( nodo_i(i), nodo_j(i) ) - ( a_tap_m(nodo_i(i), nodo_j(i)) * Ys_linha(i) ); %FALTA DESFASADOR
    Y_barras( nodo_j(i), nodo_i(i) ) = Y_barras( nodo_i(i), nodo_j(i) );
    
    b_shunt_m( nodo_i(i), nodo_j(i) ) = b_shunt_m( nodo_i(i), nodo_j(i) ) + imag(b_shunt(i)) + ( a_tap_m(nodo_i(i), nodo_j(i))*(a_tap_m(nodo_i(i), nodo_j(i))-1)*imag(Ys_linha(i)) );
    b_shunt_m( nodo_j(i), nodo_i(i) ) = b_shunt_m( nodo_j(i), nodo_i(i) ) + imag(b_shunt(i)) + ( (1-a_tap_m(nodo_i(i), nodo_j(i)))*imag(Ys_linha(i)) );%conferir
     if (i==9)
         Y_barras(i,i) = Y_barras(i,i) + (1i*0.19);
         b_shunt_m(i,i) = b_shunt_m(i,i) + 0.19; 
     end
    % Elementos da diagonal
    Y_barras( nodo_i(i), nodo_i(i) ) = Y_barras( nodo_i(i), nodo_i(i) ) + ((a_tap_m(nodo_i(i), nodo_j(i))^2)*Ys_linha(i)) + b_shunt(i);    %(a_tap(i) * Ys_linha(i)) + 1i*b_shunt_m( nodo_i(i), nodo_j(i) );
    Y_barras( nodo_j(i), nodo_j(i) ) = Y_barras( nodo_j(i), nodo_j(i) ) + Ys_linha(i) + b_shunt(i);%(a_tap(i) * Ys_linha(i)) + 1i*b_shunt_m( nodo_j(i), nodo_i(i) ); %Ys_linha(i)
end



end
