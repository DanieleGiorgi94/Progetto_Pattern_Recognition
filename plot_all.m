function r=plot_all(ZZZ,V)
% questa funzione realizza un generico plot a partire dalla matrice ZZZ
% tramite la conoscenza del vettore V in cui sono presenti le prime 3 componenti
% che sono le coordinate dei tre assi e la 4 componente che invece ? la colonna che indica 
% le label da associare ad ogni punto.
%la quinta componente di V ci dice il colore del grafico
SS=ZZZ;
V1=V;
col1=['b' 'r' 'k' 'm' 'g' 'c' 'y'];
if V(5)==0
   col='b';
end;
col=col1(V(5));

if V1(3)==0
   for i=1:length(SS(:,1))
      plot(SS(i,V1(1)),SS(i,V1(2)),'w');
      if V1(4)==0
      text(SS(i,V1(1)),SS(i,V1(2)),[num2str(i)],'Fontsize',13,'color',col);
      elseif V(4)>0
      text(SS(i,V1(1)),SS(i,V1(2)),[num2str(SS(i,V1(4)))],'Fontsize',13,'color',col);
      end;
      xlabel([num2str(V1(1))]);
      ylabel([num2str(V1(2))]);
      hold on;
      grid on;
      zoom;
    end;
 end;   
 if V1(3)>0
   for i=1:length(SS(:,1))
      plot3(SS(i,V(1)),SS(i,V(2)),SS(i,V(3)),'w');
      if V1(4)==0
      text(SS(i,V(1)),SS(i,V(2)),SS(i,V(3)),[num2str(i)],'Fontsize',13,'color',col);
      elseif V1(4)>0
      text(SS(i,V1(1)),SS(i,V(2)),[num2str(SS(i,V1(4)))],'Fontsize',13,'color',col);
      end;
      hold on;
       
   end;

   grid on;
   xlabel([' ',num2str(V1(1))]);
   ylabel([' ',num2str(V1(2))]);
   zlabel([' ',num2str(V1(3))]);
   rotate3d; 
 end;
 r=1;
