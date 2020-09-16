#importing libraries
import pandas as pd
import numpy as np

def predict(val):
    
    #importing dataset
    braindata = pd.read_csv("Features_Brain.csv")


    #data preprocessing
    X_train = braindata.drop('Type', axis=1)   # All features = 9
    Y_train = braindata['Type']                # Type (tumor = 1  or  no tumor = 0)
    
    
    #training the model
    from sklearn.svm import SVC
    svclassifier = SVC(kernel = 'poly',gamma='auto')
    svclassifier.fit(X_train, Y_train)  # Training 
    
    #make predictions
    y_pred = svclassifier.predict(np.array(val).reshape(1,-1))
    
    
    ###################
    arrayToStr = ''.join(map(str, y_pred))   # convert array to string 
    
    return arrayToStr

