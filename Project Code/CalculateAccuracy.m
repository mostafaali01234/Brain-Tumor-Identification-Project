list = ["linear","rbf","poly","sigmoid"];
data = {50, 10, 30, 40};

for range=1:50
   for n=1:4 
        oldAccuracy = 0;
        for i=1:100
            %%%%%% Call python code for kernels %%%%%%%%%%
            newAccuracy = py.svm_accuracy.kerFun(list{n});
            if newAccuracy > oldAccuracy
                oldAccuracy = newAccuracy;
            end
        end
        %%% set the accuracy value into the text(GUI) 
        data{n} = round(oldAccuracy*100);
   end
    %%%%%%%%%%%%%%%%%%%%%% Save the output in excel file %%%%%%%%%%%%%%%%%%%%%%%%%%
    filename='Accuracy.xlsx';
    fileExist = exist(filename,'file'); 
    if fileExist==0
        header = {'linear', 'rbf', 'poly', 'sigmoid'};
        xlswrite(filename, header);
    end
    [~,~,input] = xlsread(filename); % Read in your xls file to a cell array (input)
    output = cat(1,input, data); % Concatinate your new data to the bottom of input
    xlswrite(filename,output); % Write to the new excel file. 
  
end