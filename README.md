# Scene-Parsing-Framework-with-Context-Adaptive-Feature-Intregation

The proposed model can be divided into 3 logical layers or modules. The first layer (i.e., the Visual Layer) is introduced to extract optimized features using a Genetic Algorithm and train the One-vs-All binary classifier. The following layer deals with contextual information that learns the global and local contexts of an image. The final layer combines all the information optimally using a noble MLP-based regression method to produce the final class label. 

User should run the SuperpixelData.m file and set the paramereters maually.
1.  dataBases - which database to run on
2.  classifiers - fist layer classifier
3.  Integration_Layer - regression model


Dataset perparation: For each input image file, one label file with .txt extension needs to be provided. Some samples label files are provided.

