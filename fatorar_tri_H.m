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
%AN?LISE OBSERVABILIDADE
function [ Fatores, index_pm_add, num_pm_obs, index_pm_Hfator, num_tipo_pm_add, H_fatorada ] = fatorar_tri_H( num_barras, H_obs, tipo_pm, no_pm_i, no_pm_j, no_l_i, no_l_j, vetor_flag_pm )
%fatorar_tri_m Summary of this function goes here
%   Realiza fatora??o triangular: Forward (Adiciona pseudo medidas
%   artificiais e atualiza z_obs e H_obs. Depois realiza Diagonaliza??o e
%   backward
c               = min(size(H_obs));


Fatores         = zeros(num_barras, num_barras);     %Da para alocar na mesma matriz G

num_pm_obs      = 0;
index_pm_add    = [];
num_tipo_pm_add = zeros( size(unique(tipo_pm),1) ,1 );
index_pm_Hfator = zeros(size(H_obs,2),1);
for i = 1 : size(H_obs,2)
    index_pm_Hfator(i) = i;
end
%Fatora??o Triangular
%Forward
for i = 1 : num_barras-1       %PERCORRE COLUNAS (MEDIDAS)
    if i > min(size(H_obs))
        H_col          = zeros(num_barras, 1);
        H_obs          = [H_obs, H_col];
    end        
    if( all( abs( H_obs(i:i, i: size(H_obs,2) ) ) < 1e-10 ) ) && ( all( abs( H_obs(i:size(H_obs,1), i:i ) ) < 1e-10 ) )          %ADI??O DE PSEUDO MEDIDA
        i_nulo         = i;
        [ H_col, i_pm_add ] = busca_pm( i_nulo, H_obs, tipo_pm, no_pm_i, no_pm_j, no_l_i, no_l_j, Fatores, vetor_flag_pm );
        index_pm_add        = [index_pm_add; i_pm_add];
        num_tipo_pm_add( tipo_pm(i_pm_add) ) = num_tipo_pm_add( tipo_pm(i_pm_add) ) +1;
        num_pm_obs          = num_pm_obs + 1;
        H_obs               = [H_obs, H_col];
        [ H_obs, ref ]      = trocar_colunas_Hobs( H_obs, i );
        index_pm_Hfator     = [index_pm_Hfator;num_barras+num_pm_obs];
        a                  = index_pm_Hfator(i);
        index_pm_Hfator(i) = index_pm_Hfator(ref);           index_pm_Hfator(ref) = a;
    else
        if abs( H_obs(i,i) ) < 1e-10                                            %TROCA DE COLUNAS
            [ H_obs, ref ]          = trocar_colunas_Hobs( H_obs, i );
            a                  = index_pm_Hfator(i);
            index_pm_Hfator(i) = index_pm_Hfator(ref);           index_pm_Hfator(ref) = a;
        end
        
    end
    for j = i + 1 : size(H_obs, 1) %PERCORRE FILAS (VAR ESTADO) PARA FATORAR MATRIZ
        Fatores( j , i )   = -H_obs(j,i) / H_obs(i,i);
        H_obs(j:j , : )    =  ( Fatores( j , i ) .* H_obs(i:i , : ) ) + H_obs(j:j, :);
    end
end

%Diagonaliza??o
for i = 1 : num_barras-1
   Fatores( i , i ) = 1 / H_obs(i,i);
   H_obs(i:i , : )  =  ( Fatores( i , i ) .* H_obs(i:i , : ) );    
end

%Backward
for i = num_barras-1 : -1 : 1
    for j = i - 1 : -1 : 1
        if abs(H_obs( j , i )) > 1e-10
            Fatores( j , i ) = -H_obs( j , i );
            H_obs(j:j , : )  =  ( Fatores( j , i ) .* H_obs( i:i , : ) ) + H_obs(j:j, :);
        end
    end
end

H_fatorada = H_obs;
end

