function Fe = leFrameF(ELEM, NODE, fe)
    %Density
    rho = ELEM.prop(2);

    %Cross-Section Area
    Ae = ELEM.prop(3);
    
    %Element direction and length
    ve = NODE(2).coords - NODE(1).coords;
    Le = norm(ve);
    
    %Rotation matrix from global to local
    Re = LocalAxesFrame(ve);
    
    %Force in frame local coordinates
    q  = LocalLoadFrame(ve,fe);
    qe = rho*Ae*Le/2*[q(1); q(2); q(2)*Le/6; q(1); q(2); -q(2)*Le/6];
    
    %Force in global coordinate
    Fe = Re'*qe;
end

%Compute the local load of the element.
function q = LocalLoadFrame(v,fe)
    %Local axis definition.
    u = v/norm(v);
    R = [ u(1), u(2);
         -u(2), u(1)];

    %Transformation matrix
    q = R*fe';
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
