%%绘制I与Vmin，Vmax的关系
figure(1);clf;
dImem = 1;
Imem = 0:dImem:160;
min = 0*Imem;
max = 0*Imem;
for i = 1:length(Imem)
    mm = hhrun(Imem(i));
    min(i)=mm(1);
    max(i)=mm(2);
end

plot(Imem,min,Imem,max);
line([6,6],[-20,120],'linestyle','--','color','black');
line([156,156],[-20,120],'linestyle','--','color','black');
xlabel('I');
ylabel('V')
axis([Imem(1) Imem(end) -20 120]);
legend('Vmin','Vmax');