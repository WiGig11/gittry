import tensorflow as tf
import numpy as np
import matplotlib.pyplot as plt
import pickle as pkl
import os
import struct
from  PIL import Image
#%matplotlib inline
#%config InlineBackend.figure_format = 'retina'
# 导入数据
from tensorflow.examples.tutorials.mnist import input_data
mnist = input_data.read_data_sets('MNIST_data')
# 模型输入
# 输入有两个：真实图像输入 和 高斯噪声输入
def model_input(real_dim, z_dim):
    '''

    Args:
        real_dim, 真实图像的大小，例如MNIST中为 28*28 = 784
        z_dim, 高斯噪声的大小

    Returns:
        两个输入的张量
    '''

    inputs_real = tf.placeholder(tf.float32, [None, real_dim], name='input_real')
    inputs_z = tf.placeholder(tf.float32, [None, z_dim], name='input_z')

    return inputs_real, inputs_z
def generator(z, out_dim, n_units=128, reuse=False, alpha=0.01):
    '''
    生成网络
    Args:
        z, 高斯噪声输入
        out_dim, 输出的大小，例如在MNIS中为MNIST
        n_units, 中间隐藏层的单元个数
        reuse, 是否重复使用
        alpha, LeakyReLU的参数

    Returns:
        生成的数据
    '''
    with tf.variable_scope('generator', reuse=reuse):
        h1 = tf.keras.layers.Dense(n_units)(z)
        h1 = tf.keras.layers.LeakyReLU(alpha)(h1)

        out = tf.keras.layers.Dense(out_dim, activation='tanh')(h1)

    return out
def discriminator(x, n_units=128, reuse=False, alpha=0.01):
    '''
    判别网络
    Args:
        x, 输入的图像
        n_units, 中间隐藏层的单元个数
        reuse, 是否重复使用
        alpha, LeakyReLU的参数

    Returns:
        为真的概率
    '''

    with tf.variable_scope('discriminator', reuse=reuse):
        h1 = tf.keras.layers.Dense(n_units)(x)
        h1 = tf.keras.layers.LeakyReLU(alpha)(h1)

        logits = tf.keras.layers.Dense(1)(h1)
        out = tf.keras.layers.Activation('softmax')(logits)
    return out, logits
# 超参数

# 28*28 for mnist
input_size = 784
# 高斯噪声输入大小
z_size = 100
# 隐层神经元个数
g_hidden_size = 128
d_hidden_size = 128
# Leak factor
alpha = 0.01
# Smoothing，用于平滑label(后面有解释)
smooth = 0.1
tf.reset_default_graph()
# 建立输入
input_real, input_z = model_input(input_size, z_size)

# 生成器
g_model = generator(input_z, input_size, g_hidden_size, alpha=alpha)

# 判别器
d_model_real, d_logits_real = discriminator(input_real, d_hidden_size, alpha=alpha)
d_model_fake, d_logits_fake = discriminator(g_model, reuse=True, n_units=d_hidden_size, alpha=alpha)
# Calculate losses

d_loss_real = tf.reduce_mean(
                  tf.nn.sigmoid_cross_entropy_with_logits(logits=d_logits_real,
                                                          labels=tf.ones_like(d_logits_real) * (1 - smooth)))
d_loss_fake = tf.reduce_mean(
                  tf.nn.sigmoid_cross_entropy_with_logits(logits=d_logits_fake,
                                                          labels=tf.zeros_like(d_logits_real)))
d_loss = d_loss_real + d_loss_fake

g_loss = tf.reduce_mean(
             tf.nn.sigmoid_cross_entropy_with_logits(logits=d_logits_fake,
                                                     labels=tf.ones_like(d_logits_fake)))
learning_rate = 0.002

# 获取相应要训练的变量
g_vars = tf.get_collection(tf.GraphKeys.TRAINABLE_VARIABLES, 'generator')
d_vars = tf.get_collection(tf.GraphKeys.TRAINABLE_VARIABLES, 'discriminator')

d_train_opt = tf.train.AdamOptimizer(learning_rate).minimize(d_loss, var_list=d_vars)
g_train_opt = tf.train.AdamOptimizer(learning_rate).minimize(g_loss, var_list=g_vars)
batch_size = 100
epochs = 100
samples = []
losses = []

# 只保存生成器变量
saver = tf.train.Saver(var_list = g_vars)

with tf.Session() as sess:
    sess.run(tf.global_variables_initializer())

    for e in range(epochs):
        for ii in range(mnist.train.num_examples // batch_size):

            # 获取一个batch的数据
            batch = mnist.train.next_batch(batch_size)
            # 将图片拉伸至一维
            batch_images = batch[0].reshape((batch_size, 28*28))
            # 预处理数据
            batch_images = batch_images*2 - 1

            # 高斯噪声输入
            batch_z = np.random.uniform(-1, 1, size=(batch_size, z_size))

            # run optimizers
            _ = sess.run(d_train_opt, feed_dict={input_real:batch_images, input_z:batch_z})
            _ = sess.run(g_train_opt, feed_dict={input_z:batch_z})

        train_loss_d = sess.run(d_loss, {input_z:batch_z, input_real:batch_images})
        train_loss_g = g_loss.eval({input_z:batch_z})

        print("Epoch {}/{}...".format(e+1, epochs),
              "Discriminator Loss: {:.4f}...".format(train_loss_d),
              "Generator Loss: {:.4f}".format(train_loss_g))

        # Save losses to view after training
        losses.append((train_loss_d, train_loss_g))

        # Sample from generator as we're training for viewing afterwards
        sample_z = np.random.uniform(-1, 1, size=(16, z_size))
        gen_samples = sess.run(
                       generator(input_z, input_size, reuse=True),
                       feed_dict={input_z: sample_z})

        samples.append(gen_samples)
        saver.save(sess, './checkpoints/generator.ckpt')

# Save training generator samples
with open('train_samples.pkl', 'wb') as f:
    pkl.dump(samples, f)

fig, ax = plt.subplots()
losses = np.array(losses)
plt.plot(losses.T[0], label='Discriminator')
plt.plot(losses.T[1], label='Generator')
plt.title("Training Losses")
plt.legend()
def view_samples(epoch, samples):
    fig, axes = plt.subplots(figsize=(7,7), nrows=4, ncols=4, sharey=True, sharex=True)
    for ax, img in zip(axes.flatten(), samples[epoch]):
        ax.xaxis.set_visible(False)
        ax.yaxis.set_visible(False)
        im = ax.imshow(img.reshape((28,28)), cmap='Greys_r')

    return fig, axes

# Load samples from generator taken while training
with open('train_samples.pkl', 'rb') as f:
    samples = pkl.load(f)