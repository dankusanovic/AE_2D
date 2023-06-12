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
modelpath ='/home/danilo/Documents/01-Lectures/AE_CIV234/Homework/AE_2D/Examples/Marco2D.txt';

%TODO: Parse the file located at modelpath
MESH = ParseSimulationData(modelpath);

%TODO: Perform the static analysis
plotModel(MESH)

%TODO: Display the deformed shape
