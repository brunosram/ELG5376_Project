%DECODE%
% result_l=zeros(448,1);
% result_r=zeros(448,1);

p_rec = zeros(length(result),2);
for i=1:length(result)
    p_rec(i,2)=mod(result(i),2);
    p_rec(i,1)=(result(i)-p_rec(i,2))/2;
end

%p_rec is the decode input%

p_rec = p_rec';
p_dec1 = reshape(p_rec,[],n1);
p_dec2 = decode(p_dec1,n1,m1,'hamming/binary');
p_dec = reshape(p_dec2,1408,1);
p_decr = zeros(m,n);
for i = 1:m*n
    for j = 1:times
        p_decr(i) = p_decr(i) + p_dec(i+(times-1)*m*n);
    end
    p_decr(i) = round(p_decr(i)/times);
end
p_decr = reshape(p_decr,m,n);
sum = 0;

for i=1:m
    for j=1:n
        if p_decr(i,j)~=data_input(i,j)
            sum = sum+1;
        end
    end
end
sum

% p_dec = p_dec * 255;
% imwrite(p_dec,'output.png');
% imshow(p_dec,[]);
%p_dec is the decoded output%