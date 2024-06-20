from sklearn.preprocessing import MinMaxScaler
from sklearn.cluster import KMeans
import numpy as np
from classifier_generator import generateClassifier
from dataset_generator import generate_dataset, get_feature_list
from normalization import get_normalization_params
from rich import print

if __name__ == '__main__':
    dataset = generate_dataset("./http.pcap")
    featuresList = get_feature_list()

    max_values = np.max(dataset, axis=0)
    min_values = np.min(dataset, axis=0)

    featureParamsList = []

    for i in range(len(featuresList)):
        normalization_params = get_normalization_params(max_values[i], min_values[i])
        featureParamsList.append({
            "name": featuresList[i],
            "min": normalization_params["min_feature"],
            "divisor_mask": normalization_params["divisor_mask"],
        })

    scaler = MinMaxScaler()
    scaledData = scaler.fit_transform(dataset)

    #train and test split, need to determina wether the instances are video or not (for the Y)
    #I can read specific pcap files that I know refer to either video streaming or not video streaming
    #also use elbow method to determine optimal number of clusters

    kmeans = KMeans(n_init="auto")
    result = kmeans.fit(scaledData)
    clusters = result.cluster_centers_

    centroids = []
    
    for cluster in clusters:
        clusterDict = dict()
        for i in range(len(featuresList)):
            clusterDict[featuresList[i]] = cluster[i]
        clusterDict["isVideo"] = 0 #I have to figure this out
        centroids.append(clusterDict)

    generateClassifier(featureParamsList, centroids)
