function y1=crop_character(charac1,row_percent,column_percent)
[r c]=size(charac1);


column_sum=zeros(1,c);
for i=1:c
    sum=0;
    for j=1:r
        sum=sum+charac1(j,i);
    end
    column_sum(1,i)=sum;
end

cz=c*(column_percent/100);
rz=r*(row_percent/100);

%--column limit:

for i=1:c
    if(column_sum(1,i)<=rz)
        c3=i;
        break
    end
end

for i=c:-1:1
    if(column_sum(1,i)<=rz)
        c4=i;
        break
    end
end

charac1=charac1(1:r,c3:c4);

[r c]=size(charac1);

row_sum=zeros(r,1);
for i=1:r
    sum=0;
    for j=1:c
        sum=sum+charac1(i,j);
    end
    row_sum(i,1)=sum;
end


column_sum=zeros(1,c);
for i=1:c
    sum=0;
    for j=1:r
        sum=sum+charac1(j,i);
    end
    column_sum(1,i)=sum;
end

cz=c*(column_percent/100);
rz=r*(row_percent/100);

%--row limit:
for i=1:r
    if(row_sum(i,1)<=cz)
        r3=i;
        break
    end
end

for i=r:-1:1
    if(row_sum(i,1)<=cz)
        r4=i;
        break
    end
end

%--column limit:

for i=1:c
    if(column_sum(1,i)<=rz)
        c3=i;
        break
    end
end

for i=c:-1:1
    if(column_sum(1,i)<=rz)
        c4=i;
        break
    end
end

width=c4-c3;
height=r4-r3;
y1=imcrop(charac1,[c3,r3,width,height]); 

