y = [0.015, 2, 4, 6, 8, 10, 12, 13, 15, 18, 22, 27, 33, 40, 48, 57, 59, 63, ...
        69, 77, 87, 99, 113, 114, 116, 119, 123, 128, 134, 141, 149, 151.5, ...
        156.5, 164, 174, 186.5, 200.5, 204.5, 209.5, 212.5, 221.5, 226.5, ...
        232.5, 249.5, 237.5, 267, 275, 298.5, 320.5, 335, 342];
x = [0.1, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6, 6.5, 7, 7.5, ...
        8, 8.5, 9, 9.5, 10, 10.5, 11, 11.5, 12, 12.5, 13, 13.5, 14, 14.5, ...
        15, 15.5, 16, 16.5, 17, 17.5, 18, 18.5, 19, 19.5, 20, 20.5, 21, ...
        21.5, 22, 22.5, 23, 23.5, 24, 24.5, 25];

figure(1);
plot(x, y, 'o-');
xlabel('Время');
ylabel('Результаты измерений');
title('Зависимость результатов измерений от времени');
grid on;

order = 4; % максимальный порядок полинома
S_values = zeros(order, 1);   % Массив для хранения значений СКО
fit_results = cell(order, 1); % Ячейковый массив для хранения результатов аппроксимации

for n = 1:order
    % Подходящий полином
    p = polyfit(x, y, n);
    % Вычисление аппроксимированных значений
    y_fit = polyval(p, x);
    % Вычисление СКО
    S = sqrt(sum((y - y_fit).^2) / length(y));
    S_values(n) = S;
    % Сохранение результатов
    fit_results{n} = struct('coefficients', p, 'y_fit', y_fit);
    % График
    figure(n+1);
    plot(x, y, 'o', x, y_fit, '-');
    title(sprintf('Аппроксимация полиномом порядка %g', n));
    xlabel('Время');
    ylabel('Результаты измерений');
    legend('Данные', 'Аппроксимация');
    grid on;
end

result_table = table((1:order)', S_values, 'VariableNames', {'Порядок', 'СКО'});
result_table.Properties.RowNames = {'Линейная', 'Квадратичная', 'Третья', 'Четвертая'};
disp(result_table);

figure(order + 2);
plot(1:order, S_values, 'o-');
xlabel('Порядок полинома');
ylabel('СКО');
title('Зависимость СКО от порядка полинома');
grid on;

[min_S, best_order] = min(S_values);
best_fit = fit_results{best_order};
fprintf('Наилучший порядок: %d, СКО: %.4f\n', best_order, min_S);
disp('Коэффициенты аппроксимации:');
disp(best_fit.coefficients);


figure(order + 3);
plot(x, y, 'o', x, best_fit.y_fit, '-');
hold on;
best_S = S_values(best_order);
% Вычисление границ по критерию Романовского
Y_min = best_fit.y_fit - 3 * best_S;
Y_max = best_fit.y_fit + 3 * best_S;
plot(x, Y_min, '--r');
plot(x, Y_max, '--b');
title(sprintf('Наилучшая аппроксимация полиномом порядка %g с границами по критерию Романовского', best_order));
xlabel('Время');
ylabel('Результаты измерений');
legend('Данные', 'Аппроксимация', 'Y_{min}', 'Y_{max}');
grid on;
hold off;

outliers = (y < Y_min) | (y > Y_max);
outlier_table = table(x(outliers)', y(outliers)', 'VariableNames', {'x', 'y'});
disp('Выбросы:');
disp(outlier_table);
% Исключение выбросов из данных
cleaned_x = x(~outliers);
cleaned_y = y(~outliers);

figure(order + 4);
plot(cleaned_x, cleaned_y, 'o');
hold on;
% Построение наилучшей аппроксимации для данных без выбросов
cleaned_best_fit = polyfit(cleaned_x, cleaned_y, best_order);
cleaned_y_fit = polyval(cleaned_best_fit, cleaned_x);
plot(cleaned_x, cleaned_y_fit, '-');
% Построение новых границ для данных без выбросов
cleaned_best_S = sqrt(sum((cleaned_y - cleaned_y_fit).^2) / length(cleaned_y));
cleaned_Y_min = cleaned_y_fit - 3 * cleaned_best_S;
cleaned_Y_max = cleaned_y_fit + 3 * cleaned_best_S;
% Границы Романовского
plot(cleaned_x, cleaned_Y_min, '--r');
plot(cleaned_x, cleaned_Y_max, '--b');
title('График без выбросов с новой аппроксимацией и границами');
xlabel('Время');
ylabel('Результаты измерений');
legend('Данные  (без выбросов)', 'Аппроксимация (без выбросов)', 'Y_{min} (без выбросов)', 'Y_{max} (без выбросов)');
grid on;
hold off;







