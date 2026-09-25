% Codice MATLAB per visualizzare l'effetto di Poisson su un complesso di 4 cubi in legno 

clc; clear; close all;

%% Definizione della Geometria del Cubo Composto

% Dimensioni del cubetto
cube_size = 1;

% Numero di cubetti per lato (2x2 per un totale di 4 cubetti)
num_cubes_per_side = 2;

% Generazione dei vertici e delle facce per l'intera struttura
[vertices, faces] = generateCubes(num_cubes_per_side, cube_size);

%% Definizione delle Proprietà del Materiale per il Legno

E = 10e9;    % Modulo di Young in Pa
nu = 0.35;   % Coefficiente di Poisson

%% Definizione della Forza Applicata

F = -1e6;    % Forza in Newton (1 MN)

%% Calcolo delle Sollecitazioni e Deformazioni

% Calcolo dell'area trasversale
L = cube_size * num_cubes_per_side;  % Lunghezza totale del cubo
A = L^2;                             % Area trasversale

% Calcolo dello stress
sigma_z = F / A;   % Stress in Pa

% Calcolo della deformazione assiale
epsilon_z = sigma_z / E;

% Calcolo delle deformazioni laterali (Effetto Poisson)
epsilon_x = -nu * epsilon_z;
epsilon_y = -nu * epsilon_z;

% Tensore delle deformazioni (epsilon)
epsilon = [epsilon_x, 0,          0;
           0,          epsilon_y, 0;
           0,          0,          epsilon_z];

%% Applicazione delle Deformazioni ai Vertici

% Calcolo degli spostamenti per tutti i vertici
u = (epsilon * vertices')';

% Fattore di amplificazione per la visualizzazione
amplification = 1e5;

% Calcolo dei nuovi vertici deformati amplificati
vertices_deformed_amplified = vertices + amplification * u;

%% Visualizzazione

figure('Color', 'white', 'Position', [100, 100, 800, 600]);

% Creazione dell'asse per la visualizzazione
axesAnim = axes('Units', 'normalized', 'Position', [0.05, 0.1, 0.9, 0.85]);
cla(axesAnim);
hold(axesAnim, 'on');

% Visualizzazione della configurazione originale
h1 = patch('Vertices', vertices, 'Faces', faces, 'FaceColor', 'blue', 'FaceAlpha', 0.2, ...
          'EdgeColor', 'black', 'Parent', axesAnim);

% Visualizzazione della configurazione deformata amplificata
h2 = patch('Vertices', vertices_deformed_amplified, 'Faces', faces, 'FaceColor', 'red', ...
          'FaceAlpha', 0.5, 'EdgeColor', 'black', 'Parent', axesAnim);

legend([h1, h2], {'Configurazione Originale', 'Configurazione Deformata'}, 'Location', 'best');

% Aggiornamento delle proprietà dell'asse
axis(axesAnim, 'equal');
grid(axesAnim, 'on');
view(axesAnim, 30, 20);
xlabel(axesAnim, 'X');
ylabel(axesAnim, 'Y');
zlabel(axesAnim, 'Z');
xlim(axesAnim, [0, L * 1.1]);
ylim(axesAnim, [0, L * 1.1]);
zlim(axesAnim, [0, L * 1.1]);
title(axesAnim, 'Deformazione del Cubo di Legno Sotto Azione di Forza Comprimente (Amplificata)');

hold(axesAnim, 'off');

%% Funzioni Ausiliarie

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
