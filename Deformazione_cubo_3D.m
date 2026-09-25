% Codice MATLAB per calcolare la deformazione di un cubo con rotazioni, scorrimenti angolari e allungamenti/compressioni in 3D. Include approcci di piccole e grandi deformazioni

clear; clc;

%% INPUT

% -----------------------------
% Input di deformazione definiti (valori piccoli)
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
% Input di deformazione definiti (valori grandi)
% -----------------------------

%
% Angolo di rotazione theta (in radianti)
theta_x = pi/6;  % Rotazione attorno all'asse x (30 gradi)
theta_y = pi/4;  % Rotazione attorno all'asse y (45 gradi)
theta_z = pi/8;  % Rotazione attorno all'asse z (~22.5 gradi)

% Scorrimento angolare gamma
gamma_xy = 2;     % Scorrimento nel piano xy
gamma_xz = 1.5;   % Scorrimento nel piano xz
gamma_yz = 2.3;   % Scorrimento nel piano yz

% Deformazioni normali (allungamenti/compressioni)
epsilon_xx = 0.3;    % Grande allungamento lungo l'asse x (30%)
epsilon_yy = -0.2;   % Grande compressione lungo l'asse y (20%)
epsilon_zz = 0.15;   % Grande allungamento lungo l'asse z (15%)
%


%% Sezione 1: Piccole Deformazioni

% Step 1: Costruzione di epsilon (Tensore delle Piccole Deformazioni)
% Elementi diagonali per deformazioni normali, 
% elementi fuori diagonale per scorrimenti angolari
epsilon = [epsilon_xx,    gamma_xy/2,    gamma_xz/2;
           gamma_xy/2,    epsilon_yy,    gamma_yz/2;
           gamma_xz/2,    gamma_yz/2,    epsilon_zz];

% Step 2: Costruzione di w (Tensore delle Piccole Rotazioni)
% Tensore antisimmetrico che rappresenta le piccole rotazioni
omega_x = theta_x;
omega_y = theta_y;
omega_z = theta_z;

w = [  0,         -omega_z/2,   omega_y/2;
       omega_z/2,     0,        -omega_x/2;
      -omega_y/2,  omega_x/2,      0     ];

% Step 3: Calcolo di H (Tensore del Gradiente di Spostamento)
H = epsilon + w;

% Step 4: Definizione della configurazione di riferimento (Cubo)
X = [0, 1, 1, 0, 0, 1, 1, 0;  % coordinate X
     0, 0, 1, 1, 0, 0, 1, 1;  % coordinate Y
     0, 0, 0, 0, 1, 1, 1, 1]; % coordinate Z

% Step 5: Calcolo degli spostamenti utilizzando epsilon e w 
u_small = zeros(size(X));
for i = 1:size(X, 2)
    u_small(:, i) = H * X(:, i);
end

% Step 6: Calcolo delle nuove posizioni 
x_small = X + u_small;


%% Sezione 2: Grandi Deformazioni

% Step 7: Costruzione di F (Gradiente di Deformazione) 

% Step 7a: Costruzione delle Matrici di Rotazione
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

% Step 7b: Costruzione del Tensore di Allungamento Destro U
% Includo deformazioni normali e scorrimenti angolari in U

% U deve essere simmetrico e definito positivo
U = eye(3) + epsilon;

% Step 7c: Calcolo del Gradiente di Deformazione F
F = R * U;

% Step 8: Calcolo delle nuove posizioni utilizzando F 
x_large = zeros(size(X));
for i = 1:size(X, 2)
    x_large(:, i) = F * X(:, i);
end

% Step 9: Calcolo degli spostamenti 
u_large = x_large - X;


%% Calcolo dell'errore E - epsilon

% Step 10: Calcolo del Tensore di Deformazione di Green-Lagrange E
I = eye(3);        % Matrice identità
C = F' * F;        % Tensore di deformazione di Cauchy-Green destro
E = (C - I) / 2;   % Tensore di Green-Lagrange

% Step 11: Calcolo della Differenza E - epsilon
difference = E - epsilon;


% Step 12: Visualizzazione dei Tensori Calcolati

disp('--------------- Dati per piccole deformazioni ---------------');
disp('Tensore delle Piccole Rotazioni w:');
disp(w);

disp('Tensore delle Piccole Deformazioni epsilon:');
disp(epsilon);

disp('Tensore del Gradiente di Spostamento H:');
disp(H);

disp('--------------- Dati per grandi deformazioni ---------------');

disp('Matrice delle Rotazioni R:');
disp(R);

disp('Tensore di Allungamento Destro U:');
disp(U);

disp('Gradiente di Deformazione F:');
disp(F);

disp('Tensore di Green-Lagrange E:');
disp(E);

disp('Differenza tra E ed epsilon (Errore):');
disp(difference);

disp('--------------- Coordinate ---------------');

disp('Coordinate iniziali:');
disp(X);

disp('Coordinate finali con Piccole Deformazioni:');
disp(x_small);

disp('Coordinate finali con Grandi Deformazioni:');
disp(x_large);


% -----------------------------
% Step 13: Plot delle Configurazioni Originale e Deformate
% -----------------------------

% Definizione delle facce del cubo
faces = [1 2 3 4;  % Faccia inferiore
         5 6 7 8;  % Faccia superiore
         1 2 6 5;  % Faccia laterale
         2 3 7 6;
         3 4 8 7;
         4 1 5 8];

figure;

% Plot della Configurazione Originale (Cubo blu)
patch('Vertices', X', 'Faces', faces, 'FaceColor', 'blue', 'FaceAlpha', 0.1, 'EdgeColor', 'blue', 'LineWidth', 2);
hold on;

% Plot della Configurazione Deformata utilizzando epsilon e w (Piccole Deformazioni - Cubo rosso)
patch('Vertices', x_small', 'Faces', faces, 'FaceColor', 'red', 'FaceAlpha', 0.1, 'EdgeColor', 'red', 'LineWidth', 1);

% Plot della Configurazione Deformata utilizzando F (Grandi Deformazioni - Cubo verde)
patch('Vertices', x_large', 'Faces', faces, 'FaceColor', 'green', 'FaceAlpha', 0.1, 'EdgeColor', 'green', 'LineWidth', 1);

% Legenda
legend('Configurazione Originale', 'Piccole Deformazioni (\epsilon e w)', 'Grandi Deformazioni (F)', 'Location', 'bestoutside');
xlabel('X');
ylabel('Y');
zlabel('Z');
title('Deformazione di un Cubo con Rotazioni, Scorrimenti Angolari e Allungamenti in 3D');

% Check dati visibili
axis equal;
axis vis3d;
grid on;
view(3);
set(gca, 'FontSize', 12);
box on;


% -----------------------------
% Step 14: Visualizzazione dei Valori di Input nel Grafico
% -----------------------------

% Creazione del testo da visualizzare con formattazione
input_text = {
    sprintf('Rotazioni (rad): \\theta_x = %.4f, \\theta_y = %.4f, \\theta_z = %.4f', theta_x, theta_y, theta_z);
    sprintf('Deformazioni Normali: \\epsilon_{xx} = %.4f, \\epsilon_{yy} = %.4f, \\epsilon_{zz} = %.4f', epsilon_xx, epsilon_yy, epsilon_zz);
    sprintf('Scorrimenti Angolari: \\gamma_{xy} = %.4f, \\gamma_{xz} = %.4f, \\gamma_{yz} = %.4f', gamma_xy, gamma_xz, gamma_yz);
    };

annotation('textbox', [0.7, 0.1, 0.25, 0.2], 'String', input_text, 'FitBoxToText', 'on', 'BackgroundColor', 'white', 'EdgeColor', 'black', 'Interpreter', 'tex', 'FontSize', 10);

hold off;
