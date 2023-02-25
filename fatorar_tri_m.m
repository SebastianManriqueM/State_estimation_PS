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
function [ Fatores, z_obs, H_obs_pm, num_pm_obs ] = fatorar_tri_m( num_barras, G, H_obs, z_obs )
%fatorar_tri_m Summary of this function goes here
%   Realiza fatoração triangular: Forward (Adiciona pseudo medidas
%   artificiais e atualiza z_obs e H_obs. Depois realiza Diagonalização e
%   backward
f=1;%%%%no es el de monticelli
Fatores         = zeros(num_barras, num_barras);     %Da para alocar na mesma matriz G
%z_obs           = zeros(num_medidas, 1);
num_pm_obs      = 0;
%Fatoração Triangular
%Forward
for i = 1 : num_barras
    if( abs(G(i,i)) < 1e-10 )           %Adição de pseudo medidas de ângulo
        if f == 1
            G(i,i)     = 1;
            z_obs      = [z_obs; num_pm_obs];
            add_lH     = zeros(1,num_barras);
            add_lH(i)  = 1;
            H_obs      = [H_obs; add_lH];
            num_pm_obs = num_pm_obs + 1;
        end
    else 
        for j = i + 1 : num_barras
            Fatores( j , i ) = -G(j,i) / G(i,i);
            G(j:j , : )      =  ( Fatores( j , i ) .* G(i:i , : ) ) + G(j:j, :); 
        end
    end
end

%Diagonalização
for i = 1 : num_barras
    if( abs(G(i,i)) > 1e-10 )
        Fatores( i , i ) = 1 / G(i,i);
        G(i:i , : ) =  ( Fatores( i , i ) .* G(i:i , : ) );   
    end
end

%Backward
for i = num_barras : -1 : 1
    for j = i - 1 : -1 : 1
        if abs(G( j , i )) > 1e-10
            Fatores( j , i ) = -G( j , i );
            G(j:j , : ) =  ( Fatores( j , i ) .* G( i:i , : ) ) + G(j:j, :);
        end
    end
end

H_obs_pm = H_obs;
end

