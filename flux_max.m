function f=flux_max(G,s,fi)
    f=0; 
    for i=1:G.numedges
        
        a=char(G.Edges(i,1).EndNodes(1));
        if s== a
            f=f+fi(i);
        end
    end
end
