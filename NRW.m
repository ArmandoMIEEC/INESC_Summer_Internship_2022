clear;
clc;

%Reading data
data = readmatrix('data.txt');

%Data format: [f(GHz), Re[s11], Im[s11], Re[s21], Im[s21]]

%Parameters
L = 5 * 10^ - 3;
freq = data(:, 1);
s11 = data(:, 2) + 1i * data(:, 3);
s21 = data(:, 4) + 1i * data(:, 5);
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


Lambda = (1 + Gama) ./ ((1 - Gama) .* (freq ./ c));
Er = (c^2 ./ freq.^2) .* (1 ./ Lambda.^2);

figure
plot(freq, real(Er));
title("permitividade");

n = 1 / (2 * pi) .* (- 4 * pi^2 * L^2 ./ (2 * log(abs(1./T))) .* imag(((1-Gama) ./ (1+Gama)).^2 .* (freq ./ c).^2) - angle(1./T));
figure
plot(freq, n);
hold on
n = 1 / (2*pi) * (sqrt(real(((1 - Gama) ./ (1 + Gama)).^2 .* (freq / c).^2) * 4 * pi^2 * L^2 + (log(abs(1 ./ T).^2))) - angle(1./T));
plot(freq, n);
hold off
legend('imag', 'real');
 
%{
n = fix(L * freq / c);
%n = ones(length(freq), 1);
%n = 500;
log_inv_T = log(abs(1 ./ T)) + 1j * (angle(1 ./ T) + 2 * n * pi);

inv_Lambda2 =- (1 / (2 * pi * L) .* log_inv_T).^2;
inv_Lambda = ones(length(inv_Lambda2), 1);

for i = 1:length(inv_Lambda2)

    if real(sqrt(inv_Lambda2(i))) > 0
        inv_Lambda(i) = sqrt(inv_Lambda2(i));
    else
        inv_Lambda(i) = -sqrt(inv_Lambda2(i));
    end

end

mu = (1 + Gama) .* inv_Lambda ./ ((1 - Gama) .* c ./ freq);
epsilon = (c ./ freq).^2 ./ mu .* inv_Lambda2;

% Saving the results
results = array2table([freq ./ 10^9, mu, epsilon], 'VariableNames', ["f_GHz", "mu", "epsilon"]);
writetable(results, 'Results.txt');

%plots
figure
plot(results.f_GHz, real(results.mu));
hold on
plot(results.f_GHz, imag(results.mu));
hold off
title('Permeabilidade da Amostra');
xlabel('f (GHz)');
ylabel('Permeabilidade Relativa');
legend("Parte Real", "Parte Imaginária")

figure
plot(results.f_GHz, real(results.epsilon));
hold on
plot(results.f_GHz, imag(results.epsilon));
hold off
title('Permitividade da Amostra');
xlabel('f (GHz)');
ylabel('Permitividade Relativa');
legend("Parte Real", "Parte Imaginária")

clear;
clc;
%}