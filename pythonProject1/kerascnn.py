from keras.models import Sequential
from keras.layers import Dense,Activation
from keras.utils import to_categorical
from matplotlib import pyplot as plt
from sklearn.preprocessing import StandardScaler
import numpy as np
import csv
import random
from keras.layers import Conv1D
from keras.layers import Flatten,Dropout,AveragePooling1D
#from tensorflow.python.keras.layers.convolutional import Conv1D

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
    """
    添加三层。
    第一层激活函数选择sigmoid;
    第二层激活函数选择tanh;
    第三层激活函数选择softmax。
    """
    x_train = np.expand_dims(x_train, axis=2)  # 表示是是增加的维度是在第三个维度上
    # reshape (569, 30) to (569, 30, 1)  now input can be set as input_shape=(30,1)

    model = Sequential()
    model.add(Conv1D(6, 3, activation='relu'))
    #model.add(Dropout(0.5))
    model.add(AveragePooling1D(pool_size=2))
    model.add(Conv1D(12, 3, activation='relu'))
    model.add(AveragePooling1D(pool_size=4,padding='same'))
    model.add(Flatten())
    model.add(Dense(2, activation='softmax'))  # softmax保证输出在[0,1]范围内
    """损失函数loss选择categorical_crossentropy；
    优化器optimizer选择rmsprop；
    评估标准metrics选择accuracy。"""
    model.compile(loss='categorical_crossentropy',
                  optimizer='rmsprop',
                  metrics=['accuracy'])
    # 模型的训练
    hist = model.fit(x_train, y, epochs=200)
    model.save('G:\硕士期间\光纤传感\数据\gittry\pythonProject1\model.h5')
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
        if result[i][0] > result[i][1]:
            re.append(0)
        else:
            re.append(1)
    for i in range(len(y_test)):
        if re[i] == y_test[i]:
            count = count + 1
        else:
            count = count
    print(re)
    print("实际结果为")
    print(y_test)
    print("Accuracy:" + repr(count * 100 / (len(y_test))) + "%")
    # print(svc.decision_function(x_test))

    plt.plot(hist.history['accuracy'], c='purple', alpha=0.3)
    ax2 = plt.gca().twinx()
    plt.show()
    plt(model,to_f)

if __name__ == "__main__":
    main()


#使用keras拟合
#将因变量转换为哑变量组(哑变量，用以反映质的属性的一个人工变量，是量化了的自变量，通常取
#值为0或1。引入哑变量可使线形回归模型变得更复杂，但对问题描述更简明，一个方程能达到两个方
#程的作用，而且接近现实。

# 将因变量转换为哑变量组
# 查看前五个因变量的值
#建立网络并训练模型

