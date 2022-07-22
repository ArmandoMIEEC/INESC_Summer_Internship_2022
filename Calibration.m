clear;
clc;

c = 299792458; %v luz
d = 5 * 10^ - 3; %espessura amostra
l = 0.82 * 10^ - 3; %espessura placa metálica

s11_ar = readmatrix('15_07 TLR/s11ar.csv');
s11_ar(:, 2) = 10.^(s11_ar(:, 2) / 10);
s11_ar(:, 3) = deg2rad(s11_ar(:, 3));
s11_ar(:, 2) = s11_ar(:, 2) .* exp(s11_ar(:, 3) .* 1j);

s11_metal = readmatrix('15_07 TLR/s11metal.csv');
s11_metal(:, 2) = 10.^(s11_metal(:, 2) / 10);
s11_metal(:, 3) = deg2rad(s11_metal(:, 3));
s11_metal(:, 2) = s11_metal(:, 2) .* exp(s11_metal(:, 3) .* 1j);

s11_mut = readmatrix('15_07 TLR/s11mut.csv');
s11_mut(:, 2) = 10.^(s11_mut(:, 2) / 10);
s11_mut(:, 3) = deg2rad(s11_mut(:, 3));
s11_mut(:, 2) = s11_mut(:, 2) .* exp(s11_mut(:, 3) .* 1j);

s11 =- (s11_mut(:, 2) - s11_ar(:, 2)) ./ (s11_metal(:, 2) - s11_ar(:, 2)) .* exp(4 * pi * s11_ar(:, 1) / c * d * 1j);
plot(s11_ar(:, 1), abs(s11));

s21_ar = readmatrix('15_07 TLR/s21ar.csv');
s21_ar(:, 2) = 10.^(s21_ar(:, 2) / 10);
s21_ar(:, 3) = deg2rad(s21_ar(:, 3));
s21_ar(:, 2) = s21_ar(:, 2) .* exp(s21_ar(:, 3) .* 1j);

s21_metal = readmatrix('15_07 TLR/s21metal.csv');
s21_metal(:, 2) = 10.^(s21_metal(:, 2) / 10);
s21_metal(:, 3) = deg2rad(s21_metal(:, 3));
s21_metal(:, 2) = s21_metal(:, 2) .* exp(s21_metal(:, 3) .* 1j);

s21_mut = readmatrix('15_07 TLR/s21mut.csv');
s21_mut(:, 2) = 10.^(s21_mut(:, 2) / 10);
s21_mut(:, 3) = deg2rad(s21_mut(:, 3));
s21_mut(:, 2) = s21_mut(:, 2) .* exp(s21_mut(:, 3) .* 1j);

s21 = (s21_mut(:, 2) - s21_metal(:, 2)) ./ (s21_ar(:, 2) - s21_metal(:, 2)) .* exp(-2 * pi * s21_ar(:, 1) / c * L * 1j);

data = [s11_ar(:, 1) / 10^9, real(s11), imag(s11), real(s21), imag(s21)];
writematrix(data, 'data.txt');

clear
clc
