[audio_ori,Fs] = audioread('piano.wav');
[audio_wat,Fs] = audioread('watermarked.wav');

audio_delta = audio_wat - audio_ori;
sn = snr(audio_ori,audio_delta)
