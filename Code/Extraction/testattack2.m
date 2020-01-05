result_r=zeros(616,1);
result_l=zeros(616,1);
%wav=wav1_mp3;
wav=wav_final_double;
%%%%%%%%%
p_mat2 = [p_mat',p_mat']';
for second=1:length(wav_ori)/Fs
 %%%%%%% CONSTRUCT_MATRIX  %%%%%%%%%%
%%%%%%%%  DETECTION_OF_WATERMARK  _RIGHT%%%%%%%%%%
sn=wav(Fs*(second-1)+1:Fs*second,2);
sn=sn';
S=dct(sn);
sno=wav_ori(Fs*(second-1)+1:Fs*second,2);
sno=sno';
So=dct(sno);
index=0:2:2*N-2;
flag=true;

for iter=1:Ns
 Si=S(fL+(iter-1)*2*N:fL+iter*2*N-1);
 Sio=So(fL+(iter-1)*2*N:fL+iter*2*N-1);
 si1=Si(index+1)./Sio(index+1);
 si2=Si(index+2)./Sio(index+2);
 sdo=abs(si1)-abs(si2);
 res=sdo*p_mat;
 si1=Si(index+1);
 si2=Si(index+2);
 sdo=abs(si1)-abs(si2);
 
 Si=S(fL+fH+(iter-1)*2*N:fL+fH+iter*2*N-1);
 si1=Si(index+1);
 si2=Si(index+2);
 sd2=[sdo,abs(si1)-abs(si2)];
 res2=sd2*p_mat2;
 res = res;
ind=find(res==max(res));

result_r((second-1)*Ns+iter,1)=ind-1;
end


%wav_final_r(1+Fs*(second-1):Fs*second)=sn;

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

for second=1:length(wav_ori)/Fs
 %%%%%%% CONSTRUCT_MATRIX  %%%%%%%%%%
%%%%%%%%  DETECTION_OF_WATERMARK _LEFT %%%%%%%%%%
sn=wav(Fs*(second-1)+1:Fs*second,1);
sn=sn';
S=dct(sn);
sno=wav_ori(Fs*(second-1)+1:Fs*second,1);
sno=sno';
So=dct(sno);
index=0:2:2*N-2;
flag=true;

for iter=1:Ns
 Si=S(fL+(iter-1)*2*N:fL+iter*2*N-1);
 Sio=So(fL+(iter-1)*2*N:fL+iter*2*N-1);
 si1=Si(index+1)./Sio(index+1);
 si2=Si(index+2)./Sio(index+2);
 sdo=abs(si1)-abs(si2);
 res=sdo*p_mat;
 
 si1=Si(index+1);
 si2=Si(index+2);
 sdo=abs(si1)-abs(si2);
 Si=S(fL+fH+(iter-1)*2*N:fL+fH+iter*2*N-1);
 si1=Si(index+1);
 si2=Si(index+2);
 sd2=[sdo,abs(si1)-abs(si2)];
 res2=sd2*p_mat2;
 res = res;
 ind=find(res==max(res));

result_l((second-1)*Ns+iter,1)=ind-1;
%final=dec2base(ind-1,2,6);
end


end

result=zeros(1232,1);
result(1:616,1)=result_l;
result(617:end,1)=result_r;

% 
% 
% for second=1:length(wav_ori)/Fs
% % %%%%%%%%  Inverse Transform  %%%%%%%%%%%
% x_inv=idct(X);
% sn=x_inv;%if no noise, sn=x_inv
% %%%%%%%%  DETECTION_OF_WATERMARK  %%%%%%%%%%
% S=dct(sn);
% 
% 
% index=0:2:2*N-2;
% flag=true;
% 
% for iter=1:Ns
%  Si=S(fL+(iter-1)*2*N:fL+iter*2*N-1);
%  si1=Si(index+1);
%  si2=Si(index+2);
% sd=abs(si1)-abs(si2);
% res=sd*p_mat;
% ind=find(res==max(res));
% % if ind~=iter
% %     error(second)=error(second)+1;
% %     flag=false;
% % end
% result_l((second-1)*Ns+iter,1)=ind;
% final=dec2base(ind-1,2,6);
% end
% %%%%%%%%  DETECTION_OF_WATERMARK  %%%%%%%%%%
% S=dct(sn);
% 
% index=0:2:2*N-2;
% flag=true;
% 
% for iter=1:Ns
%  Si=S(fL+(iter-1)*2*N:fL+iter*2*N-1);
%  si1=Si(index+1);
%  si2=Si(index+2);
% sd=abs(si1)-abs(si2);
% res=sd*p_mat;
% ind=find(res==max(res));
% % if ind~=p_enc3_r(iter,1)
% %     error(second)=error(second)+1;
% %     flag=false;
% % end
% result_r((second-1)*Ns+iter,1)=ind;
% final=dec2base(ind-1,2,6);
% end
% 
% 
% wav_final(1+Fs*(second-1):Fs*second)=sn;
% %flag
% end
% 
% 
% end




