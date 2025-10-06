% Description — Preprocess and summarize 11-s LFP epochs (2 kHz) recorded around a
% train of light pulses (~t=5 s). The script auto-collects 11-s variables from
% the workspace, concatenates them, high-pass filters at 50 Hz, removes 60 Hz
% harmonics (notch), and rectifies. It then (optionally) segments a 3-s window
% (1 s pre / 1 s during / 1 s post) to detect spikes (peaks) per channel and
% quantify their counts and magnitudes. It plots per-channel traces, marks the
% stimulus period, exports the filtered data to CSV, and saves the workspace.



% Filter test
% Merge the 5 repetitions into the variable 'data'

% Get information about all variables in the workspace
variables = whos;

% Initialize an empty matrix to store the data
data = [];

% Iterate over all variables and concatenate them into 'data'
for i = 1:length(variables)
    % Use eval to access each variable in the workspace
    temp_data = eval(variables(i).name); 
    
    % Ensure the variable is numeric and has the expected size (adjust as needed)
    if isnumeric(temp_data) && size(temp_data, 1) == 22000  % Adjust depending on desired length
        data = [data, temp_data];  % Concatenate each array into 'data'
    end
end

% Subtract the mean of each column
cmean = data - mean(data);

% Create the time vector t
t = 0:0.0005:(size(data, 1)-1) * 0.0005;
t = t';

% Better option
% t = linspace(0, 3, 6000)

% -------- Filtering the signal to analyze --------

% Filter parameters
orden = 4;                 % Filter order
frecuencia_corte = 50;     % Cutoff frequency in Hz

% Sampling frequency of the signal
frecuencia_muestreo = 2000; % Sampling frequency in Hz

% Normalized cutoff frequency
frecuencia_corte_normalizada = frecuencia_corte / (frecuencia_muestreo / 2);

% Design a Butterworth high-pass filter
[b, a] = butter(orden, frecuencia_corte_normalizada, 'high');

% Apply the filter to the acquired signal
s_filtrada = filter(b, a, data);

% Limited to 3 s (1 pre, during, and 1 post stimulus)
s_filtradalim = s_filtrada(8001:14000, 1:10);

% -------- Notch filters --------

% Notch filter parameters
fs = 2000;                      % Sampling rate
harmonics = 60:60:900;          % Frequencies every 60 Hz up to 900 Hz
% extra = [383]; % if we also want to remove other specific frequencies
% harmonics = [extra harmonics]; % include extra frequencies if desired
notch_filtered_signal_completa = s_filtrada;  % Previous (input) signal

% Apply the notch filter for each harmonic
for i = 1:length(harmonics)
    f0 = harmonics(i);
    
    % Design a notch filter to remove frequency f0
    notchFilter = designfilt('bandstopiir', ...
                             'FilterOrder', 2, ...
                             'HalfPowerFrequency1', f0 - 1, ...
                             'HalfPowerFrequency2', f0 + 1, ...
                             'SampleRate', fs);
    
    % Filter the signal
    notch_filtered_signal_completa = filtfilt(notchFilter, notch_filtered_signal_completa);
end

% Save the filtered signal to CSV
writematrix(notch_filtered_signal_completa, 'A493_24h_11s.csv');

% -------- Plot filtered signal, per channel --------

% tlim = t(8001:14000);
numCanales = 10;  % Total number of channels

% Compute number of rows and columns for subplots
numFilas = fix((numCanales + 1) / 2);
numColumnas = 2;

% Create figure
fig = figure;

for i = 1:numCanales
    % Determine if the channel index is even or odd
    esPar = mod(i, 2) == 0;

    % Compute subplot position
    if esPar
        fila = i / 2;
        columna = 2;
        nombreCanal = 'Channel 2';
    else
        fila = (i + 1) / 2;
        columna = 1;
        nombreCanal = 'Channel 1';
    end

    % Create subplot
    subplot(6, numColumnas, (fila - 1) * numColumnas + columna);
        
    % Plot the filtered signal
    plot(t, s_filtrada(:, i), 'k-', 'LineWidth', 1); 
    set(gca, 'FontSize', 10, 'FontName', 'Times New Roman', 'FontWeight', 'bold', 'LineWidth', 1);
    xlim([4 7]) 
    ylim([-0.04 0.04])

    % --
    hold on
    subplot(6,2,11)
    plot(t, dataS(:), 'k-', 'LineWidth', 2)
    set(gca, 'FontSize', 10, 'FontName', 'Times New Roman', 'FontWeight', 'bold', 'LineWidth', 1);
    xlim([4 7]) 
    ylim([-10 10])

    hold on
    subplot(6,2,12)
    plot(t, dataS(:), 'k-', 'LineWidth', 2)
    set(gca, 'FontSize', 10, 'FontName', 'Times New Roman', 'FontWeight', 'bold', 'LineWidth', 1);
    xlim([4 7]) 
    ylim([-10 10]) 
end

% ===== CHANGE IF NEEDED =====
% Save the figure as .fig and .jpg in the current folder
% saveas(fig, 'A493_24h.fig'); 
% saveas(fig, 'A493_24h.jpg');  

% -------- Plot the filtered signal (grouped examples) --------
subplot(4, 1, 1);
plot(t, completa_control(:, 2), 'k-', 'LineWidth', 1); 
set(gca, 'FontSize', 10, 'FontName', 'Times New Roman', 'FontWeight', 'bold', 'LineWidth', 1);
xlim([1 2.5]) 
ylim([-0.02 0.02])

hold on
subplot(4, 1, 2);
plot(t, completa_ps(:, 2), 'k-', 'LineWidth', 1); 
set(gca, 'FontSize', 10, 'FontName', 'Times New Roman', 'FontWeight', 'bold', 'LineWidth', 1);
xlim([1 2.5]) 
ylim([-0.02 0.02])

hold on
subplot(4, 1, 3);
plot(t, completa_24h(:, 2), 'k-', 'LineWidth', 1); 
set(gca, 'FontSize', 10, 'FontName', 'Times New Roman', 'FontWeight', 'bold', 'LineWidth', 1);
xlim([1 2.5]) 
ylim([-0.02 0.02])

hold on
subplot(4,1,4)
plot(t, dataS(:), 'k-', 'LineWidth', 2)
set(gca, 'FontSize', 10, 'FontName', 'Times New Roman', 'FontWeight', 'bold', 'LineWidth', 1);
xlim([1 2.5]) 
ylim([-10 10])          

% -------- Rectify the signal --------
s_filtradar = abs(s_filtrada);

% -------- Segment and create a cell array to hold segments per channel (restricted to 8001:14000) --------

% % Initialize cell
% c = cell(1, 10);
% muestras_por_segmento = 100; % ADJUST depending on pulse frequency (125 for 8 Hz, 100 for 10 Hz)
% numSegmentos = fix(6000/muestras_por_segmento)
% for i = 1:10
%     c{i} = s_filtradar(8001:14000, i);
% end
% 
% % Initialize matrix c1separado
% c1separado = zeros(muestras_por_segmento, numSegmentos, 10);
% 
% for i = 1:10
%     contador1 = 1;
%     for b = 1:numSegmentos
%         % Assign values directly via indexing
%         c1separado(:, b, i) = c{i}(contador1 : contador1 + muestras_por_segmento - 1);
%         contador1 = contador1 + muestras_por_segmento;
%     end
% end

% -------- Detect peaks --------

% % Initialize cell to store peaks per channel
% picos_por_canal = cell(1, 10);
% umbral = 0.0008; % threshold
% 
% for i = 1:10
%     % Get segment matrix for the current channel
%     segmentos_canal = c1separado(:, :, i);
% 
%     % Initialize cell to store peaks per segment
%     picos_por_segmento = cell(1, numSegmentos);
% 
%     % Find peaks in each segment
%     for j = 1:numSegmentos
%         segmento_actual = segmentos_canal(:, j);
%         [pks, locs] = findpeaks(segmento_actual, 'MinPeakHeight', umbral);
% 
%         % Store peaks and locations in the cell
%         picos_por_segmento{j} = struct('picos', pks, 'ubicaciones', locs);
%     end
% 
%     % Store the per-segment peaks cell in the per-channel cell
%     picos_por_canal{i} = picos_por_segmento;
% end

% -------- Plot number of peaks per segment for each channel --------

% Nombrecanal1 = ('Channel 1');
% Nombrecanal2 = ('Channel 2');
% 
% figure;
% 
% for i = 1:10
%     subplot(5, 2, i); % Create one subplot per channel
%     hold on;
%     
%     if i == 1
%         title(Nombrecanal1);
%     elseif i == 2    
%         title(Nombrecanal2);
%     end
% 
%     % Get the per-segment peaks cell for the current channel
%     picos_por_segmento = picos_por_canal{i};
% 
%     % Initialize a vector to store the number of peaks per segment
%     num_picos_por_segmento = zeros(1, numSegmentos);
% 
%     % Get the number of peaks per segment and store it in the vector
%     for j = 1:numSegmentos
%         num_picos_por_segmento(j) = numel(picos_por_segmento{j}.ubicaciones);
%     end
% 
%     % Plot the number of peaks per segment
%     plot(1:numSegmentos, num_picos_por_segmento, '-o');
%     if i == 9
%         xlabel('Segments');
%     elseif i == 10    
%         xlabel('Segments');
%     elseif i == 5
%         ylabel('Number of Peaks');
%     end
%     xline([16 32], '-', 'LineWidth', 2)
%     % {'1 s pre-pulse','1 s pulse','1 s post-pulse'}
%      
%     % Adjust axis limits
%     ylim([0 40]);
%     % xlim([])
%      
%     grid on;
% end
% 
% sgtitle('Number of Peaks');

% -------- Save the workspace --------

% Save the complete workspace to a .mat file
save('A455_24hplus.mat');
