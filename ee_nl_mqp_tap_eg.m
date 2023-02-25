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
%nome_sis = 'ej_ee_3barras.xlsx';
%nome_sis = 'ej_ee_aula.xlsx';
%nome_sis = 'IEEE_14_busbar.xlsx';
%nome_sis = 'IEEE_14_busbar_ex1.xlsx';
%nome_sis = 'IEEE_14_busbar_ex1_dados_london.xlsx';
%nome_sis = 'IEEE_14_busbar_ex1_dados_london2a.xlsx';
nome_sis = 'IEEE_14_busbar_prova_london_b.xlsx'

tol        = 10e-5;
%tol         = 0.001;
disp('começo Estimação de Estados');
disp(datestr(now));

%||  Ler dados ||
%================
%[P_base, V_base, num_linhas, num_barras, num_medidas, num_pmedidas, Dados_linhas, Dados_medidas, Dados_pmedidas] = ler_dados(nome_sis);
[P_base, V_base, num_linhas, num_barras, num_medidas, num_pmedidas, Dados_linhas, Dados_medidas, Dados_pmedidas] = ler_dados_tap(nome_sis);

no_l_i      = Dados_linhas(:,1);
no_l_j      = Dados_linhas(:,2);
Zs_linha    = Dados_linhas(:,3) + 1i*Dados_linhas(:,4);
Ys_linha    = 1./Zs_linha;                              %Admitância Serie da Linha
b_shunt     = 1i*Dados_linhas(:,5);
b_shunt_b   = zeros(num_barras,1);
a_tap       = Dados_linhas(:,6);                        %DADOS TAP
for i = 1 : num_linhas
   b_shunt_b( no_l_i(i) ) = b_shunt_b( no_l_i(i) ) + b_shunt( i );
   b_shunt_b( no_l_j(i) ) = b_shunt_b( no_l_j(i) ) + b_shunt( i ); 
end

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
%[Y_barras] = calculo_Yb(Ys_linha, b_shunt, num_barras, num_linhas, no_l_i, no_l_j);
[Y_barras, b_shunt_m, a_tap_m] = calculo_Yb_tap(Ys_linha, b_shunt, num_barras, num_linhas, no_l_i, no_l_j, a_tap);
G_barras   = real(Y_barras);
B_barras   = imag(Y_barras);

%||  Vetor que indica quantas medidas de cada tipo há ||
%=======================================================
[ num_tipo_m ]  = quant_tipo_medidas( tipo_m );
[ num_tipo_pm ] = quant_tipo_medidas( tipo_pm );

%||  Vetor que indica quantas medidas de cada tipo há ||
%=======================================================

%INDEX
[ index_bs ] = calc_index_bshunt_ij( no_l_i, no_l_j, no_m_i, no_m_j, tipo_m, num_linhas, num_medidas );

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

flag = 1;
cont = 0;
disp('Começo iterações');
while(flag && cont<200)
    cont   = cont + 1;
    disp(strcat('----Iteração---- ',num2str(cont)));
    [ V_complejo, I_inj, S_calc, P_calc, Q_calc ] = calc_PQ_VI( v_barras, delt_barras, Y_barras );
    
    %[ J_Pt, J, J_Qt, J_Qv, J_Vt, J_Vv, H ] = jacobiano( v_barras, delt_barras, -G_barras, -B_barras, b_shunt_m, P_calc, Q_calc, tipo_m, no_m_i, no_m_j, num_medidas, num_tipo_m,  num_barras, index_bs );
    [ J_Pt, J, J_Qt, J_Qv, J_Vt, J_Vv, H ] = jacobiano_tap( v_barras, delt_barras, -G_barras, -B_barras, b_shunt_m, P_calc, Q_calc, tipo_m, no_m_i, no_m_j, num_medidas, num_tipo_m,  num_barras, index_bs, a_tap_m );
    [ G ]       = calc_G( H, W );
    
    %[ h,z_m_h ] = calc_z_m_h( num_barras, num_linhas, num_medidas, no_l_i, no_l_j, Y_barras, b_shunt, I_inj, V_complejo, v_barras, S_calc, z, tipo_m, no_m_i, no_m_j );
    [ h,z_m_h ] = calc_z_m_h_tap( num_barras, num_linhas, num_medidas, no_l_i, no_l_j, Y_barras, 1i*b_shunt_m, I_inj, V_complejo, v_barras, S_calc, z, tipo_m, no_m_i, no_m_j );
    %Função Objetivo
    Jx          = z_m_h.' * W * z_m_h
    Delta_x_a   = Delta_x;
    iG          = inv(G);
    Delta_x     = G \ ( H' * W * z_m_h )
    x           = x + [0;Delta_x];
    delt_barras = x(1:num_barras)
    v_barras    = x(num_barras+1:2*num_barras)
    if ( all(abs(Delta_x) <= tol_m) )
        flag = 0;
        disp('Estimação de Estados Finalizada')
        break;
    end
end
[ V_complejo, I_inj, S_calc, P_calc, Q_calc ] = calc_PQ_VI( v_barras, delt_barras, Y_barras );
%[ J_Pt, J, J_Qt, J_Qv, J_Vt, J_Vv, H ] = jacobiano( v_barras, delt_barras, -G_barras, -B_barras, abs(b_shunt_b), P_calc, Q_calc, tipo_m, no_m_i, no_m_j, num_medidas, num_tipo_m,  num_barras, index_bs );
[ J_Pt, J, J_Qt, J_Qv, J_Vt, J_Vv, H ] = jacobiano_tap( v_barras, delt_barras, -G_barras, -B_barras, b_shunt_m, P_calc, Q_calc, tipo_m, no_m_i, no_m_j, num_medidas, num_tipo_m,  num_barras, index_bs, a_tap_m );
[ G ]       = calc_G( H, W );
iG          = inv(G);
Om         = inv( W ) - ( H * iG * H.' );
[ h,z_m_h ] = calc_z_m_h_tap( num_barras, num_linhas, num_medidas, no_l_i, no_l_j, Y_barras, 1i*b_shunt_m, I_inj, V_complejo, v_barras, S_calc, z, tipo_m, no_m_i, no_m_j );
residuo_N  = normalizar_r(abs(z_m_h), Om)
r_N_max    = max( abs(residuo_N) )
bool_index_m_eg = abs(residuo_N) >= r_N_max
[ UI, erro_est ]     = calcular_UI( num_medidas, H, iG, W, residuo_N )
imprimir_res( num_barras, num_linhas, num_medidas, tipo_m, Jx, no_l_i, no_l_j, no_m_i, no_m_j, z, h, v_barras, delt_barras, z_m_h, residuo_N, UI, erro_est, P_base, V_base, cont, nome_sis );
residuo_N(bool_index_m_eg)

if(r_N_max >= 3)
    disp('--**Foi detectada medida portadora de E.G.**--');
    for i = 1 : size(residuo_N,1)
        if residuo_N(i) == r_N_max
            index_m_eg = i;
            break;
        end
    end
    disp( strcat('--**Eliminou-se Medida: ',num2str(index_m_eg),', **--\n--**Tipo: ',num2str(tipo_m(index_m_eg)),'-',num2str(no_m_i(index_m_eg)),'-', num2str(no_m_j(index_m_eg)),'**--' ));
    %Atualizar medidas, num medidas, num tipo, tipo
    num_tipo_m( tipo_m(index_m_eg) )  = num_tipo_m( tipo_m(index_m_eg) ) - 1;
    tipo_m      = [tipo_m(1:index_m_eg-1, :) ;tipo_m(index_m_eg+1:size(tipo_m,1), :) ];
    no_m_i      = [no_m_i(1:index_m_eg-1, :) ;no_m_i(index_m_eg+1:size(no_m_i,1), :) ];
    no_m_j      = [no_m_j(1:index_m_eg-1, :) ;no_m_j(index_m_eg+1:size(no_m_j,1), :) ];
    z           = [z(1:index_m_eg-1, :) ;z(index_m_eg+1:size(z,1), :) ];

    %Atualizar matriz W
    W           = [W(1:index_m_eg-1, :) ;W(index_m_eg+1:size(W,1), :) ];
    W           = [W( : , 1:index_m_eg-1) ,W( : , index_m_eg+1:size(W,1)) ];
end