from __future__ import print_function, division
from keras.datasets import mnist
from keras.layers import Input, Dense, Reshape, Flatten, Dropout
from keras.layers import BatchNormalization, Activation, ZeroPadding2D
#from keras.layers.advanced_activations import LeakyReLU
from keras.layers import Activation
from keras.layers.convolutional import UpSampling2D, Conv2D
from keras.models import Sequential, Model
from keras.optimizers import Adam
import os
import matplotlib.pyplot as plt
import sys
import numpy as np
import csv
import random
from keras.utils import to_categorical


class GAN():
    def __init__(self):
        # --------------------------------- #
        #   行28，列28，也就是mnist的shape
        # --------------------------------- #
        self.img_rows = 28
        self.img_cols = 28
        self.channels = 1
        # 28,28,1
        self.img_shape = (self.img_rows, self.img_cols, self.channels)
        self.latent_dim = 100  # 噪声的维度
        # adam优化器
        optimizer = Adam(0.0002, 0.5)
        # --------------------------训练鉴别器--------------------------
        self.discriminator = self.build_discriminator()
        self.discriminator.compile(loss='binary_crossentropy',
                                   optimizer=optimizer,
                                   metrics=['accuracy'])
        # ----------------------------训练生成器-------------------------------
        self.generator = self.build_generator()
        gan_input = Input(shape=(self.latent_dim,))
        img = self.generator(gan_input)  # Model(noise, img)
        # 在训练generate的时候不训练discriminator
        self.discriminator.trainable = False
        # 对生成的假图片进行预测
        validity = self.discriminator(img)  # Model(img, validity)
        self.combined = Model(gan_input, validity)  # 把生成器和鉴别器连起来
        self.combined.compile(loss='binary_crossentropy', optimizer=optimizer)

    def build_generator(self):
        # --------------------------------- #
        #   生成器，输入一串随机数字，输出一副图像
        # --------------------------------- #
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

        # 生成图像大小的序列 28*28 *1
        model.add(Dense(np.prod(self.img_shape), activation='tanh'))
        # 然后reshape成（28,28,1）大小
        model.add(Reshape(self.img_shape))

        noise = Input(shape=(self.latent_dim,))
        img = model(noise)

        return Model(noise, img)

    def build_discriminator(self):
        # ----------------------------------- #
        #   评价器，对输入进来的图片进行鉴别真假
        # ----------------------------------- #
        model = Sequential()
        # 输入一张图片
        model.add(Flatten(input_shape=self.img_shape))
        model.add(Dense(512))
        model.add(Activation('tanh'))
        model.add(Dense(256))
        model.add(Activation('tanh'))
        # 判断真伪，输出概率，1为真，0为假
        model.add(Dense(1, activation='sigmoid'))

        img = Input(shape=self.img_shape)
        validity = model(img)

        return Model(img, validity)

    # 训练步骤
    def train(self, epochs, batch_size=128, sample_interval=50):
        # 获得数据
        (X_train, _), (_, _) = mnist.load_data()

        # 进行标准化(-1,1)之间
        X_train = X_train / 127.5 - 1.
        X_train = np.expand_dims(X_train, axis=3)  # (28,28)--->(28,28,1)

        # 创建标签
        valid = np.ones((batch_size, 1))
        fake = np.zeros((batch_size, 1))

        for epoch in range(epochs):

            # --------------------------- #
            #   随机选取batch_size个图片
            #   对discriminator进行训练
            # --------------------------- #
            idx = np.random.randint(0, X_train.shape[0], batch_size)  # 在0到总图像数量中随机产生一个batch_size的序列
            imgs = X_train[idx]  # 随机选取图像

            noise = np.random.normal(0, 1, (batch_size, self.latent_dim))  # 在（0,1）中随机产生batch_size个latent_dim维的噪声

            gen_imgs = self.generator.predict(noise)  # 由噪声生成图片
            # 计算鉴别器loss = 0.5 *（鉴别真图像的loss +  鉴别假图像的loss）
            d_loss_real = self.discriminator.train_on_batch(imgs, valid)
            d_loss_fake = self.discriminator.train_on_batch(gen_imgs, fake)
            d_loss = 0.5 * np.add(d_loss_real, d_loss_fake)

            # --------------------------- #
            #  训练generator
            # --------------------------- #
            noise = np.random.normal(0, 1, (batch_size, self.latent_dim))  # 为了增加generator的随机性，这里的噪声是重新生成的，只是用了训练好的参数
            g_loss = self.combined.train_on_batch(noise, valid)
            print("%d [D loss: %f, acc.: %.2f%%] [G loss: %f]" % (epoch, d_loss[0], 100 * d_loss[1], g_loss))

            if epoch % sample_interval == 0:
                self.sample_images(epoch)

    def sample_images(self, epoch):
        # 采样25个图像
        r, c = 5, 5
        noise = np.random.normal(0, 1, (r * c, self.latent_dim))
        gen_imgs = self.generator.predict(noise)  # 为了增加generator的随机性，这里的噪声是重新生成的，只是用了训练好的参数

        gen_imgs = 0.5 * gen_imgs + 0.5  # 生成的图像在（-1,1）之间，转化到（0,1）之间

        fig, axs = plt.subplots(r, c)
        cnt = 0
        for i in range(r):
            for j in range(c):
                axs[i, j].imshow(gen_imgs[cnt, :, :, 0], cmap='gray')
                axs[i, j].axis('off')
                cnt += 1
        fig.savefig("images/%d.png" % epoch)
        plt.close()


if __name__ == '__main__':
    if not os.path.exists("./images"):
        os.makedirs("./images")
    gan = GAN()
    gan.train(epochs=30000, batch_size=256, sample_interval=200)