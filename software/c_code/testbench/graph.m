data = readtable('error.csv');
data_matrix = data{:,:};
real_float = data_matrix(38:end, 1);
error = data_matrix(38:end, 4);
semilogx(real_float, error);
%axis([1e-4 1 0 20]);