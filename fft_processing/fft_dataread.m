%--------------------------------------------------------------------
% Aurthor: Duncan Phyfe
%
% Document: fft_dataread.m
% Date: 2015.03.02                  Rev. PRELIM
%
% Tilte: Cycle thru datafiles and perform fft
%--------------------------------------------------------------------

%--------------------------------------------------------------------
% 1 - ALL FILES IN CURRENT WORKING DIRECTORY
% 2 - filenames assumed to be 6 characters long before '.txt'
%--------------------------------------------------------------------

%data inputs...
%cfd_tstep=1e-4;
%cfd_write=100;
cfd_datasets=2048;  %select to be 2^x  (case20 = 2500 lines)
cfd_tstart=0.0;
cfd_tfinish=9.996;

%--------------------------------------------------------------------
% Creating case list @ Windows command prompt
%
% c:\CWD> dir /b case* > filelist.txt     /CWD=current working directory
% 
%--------------------------------------------------------------------

%open the file "case list" for reading
fid = fopen('filelist.txt','r');  %Enter your case list filename 'filelist.txt' for example
lr=1;   %line read counter

if (fid < 0)
  printf('Error')     %error trap if file couldn't be opened check CWD 
  
else

  while ~feof(fid),
    cid = fgetl(fid);
    
    %load cfd force results
    cfd_results=dlmread(cid);    %read space delimited file
    t_run=cfd_results(:,1);               % get the time history
    
    %put columns of interest into own var for fft
    c_11=cfd_results(:,11);     
    c_12=cfd_results(:,12); 
    c_14=cfd_results(:,14); 
    c_16=cfd_results(:,16); 

    f_s=cfd_datasets/(cfd_tfinish-cfd_tstart);
    sa=cfd_datasets;

    n=cfd_datasets; %required to be 2^x // Octave will truncate or "0 fill" to reach n

    freq = f_s*(0:n-1)/n;

    f_11 = abs(fft(c_11, n))*2/sa; 
    f_12 = abs(fft(c_12, n))*2/sa;
    f_14 = abs(fft(c_14, n))*2/sa;
    f_16 = abs(fft(c_16, n))*2/sa;
    transform=[f_11,f_12,f_14,f_16];

    %write out data
    cid=strtrunc(cid,6);
    fn=strcat(cid,"-","4col",".txt");
    dlmwrite(fn,transform);  
    
    %remove 0 frquency from dataset for plotting
    freq(:,1)=[];
    f_11(1,:)=[];
    f_12(1,:)=[];
    f_14(1,:)=[];
    f_16(1,:)=[];

    %find the Maximum // Single Maximum
    [p_11max,p_11i]=max(f_11);
    p_11mf=freq(p_11i);
    [p_12max,p_12i]=max(f_12);
    p_12mf=freq(p_12i);
    [p_14max,p_14i]=max(f_14);
    p_14mf=freq(p_14i);
    [p_16max,p_16i]=max(f_16);
    p_16mf=freq(p_16i);

    %plotting & saving
    for i = 1:4
      figure (num2str(i));
      plot(freq,f_11);
      graphic=strcat(cid,"-",num2str(i),".png");
      print(graphic);
     endfor 
    lr++;
  end;        %while

end;          %if

