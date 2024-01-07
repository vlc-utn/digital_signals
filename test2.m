%% Test2
% El contenido de este archivo son pruebas sueltas, y no debe considerarse
% como contenido relevante.

clc; clear; close all;

M = 3;
x = [0 1 1 2 1 0 1 2 2 0];
y = [0 1 2 2 1 0 0 2 1 0];

[Px, Py, Pxy, Py_x, Px_y] = probability(M,x,y)
[Hx,Hy, Hxy] = entropy(M,x,y)

channel_capacity(M,x,y)

