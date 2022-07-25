%%% FLAGS %%%
GAUSS_ON = true;
LOW_ON = true;
MEAN_ON = false;



%%% READ DATA %%%
%[f, s11_notfilt] = read_Sparam('21_07 Free Space/s11mut.csv');
%[f, s12_notfilt] = read_Sparam('21_07 Free Space/s12mut.csv');
%[f, s21_notfilt] = read_Sparam('21_07 Free Space/s21mut.csv');
%[f, s22_notfilt] = read_Sparam('21_07 Free Space/s22mut.csv');
[f, s11_notfilt] = read_Sparam('33GHz_d31_8cm/s11_2.csv');
[f, s12_notfilt] = read_Sparam('33GHz_d31_8cm/s12.csv');
[f, s21_notfilt] = read_Sparam('33GHz_d31_8cm/s21.csv');
[f, s22_notfilt] = read_Sparam('33GHz_d31_8cm/s22.csv');

s11 = s11_notfilt;
s12 = s12_notfilt;
s21 = s21_notfilt;
s22 = s22_notfilt;

%%% APPLY GAUSSIAN FILTER %%%
if LOW_ON
  s11 = lowpass(s11, 0.05);
  s21 = lowpass(s21, 0.05);
  s12 = lowpass(s12, 0.05);
  s22 = lowpass(s22, 0.05);
end
if GAUSS_ON 
  w = gausswin(10);
  w = w / sum(w);
  s11 = filter(w, 1, s11);
  s12 = filter(w, 1, s12);
  s21 = filter(w, 1, s21);
  s22 = filter(w, 1, s22);
end

if MEAN_ON
  s11 = movmean(s11, 10);
  s12 = movmean(s12, 10);
  s21 = movmean(s21, 10);
  s22 = movmean(s22, 10);
end

%%% SAVE DATA %%%
data = [f, real(s11), imag(s11), real(s21), imag(s21)];
writematrix(data, 'gaussdata.txt');

%%% PLOTS %%%
%%% Real Part s11 %%%
figure
plot(f, real(s11_notfilt));
hold on
plot(f, real(s11));
hold off
title('Real Part of S11');
legend('Not filtred', 'Filtred');
%xlim([2.2e10 2.75e10]);

%%% Imaginary Part s11 %%%
figure
plot(f, imag(s11_notfilt));
hold on
plot(f, imag(s11));
hold off
title('Imaginary Part of S11');
legend('Not filtred', 'Filtred');
%xlim([2.2e10 2.75e10]);

%%% Real Part s21 %%%
figure
plot(f, real(s21_notfilt));
hold on
plot(f, real(s21));
hold off
title('Real Part of S21');
legend('Not filtred', 'Filtred');
%xlim([2.2e10 2.75e10]);

%%% Real Part s21 %%%
figure
plot(f, imag(s21_notfilt));
hold on
plot(f, imag(s21));
hold off
title('Imaginary Part of S21');
legend('Not filtred', 'Filtred');
%xlim([2.2e10 2.75e10]);

function [f, s] = read_Sparam(filename)
  s = readmatrix(filename);
  s(end, :) = [];
  f = s(:, 1);
  norm = 10.^(s(:, 2) ./ 10);
  s = norm .* exp(deg2rad(s(:, 3)) * 1j);
end
