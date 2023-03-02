# Scene-Parsing-Framework-with-Context-Adaptive-Feature-Intregation

The proposed model can be divided into 3 logical layers or modules. The first layer (i.e., the Visual Layer) is introduced to extract optimized features using a Genetic Algorithm and train the One-vs-All binary classifier. The following layer deals with contextual information that learns the global and local contexts of an image. The final layer combines all the information optimally using a noble MLP-based regression method to produce the final class label. 

You need to follow the instructions below to run the code successfully. The default parameters are set already in SuperpixelData.m file. 
However, parameters can be changed to select a few classifiers for layer1 and layer3

User should run the SuperpixelData.m file and set the paramereters maually.
1.  dataBases - which database to run on
2.  classifiers - fist layer classifier
3.  Integration_Layer - regression model
The default values of the parameters are already set. However, you can choose different set of parameters. 

## Selection of database
The following two code lines shows that five different datasets can be set by setting the selDB value. 
Here we set selDB value as "STAN", as we are working one Stanford dataset.

dataBases = {'STAN','MSRC','CORE','SIFT','CAMV'};
selDB = dataBases{1};

## selection of classifier for visual feature extraction layer
The algorithm select Artificail Neural Networks if the selClf vaule is set classifiers{1}, 
similarly if we want to select SVM, the classifiers value should 2.   
classifiers = {'ANN','SVM','ADB','RDF','CNN'};
selClf = classifiers{1};

## Visual feature dimension selection. 
The selFeatLen variable need to set as follows. The feautres size will be 50 after selection process
selFeatLen = 50


## selection of classifier in the third layer (Integrtion layer)
Integration layer selection has five options. The default selection is MLP, the values of MLP is set to selInt Variable.

Integration_Layer = {'Linear','Non_linear','SVM','MLP','R-Ensemble'};   % Options for Integration Layer (Regression)
selInt = Integration_Layer{4};


## Experients with new datasets
Instructions for Data preparations  
Dataset perparation: For each input image file, one label file with .txt extension needs to be provided.

STANimg, STANlables, and STANmat are the three folders that stores images, labels and extracted features files.

You need to follow the similar data processing method mentioned below:  The Stanford Background Dataset was introduced in Gould et al. (ICCV 2009) for evaluating methods for geometric and semantic scene understanding. The dataset contains 715 images chosen from public datasets: LabelMe, MSRC, PASCAL VOC and Geometric Context. The selection criteria were for the images were of outdoor scenes, having approximately 320-by-240 pixels, containing at least one foreground object, and having the horizon position within the image (it need not be visible). Semantic and geometric labels were obtained using Amazon's Mechanical Turk (AMT).

S. Gould, R. Fulton, D. Koller. Decomposing a Scene into Geometric and Semantically Consistent Regions. Proceedings International Conference on Computer Vision (ICCV), 2009.

Here, we considerd images 320-by-240 pixels as explained by the dataset. Label data are converted into corresponding numeric value of classes. We have (0-7) numeric values as Stanford Background Dataset has only 8 classes.

















