import sys
import numpy as np
import scipy.misc
bresen = np.zeros(shape=(640,480))
print(bresen)
with open('output.txt', 'r') as f:
    read_data = f.readlines()
print(read_data[1])
x = read_data[1][10:19]
y = read_data[1][0:10]
xInt = int(x, base=2)
yInt = int(y, base=2)
for address in read_data:
    bresen.itemset(((int(address[0:10], base=2)-1),(int(address[10:19], base=2)-1)),1)

scipy.misc.imsave('outfile.bmp', bresen)
