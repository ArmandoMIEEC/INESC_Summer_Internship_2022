clear;
clc;

ant_218 = readmatrix('antena_grande.csv');
ant_2233 = readmatrix('antena_pequena.csv');

figure
plot(ant_2233(:, 1) ./ 10^9, ant_2233(:, 7), 'LineWidth', 2);
title('Antena 22-33GHz', 'FontSize', 26);
grid();
xlabel('Frequência (GHz)');
ylabel('Lado da amostra (cm)');
set(gca, 'FontSize', 20);

figure
plot(ant_218(:, 1) ./ 10^9, ant_218(:, 7), 'LineWidth', 2);
title('Antena 2-18GHz', 'FontSize', 26);
grid();
xlabel('Frequência (GHz)');
ylabel('Lado da amostra (cm)');
set(gca, 'FontSize', 20);

figure
plot(ant_2233(:, 1) ./ 10^9, ant_2233(:, 2) .* 100, 'LineWidth', 2);
title('Antena 22-33GHz', 'FontSize', 26);
grid();
xlabel('Frequência (GHz)');
ylabel('Distânica até à amostra (cm)');
set(gca, 'FontSize', 20);

figure
plot(ant_218(:, 1) ./ 10^9, ant_218(:, 2), 'LineWidth', 2);
title('Antena 2-18GHz', 'FontSize', 26);
grid();
xlabel('Frequência (GHz)');
ylabel('Distânica até à amostra (m)');
set(gca, 'FontSize', 20);
