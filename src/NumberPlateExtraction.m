clc
close all;
clear all;

%-------LOADING IMAGE------------
a=imread('e:/test.jpg');
imshow(a);
title('captured image')

%---------FINDING NUMBER PLATE REGION----------------  
[r1 c1 kk]=size(a)
final=zeros(r1,c1);
for i=1:r1
    for j=1:c1
        rr=a(i,j,1);
        gg=a(i,j,2);
        bb=a(i,j,3);
        if((rr>=210 & rr<=260)&(gg>=140 & gg<=260)&(bb>=0 & bb<=140)) %normal r=210 to 260, g=140 to 260
            final(i,j)=1;
        end
    end
end


c=medfilt2(final); %Filtering salt & pepper noise
e=wiener2(c,[2,2]); %Filtering Gaussian noise

row_sum=zeros(r1,1);

%-----------CALCULATING SUM OF ALL ROWS AND COLUMNS------------
for i=1:r1
    sum=0;
    for j=1:c1
        sum=sum+e(i,j);
    end
    row_sum(i,1)=sum;
end

column_sum=zeros(1,c1);

for i=1:c1
    sum=0;
    for j=1:r1
        sum=sum+e(j,i);
    end
    column_sum(1,i)=sum;
end

MIN_NUMBER_OF_WHITE_PIXELS=30

%--------------------FINDING ROW LIMITS-----------------------------

for i=1:r1
    if(row_sum(i,1)>MIN_NUMBER_OF_WHITE_PIXELS)
        r3=i;
        break
    end
end

for i=r1:-1:1
    if(row_sum(i,1)>MIN_NUMBER_OF_WHITE_PIXELS)
        r4=i;
        break
    end
end

%--------------FINDING COLUMN LIMITS--------------------------------

for i=1:c1
    if(column_sum(1,i)>MIN_NUMBER_OF_WHITE_PIXELS)
        c3=i;
        break
    end
end

for i=c1:-1:1
    if(column_sum(1,i)>MIN_NUMBER_OF_WHITE_PIXELS)
        c4=i
        break
    end
end

%--------------CROPPING PLATE TO FIND NUMBER AREA--------------------------------

width=c4-c3;
height=r4-r3;

plate=imcrop(e,[c3,r3,width,height]);
plate=crop(plate,80,80);
plate=crop(plate,98,90);

%------PROCESSING PLATE----------

[r5 c5]=size(plate);
ww=ones(r5,1);
plate=[ww plate ww];
[r5 c5]=size(plate);
column_sum2=zeros(1,c5);

for i=1:c5
    sum=0;
    for j=1:r5
        sum=sum+plate(j,i);
    end
    column_sum2(1,i)=sum;
end

counter=1;
meanz=r5*(95/100);
i=1;
clear temp;
temp=0;
clear location5;

while temp<c5
    temp=temp+1;
    
    if(column_sum2(1,temp)>meanz)
        location5(counter)=temp;
        counter=counter+1;
        while(column_sum2(1,temp)>meanz) & (temp<c5)
            temp=temp+1;
        end
    end
    
end

clear sum1;
fp=fopen('e:/data.txt','w');

for i=1:(length(location5)-1)
    ll=location5(i);
    uu=location5(i+1);
    characters=plate(1:r5,ll:uu);
    characters=im2bw(characters);
    total_pixels=(r5)*(uu-ll+1);
    sum=total_pixels*(mean(mean(characters)));
    percent=(sum/total_pixels)*100;
    percent_black_pixels=100-percent;
    if(percent_black_pixels>15)
        characterz=recognition(characters);
        figure,imshow(characters)
    end
    
end