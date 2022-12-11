from keras.models import Sequential
from keras.layers import Dense,Activation
from keras.utils import to_categorical
from matplotlib import pyplot as plt
from sklearn.preprocessing import StandardScaler
import numpy as np
import csv
import random
from tensorflow import keras


# 加载数据集
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
#模型评价以及效果评价
    dataset = divideDataset(r"G:\硕士期间\光纤传感\数据\gittry\pythonProject1\try1.csv")
    dataset.pop(0)
    trainingSet = []  # 训练数据集
    testSet = []  # 测试数据集
    split = 0.7
    loadDataset(r"G:\硕士期间\光纤传感\数据\gittry\pythonProject1\allfeatures1.csv", split, trainingSet, testSet)
    print("Train set :" + repr(len(trainingSet)))
    print("Test set :" + repr(len(testSet)));
    # 去除空格
    trainingSetn = removespace(trainingSet, len(trainingSet[0])-2)
    testSetn = removespace(testSet, len(trainingSet[0])-2)
    # 得到类别
    typetrain = []
    typetest = []
    y_train = np.asarray(gettype(trainingSet))
    y_test = np.asarray(gettype(testSet))
    x_train = np.asarray(trainingSetn)
    x_test = np.asarray(testSetn)
    y = to_categorical(y_train)
    '''
    添加三层。
    第一层激活函数选择sigmoid;
    第二层激活函数选择tanh;
    第三层激活函数选择softmax。
    '''
    model = keras.models.load_model('G:\硕士期间\光纤传感\数据\gittry\pythonProject1\model.h5')
    model.summary()
    scores = model.evaluate(x_train, y)
    print('-' * 20)
    print("测试集损失函数：%f，预测准确率：%2.2f%%" % (scores[0], scores[1] * 100))
    # 模型的预测
    result = model.predict(x_test)
    print(result)
    print('-' * 20)
    print("测试集测试结果为")
    re = []
    count = 0
    for i in range(len(y_test)):
        if result[i][0]>result[i][1]:
           re.append(0)
        else:
            re.append(1)
    for i in range(len(y_test)):
        if re[i] == y_test[i]:
            count = count+1
        else:
            count = count
    print(re)
    print("实际结果为")
    print(y_test)
    print("Accuracy:" + repr(count*100/(len(y_test))) + "%")
        #print(svc.decision_function(x_test))

if __name__ == "__main__":
    main()