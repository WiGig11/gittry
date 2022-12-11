import csv  # 用于处理csv文件
import random  # 用于随机数
import math
import operator
from sklearn import neighbors

'''
本算法为KNN最近邻算法，针对的是IRIS鸢尾花数据集，第一行为数据类型ID等，第二行到第151行共150个数据
第一列为id(0),1-4为数据，5为类型

进行测试，其中设置3个最近邻，
'''


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


def euclideanDistance(instance1, instance2, length):
    distance = 0
    for x in range(1, length-1):
        distance += pow((instance1[x] - instance2[x]), 2)
    return math.sqrt(distance)


# 返回K个最近邻
def getNeighbors(trainingSet, testInstance, k):
    distances = []
    length = len(testInstance) - 1
    # 计算每一个测试实例到训练集实例的距离
    for x in range(len(trainingSet)):
        dist = euclideanDistance(testInstance, trainingSet[x], length)
        distances.append((trainingSet[x], dist))
        # 对所有的距离进行排序
    distances.sort(key=operator.itemgetter(1))
    neighbors = []
    # 返回k个最近邻
    for x in range(k):
        neighbors.append(distances[x][0])
    return neighbors


# 对k个近邻进行合并，返回value最大的key
def getResponse(neighbors):
    classVotes = {}
    for x in range(len(neighbors)):
        response = neighbors[x][-2]
        if response in classVotes:
            classVotes[response] += 1
        else:
            classVotes[response] = 1
            # 排序
    sortedVotes = sorted(classVotes.items(), key=operator.itemgetter(1), reverse=True)
    return sortedVotes[0][0]


# 计算准确率
def getAccuracy(testSet, predictions):
    correct = 0
    for x in range(len(testSet)):
        if testSet[x][-2] == predictions[x]:
            correct += 1
    return (correct / float(len(testSet))) * 100.0


#已经改好了去除type和ID的
def main():
    trainingSet = []  # 训练数据集
    testSet = []  # 测试数据集
    split = 0.7  # 分割的比例
    loadDataset(r"G:\硕士期间\光纤传感\数据\gittry\pythonProject1\allfeatures1.csv", split, trainingSet, testSet)
    print("Train set :" + repr(len(trainingSet)))
    print("Test set :" + repr(len(testSet)));
    predictions = []
    k = 2
    for x in range(len(testSet)):
        neighbors = getNeighbors(trainingSet, testSet[x], k)
        result = getResponse(neighbors)
        predictions.append(result)
        print(">predicted = " + repr(result) + ",actual = " + repr(testSet[x][-2]))
    accuracy = getAccuracy(testSet, predictions)
    print("Accuracy:" + repr(accuracy) + "%")


if __name__ == "__main__":
    main()
'''
def knn(trainData, testData, labels, k):
    # 计算训练样本的行数
    rowSize = trainData.shape[0]
    # 计算训练样本和测试样本的差值
    diff = np.tile(testData, (rowSize, 1)) - trainData
    # 计算差值的平方和
    sqrDiff = diff ** 2
    sqrDiffSum = sqrDiff.sum(axis=1)
    # 计算距离
    distances = sqrDiffSum ** 0.5
    # 对所得的距离从低到高进行排序
    sortDistance = distances.argsort()

    count = {}

    for i in range(k):
        vote = labels[sortDistance[i]]
        count[vote] = count.get(vote, 0) + 1
    # 对类别出现的频数从高到低进行排序
    sortCount = sorted(count.items(), key=operator.itemgetter(1), reverse=True)

    # 返回出现频数最高的类别
    return sortCount[0][0]

trainData = np.array([[5, 1], [4, 0], [1, 3], [0, 4]])
labels = ['动作片', '动作片', '爱情片', '爱情片']
testData = [3, 2]
X = knn(trainData, testData, labels, 3)
print(X)'''
