clear all
clc

Key = 1;
rng(Key);

data_output = zeros(1408,1);
%data_input = imread('uottawa_binary.png');
data_input =randi([0,1],160,1); 
[m,n]=size(data_input);
times = floor(length(data_output)/(m*n));
data_input1 = reshape(data_input,[],1);
for i=1:times*m*n
    data_output(i)=data_input1(mod(i-1,m*n)+1,1);
end
