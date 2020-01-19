function G = ajouter_arc(G, a, b, c)
     d=findedge2(G, a, b); 
     if d ~= 0
         G = rmedge(G, a, b);
         G = addedge(G, a, b, c);
     else
         G = addedge(G, a, b, c);
     end
end     
