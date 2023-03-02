function MESH = ParseSimulationData(modelpath)
    %Reads the Input File
    meshfile = fileread(modelpath);
    meshfile = strsplit(meshfile,'\n');

    %Creates empty structures
    Damping = struct('name', [], 'coeff', []);
    [Nodes, Elements, Loads, Bodies, Library] = GetDataStructure(meshfile);

    nlines = length(meshfile);
    for k = 1:nlines
        data = split(meshfile{1,k});
        if strcmpi(data{1},'NODE')
            %Node's identifier
            ntag = str2double(data{2});

            %Number of degree-of-freedom
            ndof = str2double(data{3});

            %Node's coordinate values
            coords = [str2double(data{4}), str2double(data{5})];

            %Degree of freedom numbering
            free = zeros(1,ndof);
            total = zeros(1,ndof);
            for m = 1:ndof
                total(1,m) = str2double(data{5+m});
                free(1,m)  = str2double(data{5+ndof+m});
            end

            %Fills the information
            Nodes(ntag,1).ndof = ndof;
            Nodes(ntag,1).free = free;
            Nodes(ntag,1).total = total;
            Nodes(ntag,1).coords = coords;

        elseif strcmpi(data{1},'ELEMENT')
            %Element's information
            etag = str2double(data{2});
            ename = data{3};

            %Available elements
            if strcmpi(ename, 'TRUSS')
                nodes = [str2double(data{4}), str2double(data{5})];
                E   = str2double(data{6});
                rho = str2double(data{7});
                A   = str2double(data{8});
                eprop = [E, rho, A];
            elseif strcmpi(ename, 'FRAME')
                nodes = [str2double(data{4}), str2double(data{5})];
                E   = str2double(data{6});
                rho = str2double(data{7});
                A   = str2double(data{8});
                I   = str2double(data{9});
                eprop = [E, rho, A, I];
                fprintf('The ELEMENT %s is not recognized!\n',ename);
            end

            %Fills the information
            Elements(etag,1).name = ename;
            Elements(etag,1).node = nodes;
            Elements(etag,1).prop = eprop;

        elseif strcmpi(data{1},'FORCE')
            %Point load's information
            ltag = str2double(data{2});
            ltype = data{3};
            lname = data{4};

            %Force values
            if strcmpi(lname, 'CONSTANT')
                value = str2double(data{5});
            elseif strcmpi(lname, 'TRANSIENT')
                path = data{5};
                value = load(path);
            end

            %Direction of this force
            ndof = str2double(data{6});
            dir  = zeros(1, ndof);
            for m = 1:ndof
                dir(1,m) = str2double(data{6+m});
            end

            %Nodes which have this force
            num = str2double(data{7+ndof});
            tags = zeros(1, num);
            for m = 1:num
                tags(1,m) = str2double(data{7+ndof+m});
            end

            %Fills the information
            if strcmpi(ltype, 'POINT')
                Loads(ltag,1).name  = lname;
                Loads(ltag,1).value = value;
                Loads(ltag,1).dir   = dir;
                Loads(ltag,1).node  = tags;
            elseif strcmpi(ltype, 'SURFACE')
            elseif strcmpi(ltype, 'VOLUME')
                Bodies(ltag,1).name  = lname;
                Bodies(ltag,1).value = value;
                Bodies(ltag,1).dir   = dir;
                Bodies(ltag,1).element = tags;
            end
        end
    end

    %Memory allocation
    mem = 0;
    com = 0;
    Alloc = struct('free', [], 'total', [], 'alloc', [], 'block', []);

    for k = 1:length(Elements)
        aux = 0.0;
        for j = Elements(k,1).node
            aux = aux + Nodes(j,1).ndof;
            mem = mem + Nodes(j,1).ndof; 
        end
        com = com + aux^2;
    end

    Alloc.alloc = com;
    Alloc.block = mem;

    nfree = 0;
    ntotal = 0;
    for k = 1:length(Nodes)
        nfree = max([nfree, Nodes(k,1).free]);
        ntotal = max([ntotal, Nodes(k,1).total]);
    end

    Alloc.free = nfree;
    Alloc.total = ntotal;

    %The mesh structure
    Sols   = struct('U', []);
    Model  = struct('M', [], 'C', [], 'K', [],'F', [], 'L', [], 'T', []);
    Forces = struct('Point', Loads, 'Surface', [], 'Volume', Bodies);
    MESH   = struct('NODE', Nodes, 'ELEMENT', Elements, 'LOAD', Forces, 'LIBRARY', Library, 'STORAGE', Alloc, 'MODEL', Model, 'SOLUTION', Sols);
end