from __future__ import print_function, division
from keras.layers import Input, Dense, Reshape, Flatten, Dropout
from keras.layers import BatchNormalization, Activation, ZeroPadding2D
from keras.layers import Activation
from keras.models import Sequential, Model
from keras.optimizers import Adam
import os
import matplotlib.pyplot as plt
import numpy as np
import csv
import random
from keras.utils import to_categorical


class GAN():
    def __init__(self):
        self.img_rows = 1  # 图片大小
        self.img_cols = 24  # 图片大小
        self.channels = 1   # 由于生成的是灰度图，所以维度为1
        self.img_shape = (self.img_rows, self.img_cols, self.channels)  # 设置shape参数
        self.latent_dim = 10   # 输入100维度服从高斯分布的向量
        optimizer = Adam(0.0002, 0.5)   # 使用Adam的优化器
        # 构建和编译判别器
        self.discriminator = self.build_discriminator()
        self.discriminator.compile(loss='binary_crossentropy',
                                   optimizer=optimizer,
                                   metrics=['accuracy'])
        # 构建生成器
        self.generator = self.build_generator()
        # 生成器输入噪音，生成假的图片
        z = Input(shape=(self.latent_dim,))
        img = self.generator(z)
        # 为了组合模型，只训练生成器
        self.discriminator.trainable = False
        # 判别器将生成的图像作为输入并确定有效性
        validity = self.discriminator(img)
        # 训练生成器骗过判别器
        self.combined = Model(z, validity)
        self.combined.compile(loss='binary_crossentropy', optimizer=optimizer)

    def loadDataset(self,filename, split, oneSet=[], zeroSet=[]):
        with open(filename, "r") as csvfile:
            lines = csv.reader(csvfile)
            dataset = list(lines)
            for x in range(1, len(dataset)):
                for y in range(len(dataset[1]) - 1):
                    dataset[x][y] = float(dataset[x][y])
                if random.random() < split:
                    oneSet.append(dataset[x])
                else:
                    zeroSet.append(dataset[x])
            if len(zeroSet) == 0:
                index = random.randint(1, 6)
                zeroSet.append(oneSet[index - 1])
                oneSet.pop(index - 1)
            else:
                zeroSet = zeroSet
                # 计算距离
    def findtype(self, dataset, oneSet=[], zeroSet=None):
        if zeroSet is None:
            zeroSet = []
        for x in range(1, len(dataset)):
            if dataset[x][-2]  == 1:
                oneSet.append(dataset[x])
            else:
                zeroSet.append(dataset[x])
        return oneSet
        return zeroSet

    def divideDataset(self,filename):
        with open(filename, "r") as csvfile:
            lines = csv.reader(csvfile)
            dataset = list(lines)
            for x in range(1, len(dataset)):
                for y in range(len(dataset[1]) - 1):
                    dataset[x][y] = float(dataset[x][y])
            return dataset
            # 计算距离

    def removespace(self,set, col):
        setnew = []
        setf = []
        for i in range(len(set)):
            setnew = set[i][1:col]
            setf.append(setnew)
        return setf

    def gettype(self,set):
        typearray = [0 for i in range(len(set))]
        for i in range(len(set)):
            typearray[i] = set[i][-2]
        return typearray



    def build_generator(self):
        model = Sequential()
        model.add(Dense(256, input_dim=self.latent_dim))
        model.add(Activation('tanh'))
        model.add(BatchNormalization(momentum=0.8))
        model.add(Dense(512))
        model.add(Activation('tanh'))
        model.add(BatchNormalization(momentum=0.8))
        model.add(Dense(1024))
        model.add(Activation('tanh'))
        model.add(BatchNormalization(momentum=0.8))
        model.add(Dense(np.prod(self.img_shape), activation='tanh'))
        model.add(Reshape(self.img_shape))
        model.summary()
        noise = Input(shape=(self.latent_dim,))
        img = model(noise)
        return Model(noise, img)

    def build_discriminator(self):
        model = Sequential()
        model.add(Flatten(input_shape=self.img_shape))
        model.add(Dense(512))
        model.add(Activation('tanh'))
        model.add(Dense(256))
        model.add(Activation('tanh'))
        model.add(Dense(1, activation='sigmoid'))
        model.summary()
        img = Input(shape=self.img_shape)
        validity = model(img)
        return Model(img, validity)

    def test(self, gen_nums=100):
        self.generator.load_weights("keras_model/G_model15000.hdf5", by_name=True)
        self.discriminator.load_weights("keras_model/D_model15000.hdf5", by_name=True)
        noise = np.random.normal(0, 1, (gen_nums, self.latent_dim))
        gen = self.generator.predict(noise)
        print(gen.shape)
        # 重整图片到0-1
        gen = 0.5 * gen + 0.5
        for i in range(0, len(gen)):
            plt.figure(figsize=(128, 128), dpi=1)
            plt.imshow(gen[i, :, :, 0], cmap="gray")
            plt.axis("off")
            if not os.path.exists("keras_gen"):
                os.makedirs("keras_gen")
            plt.savefig("keras_gen" + os.sep + str(i) + '.jpg', dpi=1)
            plt.close()


    def train(self, epochs, batch_size=1, sample_interval=1):
        dataset = self.divideDataset(r"G:\硕士期间\光纤传感\数据\gittry\pythonProject1\1218dataset_all1.csv")
        dataset.pop(0)
        oneSet = []  # 训练数据集
        zeroSet = []  # 测试数据集
        #split = 0.7
        #self.loadDataset(r"G:\硕士期间\光纤传感\数据\gittry\pythonProject1\1218dataset_all1.csv", split, oneSet, zeroSet)
        self.findtype(dataset,oneSet,zeroSet)
        print("one set :" + repr(len(oneSet)))
        print("zero set :" + repr(len(zeroSet)));
        # 去除空格
        oneSetn = self.removespace(oneSet, len(oneSet[0]) - 2)
        zeroSetn = self.removespace(zeroSet, len(oneSet[0]) - 2)
        # 得到类别
        x_train = np.asarray(oneSetn)
        x_test = np.asarray(zeroSetn)
        typetrain = []
        typetest = []
        y_train = np.asarray(self.gettype(oneSet))
        y_test = np.asarray(self.gettype(zeroSet))
        y = to_categorical(y_train)
        """
        添加三层。
        第一层激活函数选择sigmoid;
        第二层激活函数选择tanh;
        第三层激活函数选择softmax。
    
        """
        x_train = np.expand_dims(x_train, axis=1)  # 表示是是增加的维度是在第三个维度上
        x_train = np.expand_dims(x_train, axis=3)  # 表示是是增加的维度是在第三个维度上
        # reshape (569, 30) to (569, 30, 1)  now input can be set as input_shape=(30,1)
        #(X_train, _), (_, _) = mnist.load_data()
        # 归一化到-1到1
        #X_train = X_train / 127.5 - 1.
        print(x_train.shape)
        # Adversarial ground truths
        valid = np.ones((batch_size, 1))
        fake = np.zeros((batch_size, 1))
        temp = np.zeros((200,24))
        for epoch in range(epochs):
            # ---------------------
            #  训练判别器
            # ---------------------
            # X_train.shape[0]为数据集的数量，随机生成batch_size个数量的随机数，作为数据的索引
            idx = np.random.randint(0, x_train.shape[0], batch_size)
            # 从数据集随机挑选batch_size个数据，作为一个批次训练
            imgs = x_train[idx]
            # 噪音维度(batch_size,100)
            noise = np.random.normal(0, 1, (batch_size, self.latent_dim))
            # 由生成器根据噪音生成假的图片
            gen_imgs = self.generator.predict(noise)
            # 训练判别器，判别器希望真实图片，打上标签1，假的图片打上标签0
            d_loss_real = self.discriminator.train_on_batch(imgs, valid)
            d_loss_fake = self.discriminator.train_on_batch(gen_imgs, fake)
            d_loss = 0.5 * np.add(d_loss_real, d_loss_fake)
            # ---------------------
            #  训练生成器
            # ---------------------
            noise = np.random.normal(0, 1, (batch_size, self.latent_dim))
            # Train the generator (to have the discriminator label samples as valid)
            g_loss = self.combined.train_on_batch(noise, valid)
            # 打印loss值
            print("%d [D loss: %f, acc.: %.2f%%] [G loss: %f]" % (epoch, d_loss[0], 100 * d_loss[1], g_loss))
            # 没sample_interval个epoch保存一次生成图片
            r,c = 1, 1
            noise = np.random.normal(0, 1, (r * c, self.latent_dim))
            gen_imgs = self.generator.predict(noise)
            # 将生成的图片重新归整到0-1之间
            gen_imgs = 0.5 * gen_imgs + 0.5
            for i in range(len(gen_imgs[0][0])):
                temp[epoch][i] = gen_imgs[0][0][i][0]
        with open('G:\硕士期间\光纤传感\数据\gittry\pythonProject1\gen_result.csv', 'w',newline='') as f:
            # create the csv writer
            writer = csv.writer(f)
            # write a row to the csv file
            for i in range(epochs):
                writer.writerow(temp[i])
            '''
            if epoch % sample_interval == 0:
                self.sample_images(epoch,temp)
                
                    if not os.path.exists("keras_model"):
                        os.makedirs("keras_model")
                    self.generator.save_weights("keras_model/G_model%d.hdf5" % epoch, True)
                    self.discriminator.save_weights("keras_model/D_model%d.hdf5" % epoch, True)
        
                    '''
'''
    def sample_images(self, epoch):
        r, c = 1, 1
        # 重新生成一批噪音，维度为(25,100)
        noise = np.random.normal(0, 1, (r * c, self.latent_dim))
        gen_imgs = self.generator.predict(noise)
        # 将生成的图片重新归整到0-1之间
        gen_imgs = 0.5 * gen_imgs + 0.5
        fig, axs = plt.subplots(r, c)
        cnt = 0
        for i in range(r):
            for j in range(c):
                axs[i, j].imshow(gen_imgs[cnt, :, :, 0], cmap='gray')
                axs[i, j].axis('off')
                cnt += 1
        # if not os.path.exists("keras_data"):
            os.makedirs("keras_data")
        
        # open the file in the write mode
        with open('G:\硕士期间\光纤传感\数据\gittry\pythonProject1\gen_result.csv', 'w') as f:
            # create the csv writer
            writer = csv.writer(f)
            for i in range(len(gen_imgs[0][0])):
                temp[k][i] = gen_imgs[0][0][i][0]
            # write a row to the csv file
            writer.writerow(temp[k])
            k=k+1
    '''



if __name__ == '__main__':
    gan = GAN()
    gan.train(epochs=200, batch_size=1, sample_interval=1)
    #gan.test()

