import numpy as np
import os
import matplotlib.pyplot as plt

# Make sure that caffe is on the python path:
caffe_root = '/work/01932/dineshj/CS381V/caffe_install_scripts/caffe' #this file is expected to be in {caffe_root}/examples
my_dir='/home/03701/manuag/hw2'
import sys
sys.path.insert(0, caffe_root + 'python')

pycaffe_dir = os.path.join(caffe_root, 'python')
import caffe

plt.rcParams['figure.figsize'] = (10, 10)
plt.rcParams['image.interpolation'] = 'nearest'
plt.rcParams['image.cmap'] = 'gray'

import os

caffe.set_mode_cpu()
net = caffe.Net(my_dir+'/CS381V-caffe-tutorial/finetune/deployment.prototxt',
                my_dir+'/CS381V-caffe-tutorial/finetune/finetune_25_style_lmdb_iter_1000.caffemodel',
                caffe.TEST)

#input preprocessing: 'data' is the name of the input blob == net.inputs[0]
transformer = caffe.io.Transformer({'data': net.blobs['data'].data.shape})
transformer.set_transpose('data', (2,0,1))
meanFile = os.path.join(pycaffe_dir, 'caffe/imagenet/ilsvrc_2012_mean.npy')
transformer.set_mean('data', np.load(meanFile).mean(1).mean(1))
transformer.set_raw_scale('data', 255)
transformer.set_channel_swap('data', (2,1,0))
net.blobs['data'].reshape(50,3,227,227)
#labels_array shall contain the labels of images
labels_array = []
fileID = open('../../data/test.txt','r')
#iterate over test.txt and create labels_array
for tline in fileID:
	[path, label] = tline.split()
	labels_array.append((path, label))	

label_file = '25_class_labels.txt'
labels = np.loadtxt(label_file, str, delimiter='\t')
out_file = open('model_labels.txt', 'w')
#write output to model_labels.txt
for (path, label) in labels_array:
	print path
	image = caffe.io.load_image(path);
	net.blobs['data'].data[...] = transformer.preprocess('data', image);
	net.forward();
	top_k = net.blobs['prob'].data[0].flatten().argsort()[-1:-6:-1]
	out_file.write(path + '\t' + labels[int(label)] + '\t' + '\t'.join(labels[top_k]) + '\n')
	
