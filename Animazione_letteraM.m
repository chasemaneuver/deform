% Codice MATLAB per animare la deformazione della lettera 'M' con rotazioni, scorrimenti angolari e allungamenti/compressioni in 3D
% Visualizza contemporaneamente la configurazione originale, le piccole deformazioni e le grandi deformazioni

clear; clc; 

%% INPUT

% -----------------------------
% Parametri di Deformazione Iniziali (Configurazione Originale)
% -----------------------------
theta_x_initial = 0;     % Rotazione iniziale attorno all'asse x
theta_y_initial = 0;     % Rotazione iniziale attorno all'asse y
theta_z_initial = 0;     % Rotazione iniziale attorno all'asse z

gamma_xy_initial = 0;    % Scorrimento iniziale nel piano xy
gamma_xz_initial = 0;    % Scorrimento iniziale nel piano xz
gamma_yz_initial = 0;    % Scorrimento iniziale nel piano yz

epsilon_xx_initial = 0;  % Deformazione iniziale lungo l'asse x
epsilon_yy_initial = 0;  % Deformazione iniziale lungo l'asse y
epsilon_zz_initial = 0;  % Deformazione iniziale lungo l'asse z

% -----------------------------
% Parametri di Deformazione Finali (Configurazione Deformata)
% -----------------------------
theta_x_final = 0.8;     % Rotazione finale attorno all'asse x
theta_y_final = 0.75;     % Rotazione finale attorno all'asse y
theta_z_final = 0.45;     % Rotazione finale attorno all'asse z

gamma_xy_final = 0.9;    % Scorrimento finale nel piano xy
gamma_xz_final = -0.35;  % Scorrimento finale nel piano xz
gamma_yz_final = 0.25;    % Scorrimento finale nel piano yz

epsilon_xx_final = 0.6;   % Deformazione finale lungo l'asse x
epsilon_yy_final = -0.3; % Deformazione finale lungo l'asse y
epsilon_zz_final = 0.9;   % Deformazione finale lungo l'asse z

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

%% Creazione delle Linee per la Lettera 'M'

% Indici dei punti
% Punti inferiori: 1 to num_base_points
% Punti superiori: (num_base_points + 1) to (2 * num_base_points)

% Linee che connettono i punti per formare la lettera 'M'
lines = [
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

%% Parametri per l'Animazione

num_frames = 100;  % Numero di frame dell'animazione

% Creazione di vettori di parametri interpolati per l'animazione
theta_x_values = linspace(theta_x_initial, theta_x_final, num_frames);
theta_y_values = linspace(theta_y_initial, theta_y_final, num_frames);
theta_z_values = linspace(theta_z_initial, theta_z_final, num_frames);

gamma_xy_values = linspace(gamma_xy_initial, gamma_xy_final, num_frames);
gamma_xz_values = linspace(gamma_xz_initial, gamma_xz_final, num_frames);
gamma_yz_values = linspace(gamma_yz_initial, gamma_yz_final, num_frames);

epsilon_xx_values = linspace(epsilon_xx_initial, epsilon_xx_final, num_frames);
epsilon_yy_values = linspace(epsilon_yy_initial, epsilon_yy_final, num_frames);
epsilon_zz_values = linspace(epsilon_zz_initial, epsilon_zz_final, num_frames);

%% Creazione della Figura per l'Animazione

figure('Color', 'white');
set(gcf, 'Position', [100, 100, 800, 600]);

% Ciclo per l'Animazione

for frame = 1:num_frames
    % Estrazione dei parametri per il frame corrente
    theta_x = theta_x_values(frame);
    theta_y = theta_y_values(frame);
    theta_z = theta_z_values(frame);
    
    gamma_xy = gamma_xy_values(frame);
    gamma_xz = gamma_xz_values(frame);
    gamma_yz = gamma_yz_values(frame);
    
    epsilon_xx = epsilon_xx_values(frame);
    epsilon_yy = epsilon_yy_values(frame);
    epsilon_zz = epsilon_zz_values(frame);
    
    % Calcolo delle Deformazioni per il Frame Corrente
    
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
    
    % Step 6: Costruzione di F (Gradiente di Deformazione) per Grandi Deformazioni
    
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
    
    % Step 6b: Costruzione del Tensore di Allungamento Destro U
    U = eye(3) + epsilon;
    
    % Step 6c: Calcolo del Gradiente di Deformazione Totale F
    F = R * U;
    
    % Step 7: Calcolo delle Nuove Posizioni utilizzando F (Grandi Deformazioni)
    x_large = zeros(size(X));
    for i = 1:size(X, 2)
        x_large(:, i) = F * X(:, i);
    end
    
    % Visualizzazione della Configurazione Deformata
    
    clf; 
    
    % Plot della Configurazione Originale (Lettera 'M' Blu)
    for i = 1:size(lines, 1)
        idx = lines(i, :);
        h_original = plot3(X(1, idx), X(2, idx), X(3, idx), 'b-', 'LineWidth', 1); hold on;
    end
    
    % Plot della Configurazione Deformata (Piccole Deformazioni - Verde)
    for i = 1:size(lines, 1)
        idx = lines(i, :);
        h_small = plot3(x_small(1, idx), x_small(2, idx), x_small(3, idx), 'g--', 'LineWidth', 2);
    end
    
    % Plot della Configurazione Deformata (Grandi Deformazioni - Rosso)
    for i = 1:size(lines, 1)
        idx = lines(i, :);
        h_large = plot3(x_large(1, idx), x_large(2, idx), x_large(3, idx), 'r-', 'LineWidth', 2);
    end
    
    legend([h_original, h_small, h_large], {'Configurazione Originale', 'Piccole Deformazioni (\epsilon e w)', 'Grandi Deformazioni (F)'}, 'Location', 'best');
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    title('Animazione della Deformazione della Lettera ''M'' in 3D');
    
    % Assicurarsi che tutti i dati siano visibili
    axis equal;
    grid on;
    view(30, 20);
    
    % Limiti degli assi per mantenere la lettera centrata
    xlim([-1, 2]);
    ylim([-1, 2]);
    zlim([-1, 2]);
    
    % Visualizzazione dei parametri attuali
    input_text = {
        sprintf('Frame %d/%d', frame, num_frames);
        sprintf('\\theta_x = %.2f, \\theta_y = %.2f, \\theta_z = %.2f', theta_x, theta_y, theta_z);
        sprintf('\\gamma_{xy} = %.2f, \\gamma_{xz} = %.2f, \\gamma_{yz} = %.2f', gamma_xy, gamma_xz, gamma_yz);
        sprintf('\\epsilon_{xx} = %.2f, \\epsilon_{yy} = %.2f, \\epsilon_{zz} = %.2f', epsilon_xx, epsilon_yy, epsilon_zz);
        };
    
    annotation('textbox', [0.7, 0.05, 0.25, 0.2], 'String', input_text, 'FitBoxToText', 'on', ...
               'BackgroundColor', 'white', 'EdgeColor', 'black', 'Interpreter', 'tex', 'FontSize', 10);
    
    drawnow;  % Aggiorna la figura
    
end

