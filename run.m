%Clean the workspace
clc;
clear; 
close all; 

%Include FEM Libraries
addpath(genpath(pwd));
path(path);

%Prints Welcome Message
fprintf('STRUCTURAL ANALYSIS\n');
fprintf('Universidad Tecnica Federico Santa Maria\n');
fprintf('Departamento de Obras Civiles\n');

%TODO: Specify path to load file
modelpath ='path/to/file';

%TODO: Parse the file located at modelpath
MESH = ParseSimulationData(modelpath);

%TODO: Perform the static analysis
plotModel(MESH)

%TODO: Display the deformed shape
