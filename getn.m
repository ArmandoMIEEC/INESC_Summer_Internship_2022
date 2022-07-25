%%% Calcula a permitividade e a permeabilidade e dá o número n %%%
% Input: frequencia, S11, S12, group delay

%%% Inputs %%%
f = 22000000000;
Delta_f = 55000000;

% parametros S para correspondentes a frequencia f
s11_norm1 = 10^(-15.258406 / 10);
s11_phase1 = deg2rad(-78.902824);
s21_norm1 = ;
s21_phase1 = ;

% parametros S para correspondentes a frequencia f + Delta_f
s11_norm2 = 10^(-12.95456 / 10);
s11_phase2 = deg2rad(-78.902824);
s21_norm2 = ;
s21_phase2 = ;

tau_meas = ; % group delay medido
L = 0.005; % espessura do material (m)

c = 299792458; % velocidade da luz (m/s)

% parametros S da frequencia f
s11_1 = s11_norm1 * exp(s11_phase1 * 1j);
s21_1 = s21_norm1 * exp(s21_phase1 * 1j);

% parametros S da frequencia f + Delta_f
s11_2 = s11_norm2 * exp(s11_phase2 * 1j);
s21_2 = s21_norm2 * exp(s21_phase2 * 1j);

%%% Calculo de T para a frequência f %%%
Gama1 = get_Gama(s11_1, s21_1);
Gama2 = get_Gama(s11_2, s21_2);
T1 = get_T(s11_1, s21_1, Gama1);
T2 = get_T(s11_2, s21_2, Gama2);

%%% D� print do resultado para diferentes n's %%%
n = 0;
while true
  prod_emu1 = - c^2 / (2 * pi * f * L)^2 * (log(abs(1/T1) + 1j * ((angle(1/T1) + 2 * n * pi))));  
  prod_emu2 = - c^2 / (2 * pi * (f + Delta_f) * L)^2 * (log(abs(1/T2) + 1j * ((angle(1/T2) + 2 * n * pi))));  

  tau_cal = L / c * (sqrt(prod_emu1) + f / (2 * sqrt(prod_emu1)) * (prod_emu2 - prod_emu1) / Delta_f);
  res = tau_cal - tau_meas;
  disp('n = %d', n);
  disp('tau_cal - tau_meas = %f+i%f', [real(res), imag(res)]);
  pause(0.5);
  n = n + 1;
end


%%% Functions %%%
function Gama = get_Gama(s11, s21)
  X = (s11^2 - s21^2 + 1) / (2 * s11);
  Gama = X + sqrt(X^2 - 1);
  if abs(Gama) >= 1
    Gama = X - sqrt(X^2 - 1);
  end
end

function T = get_T(s11, s21, Gama)
  T = (s11 + s21 - Gama) / (1 - (s11 + s21) * Gama);
end
