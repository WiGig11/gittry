import matplotlib.pyplot as plt
import numpy as np
import csv
import random
from sklearn.datasets import load_iris
from sklearn.tree import DecisionTreeClassifier
from sklearn.tree import export_graphviz
#载入数据

def loadDataset(filename, split, trainingSet=[], testSet=[]):
    with open(filename, "r") as csvfile:
        lines = csv.reader(csvfile)
        dataset = list(lines)
        for x in range(1, len(dataset)):
            for y in range(len(dataset[1])-1):
                dataset[x][y] = float(dataset[x][y])
            if random.random() < split:
                trainingSet.append(dataset[x])
            else:
                testSet.append(dataset[x])
        if len(testSet) == 0:
            index = random.randint(1, 6)
            testSet.append(trainingSet[index-1])
            trainingSet.pop(index-1)
        else:
            testSet = testSet
            # 计算距离
def divideDataset(filename):
    with open(filename, "r") as csvfile:
        lines = csv.reader(csvfile)
        dataset = list(lines)
        for x in range(1, len(dataset)):
            for y in range(len(dataset[1])-1):
                dataset[x][y] = float(dataset[x][y])
        return dataset
            # 计算距离

def removespace(set,col):
    setnew = []
    setf = []
    for i in range(len(set)):
        setnew  = set[i][1:col]
        setf.append(setnew)
    return setf

def gettype(set):
    typearray = [0 for i in range(len(set))]
    for i in range(len(set)):
        typearray[i] = set[i][-2]
    return typearray




def main():
    trainingSet = []  # 训练数据集
    testSet = []  # 测试数据集
    split = 0.7  # 分割的比例
    loadDataset(r"G:\硕士期间\光纤传感\数据\gittry\pythonProject1\allfeatures1.csv", split, trainingSet, testSet)
    print("Train set :" + repr(len(trainingSet)))
    print("Test set :" + repr(len(testSet)));
    # 去除空格
    trainingSetn = removespace(trainingSet, len(trainingSet[0]) - 2)
    testSetn = removespace(testSet, len(trainingSet[0]) - 2)
    # 得到类别
    y_train = np.asarray(gettype(trainingSet))
    y_test = np.asarray(gettype(testSet))
    x_train = np.asarray(trainingSetn)
    x_test = np.asarray(testSetn)
    predictions = []
    clf = DecisionTreeClassifier()
    clf.fit(x_train,y_train)
    score = clf.score(x_test,y_test)
    print("Accuracy:" + repr(score*100) + "%")
    with open('G:\硕士期间\光纤传感\数据\gittry\pythonProject1/allfeatures1.dot', 'w', encoding='utf-8') as f:
        f = export_graphviz(clf, out_file=f, filled=True,
                            rounded=True)  # filled=True,rounded=True ：前面一个设置是填充颜色，后面一个是圆形框


if __name__ == "__main__":
    main()