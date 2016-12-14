import sys
import numpy as np
import scipy.misc
bresen = np.zeros(shape=(480,640))
print(bresen)
with open('output.txt', 'r') as f:
    read_data = f.readlines()
print(read_data[1])
x = read_data[1][10:19]
y = read_data[1][0:10]
xInt = int(x, base=2)
yInt = int(y, base=2)
for address in read_data:
	y = int(address[10:19], base=2)-1
	x = int(address[0:10], base=2)-1
	if x < 0:
		x = 0
	if x > 640:
		x = 640
	if y < 0:
		y = 0
	if y > 480:
		y = 480
	bresen[y][x] = 1


scipy.misc.imsave('outfile.bmp', bresen)
