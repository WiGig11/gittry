import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans
from sklearn import metrics

df = pd.read_excel('test.xlsx')
data = np.array(df)
y_pred = KMeans(n_clusters=2, random_state=4).fit_predict(data)
plt.scatter(data[:, 0], data[:, 1], c=y_pred)
plt.show
print(metrics.calinski_harabasz_score(data, y_pred))