function MESH = ComputeRestrainOperator(MESH)
    %TODO: Allocate memory for variables
    nt = MESH.STORAGE.total;
    nf = MESH.STORAGE.free;
    Tr = zeros(nf, 3);

    %TODO: Compute the restrain/constrain operator
    i = 0;
    for k = 1:length(MESH.NODE)
        for j = 1:MESH.NODE(k,1).ndof 
            if MESH.NODE(k,1).free(j) > 0
                i = i + 1; 
                Tr(i,1) = MESH.NODE(k,1).total(j);
                Tr(i,2) = MESH.NODE(k,1).free(j);
                Tr(i,3) = 1.00; 
            end
        end
    end

    %TODO: Store the Reastrain Operator in MESH
    MESH.MODEL.T = sparse(Tr(:,1), Tr(:,2), Tr(:,3), nt, nf);
end
