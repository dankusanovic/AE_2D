function plotModel(MESH)
    %Obtaines elements and coordinates
    [LINES, QUADS, COORD] = renderData(MESH);

    %Plots the animation
    xmax = 1.25*[min(COORD(:,1)), max(COORD(:,1))];
    zmax = 1.25*[min(COORD(:,2)), max(COORD(:,2))];

    %Generates the mesh visualization
    patch('Vertices', COORD, 'Faces', QUADS, 'facecolor', [0.675 0.925 1]);
    patch('Vertices', COORD, 'Faces', LINES, 'facecolor', [1 1 1], 'Linewidth', 2);
    axis equal;
    axis off;
    xlim(xmax);
    ylim(zmax);
end

function [LINES, QUADS, COORD] = renderData(MESH)
    nNodes = length(MESH.NODE);
    nElems = length(MESH.ELEMENT);
    
    %Computes the center of the model
    xcm = zeros(1, 2);
    for k = 1:nNodes
        xcm = xcm + MESH.NODE(k,1).coords;
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