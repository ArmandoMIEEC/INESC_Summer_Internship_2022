clear;
clc;

%Reading data
data = readmatrix('data.txt');

%Data format: [f(GHz), Re[s11], Im[s11], Re[s21], Im[s21]]

%Parameters
L = 0.5 * 10^ - 3;
freq = data(:, 1) * 10^9;
s11 = data(:, 2) + 1i * data(:, 3);
s21 = data(:, 4) + 1i * data(:, 5);
c = 299792458;

%%%---***Reflection Coeficient Calculation***---%%%
X = (s11.^2 - s21.^2 + 1) ./ (2 * s11);
Gama_plus = X + sqrt(X.^2 - 1);
Gama_minus = X - sqrt(X.^2 - 1);

for i = 1:length(X)

    if abs(Gama_plus(i)) < 1
        Gama(i) = Gama_plus(i);
    else
        Gama(i) = Gama_minus(i);
    end

end

%%%---***Transmition Coeficient Calculation***---%%%
T = (s11 + s21 - Gama) ./ (1 - (s11 + s21) .* Gama);

%%%---***N parameter calculation***---%%%
n = %group delay

%%%---***Permeability calculation***---%%%

log_inv_T = log(abs(1 ./ T)) + 1j * (angle(1 ./ T) + 2 * n * pi);

inv_Lambda2 =- (1 / (2 * pi * L) * log_inv_T).^2;
inv_Lambda = ones(length(inv_Lambda2), 1);

for i = 1:length(inv_Lambda2)

    if real(sqrt(inv_Lambda2(i))) > 0
        inv_Lambda(i) = sqrt(inv_Lambda2(i));
    else
        inv_Lambda(i) = -sqrt(inv_Lambda2(i));
    end

end

mu = (1 + Gama) .* inv_Lambda ./ ((1 - Gama) .* c ./ freq); % Ver cutoff frequencys
epsilon = (c ./ freq).^2 ./ mu .* inv_Lambda2;

disp(Gama)
disp("freq:");
disp(freq(1));
disp("s11:");
disp(s11(1));
disp("s21:");
disp(s21(1));
disp("X:");
disp(X(1));
disp("Gama:");
disp(Gama(1));
disp("Gama_plus:");
disp(Gama_plus(1));
disp("Gama_minus:");
disp(Gama_minus(1));
disp("Gama_plus abs:");
disp(abs(Gama_plus(1)));
disp("Gama_minus abs:");
disp(abs(Gama_minus(1)));
