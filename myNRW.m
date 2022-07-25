clear;
clc;

data = readmatrix('gaussdata.txt');

L = 5e-3;
f = data(:,1);
s11 = data(:,2) + 1j * data(:,3);
s21 = data(:,4) + 1j * data(:,5);
c = 299792458;

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

inv_Lambda_square = - (1 / (2 * pi* L) * (log(abs(1/T)) + (1j * 2 * pi * n))).^2;

mur = c * (1 + Gama) .* sqrt(inv_Lambda_square) ./ ((1 - Gama) .* f);
er = c^2 ./ (mur .* f.^2) .* inv_Lambda_square;

figure
plot(f, real(mur));
hold on
plot(f, imag(mur));
hold off
title('Relative Permeability');
legend('real', 'imaginary');

figure
plot(f, real(er));
hold on
plot(f, imag(er));
hold off
title('Relative permitivity');
legend('real', 'imaginary');

