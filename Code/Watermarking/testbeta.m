beta=0.05;
 beta_min=0.001;
 delta_beta=0.005;
 beta_max=0.2;
% beta=beta_min;
 gama1=0.001;
 gama2=2;
%%%% Generate Pseudo-Random Sequence %%%
N_sample = 2464;
n1 = 7;
m1 = 4;
Ndata = N_sample/n1*m1;
%n1 is the length of code, m1 is the length of a message%

%Message length is 1408bit (data)

p1 = reshape(data_output,[],m1);
p_enc1 = encode(p1,n1,m1,'hamming/binary');
p_enc2 = reshape(p_enc1,2,[]);
p_enc2 = p_enc2';
p_enc3 = zeros(length(p_enc2),1);
for i=1:length(p_enc2)
    p_enc3(i)=p_enc2(i,1)*2 + p_enc2(i,2);
end
p_enc3_l=p_enc3(1:616,1);
p_enc3_r=p_enc3(617:end,1);
%%%%%%%%%%%%%%%  ENCODE  %%%%%%%%%%%%%%%%%%
H = hadamard(64);
N=64;%length of Xi is 2N
Np=4;
Key=1;
fL =1;
fH=10000;
rng(Key);
p=H(2,:);
% p=rand(1,N);
% for i=1:length(p)
%     if p(i)>=0.5
%         p(i)=1;
%     else 
%         p(i)=-1;
%     end 
% end

 %[wav_ori,Fs] = audioread('04.��Լ�ڶ���--���� 00_00_00-00_00_10.wav');
% [wav_ori,Fs] = audioread('04.��Լ�ڶ���--���� 00_00_00-00_00_30.wav');
 %[wav_ori,Fs] = audioread('18.Lorde - Team 00_00_28-00_00_38.wav');
 %[wav_ori,Fs] = audioread('Lorde - Royals 00_00_45-00_00_55.wav');%10 seconds
% [wav_ori,Fs] = audioread('ǡ���������? 00_01_10-00_01_20.wav');%10 seconds
% [wav_ori,Fs] = audioread('Queen-Bohemian-Rhapsody 00_00_07-00_00_22.50.wav');%15.50seconds
%[wav_ori,Fs] = audioread('Queen-We-Will-Rock-You 00_00_00-00_00_20.wav');%20 seconds
%[wav_ori,Fs] = audioread('pop.wav');
[wav_ori,Fs] = audioread('piano.wav');
% [wav_ori,Fs] = audioread('classic.wav');
% [wav_ori,Fs] = audioread('blues.wav');
% [wav_ori,Fs] = audioread('jazz.wav');
%%%%%%%%%%%%  UPPER CHANNEL  %%%%%%%%%%%%%%%
wav_final=zeros(1,length(wav_ori));

 %%%%%%% CONSTRUCT_MATRIX  %%%%%%%%%%
 p_mat=zeros(N,Np);
for iter=1:4
    
    p_mat(:,iter)=H(iter+1,:)';
end


for second=1:length(wav_ori)/Fs
x=wav_ori(Fs*(second-1)+1:Fs*second,2);

%%%% Conduct DCT on Signal %%%%%%
X=dct(x);
%stem(X)
%%%% Select Specific Coefficients %%%%%%
 %fH=100000;
 fL =1;
 fH=10000;
 Ns=77;
 %fH=8000;
 %Ns=floor((fH-fL+1)/(2*N));
 
%%%%%%% BEGINNING_OF_LOOP  %%%%%%%%%% 
%%%%%%% FINDING_BETA  %%%%%%%%%%%%%%
index=0:2:2*N-2;
X=X';

for iter=1:Ns
 Xi=X(fL+(iter-1)*2*N:fL+iter*2*N-1);
 xi1=Xi(index+1);
 xi2=Xi(index+2);
 %%%% Embed Watermark %%%%%%%%%%%%
%%%% Rotationally Shift PN Sequence %%%%%
 %pt=circshift(p,p_enc3_r((second-1)*Ns+iter));
pt=p_mat(:,p_enc3_r((second-1)*Ns+mod(iter-1,Ns)+1)+1)';
 xtil_i_1=(1+beta*pt).*xi1;
 xtil_i_2=(1-beta*pt).*xi2;
 Xtil=zeros(1,2*N);
 index_prime=1:N;
 Xtil(2*index_prime-1)=xtil_i_1(index_prime);
 Xtil(2*index_prime)=xtil_i_2(index_prime);
X(fL+(iter-1)*2*N:fL+iter*2*N-1)=Xtil;
end

for iter=1:Ns
 Xi=X(fL+fH+(iter-1)*2*N:fL+fH+iter*2*N-1);
 xi1=Xi(index+1);
 xi2=Xi(index+2);
 %%%% Embed Watermark %%%%%%%%%%%%
%%%% Rotationally Shift PN Sequence %%%%%
 %pt=circshift(p,p_enc3_r((second-1)*Ns+iter));
pt=p_mat(:,p_enc3_r((second-1)*Ns+mod(iter-1,Ns)+1)+1)';
 xtil_i_1=(1+beta*pt).*xi1;
 xtil_i_2=(1-beta*pt).*xi2;
 Xtil=zeros(1,2*N);
 index_prime=1:N;
 Xtil(2*index_prime-1)=xtil_i_1(index_prime);
 Xtil(2*index_prime)=xtil_i_2(index_prime);
X(fL+fH+(iter-1)*2*N:fL+fH+iter*2*N-1)=Xtil;
end

x_inv=idct(X);
sn=x_inv;%if no noise, sn=x_inv
wav_final_r(1+Fs*(second-1):Fs*second)=sn;
end

%%%%%%%%%% END_OF_LOOP %%%%%%%%%%%%%%
% %%%%%%%%  Inverse Transform  %%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%
%                                     LEFT_CHANNEL
%
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

wav_final_l=zeros(1,length(wav_ori));

for second=1:length(wav_ori)/Fs
x=wav_ori(Fs*(second-1)+1:Fs*second,1);
%%%% Conduct DCT on Signal %%%%%%
X=dct(x);
%stem(X)
%%%% Select Specific Coefficients %%%%%%
 %Ns=floor((fH-fL+1)/(2*N));

%%%%%%% BEGINNING_OF_LOOP  %%%%%%%%%% 
%%%%%%% FINDING_BETA  %%%%%%%%%%%%%%
index=0:2:2*N-2;
X=X';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for iter=1:Ns
 Xi=X(fL+(iter-1)*2*N:fL+iter*2*N-1);
 xi1=Xi(index+1);
 xi2=Xi(index+2);
 %%%% Embed Watermark %%%%%%%%%%%%
%%%% Rotationally Shift PN Sequence %%%%%
%pt=circshift(p,p_enc3_l((second-1)*Ns+iter)*14+7);
pt=p_mat(:,p_enc3_l((second-1)*Ns+iter)+1)';
 xtil_i_1=(1+beta*pt).*xi1;
 xtil_i_2=(1- beta*pt).*xi2;
 Xtil=zeros(1,2*N);
 index_prime=1:N;
 Xtil(2*index_prime-1)=xtil_i_1(index_prime);
 Xtil(2*index_prime)=xtil_i_2(index_prime);
X(fL+(iter-1)*2*N:fL+iter*2*N-1)=Xtil;
end

for iter=1:Ns
 Xi=X(fL+fH+(iter-1)*2*N:fL+fH+iter*2*N-1);
 xi1=Xi(index+1);
 xi2=Xi(index+2);
 %%%% Embed Watermark %%%%%%%%%%%%
%%%% Rotationally Shift PN Sequence %%%%%
 %pt=circshift(p,p_enc3_r((second-1)*Ns+iter));
pt=p_mat(:,p_enc3_r((second-1)*Ns+mod(iter-1,Ns)+1)+1)';
 xtil_i_1=(1+beta*pt).*xi1;
 xtil_i_2=(1- beta*pt).*xi2;
 Xtil=zeros(1,2*N);
 index_prime=1:N;
 Xtil(2*index_prime-1)=xtil_i_1(index_prime);
 Xtil(2*index_prime)=xtil_i_2(index_prime);
X(fL+fH+(iter-1)*2*N:fL+fH+iter*2*N-1)=Xtil;
end

%%%%%%%%%% END_OF_LOOP %%%%%%%%%%%%%%



x_inv=idct(X);
sn=x_inv;%if no noise, sn=x_inv
wav_final_l(1+Fs*(second-1):Fs*second)=sn;
%flag
end
wav_final_double=zeros(length(wav_ori),2);
wav_final_double(:,1)=wav_final_l';
wav_final_double(:,2)=wav_final_r';
wav_final_double=wav_final_double;
filename = 'watermarked.wav';
audiowrite(filename,wav_final_double,Fs);
%sound(wav_final_double,Fs)
%sound(wav_final_double,Fs)











%%%%%%% FIRST_CONSTRUCT_EMBED %%%%%%%
% Xibe=X(fL:fL+2*N-1);
%  xi1be=Xibe(index+1);
%  xi2be=Xibe(index+2);
% n=16;
%  ptn=circshift(p,n);
% %  xtil_i_1=(1+beta*pt3).*xi1;
% %  xtil_i_2=(1- beta*pt3).*xi2;
% ptnT=ptn';
%  pt_mat=p_mat(:,[1:n n+2:end]);
% 
% while(beta<=beta_max)
%     d=abs(xi1be)-abs(xi2be)+beta*ptn.*(abs(xi1be)+abs(xi2be));
%     u1=d*ptnT;
%     u2=max(d*pt_mat);
%     v=max(gama2,gama1*u1);
%     if u2>(u1-v)
%         beta=beta+delta_beta;
%     else 
% break
%     end
% end