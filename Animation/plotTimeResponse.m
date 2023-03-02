function plotTimeResponse(MESH, A)
    %Obtaines elements and coordinates
    [LINES, QUADS, COORD, dof] = renderData(MESH);

    %Plots the animation
    U = MESH.SOLUTION.U;
    xmax = [min(COORD(:,1)), max(COORD(:,1))] + A*[min(min(U(dof(:,1),:))), max(max(U(dof(:,1),:)))];
    zmax = [min(COORD(:,2)), max(COORD(:,2))] + A*[min(min(U(dof(:,2),:))), max(max(U(dof(:,2),:)))];

    %Generates the mesh visualization
    q = patch('Vertices', COORD, 'Faces', QUADS, 'facecolor', [0.675 0.925 1]);
    f = patch('Vertices', COORD, 'Faces', LINES, 'facecolor', [1 1 1], 'Linewidth', 2);

    %Plots the response
    for k = 1:size(U,2)
        X = U(:,k);
        set(q,'Vertices', COORD + A*X(dof));
        set(f,'Vertices', COORD + A*X(dof));
        axis equal;
        axis off;
        xlim(xmax);
        ylim(zmax);
        drawnow;
    end
end

function [LINES, QUADS, COORD, dof] = renderData(MESH)
    nNodes = length(MESH.NODE);
    nElems = length(MESH.ELEMENT);
    
    %Computes the center of the model
    xcm = zeros(1, 2);
    dof = zeros(nNodes, 2);
    for k = 1:nNodes
        xcm = xcm + MESH.NODE(k,1).coords;
        dof(k,:) = MESH.NODE(k,1).total(1:2);
    end
    xcm = xcm/length(MESH.NODE);
    
    %Centers the model at mid-point
    COORD = zeros(nNodes, 2);
    for k = 1:nNodes
        COORD(k,:) = MESH.NODE(k,1).coords - xcm;
    end
    
    %Gets the elements according to geometry
    LINES = [];
    QUADS = [];
    for k = 1:nElems
        conn = MESH.ELEMENT(k,1).node;

        if length(conn) == 2
            LINES = [LINES;[conn(1), conn(2), conn(2), conn(1)]];
        elseif length(conn) == 4
            QUADS = [QUADS;[conn(1), conn(2), conn(3), conn(4)]];
        end
    end
end
