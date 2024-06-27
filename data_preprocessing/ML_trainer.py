from sklearn.preprocessing import MinMaxScaler
from sklearn.model_selection import train_test_split
from sklearn.cluster import KMeans
import numpy as np
from classifier_generator import generateClassifier
from normalization import get_normalization_params, normalize
import pandas as pd
from capture_reader import get_feature_list

def get_nonvideo_df():
    df = pd.read_csv('not-video-dataset.csv', header = 0)
    return df.iloc[lambda x: x.index % 3 != 0]

def get_dataset():
    videoDF = pd.read_csv('video-dataset.csv', header = 0)
    nonVideoDF = get_nonvideo_df()
    df = pd.concat([videoDF, nonVideoDF])
    return df.sample(frac=1)

if __name__ == '__main__':
    dataset = get_dataset()

    featuresList = get_feature_list()

    x = dataset.loc[:, featuresList]
    y = dataset.isVideo

    max_values = x.max()
    min_values = x.min()

    featureParamsList = []

    for i in range(len(featuresList)):
        normalization_params = get_normalization_params(max_values[i], min_values[i])

        featureParamsList.append({
            "name": featuresList[i],
            "min": normalization_params["min_feature"],
            "divisor_mask": normalization_params["divisor_mask"],
            "mult_factor": normalization_params["mult_factor"]
        })

    scaler = MinMaxScaler(feature_range=(0, 1024))
    x_scaled = scaler.fit_transform(x)

    kmeans = KMeans(n_init="auto")
    result = kmeans.fit(x_scaled)
    clusters = result.cluster_centers_



    # centroids = []
    
    # for cluster in clusters:
    #     clusterDict = dict()
    #     for i in range(len(featuresList)):
    #         clusterDict[featuresList[i]] = cluster[i]
    #     clusterDict["isVideo"] = 0 #I have to figure this out
    #     centroids.append(clusterDict)

    # generateClassifier(featureParamsList, centroids)

    # testRows = [1024]

    # print("===========================")

    # for index in testRows:
    #     approxNorms = []
    #     for param in featureParamsList:
    #         name = param["name"]
    #         mult_factor = param["mult_factor"]
    #         div_mask = param["divisor_mask"]
    #         min = param["min"]
    #         value = x.iloc[index][name]
    #         norm_value = normalize(value, min, div_mask, mult_factor)
    #         approxNorms.append(norm_value)

    #     scalerString = ""
    #     normString = ""

    #     for i in range(16):
    #         scalerString = scalerString + str(round(x_scaled[index][i])) + "|\t"
    #         normString = normString + str(approxNorms[i]) + "|\t"

    #     print("MinMaxScaler: ")
    #     print(scalerString)
    #     print("")
    #     print("ApproxNorm:")
    #     print(normString)
    #     print("===========================")

    #train and test split, need to determina wether the instances are video or not (for the Y)
    #I can read specific pcap files that I know refer to either video streaming or not video streaming
    #also use elbow method to determine optimal number of clusters

    # kmeans = KMeans(n_init="auto")
    # result = kmeans.fit(scaledData)
    # clusters = result.cluster_centers_

    # centroids = []
    
    # for cluster in clusters:
    #     clusterDict = dict()
    #     for i in range(len(featuresList)):
    #         clusterDict[featuresList[i]] = cluster[i]
    #     clusterDict["isVideo"] = 0 #I have to figure this out
    #     centroids.append(clusterDict)

    # generateClassifier(featureParamsList, centroids)
