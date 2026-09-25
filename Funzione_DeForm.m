function programma_letteraM
% Codice MATLAB per animare la deformazione della lettera 'M' con controlli interattivi
% Visualizza contemporaneamente la configurazione originale, le piccole deformazioni e le grandi deformazioni

clc; close all;

%% Definizione della Lettera 'M'

% Spessore della lettera 'M' lungo l'asse z
t = 0.2;

% Definizione dei punti della lettera 'M' nel piano XY (z = 0)
base_points = [
    0, 0;
    0, 1;
    0.5, 0.5;
    1, 1;
    1, 0
    ];

% Numero di punti
num_base_points = size(base_points, 1);

% Creazione dei punti inferiori (z = 0)
lower_points = [base_points, zeros(num_base_points, 1)];

% Creazione dei punti superiori (z = t)
upper_points = [base_points, t * ones(num_base_points, 1)];

% Combinazione dei punti
X = [lower_points; upper_points]';

%% Creazione delle linee per la Lettera 'M'

% Linee che connettono i punti per formare la lettera 'M'
line_indices = [
    % Lati inferiori
    1, 2;
    2, 3;
    3, 4;
    4, 5;
    % Lati superiori (z = t)
    6, 7;
    7, 8;
    8, 9;
    9, 10;
    % Collegamenti verticali tra punti inferiori e superiori
    1, 6;
    2, 7;
    3, 8;
    4, 9;
    5, 10
    ];

%% Creazione della figura e dei controlli interattivi

% Creazione della figura
figure('Color', 'white', 'Position', [100, 100, 1000, 600]);

% Assicurarsi che il renderer sia impostato correttamente
set(gcf, 'Renderer', 'painters');

% Creazione dell'asse per l'animazione
axesAnim = axes('Units', 'normalized', 'Position', [0.05, 0.2, 0.6, 0.75]);

% Impostazione delle proprietà dell'asse
x_limits = [-1, 2];
y_limits = [-1, 2];
z_limits = [-1, 2];

xlim(axesAnim, x_limits);
ylim(axesAnim, y_limits);
zlim(axesAnim, z_limits);
axis(axesAnim, 'equal');
grid(axesAnim, 'on');
view(axesAnim, 30, 20);
xlabel(axesAnim, 'X');
ylabel(axesAnim, 'Y');
zlabel(axesAnim, 'Z');
title(axesAnim, 'Deformazione Interattiva della Lettera ''M'' in 3D');

%% Inizializzazione dei Parametri di Deformazione

% Valori iniziali
theta_x = 0;
theta_y = 0;
theta_z = 0;

gamma_xy = 0;
gamma_xz = 0;
gamma_yz = 0;

epsilon_xx = 0;
epsilon_yy = 0;
epsilon_zz = 0;

%% Creazione degli slider per i parametri di deformazione

% Posizioni e dimensioni degli slider
sliderWidth = 0.2;
sliderHeight = 0.03;
sliderX = 0.65;
sliderYStart = 0.8;
sliderYSpacing = 0.05;

% Struttura per memorizzare i riferimenti alle caselle di testo dei valori
valueTexts = struct();

% Slider per theta_x
slider_theta_x = uicontrol('Style', 'slider', 'Min', -pi, 'Max', pi, 'Value', theta_x, ...
    'Units', 'normalized', 'Position', [sliderX, sliderYStart, sliderWidth, sliderHeight], ...
    'Callback', @updatePlot);
uicontrol('Style', 'text', 'Units', 'normalized', ...
    'Position', [sliderX, sliderYStart + sliderHeight, sliderWidth, 0.02], ...
    'String', '\theta_x', 'BackgroundColor', 'white');
valueTexts.theta_x = uicontrol('Style', 'text', 'Units', 'normalized', ...
    'Position', [sliderX + sliderWidth + 0.01, sliderYStart, 0.05, sliderHeight], ...
    'String', num2str(theta_x, '%.2f'), 'BackgroundColor', 'white');

% Slider per theta_y
slider_theta_y = uicontrol('Style', 'slider', 'Min', -pi, 'Max', pi, 'Value', theta_y, ...
    'Units', 'normalized', 'Position', [sliderX, sliderYStart - sliderYSpacing, sliderWidth, sliderHeight], ...
    'Callback', @updatePlot);
uicontrol('Style', 'text', 'Units', 'normalized', ...
    'Position', [sliderX, sliderYStart - sliderYSpacing + sliderHeight, sliderWidth, 0.02], ...
    'String', '\theta_y', 'BackgroundColor', 'white');
valueTexts.theta_y = uicontrol('Style', 'text', 'Units', 'normalized', ...
    'Position', [sliderX + sliderWidth + 0.01, sliderYStart - sliderYSpacing, 0.05, sliderHeight], ...
    'String', num2str(theta_y, '%.2f'), 'BackgroundColor', 'white');

% Slider per theta_z
slider_theta_z = uicontrol('Style', 'slider', 'Min', -pi, 'Max', pi, 'Value', theta_z, ...
    'Units', 'normalized', 'Position', [sliderX, sliderYStart - 2 * sliderYSpacing, sliderWidth, sliderHeight], ...
    'Callback', @updatePlot);
uicontrol('Style', 'text', 'Units', 'normalized', ...
    'Position', [sliderX, sliderYStart - 2 * sliderYSpacing + sliderHeight, sliderWidth, 0.02], ...
    'String', '\theta_z', 'BackgroundColor', 'white');
valueTexts.theta_z = uicontrol('Style', 'text', 'Units', 'normalized', ...
    'Position', [sliderX + sliderWidth + 0.01, sliderYStart - 2 * sliderYSpacing, 0.05, sliderHeight], ...
    'String', num2str(theta_z, '%.2f'), 'BackgroundColor', 'white');

% Slider per gamma_xy
slider_gamma_xy = uicontrol('Style', 'slider', 'Min', -1, 'Max', 1, 'Value', gamma_xy, ...
    'Units', 'normalized', 'Position', [sliderX, sliderYStart - 3 * sliderYSpacing, sliderWidth, sliderHeight], ...
    'Callback', @updatePlot);
uicontrol('Style', 'text', 'Units', 'normalized', ...
    'Position', [sliderX, sliderYStart - 3 * sliderYSpacing + sliderHeight, sliderWidth, 0.02], ...
    'String', '\gamma_{xy}', 'BackgroundColor', 'white');
valueTexts.gamma_xy = uicontrol('Style', 'text', 'Units', 'normalized', ...
    'Position', [sliderX + sliderWidth + 0.01, sliderYStart - 3 * sliderYSpacing, 0.05, sliderHeight], ...
    'String', num2str(gamma_xy, '%.2f'), 'BackgroundColor', 'white');

% Slider per gamma_xz
slider_gamma_xz = uicontrol('Style', 'slider', 'Min', -1, 'Max', 1, 'Value', gamma_xz, ...
    'Units', 'normalized', 'Position', [sliderX, sliderYStart - 4 * sliderYSpacing, sliderWidth, sliderHeight], ...
    'Callback', @updatePlot);
uicontrol('Style', 'text', 'Units', 'normalized', ...
    'Position', [sliderX, sliderYStart - 4 * sliderYSpacing + sliderHeight, sliderWidth, 0.02], ...
    'String', '\gamma_{xz}', 'BackgroundColor', 'white');
valueTexts.gamma_xz = uicontrol('Style', 'text', 'Units', 'normalized', ...
    'Position', [sliderX + sliderWidth + 0.01, sliderYStart - 4 * sliderYSpacing, 0.05, sliderHeight], ...
    'String', num2str(gamma_xz, '%.2f'), 'BackgroundColor', 'white');

% Slider per gamma_yz
slider_gamma_yz = uicontrol('Style', 'slider', 'Min', -1, 'Max', 1, 'Value', gamma_yz, ...
    'Units', 'normalized', 'Position', [sliderX, sliderYStart - 5 * sliderYSpacing, sliderWidth, sliderHeight], ...
    'Callback', @updatePlot);
uicontrol('Style', 'text', 'Units', 'normalized', ...
    'Position', [sliderX, sliderYStart - 5 * sliderYSpacing + sliderHeight, sliderWidth, 0.02], ...
    'String', '\gamma_{yz}', 'BackgroundColor', 'white');
valueTexts.gamma_yz = uicontrol('Style', 'text', 'Units', 'normalized', ...
    'Position', [sliderX + sliderWidth + 0.01, sliderYStart - 5 * sliderYSpacing, 0.05, sliderHeight], ...
    'String', num2str(gamma_yz, '%.2f'), 'BackgroundColor', 'white');

% Slider per epsilon_xx
slider_epsilon_xx = uicontrol('Style', 'slider', 'Min', -1, 'Max', 1, 'Value', epsilon_xx, ...
    'Units', 'normalized', 'Position', [sliderX, sliderYStart - 6 * sliderYSpacing, sliderWidth, sliderHeight], ...
    'Callback', @updatePlot);
uicontrol('Style', 'text', 'Units', 'normalized', ...
    'Position', [sliderX, sliderYStart - 6 * sliderYSpacing + sliderHeight, sliderWidth, 0.02], ...
    'String', '\epsilon_{xx}', 'BackgroundColor', 'white');
valueTexts.epsilon_xx = uicontrol('Style', 'text', 'Units', 'normalized', ...
    'Position', [sliderX + sliderWidth + 0.01, sliderYStart - 6 * sliderYSpacing, 0.05, sliderHeight], ...
    'String', num2str(epsilon_xx, '%.2f'), 'BackgroundColor', 'white');

% Slider per epsilon_yy
slider_epsilon_yy = uicontrol('Style', 'slider', 'Min', -1, 'Max', 1, 'Value', epsilon_yy, ...
    'Units', 'normalized', 'Position', [sliderX, sliderYStart - 7 * sliderYSpacing, sliderWidth, sliderHeight], ...
    'Callback', @updatePlot);
uicontrol('Style', 'text', 'Units', 'normalized', ...
    'Position', [sliderX, sliderYStart - 7 * sliderYSpacing + sliderHeight, sliderWidth, 0.02], ...
    'String', '\epsilon_{yy}', 'BackgroundColor', 'white');
valueTexts.epsilon_yy = uicontrol('Style', 'text', 'Units', 'normalized', ...
    'Position', [sliderX + sliderWidth + 0.01, sliderYStart - 7 * sliderYSpacing, 0.05, sliderHeight], ...
    'String', num2str(epsilon_yy, '%.2f'), 'BackgroundColor', 'white');

% Slider per epsilon_zz
slider_epsilon_zz = uicontrol('Style', 'slider', 'Min', -1, 'Max', 1, 'Value', epsilon_zz, ...
    'Units', 'normalized', 'Position', [sliderX, sliderYStart - 8 * sliderYSpacing, sliderWidth, sliderHeight], ...
    'Callback', @updatePlot);
uicontrol('Style', 'text', 'Units', 'normalized', ...
    'Position', [sliderX, sliderYStart - 8 * sliderYSpacing + sliderHeight, sliderWidth, 0.02], ...
    'String', '\epsilon_{zz}', 'BackgroundColor', 'white');
valueTexts.epsilon_zz = uicontrol('Style', 'text', 'Units', 'normalized', ...
    'Position', [sliderX + sliderWidth + 0.01, sliderYStart - 8 * sliderYSpacing, 0.05, sliderHeight], ...
    'String', num2str(epsilon_zz, '%.2f'), 'BackgroundColor', 'white');

%% Visualizzazione Iniziale

% Chiamata iniziale alla funzione di aggiornamento
updatePlot();

% Funzione di Aggiornamento del Plot

function updatePlot(~, ~)
    % Recupera i valori dagli slider
    theta_x = get(slider_theta_x, 'Value');
    theta_y = get(slider_theta_y, 'Value');
    theta_z = get(slider_theta_z, 'Value');
    
    gamma_xy = get(slider_gamma_xy, 'Value');
    gamma_xz = get(slider_gamma_xz, 'Value');
    gamma_yz = get(slider_gamma_yz, 'Value');
    
    epsilon_xx = get(slider_epsilon_xx, 'Value');
    epsilon_yy = get(slider_epsilon_yy, 'Value');
    epsilon_zz = get(slider_epsilon_zz, 'Value');
    
    % Aggiorna le caselle di testo con i valori correnti
    set(valueTexts.theta_x, 'String', num2str(theta_x, '%.2f'));
    set(valueTexts.theta_y, 'String', num2str(theta_y, '%.2f'));
    set(valueTexts.theta_z, 'String', num2str(theta_z, '%.2f'));
    
    set(valueTexts.gamma_xy, 'String', num2str(gamma_xy, '%.2f'));
    set(valueTexts.gamma_xz, 'String', num2str(gamma_xz, '%.2f'));
    set(valueTexts.gamma_yz, 'String', num2str(gamma_yz, '%.2f'));
    
    set(valueTexts.epsilon_xx, 'String', num2str(epsilon_xx, '%.2f'));
    set(valueTexts.epsilon_yy, 'String', num2str(epsilon_yy, '%.2f'));
    set(valueTexts.epsilon_zz, 'String', num2str(epsilon_zz, '%.2f'));
    
    % Calcolo delle Deformazioni
    
    % Step 1: Costruzione di epsilon (Tensore delle Piccole Deformazioni)
    epsilon = [epsilon_xx,    gamma_xy/2,    gamma_xz/2;
               gamma_xy/2,    epsilon_yy,    gamma_yz/2;
               gamma_xz/2,    gamma_yz/2,    epsilon_zz];
    
    % Step 2: Costruzione di w (Tensore delle Piccole Rotazioni)
    omega_x = theta_x;
    omega_y = theta_y;
    omega_z = theta_z;
    
    w = [  0,         -omega_z/2,   omega_y/2;
           omega_z/2,     0,        -omega_x/2;
          -omega_y/2,  omega_x/2,      0     ];
    
    % Step 3: Calcolo di H (Tensore del Gradiente di Spostamento)
    H = epsilon + w;
    
    % Step 4: Calcolo degli Spostamenti utilizzando epsilon e w (Piccole Deformazioni)
    u_small = zeros(size(X));
    for i = 1:size(X, 2)
        u_small(:, i) = H * X(:, i);
    end
    
    % Step 5: Calcolo delle Nuove Posizioni (Piccole Deformazioni)
    x_small = X + u_small;
    
    % Grandi Deformazioni
    
    % Step 6a: Costruzione delle Matrici di Rotazione
    % Rotazione attorno all'asse x
    Rx = [1,          0,           0;
          0, cos(theta_x), -sin(theta_x);
          0, sin(theta_x),  cos(theta_x)];

    % Rotazione attorno all'asse y
    Ry = [cos(theta_y),  0, sin(theta_y);
                   0,    1,          0;
          -sin(theta_y), 0, cos(theta_y)];

    % Rotazione attorno all'asse z
    Rz = [cos(theta_z), -sin(theta_z), 0;
          sin(theta_z),  cos(theta_z), 0;
                   0,           0,     1];

    % Rotazione totale
    R = Rz * Ry * Rx;

    % Step 6b: Calcolo degli stretch ratios per le deformazioni normali
    lambda_x = exp(epsilon_xx);
    lambda_y = exp(epsilon_yy);
    lambda_z = exp(epsilon_zz);

    % Costruzione del tensore U per le deformazioni normali
    U_normal = diag([lambda_x, lambda_y, lambda_z]);

    % Costruzione delle matrici di scorrimento per grandi deformazioni
    Shear_xy = [1, tan(gamma_xy), 0;
                0,          1,     0;
                0,          0,     1];

    Shear_xz = [1, 0, tan(gamma_xz);
                0, 1,          0;
                0, 0,          1];

    Shear_yz = [1, 0,          0;
                0, 1, tan(gamma_yz);
                0, 0,          1];

    % Costruzione del tensore U completo
    U = U_normal * Shear_xy * Shear_xz * Shear_yz;

    % Step 6c: Calcolo del Gradiente di Deformazione Totale F
    F = R * U;

    % Step 7: Calcolo delle Nuove Posizioni utilizzando F (Grandi Deformazioni)
    x_large = zeros(size(X));
    for i = 1:size(X, 2)
        x_large(:, i) = F * X(:, i);
    end

    % Visualizzazione della Configurazione Deformata
    
    cla(axesAnim);

    % Plot della Configurazione Originale (Lettera 'M' Blu)
    hold(axesAnim, 'on');
    for i = 1:size(line_indices, 1)
        idx = line_indices(i, :);
        h_original = plot3(axesAnim, X(1, idx), X(2, idx), X(3, idx), 'b-', 'LineWidth', 1);
    end

    % Plot della Configurazione Deformata (Piccole Deformazioni - Verde)
    for i = 1:size(line_indices, 1)
        idx = line_indices(i, :);
        h_small = plot3(axesAnim, x_small(1, idx), x_small(2, idx), x_small(3, idx), 'g--', 'LineWidth', 2);
    end

    % Plot della Configurazione Deformata (Grandi Deformazioni - Rosso)
    for i = 1:size(line_indices, 1)
        idx = line_indices(i, :);
        h_large = plot3(axesAnim, x_large(1, idx), x_large(2, idx), x_large(3, idx), 'r-', 'LineWidth', 2);
    end

    legend(axesAnim, [h_original, h_small, h_large], {'Originale', 'Piccole Deformazioni', 'Grandi Deformazioni'}, 'Location', 'bestoutside');

    % Aggiornamento delle proprietà dell'asse
    xlim(axesAnim, x_limits);
    ylim(axesAnim, y_limits);
    zlim(axesAnim, z_limits);
    axis(axesAnim, 'equal');
    grid(axesAnim, 'on');
    view(axesAnim, 30, 20);

    % Visualizzazione dei parametri attuali
    input_text = {
        sprintf('\\theta_x = %.2f, \\theta_y = %.2f, \\theta_z = %.2f', theta_x, theta_y, theta_z);
        sprintf('\\gamma_{xy} = %.2f, \\gamma_{xz} = %.2f, \\gamma_{yz} = %.2f', gamma_xy, gamma_xz, gamma_yz);
        sprintf('\\epsilon_{xx} = %.2f, \\epsilon_{yy} = %.2f, \\epsilon_{zz} = %.2f', epsilon_xx, epsilon_yy, epsilon_zz);
        };

    % Posizione del testo
    txt_position = [x_limits(1)+0.1, y_limits(2)-0.1, z_limits(2)-0.1];
    text(axesAnim, txt_position(1), txt_position(2), txt_position(3), input_text, 'FontSize', 10, 'BackgroundColor', 'white');

    hold(axesAnim, 'off');
end  

end  
