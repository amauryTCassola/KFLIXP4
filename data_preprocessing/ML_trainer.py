from sklearn.preprocessing import MinMaxScaler
from sklearn.model_selection import train_test_split
from sklearn.cluster import KMeans
import numpy as np
from classifier_generator import generateClassifier
from normalization import get_normalization_params, normalize
import pandas as pd
from capture_reader import get_feature_list
from rich import print
from sklearn.decomposition import PCA
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.metrics import silhouette_score

cluster_number = 7 #either 6 or 7

def test_normalization(x, x_scaled, featureParamsList):
    n = len(x)
    errors = [0 for i in range(len(featureParamsList))]
    maxErrors = [0 for i in range(len(featureParamsList))]

    for index in range(len(x)):
        approxNorms = []
        for param in featureParamsList:
            name = param["name"]
            mult_factor = param["mult_factor"]
            div_mask = param["divisor_mask"]
            min = param["min"]
            value = x.iloc[index][name]
            norm_value = normalize(value, min, div_mask, mult_factor)
            approxNorms.append(norm_value)

        for i in range(len(featureParamsList)):
            error = abs(round(x_scaled[index][i]) - approxNorms[i])
            errors[i] = errors[i] + error

            # if error > 10:
            #     print("problem: "+featureParamsList[i]["name"])
            #     print("original value:"+ str(x.iloc[index][featureParamsList[i]["name"]]))
            #     print("normalized: "+ str(round(x_scaled[index][i])))
            #     print("approx: "+str(approxNorms[i]))
            #     print("div_mask: "+str(featureParamsList[i]["divisor_mask"]))
            #     print("mult_factor: "+str(featureParamsList[i]["mult_factor"]))

            if error > maxErrors[i]:
                maxErrors[i] = error


    meanErrors = [0 for i in range(len(featureParamsList))] 
    for i in range(len(errors)):
        meanErrors[i] = errors[i]/n

    print("Mean errors: ")
    print(meanErrors)
    print("\nMax errors:")
    print(maxErrors)


def get_nonvideo_df():
    df = pd.read_csv('not-video-dataset.csv', header = 0)
    return df.iloc[lambda x: x.index % 3 != 0]

def get_dataset():
    videoDF = pd.read_csv('video-dataset.csv', header = 0)
    nonVideoDF = get_nonvideo_df()
    df = pd.concat([videoDF, nonVideoDF])
    return df.sample(frac=1)

def run_kmeans(cluster_number, X_train, y_train, X_test, y_test):
    kmeans = KMeans(n_clusters = cluster_number, n_init='auto')
    kmeans.fit(X_train)

    cluster_labels = kmeans.labels_
    data = {"label": list(cluster_labels)}
    labels_df = pd.DataFrame(data, columns=['label'])

    clustered_data = pd.concat([y_train.reset_index(),labels_df],axis=1)
    clustered_data['isVideo_pred'] = 'none'

    cluster_isVideo_values = [0 for i in kmeans.cluster_centers_]
    
    for k in range(len(kmeans.cluster_centers_)):
        cluster_samples = clustered_data[clustered_data['label']==k]
        cluster_is_video = cluster_samples['isVideo'].value_counts().index[0]
        clustered_data['isVideo_pred'] = np.where(clustered_data['label']==k,cluster_is_video,clustered_data['isVideo_pred'])
        cluster_isVideo_values[k] = cluster_is_video

    X_test_predict = kmeans.predict(X_test)

    test_data = {"label": list(X_test_predict)}
    test_df = pd.DataFrame(test_data, columns=['label'])
    clustered_test_data = pd.concat([y_test.reset_index(),test_df],axis=1)
    clustered_test_data['isVideo_pred'] = 'none'
    for k in range(len(kmeans.cluster_centers_)):
        cluster_is_video = cluster_isVideo_values[k]
        clustered_test_data['isVideo_pred'] = np.where(clustered_test_data['label']==k,cluster_is_video,clustered_test_data['isVideo_pred'])

    true_positives = len(clustered_test_data[(clustered_test_data["isVideo"] == 1) & (clustered_test_data["isVideo_pred"] == 1)])
    false_positives = len(clustered_test_data[(clustered_test_data["isVideo"] == 0) & (clustered_test_data["isVideo_pred"] == 1)])

    true_negatives = len(clustered_test_data[(clustered_test_data["isVideo"] == 0) & (clustered_test_data["isVideo_pred"] == 0)])
    false_negatives = len(clustered_test_data[(clustered_test_data["isVideo"] == 1) & (clustered_test_data["isVideo_pred"] == 0)])

    total_n = true_negatives + true_positives + false_negatives + false_positives

    accuracy = (true_positives + true_negatives)/total_n
    precision = true_positives/(true_positives + false_positives)
    recall = true_positives/(true_positives + false_negatives)
    f1 = 2*( (precision*recall)/(precision+recall) )

    score = silhouette_score(X_train, cluster_labels)

    wss = kmeans.inertia_

    return accuracy, precision, recall, f1, score, wss

    

if __name__ == '__main__':
    dataset = get_dataset()

    featuresList = get_feature_list()

    x = dataset.loc[:, featuresList]

    max_values = x.max()
    min_values = x.min()

    featureParamsList = []

    for i in range(len(featuresList)):
        normalization_params = get_normalization_params(max_values[i], min_values[i], scale_max=1024, max_power=32)

        featureParamsList.append({
            "name": featuresList[i],
            "min": normalization_params["min_feature"],
            "divisor_mask": normalization_params["divisor_mask"],
            "mult_factor": normalization_params["mult_factor"]
        })

    X = dataset[featuresList]
    Y = dataset[['isVideo']]

    scaler = MinMaxScaler(feature_range=(0, 1024))
    X_scaled = scaler.fit_transform(X)

    X_train, X_test, y_train, y_test = train_test_split(X_scaled, Y, test_size=0.33)

    K = range(0, 12)

    accuracies = [0 for i in K]
    precisions = [0 for i in K]
    recalls = [0 for i in K]
    f1s = [0 for i in K]
    scores = [0 for i in K]
    wss_s = [0 for i in K]

    for iteration in range(0, 30):
        for cluster_num in K:
            if cluster_num != 0 and cluster_num != 1:
                accuracy, precision, recall, f1, score, wss = run_kmeans(cluster_num, X_train, y_train, X_test, y_test)

                accuracies[cluster_num] = accuracies[cluster_num] + accuracy
                precisions[cluster_num] = precisions[cluster_num] + precision
                recalls[cluster_num] = recalls[cluster_num] + recall
                f1s[cluster_num] = f1s[cluster_num] + f1
                scores[cluster_num] = scores[cluster_num] + score
                wss_s[cluster_num] = wss_s[cluster_num] + wss
    
    plt.figure()
    plt.plot(K, [value/30 for value in accuracies], 'bx-')
    plt.xlabel('Values of K')
    plt.ylabel('Accuracy')
    plt.title('Accuracy')

    plt.figure()
    plt.plot(K, [value/30 for value in precisions], 'bx-')
    plt.xlabel('Values of K')
    plt.ylabel('Precision')
    plt.title('Precision')

    plt.figure()
    plt.plot(K, [value/30 for value in recalls], 'bx-')
    plt.xlabel('Values of K')
    plt.ylabel('Recall')
    plt.title('Recall')

    plt.figure()
    plt.plot(K, [value/30 for value in f1s], 'bx-')
    plt.xlabel('Values of K')
    plt.ylabel('F1')
    plt.title('F1')

    plt.figure()
    plt.plot(K, [value/30 for value in scores], 'bx-')
    plt.xlabel('Values of K')
    plt.ylabel('Score')
    plt.title('Silhouette Score')

    plt.figure()
    plt.plot(K, [value/30 for value in wss_s], 'bx-')
    plt.xlabel('Values of K')
    plt.ylabel('WSS')
    plt.title('Elbow Method')

    plt.show()

    # feature_x = "InitialWindow"
    # feature_y = "MeanPktLength"

    # plt.figure()
    # sns.scatterplot( data=X_train.reset_index(), x=feature_x, y=feature_y, hue=kmeans.labels_)
    # plt.title('Clusters')

    # plt.figure()
    # sns.scatterplot( data=X_train.reset_index(), x=feature_x, y=feature_y, hue=clustered_data["isVideo_pred"])
    # plt.title('isVideo_pred')

    # plt.figure()
    # sns.scatterplot( data=X_train.reset_index(), x=feature_x, y=feature_y, hue=clustered_data["isVideo"])
    # plt.title('isVideo')

    # plt.show()

    # for cluster in range(kmeans.n_clusters):

    #     samplesIndexes = cluster_map[cluster_map.cluster == cluster].data_index
    #     n_video = 0
    #     n_not_video = 0

    #     for index in samplesIndexes:
            # is_video = y_train.loc[index]
            # print(index)
            # print(is_video)
            #exit()
            # if y_train.iloc[index]["isVideo"] == 1:
            #     n_video = n_video + 1
            # else: n_not_video = n_not_video + 1

        # print("Cluster "+str(cluster))
        # print("n_video: "+str(n_video))
        # print("n_not_video: "+str(n_not_video))
        # if n_video > n_not_video:
        #     print("This cluster is video")
        # else:
        #     print("This cluster is not video")

        # print("==============================\n")


    



    # centroids = []
    
    # for cluster in clusters:
    #     clusterDict = dict()
    #     for i in range(len(featuresList)):
    #         clusterDict[featuresList[i]] = cluster[i]
    #     clusterDict["isVideo"] = 0 #I have to figure this out
    #     centroids.append(clusterDict)

    # generateClassifier(featureParamsList, centroids)

    

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
