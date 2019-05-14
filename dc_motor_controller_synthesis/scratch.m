
T1=0:delta:(Tstar(1)-delta);U1=ones(size(T1));
T2=Tstar(1):delta:(Tstar(2)-delta);U2=-ones(size(T2));
T3=Tstar(2):delta:(Tstar(3)-delta);U3=zeros(size(T3));


[Y,T,X] = step(SSk,tfinal);
figure; plot(T,Y); title("step response"); grid;
figure; 
subplot(411);plot(T,X(:,1),'r-');grid;title("controller state");
subplot(412);plot(T,X(:,2),'g-');grid;title("theta");
subplot(413);plot(T,X(:,3),'b-');grid;title("thetadot");
subplot(414);plot(T,X(:,4),'k-');grid;title("i_a");

