The code folder contains files for two experiments along with pre-processing and post-processing files. 

train_val_lmdb.prototxt and solver_lmdb.prototxt are the files used for specifying the protocol buffers for training and testing. 

ConfusionMatrixFeatureVectorGenerator.py generates a model_labels.txt file which contains the true labels along with the predicted labels for the test images.

finetune_script.sh is the script that generates lmdb and does the finetuning. To finetune bvlc referene caffenet and test on test.txt, simple run this shell script in the appropriate folder.

extract_hog.m is a MATLAB script for generating HoG features from testing images and testing using a SVM classifier. It makes use of calculate_features_and_labels.m

train_gen.m and test_gen.m are for generating the train.txt and test.txt files that act as input to the CNN for finetuning.

createConfusionMatrix.m generates the confusion matrix from model_labels.txt.

extract_train_images.m and extract_test_images.m are MATLAB scripts for copying train and test images to the desired folders.

model_labels.txt is the test file containing the top 5 output class labels output by CNN when finetuning just the last layer. model_labels2.txt is the corresponding file when finetuning all the layers.

