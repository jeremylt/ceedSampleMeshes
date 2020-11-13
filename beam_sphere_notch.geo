// Inputs
SetFactory("OpenCASCADE");
gridsize = 100/30;

// Points
// -- Circle
Point(1) = {  0,  -0.5, 0, gridsize};
Point(2) = { 37,  -0.5, 0, gridsize};
Point(3) = {  0, -37.5, 0, gridsize};
// -- Outline
Point(4) = {-15, -37.5, 0, gridsize};
Point(5) = {-15,   -50, 0, gridsize};
Point(6) = {400,   -35, 0, gridsize};
Point(7) = {400,  -0.5, 0, gridsize};

// Lines
Circle(101) = {2, 1, 3};
Line(102) = {3, 4};
Line(103) = {4, 5};
Line(104) = {5, 6};
Line(105) = {6, 7};
Line(106) = {7, 2};

// Surface
Line Loop(110) = {101, 102, 103, 104, 105, 106};
Plane Surface(201) = {110};
Recombine Surface{201};

// Extrude to 3D
upperExtrusion[] =
Extrude { {1, 0, 0}, {400, 0, 0}, Pi}
{
    Surface{201};
    Layers{100/gridsize};
    Recombine;
};
lowerExtrusion[] =
Extrude { {1, 0, 0}, {400, 0, 0}, -Pi}
{
    Surface{201};
    Layers{100/gridsize};
    Recombine;
};

// Boundaries
Physical Surface("notch") = {upperExtrusion[2], lowerExtrusion[2]};
Physical Surface("end") = {upperExtrusion[6], lowerExtrusion[6]};

// Volume
Physical Volume("mesh") = {upperExtrusion[1], lowerExtrusion[1]};
Mesh 3;
Coherence Mesh;
