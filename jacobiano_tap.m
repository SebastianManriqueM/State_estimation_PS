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
%Função para achar Jacobiano.

function [ J_Pt, J_Pv, J_Qt, J_Qv, J_Vt, J_Vv, JT, b, e ] = jacobiano_tap( v_barras, delt_barras, G_barras, B_barras, b_shunt, P_calc, Q_calc, tipo_m, no_m_i, no_m_j, num_medidas, num_tipo_m,  num_barras, index_bs, a_tap )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

J_Pt  = zeros(num_tipo_m(2) , num_barras-1);
J_Pv  = zeros(num_tipo_m(2) , num_barras);
J_Qt  = zeros(num_tipo_m(4) , num_barras-1);
J_Qv  = zeros(num_tipo_m(4) , num_barras);
J_Vt  = zeros(num_tipo_m(5) , num_barras-1);
J_Vv  = zeros(num_tipo_m(5) , num_barras);

JT    = zeros(num_medidas , 2*num_barras-1);
a = num_barras - 1;
%||  Derivada de P respeito a Theta ||      
%=====================================
for i = 1 : num_medidas
    if tipo_m(i) == 1                       % MEDIDAS DE POTÊNCIA ATIVA PELAS LINHAS
        %||  Derivada de Plin respeito a Theta/V ||      
        %=======================================
        for j = 1 : num_barras

            if (no_m_i(i) == j)
                if j>1
                    %P_ij/theta_i
                    JT(i , j-1) =  (a_tap(j, no_m_j(i)) * v_barras( j ) * v_barras( no_m_j(i) ) ) * ( G_barras(j, no_m_j(i)) * sin(delt_barras(j)-delt_barras(no_m_j(i))) -  B_barras(j, no_m_j(i)) * cos(delt_barras(j)-delt_barras(no_m_j(i))));
                end
                %P_ij/V_i
                JT(i , j+a) = ( ( -a_tap(j, no_m_j(i)) * v_barras( no_m_j(i) ) ) * ( G_barras(j, no_m_j(i)) * cos(delt_barras(j)-delt_barras(no_m_j(i)))  + B_barras(j, no_m_j(i)) * sin(delt_barras(j)-delt_barras(no_m_j(i))) ) + 2*(a_tap(j, no_m_j(i))^2)*v_barras(j)*( G_barras(j, no_m_j(i)) ) );
            elseif(no_m_j(i) == j)
                if j>1
                    %P_ij/theta_j
                    JT(i , j-1) =  (-a_tap(no_m_i(i),j) * v_barras( no_m_i(i) ) * v_barras( j ) ) * ( G_barras(no_m_i(i),j) * sin(delt_barras(no_m_i(i))-delt_barras(j)) -  B_barras(no_m_i(i),j) * cos(delt_barras(no_m_i(i))-delt_barras(j)));
                end
                %P_ij/V_j
                JT(i , j+a) = ( -a_tap(no_m_i(i),j) * v_barras( no_m_i(i) ) ) * ( G_barras(no_m_i(i), j) * cos(delt_barras(no_m_i(i))-delt_barras(j))  + B_barras(no_m_i(i), j) * sin(delt_barras(no_m_i(i))-delt_barras(j)) );
            end

        end
    
    elseif tipo_m(i) == 2                   % MEDIDAS DE POTÊNCIA ATIVA injetada  
        %||  Derivada de Pinj respeito a Theta ||      
        %=======================================
        for j = 1 : num_barras

            if ( no_m_i(i) == j )
                if j>1
                    JT(i , j-1) = ( -(v_barras( j )^2 ) * -B_barras(j , j)) - Q_calc(no_m_i(i));            %COmo se esta passando 0G_barras e -Y barras é necessário retornar o sinal
                end
                JT(i , j+a) = ( v_barras(j) * -G_barras(j , j)) + (1/v_barras(j))*P_calc(j);
            else
                if j>1
                    JT(i , j-1) = v_barras(no_m_i(i)) * v_barras(j) * ( (-G_barras(no_m_i(i),j)*sin(delt_barras(no_m_i(i))-delt_barras(j)) ) - (-B_barras(no_m_i(i),j)*cos(delt_barras(no_m_i(i))-delt_barras(j)) )  );
                end
                JT(i , j+a) = v_barras(no_m_i(i)) * ( (-G_barras(no_m_i(i),j)*cos(delt_barras(no_m_i(i))-delt_barras(j)) ) + (-B_barras(no_m_i(i),j)*sin(delt_barras(no_m_i(i))-delt_barras(j)) )  );
            end

        end
    elseif tipo_m(i) == 3                   % MEDIDAS DE POTÊNCIA REATIVA PELAS LINHAS 
        %||  Derivada de Qlin respeito a theta/Tensão ||      
        %=======================================
        for j = 1 : num_barras
            
            if( no_m_i(i) == j )
                if j>1
                    %Q_ij/\theta_i
                    JT(i , j-1) = (-a_tap(j, no_m_j(i)) * v_barras( j ) * v_barras( no_m_j(i) ) ) * ( G_barras(j, no_m_j(i)) * cos(delt_barras(j)-delt_barras(no_m_j(i))) +  B_barras(j, no_m_j(i)) * sin(delt_barras(j)-delt_barras(no_m_j(i))));
                end
                %Q_ij/\V_i
                JT(i , j+a) =( ( -a_tap(j, no_m_j(i)) * v_barras( no_m_j(i) ) ) * ( G_barras(j, no_m_j(i)) * sin(delt_barras(j)-delt_barras(no_m_j(i)))  - B_barras(j, no_m_j(i)) * cos(delt_barras(j)-delt_barras(no_m_j(i))) ) - 2*(a_tap(j, no_m_j(i))^2)*v_barras(j)*( B_barras(j, no_m_j(i)) + b_shunt(j, no_m_j(i)) ) );
            elseif( no_m_j(i) == j )
                if j>1
                    %Q_ij/\theta_j
                    JT(i , j-1) =  (a_tap(no_m_i(i),j) * v_barras( no_m_i(i) ) * v_barras( j ) ) * ( G_barras(no_m_i(i),j) * cos(delt_barras(no_m_i(i))-delt_barras(j)) +  B_barras(no_m_i(i),j) * sin(delt_barras(no_m_i(i))-delt_barras(j)));
                end
                %Q_ij/\V_j
                JT(i , j+a) = ( -a_tap(no_m_i(i),j) * v_barras( no_m_i(i) ) ) * ( G_barras(no_m_i(i), j) * sin(delt_barras(no_m_i(i))-delt_barras(j))  - B_barras(no_m_i(i), j) * cos(delt_barras(no_m_i(i))-delt_barras(j)) );
            end
            
        end
    elseif tipo_m(i) == 4                   % MEDIDAS DE POTÊNCIA REATIVA injetada  
        %||  Derivada de Qinj respeito a Tensão ||      
        %=======================================
        for j = 1 : num_barras
            if ( no_m_i(i) == j )
                if j>1
                    JT(i , j-1) = P_calc(j)-(v_barras(j)^2*-G_barras(j,j));     %COmo se esta passando 0G_barras e -Y barras é necessário retornar o sinal
                end
                JT(i , j+a) = ( -(v_barras(j)) * -B_barras(j , j))  + (1/v_barras(j))*Q_calc(j);
            else
                if j>1
                    JT(i , j-1) =  -v_barras(no_m_i(i)) * v_barras(j) *( (-G_barras(no_m_i(i),j)*cos(delt_barras(no_m_i(i))-delt_barras(j)) ) + (-B_barras(no_m_i(i),j)*sin(delt_barras(no_m_i(i))-delt_barras(j)) )  );
                end
                JT(i , j+a) = v_barras(no_m_i(i)) * ( (-G_barras(no_m_i(i),j)*sin(delt_barras(no_m_i(i))-delt_barras(j)) ) - (-B_barras(no_m_i(i),j)*cos(delt_barras(no_m_i(i))-delt_barras(j)) )  );
            end
        end
        
    elseif tipo_m(i) == 5                   % MEDIDAS DE TENSÃO
        for j = 1 : num_barras
            if no_m_i(i) == j
                JT(i , j+a) = 1;
            end
        end
    end
end
b = num_tipo_m(1)+num_tipo_m(2);
c = b + num_tipo_m(3)+num_tipo_m(4);
d = c + num_tipo_m(5);
e = d - b;
J_Pt  = JT(1:b , 1:a);
J_Pv  = JT(1:b , a+1:2*num_barras-1);
J_Qt  = JT(b+1:c , 1:a);
J_Qv  = JT(b+1:c , a+1:2*num_barras-1);
J_Vt  = JT(c+1:d , 1:a);
J_Vv  = JT(c+1:d , a+1:2*num_barras-1);

end
