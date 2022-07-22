clear;
clc;

c = 299792458;
d = 5 * 10^ - 3;
l = 0.82 * 10^ - 3;

%flags
FILT_ON = false; %0->filtering off, 1->filtering on | nao afeta último filtro
FINAL_FILT_ON = true; %0->final filtering off, 1->final filtering on
FINAL_FILT_LOW = false; %1->filtro final lowpass, 0->filtro final movmean | só se aplica quando FINAL_FILT_ON é 1

%%%%%%%%%%%%%%%---*leitura params*---%%%%%%%%%%%%%%%
%%%---*s11*---%%%
%s11 ar
s11_ar = readmatrix('15_07 TLR/s11ar.csv'); %ler ficheiro csv
s11_ar(end, :) = []; %apagar ultima linha -> END csv NaN
s11_ar(:, 2) = 10.^(s11_ar(:, 2) / 10); %converção mod db->linear

if FILT_ON
    s11_ar(:, 2) = lowpass(s11_ar(:, 2), 0.05); %lowpass para reduzir ruído
end

s11_ar(:, 3) = deg2rad(s11_ar(:, 3)); %conversão fase deg->rad
new_col = s11_ar(:, 2) .* exp(s11_ar(:, 3) .* 1j); %param complexo
s11_ar = [s11_ar new_col]; %criar nova coluna com param complexo

%s11 metal
s11_metal = readmatrix('15_07 TLR/s11metal.csv'); %ler ficheiro csv
s11_metal(end, :) = []; %apagar ultima linha -> END csv NaN
s11_metal(:, 2) = 10.^(s11_metal(:, 2) / 10); %converção mod db->linear

if FILT_ON
    s11_metal(:, 2) = lowpass(s11_metal(:, 2), 0.05); %lowpass para reduzir ruído
end

s11_metal(:, 3) = deg2rad(s11_metal(:, 3)); %conversão fase deg->rad
new_col = s11_metal(:, 2) .* exp(s11_metal(:, 3) .* 1j); %param complexo
s11_metal = [s11_metal new_col]; %criar nova coluna com param complexo

%s11 mut
s11_mut = readmatrix('15_07 TLR/s11mut.csv'); %ler ficheiro csv
s11_mut(end, :) = []; %apagar ultima linha -> END csv NaN
s11_mut(:, 2) = 10.^(s11_mut(:, 2) / 10); %converção mod db->linear

if FILT_ON
    s11_mut(:, 2) = lowpass(s11_mut(:, 2), 0.05); %lowpass para reduzir ruído
end

s11_mut(:, 3) = deg2rad(s11_mut(:, 3)); %conversão fase deg->rad
new_col = s11_mut(:, 2) .* exp(s11_mut(:, 3) .* 1j); %param complexo
s11_mut = [s11_mut new_col]; %criar nova coluna com param complexo

%%%---*s21*---%%%
%s21 ar
s21_ar = readmatrix('15_07 TLR/s21ar.csv'); %ler ficheiro csv
s21_ar(end, :) = []; %apagar ultima linha -> END csv NaN
s21_ar(:, 2) = 10.^(s21_ar(:, 2) / 10); %converção mod db->linear

if FILT_ON
    s21_ar(:, 2) = lowpass(s21_ar(:, 2), 0.05); %lowpass para reduzir ruído
end

s21_ar(:, 3) = deg2rad(s21_ar(:, 3)); %conversão fase deg->rad
new_col = s21_ar(:, 2) .* exp(s21_ar(:, 3) .* 1j); %param complexo
s21_ar = [s21_ar new_col]; %criar nova coluna com param complexo

%s21 metal
s21_metal = readmatrix('15_07 TLR/s21metal.csv'); %ler ficheiro csv
s21_metal(end, :) = []; %apagar ultima linha -> END csv NaN
s21_metal(:, 2) = 10.^(s21_metal(:, 2) / 10); %converção mod db->linear

if FILT_ON
    s21_metal(:, 2) = lowpass(s21_metal(:, 2), 0.05); %lowpass para reduzir ruído
end

s21_metal(:, 3) = deg2rad(s21_metal(:, 3)); %conversão fase deg->rad
new_col = s21_metal(:, 2) .* exp(s21_metal(:, 3) .* 1j); %param complexo
s21_metal = [s21_metal new_col]; %criar nova coluna com param complexo

%s21 mut
s21_mut = readmatrix('15_07 TLR/s21mut.csv'); %ler ficheiro csv
s21_mut(end, :) = []; %apagar ultima linha -> END csv NaN
s21_mut(:, 2) = 10.^(s21_mut(:, 2) / 10); %converção mod db->linear

if FILT_ON
    s21_mut(:, 2) = lowpass(s21_mut(:, 2), 0.05); %lowpass para reduzir ruído
end

s21_mut(:, 3) = deg2rad(s21_mut(:, 3)); %conversão fase deg->rad
new_col = s21_mut(:, 2) .* exp(s21_mut(:, 3) .* 1j); %param complexo
s21_mut = [s21_mut new_col]; %criar nova coluna com param complexo

%%%%%%%%%%%%%%%---*calculo params reais (De embbeding)*---%%%%%%%%%%%%%%%
s11_notfilt =- (s11_mut(:, 4) - s11_ar(:, 4)) ./ (s11_metal(:, 4) - s11_ar(:, 4)) .* exp(4 * pi * s11_ar(:, 1) * l * 1j / c);
s11_low = lowpass(s11_notfilt, 0.05);
s11_mean = movmean(s11_notfilt, 60);

s21_notfilt = (s21_mut(:, 4) - s21_metal(:, 4)) ./ (s21_ar(:, 4) - s21_metal(:, 4)) .* exp(-2 * pi * s21_ar(:, 1) * d * 1j / c);
s21_low = lowpass(s21_notfilt, 0.05);
s21_mean = movmean(s21_notfilt, 70);

%%%%%%%%%%%%%%%---*output para NRW*---%%%%%%%%%%%%%%%
if FINAL_FILT_ON

    if FINAL_FILT_LOW
        s11 = s11_low;
        s21 = s21_low;

    else
        s11 = s11_mean;
        s21 = s21_mean;

    end

else
    s11 = s11_notfilt;
    s21 = s21_notfilt;

end

data = [s11_ar(:, 1), real(s11), imag(s11), real(s21), imag(s21)];
writematrix(data, 'data.txt');

%%%%%%%%%%%%%%%---*plots*---%%%%%%%%%%%%%%%
figure
plot(s11_ar(:, 1), abs(s11_notfilt)); title("S11 MUT (PLA)");
hold on
plot(s11_ar(:, 1), abs(s11_low))
hold on
plot(s11_ar(:, 1), abs(s11_mean)); title("S11 MUT (PLA)");
hold off
legend('measured', 'filtered (lowpass wpass = 0.05)', 'filtered (movmean k=60)')

figure
plot(s21_ar(:, 1), abs(s21_notfilt)); title("S21 MUT (PLA)");
hold on
plot(s21_ar(:, 1), abs(s21_low))
hold on
plot(s21_ar(:, 1), abs(s21_mean))
hold off

legend('measured', 'filtered (lowpass wpass = 0.05)', 'filtered (movmean k=70)')

clear
clc
