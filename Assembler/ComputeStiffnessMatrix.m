function MESH = ComputeStiffnessMatrix(MESH)
    ns = MESH.STORAGE.alloc;
    nb = MESH.STORAGE.block;
    Kb = zeros(ns,3);
            
    %Compute the element stiffness matrices
    m = 0;
    n = 0;
    for k = 1:length(MESH.ELEMENT)
        %The element name
        name = MESH.ELEMENT(k,1).name;

        %The element connectivity
        node = MESH.ELEMENT(k,1).node;
        
        %Computes the element stiffness matrix
        ie = find(strcmpi({MESH.LIBRARY.name}, name));
        ke = feval(MESH.LIBRARY(ie).ke, MESH.ELEMENT(k,1), MESH.NODE(node));

        %Assembly the element contribution
        ndof = MESH.LIBRARY(ie).ndof;
        for i = 1:ndof
            for j = 1:ndof
                m = m + 1;
                Kb(m,1) = n + i;
                Kb(m,2) = n + j;
                Kb(m,3) = ke(i,j);
            end
        end
        n = n + ndof;
    end

    %Elements Block Matrix
    K = sparse(Kb(:,1), Kb(:,2), Kb(:,3), nb, nb);

    %Assemble all Elements
    K = MESH.MODEL.L'*K*MESH.MODEL.L;

    %Enforce Restrains/Constraints
    MESH.MODEL.K = MESH.MODEL.T'*K*MESH.MODEL.T;
end
