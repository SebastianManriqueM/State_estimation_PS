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
clc; clear all; close all;
%nome_sis = 'ej_eeAbur_3barras.xlsx';
%nome_sis = 'ej_ee_3barras_radial.xlsx';
%nome_sis = 'ej_ee_3barras.xlsx';
%nome_sis = 'ej_ee_aula.xlsx';
%nome_sis = 'ex2_observabilidade_5barras.xlsx';
%nome_sis = 'ex_slides_observabilidade_6barras.xlsx';
%nome_sis = 'ex_slides_observabilidade_6barras-mlondon.xlsx';
%nome_sis = 'ex_t8_9barras_crit.xlsx';
%nome_sis = 'ex_t8_9barras_crit_b.xlsx';
%nome_sis = 'ex_t8_9barras_c_ccm.xlsx';
%nome_sis = 'ex_t8_9barras_c_ccm-semB3.xlsx';
%nome_sis = 'ex_t8_9barras_c_ccm_semb4.xlsx';
%nome_sis = 'IEEE_14_busbar_obs.xlsx';
%nome_sis = 'ex_t8_9barras_c_ccm_NN.xlsx';
nome_sis = 'IEEE_14_busbar_obs_prova_london.xlsx';


tol        = 0.0001;
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
b_shunt_b   = zeros(num_barras,1);
for i = 1 : num_linhas
   b_shunt_b( no_l_i(i) ) = b_shunt_b( no_l_i(i) ) + b_shunt( i );
   b_shunt_b( no_l_j(i) ) = b_shunt_b( no_l_j(i) ) + b_shunt( i ); 
end

tipo_m      = Dados_medidas(:,1);
no_m_i      = Dados_medidas(:,2);
no_m_j      = Dados_medidas(:,3);
z           = Dados_medidas(:,4);
desv_p      = Dados_medidas(:,5);

tipo_pm     = Dados_pmedidas(:,1);
no_pm_i     = Dados_pmedidas(:,2);
no_pm_j     = Dados_pmedidas(:,3);
z_pm        = Dados_pmedidas(:,4);
desv_pm     = Dados_pmedidas(:,5);

tol_m = zeros(2*num_barras-1, 1);
for i = 1 : 2*num_barras-1
    tol_m(i) = tol;
end

%||  Vetor que indica quantas medidas de cada tipo há ||
%=======================================================
[ num_tipo_m ]  = quant_tipo_medidas( tipo_m );
[ num_tipo_pm ] = quant_tipo_medidas( tipo_pm );

%Detecção de Ilhas Monticelli
%[ no_lobs_i, no_lobs_j, no_mobs_i, no_mobs_j, num_tipo_mobs, tipo_mobs, num_pm_obs  ] = monticelli_obs_di( no_l_i, no_l_j, no_m_i, no_m_j, num_tipo_m, tipo_m, num_barras )

%Restauração da Observabilidade Monticelli
%[ no_lobs_i, no_lobs_j, no_mobs_i, no_mobs_j, num_tipo_mobs, tipo_mobs, n_pm_add, vetor_flag_pm  ] = monticelli_obs_ro( no_l_i, no_l_j, no_m_i, no_m_j, num_tipo_m, tipo_m, num_barras, tipo_pm, no_pm_i, no_pm_j, num_tipo_pm )

%Restauração da Observabilidade London
[no_mobs_i, no_mobs_j, num_tipo_mobs, tipo_mobs, index_pm_add, num_pm_obs, index_pm_Hfator ] = london_obs_ro( no_l_i, no_l_j, no_m_i, no_m_j, num_tipo_m, tipo_m, num_barras, tipo_pm, no_pm_i, no_pm_j, num_tipo_pm )
