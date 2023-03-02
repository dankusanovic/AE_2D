function Ke = leFrameK(ELEM,NODE)
    %TODO: Get section properties
    %Elasticiy Modulus (E)
    E = ELEM.prop(1);

    %Cross-Section Area (A)
    A = ELEM.prop(3);

    %Cross-Section Inertia (I)
    I = ELEM.prop(4);

    %TODO: Compute Element length (Le)
    ve = NODE(2).coords - NODE(1).coords;
    L = norm(ve);

    %TODO: Computes the Stiffness matrix in local coordinates
    Ke = [ E*A/L,         0.0,        0.0, -E*A/L,         0.0,        0.0;
             0.0,  12*E*I/L^3,  6*E*I/L^2,    0.0, -12*E*I/L^3,  6*E*I/L^2;
             0.0,   6*E*I/L^2,    4*E*I/L,    0.0,  -6*E*I/L^2,    2*E*I/L;
          -E*A/L,         0.0,        0.0,  E*A/L,         0.0,        0.0;
             0.0, -12*E*I/L^3, -6*E*I/L^2,    0.0,  12*E*I/L^3, -6*E*I/L^2;
             0.0,   6*E*I/L^2,    2*E*I/L,    0.0,  -6*E*I/L^2,    4*E*I/L];

    %TODO: Compute the global axes transformation (Re)
    Re = LocalAxesFrame(ve);

    %TODO: Transform the Stiffness matrix in global coordinates (Ke)
    Ke = Re'*Ke*Re;
end

%Compute/update the local axis of the element.
function R = LocalAxesFrame(v)
    %Local axis definition.
    u = v/norm(v);

    %Transformation matrix
    R =  [u(1), u(2), 0.0,   0.0,  0.0, 0.0;
         -u(2), u(1), 0.0,   0.0,  0.0, 0.0;
          0.0,   0.0, 1.0,   0.0,  0.0, 0.0;
          0.0,   0.0, 0.0,  u(1), u(2), 0.0;
          0.0,   0.0, 0.0, -u(2), u(1), 0.0;
          0.0,   0.0, 0.0,   0.0,  0.0, 1.0];
end