%--------------------------------------------------------------------
% Aurthor: Duncan Phyfe
%
% Document: vvcnt.m
% Date: 06.22.2015                  Rev. PRELIM
%
% Tilte: Data Processing, vector & contour plot 
%--------------------------------------------------------------------

%--------------------------------------------------------------------
% 1 - ALL FILES IN CURRENT WORKING DIRECTORY
% 2 - read all csv files in directory 
%--------------------------------------------------------------------

%clean things up...
clear all; 
                            
caslist=glob("*.csv");    % excel csv files in directory
numfiles=rows(caslist);

if (numfiles < 0)
  printf('Error')     %error trap if file couldn't be opened check CWD 
  
else

  for j=1:numfiles

    cid = caslist{j};
    d=csvread(cid);
    
    for i=1:10
      d(1,:)=[];
    endfor

    %setup variables
    x=d(:,13);
    y=d(:,14);
    c=d(:,7);
    vax=d(:,4);
    u=d(:,16);
    v=d(:,17);
    pr=6;  %pipe radius
    
    %plotting
    %figure(1,'Position',[50,50,800,800]);
    plot(x,y,".");    %include markers for measurement points
    hold on;
        
    %circle the wagon
    xx=-pr:0.05:pr;
    yy=(pr.^2-xx.^2).^0.5;
    plot(xx,yy,'r');
    plot(xx,-yy,'r');
    
    %contour of normalized axial 'c'
    dd=-6:1:6;
    [xq,yq]=meshgrid(dd,dd);
    vq=griddata(x,y,c,xq,yq,'nearest');
    %vq=griddata(x,y,vax,xq,yq,'nearest'); %VAX = Actual Axi-Vel
    
    dr=rows(vq);
    dc=columns(vq);
    
    for ii=1:dr 
      for jj=1:dc
       rc=(xq(ii,jj).^2+yq(ii,jj).^2).^0.5;
       if rc>6
        vq(ii,jj)=0;
       endif
      endfor
    endfor 
    
    contourf(xq,yq,vq);  %plot axial velocity contour
    colormap;
    %colormap ("gray");
    %colormap(flipud(gray));
    colorbar;
    caxis([0.4,1.1]);
    
    quiver(x,y,u,v,0.85); %plot vectors
    
    %format plot area
    axis off
    title(cid);
    hold off
    graphic=strcat("quiver-",num2str(j),".png");
    saveas(1,graphic);
    %print(graphic,"-dpng","-S800,800");
    
  endfor;
endif;


