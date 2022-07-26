clear;
clc;

e_0 = 8.8541878176e-12;

%[f, er1, mur1] = getprop('PLA_2.txt');
[f, er2, mur2] = getprop('PLA.txt');

%{
figure
plot(f ./ 10^9, real(er1), 'LineWidth', 2);
hold on
plot(f ./ 10^9, real(er2), 'LineWidth', 2);
hold off
legend('Parte Real Não Filtrada', 'Parte Real Filtrada');
title('Permitividade Relativa PLA', 'FontSize', 26);
grid();
xlabel('Frequência (GHz)');
ylabel('Permitividade relativa');
set(gca, 'FontSize', 20);
%}

figure
plot(f / 10^9, real(mur2), 'LineWidth', 2);
hold on
plot(f / 10^9, imag(mur2), 'LineWidth', 2);
hold off
legend('Parte Real', 'Parte Imaginária');
title('Permeabilidade Relativa do PLA', 'FontSize', 26);
grid();
xlabel('Frequência (GHz)');
ylabel('Permeabilidade relativa');
set(gca, 'FontSize', 20);

figure
plot(f / 10^9, real(er2), 'LineWidth', 2);
hold on
plot(f / 10^9, imag(er2), 'LineWidth', 2);
hold off
title('Permitividade Relativa do PLA', 'FontSize', 26);
grid();
xlabel('Frequência (GHz)');
ylabel('Permitividade relativa');
legend('Parte Real', 'Parte Imaginária');
set(gca, 'FontSize', 20);


figure
plot(f / 10^9,  ((2 * pi * f) * e_0) .* imag(er2), 'LineWidth', 2);
title('Condutividade do PLA', 'FontSize', 26);
grid();
xlabel('Frequência (GHz)');
ylabel('Condutividade ((\Omega m)^{-1})');
set(gca, 'FontSize', 20);


function [f, er, mur] = getprop(filename)

    % Constantes
    L = 5e-3;
    c = 299792458;

    data = readmatrix(filename);
    s11 = data(:,2) + 1j * data(:,3);
    s21 = data(:,4) + 1j * data(:,5);
    f = data(:,1);
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
    mur = c * (1 + Gama) .* sqrt(inv_Lambda_square) ./ ((1 - Gama) .* f);

    er = c^2 ./ (mur .* f.^2) .* inv_Lambda_square;
end


