'''
本文件为测试svm对iris数据集的分类效果
'''
import numpy as np
import csv
import random
from sklearn.tree import DecisionTreeClassifier
import matplotlib.pyplot as plt
import matplotlib as mpl
from matplotlib import colors

from sklearn import svm
from sklearn.svm import SVC
from sklearn import datasets
from sklearn import model_selection
from sklearn.preprocessing import StandardScaler
from sklearn.svm import LinearSVC


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
    lend = len(dataset)
    count = 0
    for i in range(lend):
        dataset = divideDataset(r"G:\硕士期间\光纤传感\数据\gittry\pythonProject1\try1.csv")
        dataset.pop(0)
        trainingSet = []  # 训练数据集
        testSet = []  # 测试数据集
        testSet.append(dataset[i])
        trainingSet = dataset
        trainingSet.pop(i)
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
        clf = DecisionTreeClassifier()
        clf.fit(x_train, y_train)
        score = clf.score(x_test, y_test)
        if score==1:
            count = count+1
        else:
            count =count
    print("Accuracy:" + repr(count*100/(len(dataset)+1)) + "%")
        #print(svc.decision_function(x_test))


if __name__ == "__main__":
    main()
'''
# 获取所需数据集
iris=datasets.load_iris()
#每行的数据，一共四列，每一列映射为feature_names中对应的值
X=iris.data
#每行数据对应的分类结果值（也就是每行数据的label值）,取值为[0,1,2]
Y=iris.target
#通过Y=iris.target.size，可以得到一共150行数据,三个类别个50条数据，并且数据是按照0，1，2的顺序放的

# 只取y<2的类别，也就是0 1并且只取前两个特征
# 获取0 1类别的数据
Y1 = Y[Y<2]
y1 = len(Y1)
# 获取0类别的数据
Y2 = Y[Y < 1]
y2 = len(Y2)
print(y2)
X = X[:y1, :2]
X_train=X[0:69, :2]
X_test = X[70:99, :2]
Y_train = Y[0:69]
Y_test = Y[70:99]
# 标准化
standardScaler=StandardScaler()
standardScaler.fit(X_train)
standardScaler.fit(X_test)
# 计算训练数据的均值和方差
X_strain=standardScaler.transform(X_train)
X_stest = standardScaler.transform(X_test)
# 用scaler中的均值和方差来转换X,使X标准化
'''

'''

#plt.scatter(X_strain[:50,0],X_strain[:50,1], label='0')
#plt.scatter(X_strain[51:69,0],X_strain[51:69,1], label='1')
#plt.legend()
#plt.show()
dataset = divideDataset(r"G:\硕士期间\光纤传感\数据\pythonProject1\try1.csv")
dataset.pop(0)
trainingSet = []  # 训练数据集
testSet = []  # 测试数据集
testSet.append(dataset[1])
trainingSet = dataset
trainingSet.pop(1)
#分开训练集和测试集
print("Train set :" + repr(len(trainingSet)))
print("Test set :" + repr(len(testSet)))
# 去除空格
trainingSetn = removespace(trainingSet, 11)
testSetn = removespace(testSet,11)
# 得到类别
typetrain  = []
typetest  = []
y_train  = np.asarray(gettype(trainingSetn))
y_test  = np.asarray(gettype(testSetn))
standardScaler = StandardScaler()
x_train = np.asarray(trainingSetn)
x_test = np.asarray(testSetn)
standardScaler.fit(x_train)
standardScaler.fit(x_test)
# 计算训练数据的均值和方差
strainings = standardScaler.transform(x_train)
stestset = standardScaler.transform(x_test)
svc = LinearSVC()
svc.fit(x_train,y_train)
print(svc.score(x_test, y_test))  # 精度
print(svc.decision_function(x_test))
'''
'''
#绘制分类曲线
w = svc.coef_
b = svc.intercept_
plt.scatter(X_strain[:49,0],X_strain[:49,1], label='0')
plt.scatter(X_strain[50:69,0],X_strain[50:69,1], label='1')
x = np.linspace(-3.0,2.0,20)
y = -w[0][0]*x/w[0][1]-b/w[0][1]
plt.plot(x,y)
plt.legend()
plt.show()
print(svc.decision_function(X_stest))
'''


'''
y_hat = svc.predict(X_standard)
# show_accuracy(y_hat, y_train, '训练集')
print(svc.score(x_test, y_test))
y_hat = clf.predict(x_test)
# show_accuracy(y_hat, y_test, '测试集')

# print ('decision_function:\n', clf.decision_function(x_train))     #每一列的值代表到各类别的距离
print('\npredict:\n', clf.predict(x_train))
x1_min, x1_max = x[:, 0].min(), x[:, 0].max()  # 第0列的范围
x2_min, x2_max = x[:, 1].min(), x[:, 1].max()  # 第1列的范围
x1, x2 = np.mgrid[x1_min:x1_max:200j, x2_min:x2_max:200j]  # 生成网格采样点
grid_test = np.stack((x1.flat, x2.flat), axis=1)  # 测试点
grid_hat = clf.predict(grid_test)  # 预测分类值
grid_hat = grid_hat.reshape(x1.shape)  # 使之与输入的形状相同

mpl.rcParams['font.sans-serif'] = [u'SimHei']
mpl.rcParams['axes.unicode_minus'] = False

cm_light = mpl.colors.ListedColormap(['#A0FFA0', '#FFA0A0', '#A0A0FF'])
cm_dark = mpl.colors.ListedColormap(['g', 'r', 'b'])
plt.pcolormesh(x1, x2, grid_hat, cmap=cm_light)
plt.scatter(x[:, 0], x[:, 1], c=np.squeeze(y), edgecolors='k', s=50, cmap=cm_dark)  # 样本  , c=y是错的
plt.scatter(x_test[:, 0], x_test[:, 1], s=120, facecolors='none', zorder=10)  # 圈中测试集样本
plt.xlabel(u'花萼长度', fontsize=13)
plt.ylabel(u'花萼宽度', fontsize=13)
plt.xlim(x1_min, x1_max)
plt.ylim(x2_min, x2_max)
plt.title(u'鸢尾花SVM二特征分类', fontsize=15)
# plt.grid()
plt.show()
'''