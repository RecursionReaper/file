clc;
clear;
n = input('Enter value of n (must be power of 2): ');
H = 1;
while size(H,1) < n
   H = [ H  H;
         H -H ];
end
disp('Hadamard Matrix:');
disp(H);
transitions = sum(abs(diff(H,1,2)), 2); 
[~, idx] = sort(transitions);
W = H(idx, :);
disp('Walsh Matrix:');
disp(W);
