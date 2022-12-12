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


class GAN():
    def __init__(self):
        self.img_rows = 28  # 图片大小
        self.img_cols = 28  # 图片大小
        self.channels = 1   # 由于生成的是灰度图，所以维度为1
        self.img_shape = (self.img_rows, self.img_cols, self.channels)  # 设置shape参数
        self.latent_dim = 100   # 输入100维度服从高斯分布的向量
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

    def train(self, epochs, batch_size=128, sample_interval=50):
        # 加载数据集
        (X_train, _), (_, _) = mnist.load_data()
        # 归一化到-1到1
        X_train = X_train / 127.5 - 1.
        print(X_train.shape)
        X_train = np.expand_dims(X_train, axis=3)
        print(X_train.shape)
        # Adversarial ground truths
        valid = np.ones((batch_size, 1))
        fake = np.zeros((batch_size, 1))
        for epoch in range(epochs):
            # ---------------------
            #  训练判别器
            # ---------------------
            # X_train.shape[0]为数据集的数量，随机生成batch_size个数量的随机数，作为数据的索引
            idx = np.random.randint(0, X_train.shape[0], batch_size)
            # 从数据集随机挑选batch_size个数据，作为一个批次训练
            imgs = X_train[idx]
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
            if epoch % sample_interval == 0:
                self.sample_images(epoch)
                if not os.path.exists("keras_model"):
                    os.makedirs("keras_model")
                self.generator.save_weights("keras_model/G_model%d.hdf5" % epoch, True)
                self.discriminator.save_weights("keras_model/D_model%d.hdf5" % epoch, True)

    def sample_images(self, epoch):
        r, c = 5, 5
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
        if not os.path.exists("keras_imgs"):
            os.makedirs("keras_imgs")
        fig.savefig("keras_imgs/%d.png" % epoch)
        plt.close()

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


if __name__ == '__main__':
    gan = GAN()
    gan.train(epochs=10, batch_size=32, sample_interval=1)
    #gan.test()

