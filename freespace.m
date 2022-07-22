clear;
clc;

%flags
FILT_ON = true %0->filtering off, 1->filtering on
FILT_LOW = false; %1->filtro final lowpass, 0->filtro final movmean | só se aplica quando FILT_ON é 1

%%%%%%%%%%%%%%%---*leitura params*---%%%%%%%%%%%%%%%
%%%---*s11*---%%%
s11_notfilt = readmatrix('21_07 Free Space/s11mut.csv'); %ler ficheiro csv
s11_notfilt(end, :) = []; %apagar ultima linha -> END csv NaN
s11_notfilt(:, 2) = 10.^(s11_notfilt(:, 2) / 10); %converção mod db->linear
s11_notfilt(:, 3) = deg2rad(s11_notfilt(:, 3)); %conversão fase deg->rad
new_col = s11_notfilt(:, 2) .* exp(s11_notfilt(:, 3) .* 1j); %param complexo
s11_notfilt = [s11_notfilt new_col]; %criar nova coluna com param complexo

%%%---*s21*---%%%
s21_notfilt = readmatrix('21_07 Free Space/s21mut.csv'); %ler ficheiro csv
s21_notfilt(end, :) = []; %apagar ultima linha -> END csv NaN
s21_notfilt(:, 2) = 10.^(s21_notfilt(:, 2) / 10); %converção mod db->linear
s21_notfilt(:, 3) = deg2rad(s21_notfilt(:, 3)); %conversão fase deg->rad
new_col = s21_notfilt(:, 2) .* exp(s21_notfilt(:, 3) .* 1j); %param complexo
s21_notfilt = [s21_notfilt new_col]; %criar nova coluna com param complexo

%%%---*s12*---%%%
s12_notfilt = readmatrix('21_07 Free Space/s12mut.csv'); %ler ficheiro csv
s12_notfilt(end, :) = []; %apagar ultima linha -> END csv NaN
s12_notfilt(:, 2) = 10.^(s12_notfilt(:, 2) / 10); %converção mod db->linear
s12_notfilt(:, 3) = deg2rad(s12_notfilt(:, 3)); %conversão fase deg->rad
new_col = s12_notfilt(:, 2) .* exp(s12_notfilt(:, 3) .* 1j); %param complexo
s12_notfilt = [s12_notfilt new_col]; %criar nova coluna com param complexo

%%%---*s22*---%%%
s22_notfilt = readmatrix('21_07 Free Space/s22mut.csv'); %ler ficheiro csv
s22_notfilt(end, :) = []; %apagar ultima linha -> END csv NaN
s22_notfilt(:, 2) = 10.^(s22_notfilt(:, 2) / 10); %converção mod db->linear
s22_notfilt(:, 3) = deg2rad(s22_notfilt(:, 3)); %conversão fase deg->rad
new_col = s22_notfilt(:, 2) .* exp(s22_notfilt(:, 3) .* 1j); %param complexo
s22_notfilt = [s22_notfilt new_col]; %criar nova coluna com param complexo

%%%%%%%%%%%%%%%---*output para NRW*---%%%%%%%%%%%%%%%
if FILT_ON

    if FILT_LOW
        s11 = lowpass(s11_notfilt, 0.05);
        s21 = lowpass(s21_notfilt, 0.05);
        s12 = lowpass(s12_notfilt, 0.05);
        s22 = lowpass(s22_notfilt, 0.05);

    else
        s11 = movmean(s11_notfilt, 60);
        s21 = movmean(s21_notfilt, 70);
        s12 = movmean(s12_notfilt, 60);
        s22 = movmean(s22_notfilt, 60);

    end

else
    s11 = s11_notfilt;
    s21 = s21_notfilt;
    s12 = s12_notfilt;
    s22 = s22_notfilt;

end

%data = [s11(:, 1), real(s11(:, 4)), imag(s11(:, 4)), real(s21(:, 4)), imag(s21(:, 4)), real(s12(:, 4)), imag(s12(:, 4)), real(s22(:, 4)), imag(s22(:, 4))];
data = [s11(:, 1), real(s11(:, 4)), imag(s11(:, 4)), real(s21(:, 4)), imag(s21(:, 4))];
writematrix(data, 'data.txt');

%%%%%%%%%%%%%%%---*plots*---%%%%%%%%%%%%%%%
figure
plot(s11(:, 1), abs(s11_notfilt(:, 4))); title("S11 MUT (PLA)");
hold on
plot(s11(:, 1), abs(s11(:, 4))); title("S11 MUT (PLA)");
hold off
legend('measured', 'filtered')

figure
plot(s21(:, 1), abs(s21_notfilt(:, 4))); title("S21 MUT (PLA)");
hold on
plot(s21(:, 1), abs(s21(:, 4)))
hold off

legend('measured', 'filtered')

clear
clc
