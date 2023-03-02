function Fe = leTrussF(ELEM, NODE, fe)
    %Density
    rho = ELEM.prop(2);

    %Cross-Section Area
    Ae = ELEM.prop(3);
    
    %Element direction and length
    ve = NODE(2).coords - NODE(1).coords;
    Le = norm(ve);
    
    %Rotation matrix from global to local
    Re = RotationAxesTruss(ve);
    
    %The global axes transformation
    Te = LocalAxesTruss(ve);
    
    %Force in truss local coordinates
    qe = rho*Ae*Le/2*Re*fe';
    
    %Force in global coordinate
    Fe = Te'*[qe; qe];
end

%Compute/update vector rotation.
function R = RotationAxesTruss(v)
    %Local axis definition.
    u = v/norm(v);

    %Transformation matrix
    R =  [ u(1), u(2);
          -u(2), u(1)];
end

%Compute/update the local axis of the element.
function N = LocalAxesTruss(v)
    %Local axis definition.
    u = v/norm(v);

    %Transformation matrix
    N =  [ u(1), u(2),  0.0,  0.0;
          -u(2), u(1),  0.0,  0.0;
           0.0,   0.0,  u(1), u(2);
           0.0,   0.0, -u(2), u(1)];
end
