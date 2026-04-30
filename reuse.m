clc; clear; close all;
R = input('Enter constant R: ');
Nc = input('Enter constant N: ');
N = 1:20;
Rv = 0.5:0.5:10;
figure
subplot(1,2,1)
plot(N, sqrt(3*N)*R, '-o'); grid on
xlabel('N'); ylabel('D'); title('R Constant')
subplot(1,2,2)
plot(Rv, sqrt(3*Nc)*Rv, '-o'); grid on
xlabel('R'); ylabel('D'); title('N Constant')
i = input('Enter i: ');
j = input('Enter j: ');
N = i^2 + i*j + j^2;
disp(['Cluster size N = ', num2str(N)])
ref = [0 0];
co = [ i+j  j-i;
      i   -j;
     -j   -i;
    -i-j   i;
     -i    j;
      j   i+j ];
disp('Co-channel cells:')
disp(co)
figure; hold on
plot(0,0,'ro','LineWidth',2)
plot(co(:,1),co(:,2),'bo','LineWidth',2)
plot([co(:,1);co(1,1)],[co(:,2);co(1,2)],'b--')
axis equal; grid on
legend('Reference','Co-channel')