a = pixe_size*out1{3,1}(2:3);
b = pixe_size*out2{3,1}(2:3);
s = a- b;
s = sqrt(s*s');
result1 = out1{1,2};
rsqure1 = out1{1,1}(:,7);

result2 = out2{1,2};
rsqure2 = out2{1,1}(:,7);

% the threshold of Rsquare
thres = 0.6;
idx1 = rsqure1 >= thres;
idx2 = rsqure2 >= thres;

pre1 = result1(idx1,5);
pre2 = result2(idx2,5);
pre_sta(1,1) = mean(pre1);
pre_sta(1,2) = std(pre1);
pre_sta(2,1) = mean(pre2);
pre_sta(2,2) = std(pre2);
pn1 = result1(idx1,1);
pn2 = result2(idx2,1);

pre_sta(1,3) = mean(pn1);
pre_sta(1,4) = std(pn1);
pre_sta(2,3) = mean(pn2);
pre_sta(2,4) = std(pn2);

loc1 = pixe_size*out1{1,1}(idx1,2:3);
loc2 = pixe_size*out2{1,1}(idx2,2:3);

s1 = loc1 - a;
s1 = s1.^2;
s1 = sqrt(sum(s1,2));

s2 = loc2 - b;
s2 = s2.^2;
s2 = sqrt(sum(s2,2));

mean(s1)
std(s1)
mean(s2)
std(s2)

% tem1 = loc1*loc1';
% tem1 = sqrt( diag(tem1));
tem1 = loc1;
std1 = std(tem1,0,1);
radiu1 = sqrt(std1*std1');

tem1 = loc2;
% tem1 = sqrt( diag(tem1));
std1 = std(tem1,0,1);
radiu2 = sqrt(std1*std1');

figure
plot(a(1),a(2),'bx','MarkerSize',14);
hold on
circle(a,radiu1,'b');
hold on
plot(loc1(:,1),loc1(:,2),'b*');



hold on
plot(b(1),b(2),'rx','MarkerSize',14);
hold on
circle(b,radiu2,'r');
hold on
plot(loc2(:,1),loc2(:,2),'r*');
grid minor

s_title = ['red radius: ',num2str(radiu2),';blue radius: ',num2str(radiu1)];
title(s_title);