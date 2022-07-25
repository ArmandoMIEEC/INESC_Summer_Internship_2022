clear;
clc;

%flags
FILT_ON = true; %0->filtering off, 1->filtering on
FILT_LOW = false; %1->filtro final lowpass, 0->filtro final movmean | só se aplica quando FILT_ON é 1

%%%%%%%%%%%%%%%---*leitura params*---%%%%%%%%%%%%%%%
%%%---*s11*---%%%
s11_notfilt = readmatrix('33GHz_d31_8cm_22_07_Free_Space/s11.csv'); %ler ficheiro csv
s11_notfilt(end, :) = []; %apagar ultima linha -> END csv NaN
s11_notfilt(:, 2) = 10.^(s11_notfilt(:, 2) / 10); %converção mod db->linear
s11_notfilt(:, 3) = deg2rad(s11_notfilt(:, 3)); %conversão fase deg->rad
new_col = [s11_notfilt(:, 2) .* cos(s11_notfilt(:, 3)), s11_notfilt(:, 2) .* sin(s11_notfilt(:, 3))]; %criar duas novas colunas (parte real, parte imaginária)
s11_notfilt = [s11_notfilt, new_col];

%%%---*s21*---%%%
s21_notfilt = readmatrix('33GHz_d31_8cm_22_07_Free_Space/s21.csv'); %ler ficheiro csv
s21_notfilt(end, :) = []; %apagar ultima linha -> END csv NaN
s21_notfilt(:, 2) = 10.^(s21_notfilt(:, 2) / 10); %converção mod db->linear
s21_notfilt(:, 3) = deg2rad(s21_notfilt(:, 3)); %conversão fase deg->rad
new_col = [s21_notfilt(:, 2) .* cos(s21_notfilt(:, 3)), s21_notfilt(:, 2) .* sin(s21_notfilt(:, 3))]; %criar duas novas colunas (parte real, parte imaginária)
s21_notfilt = [s21_notfilt, new_col];

%%%---*s12*---%%%
s12_notfilt = readmatrix('33GHz_d31_8cm_22_07_Free_Space/s12.csv'); %ler ficheiro csv
s12_notfilt(end, :) = []; %apagar ultima linha -> END csv NaN
s12_notfilt(:, 2) = 10.^(s12_notfilt(:, 2) / 10); %converção mod db->linear
s12_notfilt(:, 3) = deg2rad(s12_notfilt(:, 3)); %conversão fase deg->rad
new_col = [s12_notfilt(:, 2) .* cos(s12_notfilt(:, 3)), s12_notfilt(:, 2) .* sin(s12_notfilt(:, 3))]; %criar duas novas colunas (parte real, parte imaginária)
s12_notfilt = [s12_notfilt, new_col];

%%%---*s22*---%%%
s22_notfilt = readmatrix('33GHz_d31_8cm_22_07_Free_Space/s22.csv'); %ler ficheiro csv
s22_notfilt(end, :) = []; %apagar ultima linha -> END csv NaN
s22_notfilt(:, 2) = 10.^(s22_notfilt(:, 2) / 10); %converção mod db->linear
s22_notfilt(:, 3) = deg2rad(s22_notfilt(:, 3)); %conversão fase deg->rad
new_col = [s22_notfilt(:, 2) .* cos(s22_notfilt(:, 3)), s22_notfilt(:, 2) .* sin(s22_notfilt(:, 3))]; %criar duas novas colunas (parte real, parte imaginária)
s22_notfilt = [s22_notfilt, new_col];

%%%%%%%%%%%%%%%---*output para NRW*---%%%%%%%%%%%%%%%
if FILT_ON

    if FILT_LOW
        s11 = [lowpass(s11_notfilt(:, 4), 0.05), lowpass(s11_notfilt(:, 5), 0.05)];
        s21 = [lowpass(s21_notfilt(:, 4), 0.05), lowpass(s21_notfilt(:, 5), 0.05)];
        s12 = [lowpass(s12_notfilt(:, 4), 0.05), lowpass(s12_notfilt(:, 5), 0.05)];
        s22 = [lowpass(s22_notfilt(:, 4), 0.05), lowpass(s22_notfilt(:, 5), 0.05)];

    else
        s11 = [movmean(s11_notfilt(:, 4), 60), movmean(s11_notfilt(:, 5), 60)];
        s21 = [movmean(s21_notfilt(:, 4), 60), movmean(s21_notfilt(:, 5), 60)];
        s12 = [movmean(s12_notfilt(:, 4), 60), movmean(s12_notfilt(:, 5), 60)];
        s22 = [movmean(s22_notfilt(:, 4), 60), movmean(s22_notfilt(:, 5), 60)];

    end

else
    s11 = [s11_notfilt(:, 4), s11_notfilt(:, 5)];
    s21 = [s21_notfilt(:, 4), s21_notfilt(:, 5)];
    s12 = [s12_notfilt(:, 4), s12_notfilt(:, 5)];
    s22 = [s22_notfilt(:, 4), s22_notfilt(:, 5)];

end

%data = [s11(:, 1), real(s11(:, 4)), imag(s11(:, 4)), real(s21(:, 4)), imag(s21(:, 4)), real(s12(:, 4)), imag(s12(:, 4)), real(s22(:, 4)), imag(s22(:, 4))];
data = [s11_notfilt(:, 1), s11(:, 1), s11(:, 2), s21(:, 1), s21(:, 2)];
writematrix(data, 'data.txt');

%%%%%%%%%%%%%%%---*plots*---%%%%%%%%%%%%%%%
figure
plot(s11_notfilt(:, 1), s11_notfilt(:, 4)); title("S11 MUT (PLA) REAL");
hold on
plot(s11_notfilt(:, 1), s11(:, 1)); title("S11 MUT (PLA) REAL");
hold off
legend('measured', 'filtered')
xlim([2.2e10 2.75e10])

figure
plot(s11_notfilt(:, 1), s11_notfilt(:, 5)); title("S11 MUT (PLA) IMAG");
hold on
plot(s11_notfilt(:, 1), s11(:, 2)); title("S11 MUT (PLA) IMAG");
hold off
legend('measured', 'filtered')
xlim([2.2e10 2.75e10])

figure
plot(s11_notfilt(:, 1), s21_notfilt(:, 4)); title("S21 MUT (PLA) REAL");
hold on
plot(s11_notfilt(:, 1), s21(:, 1))
hold off

legend('measured', 'filtered')
xlim([2.2e10 2.75e10])

figure
plot(s11_notfilt(:, 1), s11_notfilt(:, 5)); title("S11 MUT (PLA) IMAG");
hold on
plot(s11_notfilt(:, 1), s11(:, 2)); title("S11 MUT (PLA) IMAG");
hold off
legend('measured', 'filtered')
xlim([2.2e10 2.75e10])
