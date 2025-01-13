% 3D Bioprinting Simulation
% Simulating the optimization of bioprinting parameters using synthetic data

% Clear workspace
clear; clc;

% Generate synthetic dataset
numSamples = 1000;
extrusionPressure = randi([50, 150], numSamples, 1); % kPa
layerHeight = rand(numSamples, 1) * 0.4 + 0.1;       % mm
printingSpeed = randi([10, 50], numSamples, 1);      % mm/s
nozzleTemp = randi([20, 50], numSamples, 1);         % °C
crosslinkingAgent = randi([1, 10], numSamples, 1);   % 0.1%-1% CaCl2 in scale
printQuality = 0.3 * extrusionPressure + 0.4 * (0.5 - abs(layerHeight - 0.2)) ...
    - 0.2 * abs(printingSpeed - 30) + 0.1 * nozzleTemp ...
    - 0.5 * abs(crosslinkingAgent - 5) + randn(numSamples, 1) * 5;

% Normalize print quality to a scale of 1-100
printQuality = rescale(printQuality, 1, 100);

% Save to CSV for visualization or external analysis
csvwrite('bioprinting_data.csv', [extrusionPressure, layerHeight, printingSpeed, nozzleTemp, crosslinkingAgent, printQuality]);

% Load dataset for simulation
data = readmatrix('bioprinting_data.csv');
pressure = data(:, 1);
height = data(:, 2);
speed = data(:, 3);
temp = data(:, 4);
agent = data(:, 5);
quality = data(:, 6);

% Visualize the data
figure;
subplot(2, 2, 1);
scatter(pressure, quality, 'r');
xlabel('Extrusion Pressure (kPa)'); ylabel('Print Quality'); title('Pressure vs Quality');

subplot(2, 2, 2);
scatter(height, quality, 'g');
xlabel('Layer Height (mm)'); ylabel('Print Quality'); title('Height vs Quality');

subplot(2, 2, 3);
scatter(speed, quality, 'b');
xlabel('Printing Speed (mm/s)'); ylabel('Print Quality'); title('Speed vs Quality');

subplot(2, 2, 4);
scatter(temp, quality, 'k');
xlabel('Nozzle Temperature (°C)'); ylabel('Print Quality'); title('Temperature vs Quality');

% Train a simple regression model
X = [pressure, height, speed, temp, agent];
y = quality;

% Split data into training and testing
cv = cvpartition(size(X, 1), 'HoldOut', 0.3);
XTrain = X(training(cv), :);
yTrain = y(training(cv), :);
XTest = X(test(cv), :);
yTest = y(test(cv), :);

% Fit a regression model
mdl = fitlm(XTrain, yTrain);

% Test the model
predictions = predict(mdl, XTest);
rmse = sqrt(mean((predictions - yTest).^2));
disp(['Root Mean Square Error (RMSE): ', num2str(rmse)]);

% Plot actual vs predicted
figure;
scatter(yTest, predictions);
xlabel('Actual Print Quality'); ylabel('Predicted Print Quality');
title('Actual vs Predicted Print Quality');
grid on;


% Generate 3D plot of Print Quality vs Extrusion Pressure and Layer Height
figure;

% Create meshgrid for pressure and height
[PressureGrid, HeightGrid] = meshgrid(linspace(min(extrusionPressure), max(extrusionPressure), 50), ...
                                      linspace(min(layerHeight), max(layerHeight), 50));

% Define a function for print quality based on the generated data
QualityGrid = 0.3 * PressureGrid + 0.4 * (0.5 - abs(HeightGrid - 0.2)) ...
              - 0.2 * abs(30 - mean(printingSpeed)) + 0.1 * mean(nozzleTemp) ...
              - 0.5 * abs(mean(crosslinkingAgent) - 5);

% Plot the surface
surf(PressureGrid, HeightGrid, QualityGrid, 'EdgeColor', 'none');
xlabel('Extrusion Pressure (kPa)');
ylabel('Layer Height (mm)');
zlabel('Print Quality');
title('3D Plot of Print Quality');
colormap('jet');
colorbar;

% Enhance visualization
shading interp;
lighting phong;
view(135, 30); % Adjust viewing angle
grid on;

% Combined 3D scatter plot
figure;
scatter3(extrusionPressure, layerHeight, printQuality, 50, printingSpeed, 'filled');
xlabel('Extrusion Pressure (kPa)');
ylabel('Layer Height (mm)');
zlabel('Print Quality');
title('3D Scatter Plot of Print Quality');
colormap('jet');
colorbar;
view(120, 30);

% Add legend and enhance
grid on;
legend('Print Quality by Speed');

% Create meshgrid for pressure and speed
[PressureGrid, SpeedGrid] = meshgrid(linspace(min(extrusionPressure), max(extrusionPressure), 50), ...
                                     linspace(min(printingSpeed), max(printingSpeed), 50));

% Define a function for print quality
QualityGrid = 0.3 * PressureGrid + 0.4 * (0.5 - abs(0.2 - mean(layerHeight))) ...
              - 0.2 * abs(SpeedGrid - 30) + 0.1 * mean(nozzleTemp) ...
              - 0.5 * abs(mean(crosslinkingAgent) - 5);

% Plot the surface
figure;
surf(PressureGrid, SpeedGrid, QualityGrid, 'EdgeColor', 'none');
xlabel('Extrusion Pressure (kPa)');
ylabel('Printing Speed (mm/s)');
zlabel('Print Quality');
title('3D Plot of Print Quality vs Pressure and Speed');
colormap('cool');
colorbar;

% Enhance visualization
shading interp;
lighting phong;
view(135, 30);
grid on;


% Create meshgrid for height and temperature
[HeightGrid, TempGrid] = meshgrid(linspace(min(layerHeight), max(layerHeight), 50), ...
                                  linspace(min(nozzleTemp), max(nozzleTemp), 50));

% Define a function for print quality
QualityGrid = 0.3 * mean(extrusionPressure) + 0.4 * (0.5 - abs(HeightGrid - 0.2)) ...
              - 0.2 * abs(30 - mean(printingSpeed)) + 0.1 * TempGrid ...
              - 0.5 * abs(mean(crosslinkingAgent) - 5);

% Plot the surface
figure;
surf(HeightGrid, TempGrid, QualityGrid, 'EdgeColor', 'none');
xlabel('Layer Height (mm)');
ylabel('Nozzle Temperature (°C)');
zlabel('Print Quality');
title('3D Plot of Print Quality vs Height and Temperature');
colormap('spring');
colorbar;

% Enhance visualization
shading interp;
lighting phong;
view(120, 30);
grid on;


% Create the 3D surface plot for animation
figure;
surf(PressureGrid, HeightGrid, QualityGrid, 'EdgeColor', 'none');
xlabel('Extrusion Pressure (kPa)');
ylabel('Layer Height (mm)');
zlabel('Print Quality');
title('Animated 3D Plot of Print Quality');
colormap('jet');
colorbar;

% Enhance visualization
shading interp;
lighting phong;
grid on;

% Set initial view angle
view(0, 30);

% Create animation
frames = 360; % Number of frames for the animation
for angle = 1:frames
    view(angle, 30); % Rotate the view by changing azimuth
    pause(0.02); % Adjust pause to control animation speed
end

% Create the 3D scatter plot
figure;
scatter3(extrusionPressure, layerHeight, printQuality, 50, printingSpeed, 'filled');
xlabel('Extrusion Pressure (kPa)');
ylabel('Layer Height (mm)');
zlabel('Print Quality');
title('Animated 3D Scatter Plot');
colormap('jet');
colorbar;

% Set initial view angle
view(0, 30);

% Create animation
frames = 360; % Number of frames for the animation
for angle = 1:frames
    view(angle, 30); % Rotate the view by changing azimuth
    pause(0.02); % Adjust pause to control animation speed
end

% Set up video writer
videoFile = VideoWriter('3D_Plot_Animation.avi');
open(videoFile);

% Create the animated 3D surface plot
figure;
surf(PressureGrid, HeightGrid, QualityGrid, 'EdgeColor', 'none');
xlabel('Extrusion Pressure (kPa)');
ylabel('Layer Height (mm)');
zlabel('Print Quality');
title('3D Plot Animation');
colormap('jet');
colorbar;
shading interp;
lighting phong;
grid on;

% Animate and save frames
for angle = 1:360
    view(angle, 30); % Rotate view
    frame = getframe(gcf); % Capture frame
    writeVideo(videoFile, frame); % Write frame to video
end

% Close the video file
close(videoFile);
disp('Video saved as 3D_Plot_Animation.avi');


% Create the 3D surface plot
figure;
surf(PressureGrid, HeightGrid, QualityGrid, 'EdgeColor', 'none');
xlabel('Extrusion Pressure (kPa)');
ylabel('Layer Height (mm)');
zlabel('Print Quality');
title('Interactive 3D Surface Plot');
colormap('parula');
colorbar;

% Enable interactive rotation
rotate3d on;

% Add dynamic lighting for better visualization
lighting phong;
camlight('headlight');
shading interp;


% Create the interactive 3D scatter plot
figure;
scatter3(extrusionPressure, layerHeight, printQuality, 50, printingSpeed, 'filled');
xlabel('Extrusion Pressure (kPa)');
ylabel('Layer Height (mm)');
zlabel('Print Quality');
title('Interactive 3D Scatter Plot');
colormap('jet');
colorbar;

% Enable interactive rotation
rotate3d on;

% Annotate data points dynamically
dcm = datacursormode(gcf); % Activate data cursor mode
set(dcm, 'UpdateFcn', @(src, event) customDataTip(event));
disp('Hover over points to see details!');
