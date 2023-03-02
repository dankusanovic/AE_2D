function Ke = leTrussK(ELEM,NODE)
    %TODO: Get properties
    %Elasticiy Modulus (E)
    Ee = ELEM.prop(1);

    %Cross-Section Area (A)
    Ae = ELEM.prop(3);
    
    %TODO: Compute the element length (Le)
    ve = NODE(2).coords - NODE(1).coords;
    Le = norm(ve);
    
    %TODO: Compute the global axes transformation (Re)
    Re = LocalAxesTruss(ve);

    %TODO: Compute the Stiffness matrix in local coordinates (ke)
    k  = Ee*Ae/Le;
    Ke = [ k, -k;
          -k,  k];

    %TODO: Compute the Stiffness matrix in global coordinates (Ke)
    Ke = Re'*Ke*Re;
end

%Compute/update the local axis of the element.
function Re = LocalAxesTruss(v)
    %Local axis definition.
    u = v/norm(v);

    %Transformation matrix
    Re = [ u(1), u(2),  0.0,  0.0;
          -u(2), u(1),  0.0,  0.0;
           0.0,   0.0,  u(1), u(2);
           0.0,   0.0, -u(2), u(1)];
end
