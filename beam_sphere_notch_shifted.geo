// Inputs
SetFactory("OpenCASCADE");
gridsize = 100/30;

// Points
// -- Circle
Point(1) = {-45,  -0.5, 0, gridsize};
Point(2) = {-15,  -0.5, 0, gridsize};
Point(3) = {-45, -30.5, 0, gridsize};
// -- End
Point(4) = {-45,   -50, 0, gridsize};
Point(5) = {  0,   -50, 0, gridsize};
Point(6) = {  0,  -0.5, 0, gridsize};
// -- Pole
Point(7) = {400,  -0.5, 0, gridsize};
Point(8) = {400,   -35, 0, gridsize};

// Lines
// -- End
Circle(101) = {2, 1, 3};
Line(102) = {3, 4};
Line(103) = {4, 5};
Line(104) = {5, 6};
Line(105) = {6, 2};
// -- Pole
Line(106) = {7, 6};
Line(107) = {8, 7};
Line(108) = {5, 8};

// Surface
// -- End
Line Loop(110) = {101, 102, 103, 104, 105};
Plane Surface(201) = {110};
Recombine Surface{201};
// -- Pole
Line Loop(120) = {-104, 108, 107, 106};
Plane Surface(202) = {120};
Recombine Surface{202};

// Extrude to 3D
upperExtrusion[] =
Extrude { {1, 0, 0}, {400, 0, 0}, Pi}
{
    Surface{201, 202};
    Layers{100/gridsize};
    Recombine;
};
lowerExtrusion[] =
Extrude { {1, 0, 0}, {400, 0, 0}, -Pi}
{
    Surface{201, 202};
    Layers{100/gridsize};
    Recombine;
};

// Boundaries
Physical Surface("notch") = {upperExtrusion[2], lowerExtrusion[2]};
Physical Surface("end") = {upperExtrusion[11], lowerExtrusion[11]};

// Volume
Physical Volume("mesh") = {
    upperExtrusion[1],
    upperExtrusion[8],
    lowerExtrusion[1],
    lowerExtrusion[8]
};
Mesh 3;
Coherence Mesh;
