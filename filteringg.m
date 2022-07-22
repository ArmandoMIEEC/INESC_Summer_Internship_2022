clear;

%ler ficheiro
S21mut = readmatrix('s21mut.csv');
S21mut(end, :) = []; % apaga ultima linha

%disp(S21mut(:,1))
plot(S21mut(:, 1), S21mut(:, 2))

%extrapolaçao
f1 = S21mut(1, 1);
f2 = S21mut(end, 1);

%delta_F = 2.5 / (f2- f1);
delta_F = 0.5e+10; %
f1e = f1 - delta_F;
f2e = f2 + delta_F;

x_ant = linspace(f1e, f1, 500);
x_pos = linspace(f2, f2e, 500);

y1 = gaussmf(x_ant, [0.1e10 2.2e10]);
plot(x_ant, y1)
hold on

plot(S21mut(:, 1), S)

y2 = gaussmf(x_pos, [0.1e10 3.3e10]);
%plot(x_pos,y2)

%Se = horzcat(y1, S21mut(:, 2), y2);

%antes de passar para time-domain
N = 1024;
window = fft(kbdwin(N));
Sw = Se * window2;

%time domain
s_t = czt(Sw);
