#importing libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

def kerFun(kernel_type):
    
    #importing dataset
    braindata = pd.read_csv("Features_Brain.csv")
    braindata.shape     #show numbre of rows & columns
    braindata.head()    #show first 5 rows
    
    #data preprocessing
    X = braindata.drop('Type', axis=1)
    Y = braindata['Type']
    
    
    #make training = 80 %   &&  testing = 20 %
    from sklearn.model_selection import train_test_split
    X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size = 0.20)    
    
    
    #training the model
    from sklearn.svm import SVC
    
    if kernel_type == 'linear':
        svclassifier = SVC(kernel = 'linear')
    elif kernel_type == 'rbf':
        svclassifier = SVC(kernel = 'rbf',gamma='auto')
    elif kernel_type == 'poly':
        svclassifier = SVC(kernel = 'poly',gamma='auto')
    elif kernel_type == 'sigmoid':
        svclassifier = SVC(kernel = 'sigmoid',gamma='auto')
        
    svclassifier.fit(X_train, Y_train)   # Training 
    
    
    #make predictions
    y_pred = svclassifier.predict(X_test)
    
    #Accuracy
    acc = svclassifier.score(X_test, Y_test)
    
    return acc









