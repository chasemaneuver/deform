% Codice MATLAB per calcolare la deformazione di una lettera 'M' con rotazioni, scorrimenti angolari e allungamenti/compressioni in 3D
% Include approcci di piccole e grandi deformazioni
% Aggiornato per deformare una lettera 'M' invece di un cubo

clear; clc;

%% INPUT
% Decommentare la sezione adatta 

% -----------------------------
% Parametri di Deformazione definiti (valori piccoli)
% -----------------------------

%{
% Angoli di rotazione theta (in radianti)
theta_x = 0.05;  % Rotazione attorno all'asse x (~2.86 gradi)
theta_y = 0.03;  % Rotazione attorno all'asse y (~1.72 gradi)
theta_z = 0.04;  % Rotazione attorno all'asse z (~2.29 gradi)

% Scorrimenti angolari gamma
gamma_xy = 0.02;   % Scorrimento nel piano xy
gamma_xz = -0.015; % Scorrimento nel piano xz
gamma_yz = 0.01;   % Scorrimento nel piano yz

% Deformazioni normali (allungamenti/compressioni)
epsilon_xx = 0.01;    % Piccolo allungamento lungo l'asse x (1%)
epsilon_yy = -0.005;  % Piccola compressione lungo l'asse y (-0.5%)
epsilon_zz = 0.02;    % Piccolo allungamento lungo l'asse z (2%)
%}

% -----------------------------
% Parametri di Deformazione definiti (valori grandi)
% -----------------------------

%{
% Angolo di rotazione theta (in radianti)
theta_x = pi/6;  % Rotazione attorno all'asse x (~2.86 gradi)
theta_y = pi/4;  % Rotazione attorno all'asse y (~1.72 gradi)
theta_z = pi/8;  % Rotazione attorno all'asse z (~2.29 gradi)

% Scorrimento angolare gamma
gamma_xy = 2;   % Scorrimento nel piano xy
gamma_xz = 1.5; % Scorrimento nel piano xz
gamma_yz = 2.3;   % Scorrimento nel piano yz

% Deformazioni normali (allungamenti/compressioni)
epsilon_xx = 0.3;    % Grande allungamento lungo l'asse x (30%)
epsilon_yy = -0.2;  % Grande compressione lungo l'asse y (20%)
epsilon_zz = 0.15;    % Grande allungamento lungo l'asse z (15%)
%}

%% Sezione 1: Definizione della Lettera 'M'

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

%% Sezione 2: Creazione delle linee per la lettera 'M'

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

%% Sezione 3: Piccole Deformazioni

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

%% Sezione 4: Grandi Deformazioni

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

%% Step 8: Visualizzazione delle Configurazioni Originale e Deformate

% Creazione di una nuova figura
figure;

% Inizializzazione degli handle per la legenda
h_original = [];
h_small = [];
h_large = [];

% Plot della Configurazione Originale (Lettera 'M' Blu)
for i = 1:size(lines, 1)
    idx = lines(i, :);
    h = plot3(X(1, idx), X(2, idx), X(3, idx), 'b-', 'LineWidth', 2); hold on;
    if isempty(h_original)
        h_original = h; % Salviamo l'handle per la legenda
    end
end

% Plot della Configurazione Deformata utilizzando epsilon e w (Piccole Deformazioni - Rosso)
for i = 1:size(lines, 1)
    idx = lines(i, :);
    h = plot3(x_small(1, idx), x_small(2, idx), x_small(3, idx), 'r--', 'LineWidth', 2);
    if isempty(h_small)
        h_small = h; % Salviamo l'handle per la legenda
    end
end

% Plot della Configurazione Deformata utilizzando F (Grandi Deformazioni - Verde)
for i = 1:size(lines, 1)
    idx = lines(i, :);
    h = plot3(x_large(1, idx), x_large(2, idx), x_large(3, idx), 'g-.', 'LineWidth', 2);
    if isempty(h_large)
        h_large = h; % Salviamo l'handle per la legenda
    end
end

% Aggiunta di Legenda utilizzando gli handle salvati
legend([h_original, h_small, h_large], {'Configurazione Originale', 'Piccole Deformazioni (\epsilon e w)', 'Grandi Deformazioni (F)'}, 'Location', 'bestoutside');

% Etichette e Titolo
xlabel('X');
ylabel('Y');
zlabel('Z');
title('Deformazione della Lettera ''M'' con Rotazioni, Scorrimenti Angolari e Allungamenti in 3D');

% Assicurarsi che tutti i dati siano visibili
axis equal;
grid on;
view(3);
set(gca, 'FontSize', 12);
box on;

%% Visualizzazione dei Valori di Input nel Grafico

% Creazione del testo da visualizzare con formattazione
input_text = {
    sprintf('Rotazioni (rad): \\theta_x = %.4f, \\theta_y = %.4f, \\theta_z = %.4f', theta_x, theta_y, theta_z);
    sprintf('Deformazioni Normali: \\epsilon_{xx} = %.4f, \\epsilon_{yy} = %.4f, \\epsilon_{zz} = %.4f', epsilon_xx, epsilon_yy, epsilon_zz);
    sprintf('Scorrimenti Angolari: \\gamma_{xy} = %.4f, \\gamma_{xz} = %.4f, \\gamma_{yz} = %.4f', gamma_xy, gamma_xz, gamma_yz);
    };

% Posizionamento del testo nel grafico
annotation('textbox', [0.7, 0.1, 0.25, 0.2], 'String', input_text, 'FitBoxToText', 'on', 'BackgroundColor', 'white', 'EdgeColor', 'black', 'Interpreter', 'tex', 'FontSize', 10);
hold off;
