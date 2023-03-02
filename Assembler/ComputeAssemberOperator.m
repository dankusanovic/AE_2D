function MESH = ComputeAssemberOperator(MESH)
    %TODO: Allocate memory for variables
    nt = MESH.STORAGE.total;
    nb = MESH.STORAGE.block;
    Lt = zeros(nb, 3);

    %TODO: Compute the restrain/constrain operator
    m = 0;
    for k = 1:length(MESH.ELEMENT)
        for j = MESH.ELEMENT(k,1).node
            for n = MESH.NODE(j,1).total
                m = m + 1;
                Lt(m,1) = m;
                Lt(m,2) = n;
                Lt(m,3) = 1.0;
            end
        end
    end

    %TODO: Store the Assembler Operator in MESH
    MESH.MODEL.L = sparse(Lt(:,1), Lt(:,2), Lt(:,3), m, nt);
end
