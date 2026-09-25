% Codice MATLAB per calcolare la deformazione di un quadrato con rotazione, scorrimento angolare e deformazioni normali. Include approcci di piccole e grandi deformazioni 

clear; clc; close all;

%% INPUT
% Decommentare la sezione interessata

% -----------------------------
% Input di deformazione definiti (valori piccoli)
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
% Input di deformazione definiti (valori grandi)
% -----------------------------

%
% Angolo di rotazione theta (in radianti)
theta = pi/4;   % Grande rotazione (45 gradi)

% Scorrimento angolare gamma
gamma = 2;   % Grande scorrimento angolare

% Deformazioni normali (allungamenti/compressioni)
epsilon_xx = 0.3;    % Grande allungamento lungo l'asse x (30%)
epsilon_yy = -0.4;   % Grande compressione lungo l'asse y (-40%)
%

% -----------------------------
% Input di deformazione definiti (Atto di moto rigido)
% -----------------------------

%{
% Angolo di rotazione theta (in radianti)
theta = 0.05;   

% Scorrimento angolare gamma
gamma = 0;   % questo valore deve essere nullo

% Deformazioni normali (allungamenti/compressioni)
epsilon_xx = 0;   % questo valore deve essere nullo
epsilon_yy = 0;   % questo valore deve essere nullo
%}

% -----------------------------
% Input di deformazione definiti (Pura deformazione assiale)
% -----------------------------

%{
% Angolo di rotazione theta (in radianti)
theta = 0.00;   % questo valore deve essere nullo

% Scorrimento angolare gamma
gamma = 0;   % questo valore deve essere nullo

% Deformazioni normali (allungamenti/compressioni)
epsilon_xx = 0.3;    % Allungamento lungo l'asse x 
epsilon_yy = 0;   % Compressione lungo l'asse y 
%}

% -----------------------------
% Input di deformazione definiti (Puro taglio)
% -----------------------------

%{
% Angolo di rotazione theta (in radianti)
theta = 0.00;   % questo valore deve essere nullo

% Scorrimento angolare gamma
gamma = 0.2;   

% Deformazioni normali (allungamenti/compressioni)
epsilon_xx = 0;    % questo valore deve essere nullo
epsilon_yy = 0;   % questo valore deve essere nullo
%}


%% Sezione 1: Piccole Deformazioni

% Step 1: Costruzione di epsilon (Tensore delle Piccole Deformazioni)
% Elementi diagonali per deformazioni normali, 
% elementi fuori diagonale per scorrimento angolare
epsilon = [epsilon_xx,    gamma/2;
           gamma/2,       epsilon_yy];

% Step 2: Costruzione di w (Tensore delle Piccole Rotazioni)
% Tensore antisimmetrico che rappresenta la piccola rotazione
w = [  0,        -theta/2;
       theta/2,    0      ];

% Step 3: Calcolo di H (Tensore del Gradiente di Spostamento)
H = epsilon + w;

% Step 4: Definizione della configurazione di riferimento (quadrato)
X = [0, 1, 1, 0;  % coordinate x
     0, 0, 1, 1]; % coordinate y
X = [X, X(:,1)];  % chiudo il quadrato nel grafico

% Step 5: Calcolo degli spostamenti utilizzando epsilon e w 
u_small = zeros(size(X));
for i = 1:size(X, 2)
    u_small(:, i) = H * X(:, i);
end

% Step 6: Calcolo delle nuove posizioni 
x_small = X + u_small;


%% Sezione 2: Grandi Deformazioni

% Step 7: Costruzione di F (Gradiente di Deformazione) 

% Step 7a: Costruzione della Matrice di Rotazione R
R = [cos(theta), -sin(theta); sin(theta), cos(theta)];

% Step 7b: Costruzione del Tensore di Allungamento Destro U
% Includiamo le deformazioni normali e il scorrimento angolare in U
epsilon_large = [epsilon_xx,    gamma/2;
                 gamma/2,       epsilon_yy];

% U deve essere simmetrico e definito positivo
U = eye(2) + epsilon_large;

% Step 7c: Calcolo del Gradiente di Deformazione F
F = R * U;

% Step 8: Calcolo delle nuove posizioni utilizzando F
x_large = zeros(size(X));
for i = 1:size(X, 2)
    x_large(:, i) = F * X(:, i);
end

% Step 9: Calcolo degli spostamenti 
u_large = x_large - X;


%% Sezione 3: Calcoli aggiuntivi

% Step 10: Calcolo del Tensore di Deformazione di Green-Lagrange E
I = eye(2);        % Matrice identità
C = F' * F;        % Tensore di deformazione di Cauchy-Green destro
E = (C - I) / 2;   % Tensore di Green-Lagrange

% Step 11: Calcolo della Differenza E - epsilon
difference = E - epsilon;

% Step 12: Calcolo delle Deformazioni Nominali e Dirette per le Fibre

% Definizione dei nodi
% Nodi nella configurazione non deformata (X)
nodes = X(1:2, 1:4)'; % 4 nodi, prendiamo solo le prime 4 colonne

% Definizione delle fibre (collegamenti tra nodi)
% Ogni riga definisce una fibra come [NodoIniziale, NodoFinale]
fibers = [
    1, 2; % Fibra 1
    2, 3; % Fibra 2
    3, 4; % Fibra 3
    4, 1; % Fibra 4
    1, 3; % Fibra 5 (diagonale)
    2, 4  % Fibra 6 (diagonale)
];

% Numero di fibre
numFibers = size(fibers, 1);

% Preallocazione degli array per le deformazioni
Lambda_small = zeros(numFibers,1);
e_nominal_small = zeros(numFibers,1);
e_direct_small = zeros(numFibers,1);

Lambda_large = zeros(numFibers,1);
e_nominal_large = zeros(numFibers,1);
e_direct_large = zeros(numFibers,1);

% Calcolo delle deformazioni per ogni fibra
for i = 1:numFibers
    n1 = fibers(i,1);
    n2 = fibers(i,2);
    
    % Vettore della fibra non deformata
    dX = nodes(n2,:) - nodes(n1,:);
    L0 = norm(dX);
    
    % Vettore della fibra deformata (piccole deformazioni)
    dx_small = x_small(:,n2) - x_small(:,n1);
    L_small = norm(dx_small);
    
    Lambda_small(i) = L_small / L0;
    e_nominal_small(i) = Lambda_small(i) - 1;
    e_direct_small(i) = 0.5 * (Lambda_small(i)^2 - 1);
    
    % Vettore della fibra deformata (grandi deformazioni)
    dx_large = x_large(:,n2) - x_large(:,n1);
    L_large = norm(dx_large);
    
    Lambda_large(i) = L_large / L0;
    e_nominal_large(i) = Lambda_large(i) - 1;
    e_direct_large(i) = 0.5 * (Lambda_large(i)^2 - 1);
end


%% Sezione 4: Visualizzazione dei Tensori e Dati Calcolati

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

disp('--------------- Errore e misure di deformazione ---------------');

disp('Differenza tra E ed epsilon (Errore):');
disp(difference);

disp('--------------- Deformazioni per le fibre ---------------');
% Creazione di tabelle per le deformazioni
fiberResults_small = table((1:numFibers)', fibers, Lambda_small, e_nominal_small, e_direct_small, ...
    'VariableNames', {'FibraID', 'Nodi', 'Lambda_small', 'e_nominale_small', 'e_diretta_small'});

fiberResults_large = table((1:numFibers)', fibers, Lambda_large, e_nominal_large, e_direct_large, ...
    'VariableNames', {'FibraID', 'Nodi', 'Lambda_large', 'e_nominale_large', 'e_diretta_large'});

disp('Deformazioni per piccole deformazioni:');
disp(fiberResults_small);

disp('Deformazioni per grandi deformazioni:');
disp(fiberResults_large);

disp('--------------- Coordinate ---------------');

disp('Coordinate iniziali:');
disp(X);

disp('Coordinate finali con Piccole Deformazioni:');
disp(x_small);

disp('Coordinate finali con Grandi Deformazioni:');
disp(x_large);


%% Sezione 5: Plot delle Configurazioni Originale e Deformate

figure;

% Plot della Configurazione Originale (Linea Blu)
plot(X(1, :), X(2, :), 'b-', 'LineWidth', 2); hold on;

% Plot della Configurazione Deformata utilizzando F (Grandi Deformazioni - Linea Verde)
plot(x_large(1, :), x_large(2, :), 'g-.', 'LineWidth', 1.5);

% Plot della Configurazione Deformata utilizzando epsilon e w (Piccole Deformazioni - Linea Rossa)
plot(x_small(1, :), x_small(2, :), 'r--', 'LineWidth', 2.5);

% Aggiunta di marcatori alle linee 
plot(X(1, :), X(2, :), 'bo', 'MarkerSize', 6, 'MarkerFaceColor', 'b');
plot(x_large(1, :), x_large(2, :), 'gs', 'MarkerSize', 6, 'MarkerFaceColor', 'g');
plot(x_small(1, :), x_small(2, :), 'r^', 'MarkerSize', 6, 'MarkerFaceColor', 'r');

% Legenda
legend('Configurazione Originale', 'Deformazione Grande (F)', 'Deformazione Piccola (\epsilon e w)', 'Location', 'bestoutside');
xlabel('X');
ylabel('Y');
title('Deformazione di un Quadrato con Rotazione, Scorrimento Angolare e Allungamenti');

% Impostazione degli assi
x_min = min([X(1,:), x_large(1,:), x_small(1,:)]) - 0.5;
x_max = max([X(1,:), x_large(1,:), x_small(1,:)]) + 0.5;
y_min = min([X(2,:), x_large(2,:), x_small(2,:)]) - 0.2;
y_max = max([X(2,:), x_large(2,:), x_small(2,:)]) + 0.2;

axis([x_min, x_max, y_min, y_max]);
axis equal;
grid on;
set(gca, 'FontSize', 12);


%% Sezione 6: Visualizzazione dei Valori di Input nel Grafico


% Creazione del testo da visualizzare con formattazione
input_text = {
    sprintf('Rotazione (rad): \\theta = %.4f', theta);
    sprintf('Deformazioni Normali: \\epsilon_{xx} = %.4f, \\epsilon_{yy} = %.4f', epsilon_xx, epsilon_yy);
    sprintf('Scorrimento Angolare: \\gamma = %.4f', gamma);
    };

annotation('textbox', [0.7, 0.1, 0.25, 0.2], 'String', input_text, 'FitBoxToText', 'on', 'BackgroundColor', 'white', 'EdgeColor', 'black', 'Interpreter', 'tex', 'FontSize', 10);

hold off;


%% Sezione 7: Visualizzazione delle Fibre Colorate in Base alla Deformazione

% Visualizzazione delle fibre per grandi deformazioni
figure;
hold on;

% Definizione della colormap
colormap jet;

% Deformazione nominale per grandi deformazioni
e_nominal_norm_large = (e_nominal_large - min(e_nominal_large)) / (max(e_nominal_large) - min(e_nominal_large));

for i = 1:numFibers
    n1 = fibers(i,1);
    n2 = fibers(i,2);
    % Ottenere il colore in base alla deformazione
    color = interp1(linspace(0,1,64), jet(64), e_nominal_norm_large(i));
    % Plot della fibra
    plot(x_large(1, [n1, n2]), x_large(2, [n1, n2]), '-', 'Color', color, 'LineWidth', 2);
end

axis equal;
grid on;
title('Quadrato Deformato (Grandi Deformazioni) Colorato in Base alla Deformazione Nominale');
xlabel('x');
ylabel('y');
clim([min(e_nominal_large), max(e_nominal_large)]);
colormap jet;
cb = colorbar;
cb.Label.String = 'Deformazione Nominale';
hold off;

% Visualizzazione delle fibre per piccole deformazioni
figure;
hold on;

% Deformazione nominale per piccole deformazioni
e_nominal_norm_small = (e_nominal_small - min(e_nominal_small)) / (max(e_nominal_small) - min(e_nominal_small));

for i = 1:numFibers
    n1 = fibers(i,1);
    n2 = fibers(i,2);
    % Ottenere il colore in base alla deformazione
    color = interp1(linspace(0,1,64), jet(64), e_nominal_norm_small(i));
    % Plot della fibra
    plot(x_small(1, [n1, n2]), x_small(2, [n1, n2]), '-', 'Color', color, 'LineWidth', 2);
end

axis equal;
grid on;
title('Quadrato Deformato (Piccole Deformazioni) Colorato in Base alla Deformazione Nominale');
xlabel('x');
ylabel('y');
clim([min(e_nominal_small), max(e_nominal_small)]);
colormap jet;
cb = colorbar;
cb.Label.String = 'Deformazione Nominale';
hold off;
