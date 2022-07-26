clear;
clc;

data = readmatrix('gaussdata.txt');

L = 5e-3;
f = data(:,1);
s11 = data(:,2) + 1j * data(:,3);
s21 = data(:,4) + 1j * data(:,5);
c = 299792458;
e_0 = 8.8541878176e-12;

X = (s11.^2 - s21.^2 + 1) ./ (2 * s11);
Gama = ones(length(X), 1);

for i = 1:length(X)
  gama = X(i) + sqrt(X(i)^2 - 1);
  if abs(gama) < 1
    Gama(i) = gama;
  else
    Gama(i) = X(i) - sqrt(X(i)^2 - 1);
  end
end

T = (s11 + s21 - Gama) ./ (1 - (s11 + s21) .* Gama);

n = ones(length(T), 1);
inv_Lambda_square = - (1 / (2 * pi * L) * (log(abs(1./T)) + (1j * 2 * pi * n))).^2;
disp(size(inv_Lambda_square));
mur = c * (1 + Gama) .* sqrt(inv_Lambda_square) ./ ((1 - Gama) .* f);

er = c^2 ./ (mur .* f.^2) .* inv_Lambda_square;

figure
plot(f / 10^9, real(mur), 'LineWidth', 2);
hold on
plot(f / 10^9, imag(mur), 'LineWidth', 2);
hold off
legend('Parte Real', 'Parte Imaginária');
title('Permeabilidade Relativa do PLA', 'FontSize', 26);
grid();
xlabel('Frequência (GHz)');
ylabel('Permeabilidade relativa');
set(gca, 'FontSize', 20);

figure
plot(f / 10^9, real(er), 'LineWidth', 2);
hold on
plot(f / 10^9, imag(er), 'LineWidth', 2);
hold off
title('Permitividade Relativa do PLA', 'FontSize', 26);
grid();
xlabel('Frequência (GHz)');
ylabel('Permitividade relativa');
legend('Parte Real', 'Parte Imaginária');
set(gca, 'FontSize', 20);

figure
plot(f / 10^9,  (2 * pi * e_0 * (f .* imag(er))), 'LineWidth', 2);
title('Condutividade do PLA', 'FontSize', 26);
grid();
xlabel('Frequência (GHz)');
ylabel('Condutividade ((\Omega m)^{-1})');
set(gca, 'FontSize', 20);
