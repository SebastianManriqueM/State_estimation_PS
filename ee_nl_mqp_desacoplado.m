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
%EE_Nao_Linear
clc; clear all; close all;
%nome_sis = 'ej_eeAbur_3barras.xlsx';
%nome_sis = 'ej_ee_3barras_radial.xlsx';
nome_sis = 'ej_ee_3barras.xlsx';
%nome_sis = 'ej_ee_aula.xlsx';

tol        = 0.001;
disp('começo Estimação de Estados');
disp(datestr(now));

%||  Ler dados ||
%================
[P_base, V_base, num_linhas, num_barras, num_medidas, num_pmedidas, Dados_linhas, Dados_medidas, Dados_pmedidas] = ler_dados(nome_sis);

no_l_i      = Dados_linhas(:,1);
no_l_j      = Dados_linhas(:,2);
Zs_linha    = Dados_linhas(:,3) + 1i*Dados_linhas(:,4);
Ys_linha    = 1./Zs_linha;                              %Admitância Serie da Linha
b_shunt     = 1i*Dados_linhas(:,5);

tipo_m      = Dados_medidas(:,1);
no_m_i      = Dados_medidas(:,2);
no_m_j      = Dados_medidas(:,3);
z           = Dados_medidas(:,4);
desv_p      = Dados_medidas(:,5);

tipo_pm      = Dados_pmedidas(:,1);
no_pm_i      = Dados_pmedidas(:,2);
no_pm_j      = Dados_pmedidas(:,3);
z_pm         = Dados_pmedidas(:,4);
desv_pm      = Dados_pmedidas(:,5);

tol_m = zeros(2*num_barras-1, 1);
for i = 1 : 2*num_barras-1
    tol_m(i) = tol;
end

%||  Cálculo Y Barras ||
%=======================
disp('Cálculo Ybarras')
[Y_barras] = calculo_Yb(Ys_linha, b_shunt, num_barras, num_linhas, no_l_i, no_l_j);
G_barras   = real(Y_barras);
B_barras   = imag(Y_barras);

%||  Vetor que indica quantas medidas de cada tipo há ||
%=======================================================
num_tipo_m = zeros(5,1);
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
    end
end

%INDEX
index_bs = zeros(num_medidas,1);
for i = 1 : num_medidas
    for j = 1 : num_linhas
        if ( no_m_i(i) == no_l_i(j) ) && ( no_m_j(i) == no_l_j(j) )
            index_bs(i) = j;
            break;
        elseif ( no_m_i(i) == no_l_j(j) ) && ( no_m_j(i) == no_l_i(j) )
             index_bs(i) = j;
            break;
        end
    end
end

%||  Cálculo Wmedidas ||
%=======================
W = zeros(num_medidas);
for i = 1 : num_medidas
    W(i, i) = 1/desv_p(i)^2;
end
%Fazer função index


%||  Ini Vetor Estados ||
%========================
 v_barras    = ones(num_barras, 1);
 delt_barras = zeros(num_barras, 1);
%v_barras    = [1; 1; 1];
%delt_barras = [0; -0.043; -0.22];
x           = [delt_barras; v_barras];

Delta_theta = zeros(num_barras-1, 1);
Delta_V     = zeros(num_barras, 1);
Delta_x     = [Delta_theta; Delta_V];

%Cálculo unido das matrizes
[ V_complejo, I_inj, S_calc, P_calc, Q_calc ] = calc_PQ_VI( v_barras, delt_barras, Y_barras );
[ J_Pt, J_Pv, J_Qt, J_Qv, J_Vt, J_Vv, H, n_p, n_q ] = jacobiano( v_barras, delt_barras, -G_barras, -B_barras, abs(b_shunt), P_calc, Q_calc, tipo_m, no_m_i, no_m_j, num_medidas, num_tipo_m,  num_barras, index_bs );
W_qv        = W(n_p+1:n_p+n_q , n_p+1:n_p+n_q);
W_pt        = W(1:n_p, 1:n_p);

flag = 1;
cont = 0;
disp('Começo iterações');
while(flag)
    cont   = cont + 1;
    disp(strcat('----Iteração---- ',num2str(cont)))
    
    [ V_complejo, I_inj, S_calc, P_calc, Q_calc ] = calc_PQ_VI( v_barras, delt_barras, Y_barras );
    [ J_Pt, J_Pv, J_Qt, J_Qv, J_Vt, J_Vv, H, n_p, n_q ] = jacobiano( v_barras, delt_barras, -G_barras, -B_barras, abs(b_shunt), P_calc, Q_calc, tipo_m, no_m_i, no_m_j, num_medidas, num_tipo_m,  num_barras, index_bs );
    [ h,z_m_h ] = calc_z_m_h ( num_barras, num_linhas, num_medidas, no_l_i, no_l_j, Y_barras, b_shunt, I_inj, V_complejo, v_barras, S_calc, z, tipo_m, no_m_i, no_m_j );
    
    %Função Objetivo
    Jx          = z_m_h.' * W * z_m_h   
    
    [ G_pt ]    = calc_G( J_Pt, W_pt );
    iG_pt       = inv(G_pt);
    
    Delta_theta = iG_pt * ( J_Pt' * W_pt * z_m_h(1:n_p) );
    delt_barras = delt_barras + [0;Delta_theta];
    x           = [delt_barras; v_barras];
    
%    [ V_complejo, I_inj, S_calc, P_calc, Q_calc ] = calc_PQ_VI( v_barras, delt_barras, Y_barras );
%    [ J_Pt, J_Pv, J_Qt, J_Qv, J_Vt, J_Vv, H, n_p, n_q ] = jacobiano( v_barras, delt_barras, -G_barras, -B_barras, abs(b_shunt), P_calc, Q_calc, tipo_m, no_m_i, no_m_j, num_medidas, num_tipo_m,  num_barras, index_bs );
%    [ h,z_m_h ] = calc_z_m_h ( num_barras, num_linhas, num_medidas, no_l_i, no_l_j, Y_barras, b_shunt, I_inj, V_complejo, v_barras, S_calc, z, tipo_m, no_m_i, no_m_j );
    Delta_x     = [Delta_theta; Delta_V];
    if ( all(abs(Delta_x) <= tol_m) )
        flag = 0;
        disp('Estimação de Estados Finalizada')
        break;
    end
    
    [ G_qv ]    = calc_G( [J_Qv;J_Vv], W_qv) ;
    iG_qv       = inv(G_qv);
    Delta_V     = iG_qv * ( [J_Qv;J_Vv]' * W_qv * z_m_h(n_p+1:n_p+n_q) );
    v_barras    = v_barras + Delta_V;
    x           = [delt_barras; v_barras]
    
    Delta_x     = [Delta_theta; Delta_V];
    if ( all(abs(Delta_x) <= tol_m) )
        flag = 0;
        disp('Estimação de Estados Finalizada')
        break;
    end
end
[ V_complejo, I_inj, S_calc, P_calc, Q_calc ] = calc_PQ_VI( v_barras, delt_barras, Y_barras );
[ J_Pt, J_Pv, J_Qt, J_Qv, J_Vt, J_Vv, H, n_p, n_q ] = jacobiano( v_barras, delt_barras, -G_barras, -B_barras, abs(b_shunt), P_calc, Q_calc, tipo_m, no_m_i, no_m_j, num_medidas, num_tipo_m,  num_barras, index_bs );
[ G ]   = calc_G( H, W );
iG      = inv(G);
Om         = inv( W ) - ( H * iG * H.' );
residuo_N  = normalizar_r(z_m_h, Om)
index_m_eg = abs(residuo_N)>=max( abs(residuo_N) )
imprimir_res( num_barras, num_linhas, num_medidas, tipo_m, Jx, no_l_i, no_l_j, no_m_i, no_m_j, z, h, v_barras, delt_barras, z_m_h, residuo_N, P_base, V_base, cont, nome_sis );
    
    
    