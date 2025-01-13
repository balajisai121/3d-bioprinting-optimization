# 3d-bioprinting-optimization
A comprehensive study and simulation of 3D bioprinting parameter optimization using machine learning and MATLAB. Includes insights into extrusion pressure, layer height, and bioink composition.

# 3D Bioprinting Optimization Project

This repository contains the course project for optimizing 3D bioprinting parameters using machine learning techniques and MATLAB simulations. The project explores the impact of extrusion pressure, layer height, printing speed, and nozzle temperature on print quality.

## Project Overview
- **Objective**: Optimize critical bioprinting parameters to improve print quality and cell viability.
- **Key Metrics**: Print quality (1-100 scale), structural fidelity, and resolution.

## Dataset Description
- **Parameters**:
  - Extrusion Pressure (kPa): 50-150
  - Layer Height (mm): 0.1-0.5
  - Printing Speed (mm/s): 10-50
  - Nozzle Temperature (°C): 20-50
  - Crosslinking Agent (% CaCl₂): 0.1-1.0
- **Outputs**: Print Quality (1-100 scale)

## Methods
- **Data Preparation**:
  - Synthetic data generated using MATLAB.
  - Feature scaling and normalization for machine learning models.
- **Machine Learning Models**:
  - Support Vector Machine (SVM)
  - Random Forest
  - Neural Networks (TensorFlow/Keras)
- **MATLAB Simulations**:
  - Visualizations of parameter relationships (scatter and 3D plots).
  - Regression model for predicting print quality.

## Results
- **Best Parameters**:
  - Extrusion Pressure: 85 kPa
  - Layer Height: 0.2 mm
  - Printing Speed: 30 mm/s
  - Nozzle Temperature: 37°C
- **Model Performance**:
  - Random Forest: 92.4% accuracy
  - Neural Network: 90.1% accuracy
  - SVM: 83.3% accuracy

## Visualizations
- Scatter plots for individual parameters vs. print quality.
- 3D surface plots for combined parameter impact.
- Residual analysis for model predictions.

## Repository Structure
```plaintext
3d-bioprinting-optimization/
├── data/                 # Raw and processed datasets
│   ├── bioprinting_data.csv
│   └── cleaned_data.csv
├── scripts/              # MATLAB scripts
│   └── 3D_BIO_PRINT.m
├── notebooks/            # Jupyter notebooks for ML models
│   ├── feature_analysis.ipynb
│   ├── model_training.ipynb
│   └── visualization.ipynb
├── visualizations/       # Plots and graphs
│   ├── scatter_plots.png
│   ├── 3d_surface_plots.png
│   └── residual_analysis.png
├── docs/                 # Reports and presentations
│   ├── FINAL_REPORT.pdf
│   └── FINAL_PRESENTATION.pdf
├── README.md             # Project overview
├── LICENSE               # License file
└── requirements.txt      # Python dependencies
