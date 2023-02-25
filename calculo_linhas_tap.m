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
%Função para calcular variáveis das linhas.

function [ S_ij, I_ij, Loses_ij ] = calculo_linhas_tap( num_barras, num_linhas, nodo_i, nodo_j, Y_barras, b_shunt, I_inj, V_complejo, S_calc )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

S_ij      = zeros(num_barras, num_barras);
I_ij      = zeros(num_barras, num_barras);
Loses_ij  = zeros(num_barras, num_barras);

%||  Cálculo I e S pelas linhas ||
for i = 1 : num_linhas
    I_ij(nodo_i(i), nodo_j(i)) = (- V_complejo(nodo_i(i)) + V_complejo(nodo_j(i)) ) * Y_barras(nodo_i(i), nodo_j(i)) + V_complejo(nodo_i(i)) * b_shunt(nodo_i(i), nodo_j(i));
    I_ij(nodo_j(i), nodo_i(i)) = (- V_complejo(nodo_j(i)) + V_complejo(nodo_i(i)) ) * Y_barras(nodo_j(i), nodo_i(i)) + V_complejo(nodo_j(i)) * b_shunt(nodo_j(i), nodo_i(i));
    
    S_ij(nodo_i(i), nodo_j(i)) = V_complejo(nodo_i(i)) * conj( I_ij(nodo_i(i), nodo_j(i)) );
    S_ij(nodo_j(i), nodo_i(i)) = V_complejo(nodo_j(i)) * conj( I_ij(nodo_j(i), nodo_i(i)) );
end

for i = 1 : num_barras
    I_ij(i , i) = I_inj(i);
    S_ij(i , i) = S_calc(i);
end

%||  Cálculo Perdas pelas linhas ||
for i = 1 : num_linhas
    Loses_ij(nodo_i(i), nodo_j(i)) = S_ij(nodo_i(i), nodo_j(i)) + S_ij(nodo_j(i), nodo_i(i));
    Loses_ij(nodo_j(i), nodo_i(i)) = Loses_ij(nodo_i(i), nodo_j(i));
end


end

