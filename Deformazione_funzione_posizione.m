% Codice MATLAB per applicare una deformazione in funzione della posizione
% a un cubo composto da quattro cubetti, utilizzando l'approccio delle grandi deformazioni

% Pulizia dell'ambiente di lavoro e delle variabili
clc; clear; 
% -----------------------------
% Definizione della geometria del cubo composto
% -----------------------------

% Dimensioni del cubetto
cube_size = 1;

% Numero di cubetti per lato (2x2 per un totale di 4 cubetti)
num_cubes_per_side = 2;

% Generazione dei vertici e delle facce per l'intera struttura
[vertices, faces] = generateCubes(num_cubes_per_side, cube_size);

% -----------------------------
% Definizione del Campo di Deformazione in Funzione della Posizione
% -----------------------------

% Estrai le coordinate X, Y, Z dei vertici
X = vertices(:, 1);
Y = vertices(:, 2);
Z = vertices(:, 3);

% Definizione del campo di deformazione
% Deformazione che varia linearmente lungo l'asse X e Y

% Parametri per controllare la variazione della deformazione
epsilon_xx_max = 0.3;  % Deformazione massima lungo X
epsilon_yy_max = -0.1; % Deformazione massima lungo Y
gamma_xy_max = 0.2;   % Scorrimento massimo nel piano XY

% Calcolo delle deformazioni in funzione della posizione
epsilon_xx = epsilon_xx_max * (X / (num_cubes_per_side * cube_size));
epsilon_yy = epsilon_yy_max * (Y / (num_cubes_per_side * cube_size));
gamma_xy = gamma_xy_max * ((X + Y) / (2 * num_cubes_per_side * cube_size));

% Calcolo degli stretch ratios per grandi deformazioni
lambda_x = exp(epsilon_xx);
lambda_y = exp(epsilon_yy);

% Inizializzazione dei nuovi vertici deformati
vertices_deformed = zeros(size(vertices));

% Applicazione delle deformazioni ai vertici
for i = 1:length(vertices)
    % Costruzione del tensore di deformazione per il vertice i
    % Poiché non vogliamo rotazioni, R = identità, quindi F = U
    % Deformazione gradient F per il vertice i
    F = [lambda_x(i), gamma_xy(i), 0;
         0,           lambda_y(i), 0;
         0,           0,           1];

    % Calcolo della nuova posizione del vertice i
    vertices_deformed(i, :) = (F * vertices(i, :)')';
end

% -----------------------------
% Visualizzazione
% -----------------------------

% Creazione della figura
figure('Color', 'white', 'Position', [100, 100, 800, 600]);

% Creazione dell'asse per la visualizzazione
axesAnim = axes('Units', 'normalized', 'Position', [0.05, 0.1, 0.9, 0.85]);
cla(axesAnim);
hold(axesAnim, 'on');

% Visualizzazione della configurazione originale
h1 = patch('Vertices', vertices, 'Faces', faces, 'FaceColor', 'blue', 'FaceAlpha', 0.2, 'EdgeColor', 'black', 'Parent', axesAnim);

% Visualizzazione della configurazione deformata
h2 = patch('Vertices', vertices_deformed, 'Faces', faces, 'FaceColor', 'red', 'FaceAlpha', 0.5, 'EdgeColor', 'black', 'Parent', axesAnim);

legend([h1, h2], {'Configurazione Originale', 'Configurazione Deformata'}, 'Location', 'best');

% Aggiornamento delle proprietà dell'asse
axis(axesAnim, 'equal');
grid(axesAnim, 'on');
view(axesAnim, 30, 20);
xlabel(axesAnim, 'X');
ylabel(axesAnim, 'Y');
zlabel(axesAnim, 'Z');
xlim(axesAnim, [0, num_cubes_per_side * cube_size * 2]);
ylim(axesAnim, [0, num_cubes_per_side * cube_size * 2]);
zlim(axesAnim, [0, cube_size * 1.5]);
title(axesAnim, 'Cubo Deformato con Deformazione in Funzione della Posizione (Grandi Deformazioni)');

hold(axesAnim, 'off');

% -----------------------------
% Funzioni Ausiliarie
% -----------------------------

function [vertices, faces] = generateCubes(num_cubes_per_side, cube_size)
    % Genera i vertici e le facce per una griglia di cubi connessi

    vertices = [];
    faces = [];
    face_offset = 0;
    vertex_indices = zeros(num_cubes_per_side + 1, num_cubes_per_side + 1, 2); % Per tenere traccia dei vertici condivisi

    % Creazione dei vertici condivisi
    index = 1;
    for i = 1:(num_cubes_per_side + 1)
        for j = 1:(num_cubes_per_side + 1)
            % Calcolo della posizione del vertice
            x = (i - 1) * cube_size;
            y = (j - 1) * cube_size;
            z_bottom = 0;
            z_top = cube_size;

            % Aggiunta dei vertici inferiori e superiori
            vertices = [vertices; x, y, z_bottom]; % Vertice inferiore
            vertices = [vertices; x, y, z_top];    % Vertice superiore

            % Memorizzazione degli indici dei vertici
            vertex_indices(i, j, :) = [index, index + 1];
            index = index + 2;
        end
    end

    % Creazione delle facce per ogni cubetto
    for i = 1:num_cubes_per_side
        for j = 1:num_cubes_per_side
            % Vertici del cubetto corrente
            v1 = vertex_indices(i, j, 1);
            v2 = vertex_indices(i, j + 1, 1);
            v3 = vertex_indices(i + 1, j + 1, 1);
            v4 = vertex_indices(i + 1, j, 1);
            v5 = vertex_indices(i, j, 2);
            v6 = vertex_indices(i, j + 1, 2);
            v7 = vertex_indices(i + 1, j + 1, 2);
            v8 = vertex_indices(i + 1, j, 2);

            % Definizione delle facce del cubetto
            cube_faces = [
                v1, v2, v3, v4; % Base inferiore
                v5, v6, v7, v8; % Base superiore
                v1, v2, v6, v5; % Lato fronte
                v2, v3, v7, v6; % Lato destra
                v3, v4, v8, v7; % Lato retro
                v4, v1, v5, v8; % Lato sinistra
                ];

            % Aggiunta delle facce al vettore globale
            faces = [faces; cube_faces];
        end
    end
end
