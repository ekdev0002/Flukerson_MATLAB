function fi = Fulkerson(G, s, t)
        fi = zeros(1, G.numedges); 
        vide=[0 0];
        Gc = G;       
        Gres = residuel(Gc, fi);
  
        chemin = chercher_chemin(Gres, s, t);
        fi = construire_flux(Gc, chemin, fi);
        while ( size(chemin) ~= vide)      
            Gres = residuel(Gc,fi);
            chemin = chercher_chemin(Gres, s, t);
            subplot(2,2,1),plot(Gc,'EdgeLabel',G.Edges.Weight),title('Graphe initial');
            pause(1);
            fi = construire_flux(Gc, chemin, fi);
        end
        G.Edges.Weight=fi';
        max=flux_max(G,s,fi);
        disp(fi);
        disp(max);
        text=strcat('Graphe final ayant pour flux max = ',num2str(max));
        subplot(2,2,[3,4]),p2=plot(G,'EdgeLabel',G.Edges.Weight);highlight(p2,G,'NodeColor','g','EdgeColor','r'),title(text);
end
   
 
function Gr = residuel(Go,fi)
    Gr=Go;
     for i = 1 : Go.numedges
         if fi(i) < Go.Edges.Weight(i)
             Gr=ajouter_arc(Gr,Go.Edges(i,1).EndNodes(1),Go.Edges(i,1).EndNodes(2),Go.Edges.Weight(i) - fi(i));
         else
             Gr=rmedge(Gr,Go.Edges(i, 1).EndNodes(1),Go.Edges(i, 1).EndNodes(2));             
         end
         if fi(i) > 0 
             source = Go.Edges(i, 1).EndNodes(2);
             puit = Go.Edges(i, 1).EndNodes(1);             
             Gr = ajouter_arc(Gr, source, puit, fi(i));
         end
     end
end


function fi = construire_flux(Gf, chemin, fi)     
  
    vide=[0 0];
    if size(chemin)~= vide
     epsilon = min(chemin.Edges.Weight);
     for i = 1 : length(chemin.Edges.Weight)
         j = findedge2(Gf, chemin.Edges(i,1).EndNodes(1), chemin.Edges(i, 1).EndNodes(2));
         if j ~= 0
             fi(j) = fi(j) + epsilon;
         else
             j = findedge2(Gf,chemin.Edges(i,1).EndNodes(2), chemin.Edges(i,1).EndNodes(1));
             fi(j) = fi(j) - epsilon;
         end
     end
  end
end

function chemin = chercher_chemin(G, s, t)
     chemin = shortestpath(G, s, t);
     subplot(2,2,2),p1=plot(G,'EdgeLabel',G.Edges.Weight);highlight(p1,chemin,'EdgeColor','r'),title('Graphe résiduel');
     vide=[0 0];
     if size(chemin) == vide
         graph_chem = digraph();
     else
         graph_chem = digraph();
         for i = 1 : length(chemin) - 1
             graph_chem = addedge(graph_chem, chemin(i), chemin(i+1), G.Edges.Weight(findedge2(G, chemin(i), chemin(i+1))));
         end
         chemin = graph_chem ;
     end
end