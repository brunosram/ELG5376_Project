%[wav1,Fs] = audioread('1.wav');
wav1=wav_final_double;
%AWGN attack%
wav1_awgn = awgn(wav1,20);

%Resampling attack%
wav1_ds = downsample(wav1,2);
wav1_ds = upsample(wav1_ds,2);

%requantization attack%
audiowrite('temp.wav',wav1,Fs)
[wav1n,Fs] = audioread('temp.wav','native');
wav1n_r = zeros(length(wav1n),2);
for i=1:length(wav1n)
    for j=1:2
        data1 = wav1n(i,j);
        data1 = (data1/256)*256;
        data2 = int16(data1);
        wav1n_r(i,j) = data2;
    end
end
wav1n_r = int16(wav1n_r);
audiowrite('temp.wav',wav1n_r,Fs)
[wav1n_r,Fs] = audioread('temp.wav');

%lpf%
wav1_lpf = lowpass(wav1,4000,Fs);

%MP3%
%[wav1_mp3,Fs] = audioread('watermarked.mp3');
%wav1_mp3=wav1_mp3(578:length(wav_ori)+577,:);