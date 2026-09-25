% Codice MATLAB per deformare un'immagine a colori utilizzando rotazione, scorrimento angolare e allungamenti/compressioni
% Include approcci di piccole e grandi deformazioni
% Aggiornato per visualizzare le immagini deformate complete

% Pulizia dell'ambiente di lavoro e delle variabili
clear; clc;

%% Caricamento dell'Immagine

% Caricamento dell'immagine
I = imread('C:\Users\miche\Desktop\nasa_logo.png');  % Sostituisci con il tuo file immagine

% Conversione dell'immagine in double per l'interpolazione
I = im2double(I);

% Dimensioni dell'immagine
[rows, cols, channels] = size(I);

%% INPUT

% -----------------------------
% Parametri di deformazione definiti (valori piccoli)
% -----------------------------

%{
% Angolo di rotazione theta (in radianti)
theta = 0.05;   % Piccola rotazione (~2.86 gradi)

% Scorrimento angolare gamma
gamma = 0.02;   % Piccolo scorrimento angolare

% Deformazioni normali (allungamenti/compressioni)
epsilon_xx = 0.01;    % Piccolo allungamento lungo l'asse x (1%)
epsilon_yy = -0.005;  % Piccola compressione lungo l'asse y (-0.5%)
%}

% -----------------------------
% Parametri di deformazione definiti e (valori grandi)
% -----------------------------

%
% Angolo di rotazione theta (in radianti)
theta = pi/4;   % Grande rotazione (45 gradi)

% Scorrimento angolare gamma
gamma = 0.7;   % Grande scorrimento angolare

% Deformazioni normali (allungamenti/compressioni)
epsilon_xx = 0.2;    % Grande allungamento lungo l'asse x (20%)
epsilon_yy = -0.3;  % Grande compressione lungo l'asse y (-30%)
%


%% Creazione della Griglia di Coordinate

[X, Y] = meshgrid(1:cols, 1:rows);

% Appiattimento delle coordinate in vettori
X_flat = X(:)';
Y_flat = Y(:)';

% Coordinate originali in forma di matrice 2xN
X_coords = [X_flat; Y_flat];

%% Sezione 1: Piccole Deformazioni

% Step 1: Costruzione di epsilon (Tensore delle piccole deformazioni)
epsilon = [epsilon_xx,    gamma/2;
           gamma/2,       epsilon_yy];

% Step 2: Costruzione di w (Tensore delle piccole rotazioni)
w = [  0,        theta/2;
       -theta/2,    0      ];

% Step 3: Calcolo di H (Tensore del gradiente di spostamento)
H = epsilon + w;

% Step 4: Calcolo delle nuove coordinate
u_small = H * X_coords;
x_small = X_coords + u_small;

%% Sezione 2: Grandi Deformazioni

% Step 5: Costruzione di F (Gradiente di deformazione) 

% Step 5a: Costruzione della matrice di rotazione R
R = [cos(theta), -sin(theta); sin(theta), cos(theta)];

% Step 5b: Costruzione del Tensore di allungamento destro U
epsilon_large = [epsilon_xx,    gamma/2;
                 gamma/2,       epsilon_yy];
U = eye(2) + epsilon_large;

% Step 5c: Calcolo del gradiente di deformazione F
F = R * U;

% Step 6: Calcolo delle nuove coordinate 
x_large = F * X_coords;

%% Sezione 3: Calcolo dei Nuovi Limiti

% Coordinate dei quattro angoli dell'immagine originale
corners = [1, cols, cols, 1;
           1, 1,    rows, rows];

% Applicazione delle deformazioni ai quattro angoli
% Piccole deformazioni
u_small_corners = H * corners;
x_small_corners = corners + u_small_corners;

% Grandi deformazioni
x_large_corners = F * corners;

% Trova i nuovi limiti per le piccole deformazioni
x_min_small = floor(min(x_small_corners(1, :)));
x_max_small = ceil(max(x_small_corners(1, :)));
y_min_small = floor(min(x_small_corners(2, :)));
y_max_small = ceil(max(x_small_corners(2, :)));

% Trova i nuovi limiti per le grandi deformazioni
x_min_large = floor(min(x_large_corners(1, :)));
x_max_large = ceil(max(x_large_corners(1, :)));
y_min_large = floor(min(x_large_corners(2, :)));
y_max_large = ceil(max(x_large_corners(2, :)));

% Trova i limiti complessivi
x_min = min([x_min_small, x_min_large, 1]);
x_max = max([x_max_small, x_max_large, cols]);
y_min = min([y_min_small, y_min_large, 1]);
y_max = max([y_max_small, y_max_large, rows]);

%% Sezione 4: Creazione delle nuove griglie

% Griglia per piccole deformazioni
[Xq_small, Yq_small] = meshgrid(x_min:x_max, y_min:y_max);

% Griglia per grandi deformazioni
[Xq_large, Yq_large] = meshgrid(x_min:x_max, y_min:y_max);

%% Sezione 5: Calcolo delle coordinate inverse

% Coordinate inverse per piccole deformazioni
Xq_small_flat = Xq_small(:)';
Yq_small_flat = Yq_small(:)';

Xq_small_coords = [Xq_small_flat; Yq_small_flat];

% Calcolo delle coordinate inverse
A_small = eye(2) - H;  % Approssimazione per piccole deformazioni
orig_coords_small = A_small \ (Xq_small_coords - H * [0;0]);

orig_x_small = reshape(orig_coords_small(1, :), size(Xq_small));
orig_y_small = reshape(orig_coords_small(2, :), size(Yq_small));

% Coordinate inverse per grandi deformazioni
Xq_large_flat = Xq_large(:)';
Yq_large_flat = Yq_large(:)';

Xq_large_coords = [Xq_large_flat; Yq_large_flat];

% Calcolo delle coordinate inverse
% inv_F = inv(F); non consigliata
orig_coords_large = F\Xq_large_coords;

orig_x_large = reshape(orig_coords_large(1, :), size(Xq_large));
orig_y_large = reshape(orig_coords_large(2, :), size(Yq_large));

%% Sezione 6: Interpolazione dell'immagine a colori

% Inizializzazione delle immagini deformate
I_small = zeros(size(Xq_small, 1), size(Xq_small, 2), channels);
I_large = zeros(size(Xq_large, 1), size(Xq_large, 2), channels);

% Interpolazione per ciascun canale di colore
for c = 1:channels
    % Estrazione del canale c
    I_channel = I(:, :, c);
    
    % Interpolazione per piccole deformazioni
    I_small(:, :, c) = interp2(X, Y, I_channel, orig_x_small, orig_y_small, 'linear', 0);
    
    % Interpolazione per grandi deformazioni
    I_large(:, :, c) = interp2(X, Y, I_channel, orig_x_large, orig_y_large, 'linear', 0);
end

%% Sezione 7: Visualizzazione delle immagini

figure;

% Visualizzazione dell'Immagine Originale
subplot(1, 3, 1);
imshow(I);
title('Immagine Originale');

% Visualizzazione dell'Immagine Deformata (Piccole Deformazioni)
subplot(1, 3, 2);
imshow(I_small);
title('Piccole Deformazioni (\epsilon e w)');

% Visualizzazione dell'Immagine Deformata (Grandi Deformazioni)
subplot(1, 3, 3);
imshow(I_large);
title('Grandi Deformazioni (F)');

%% Sezione 8: Visualizzazione dei Valori di Input

% Creazione del testo da visualizzare con formattazione
input_text = {
    sprintf('Rotazione (rad): \\theta = %.4f', theta);
    sprintf('Deformazioni Normali: \\epsilon_{xx} = %.4f, \\epsilon_{yy} = %.4f', epsilon_xx, epsilon_yy);
    sprintf('Scorrimento Angolare: \\gamma = %.4f', gamma);
    };

annotation('textbox', [0.1, 0.05, 0.8, 0.1], 'String', input_text, 'FitBoxToText', 'on', 'BackgroundColor', 'white', 'EdgeColor', 'black', 'Interpreter', 'tex', 'FontSize', 10);
