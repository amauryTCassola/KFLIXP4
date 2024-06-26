from sklearn.preprocessing import MinMaxScaler
from sklearn.cluster import KMeans
from sklearn.feature_extraction import DictVectorizer
import numpy as np
import pandas as pd
from capture_reader import read_video_capture, read_nonvideo_capture, get_feature_list
from rich import print
import os


if __name__ == '__main__':
    durationThreshold = 10

    videoDataset = []
    otherDataset = []

    videoFiles = os.listdir(os.path.join(os.getcwd(), 'captures', 'Video'))
    nonVideoFiles = os.listdir(os.path.join(os.getcwd(), 'captures', 'Not-Video'))
    
    # for filename in videoFiles:
    #     videoDataset += read_video_capture('captures/Video/'+filename)
    #     print("Finished file "+filename)

    # print("Video dataset len:")
    # print(len(videoDataset))

    # for flow in videoDataset:
    #     flow["isVideo"] = 1

    # vectorizer = DictVectorizer(sort=False)

    # videoFlowsDataset = vectorizer.fit_transform(videoDataset).toarray()

    # featuresList = get_feature_list()
    # columnsList = featuresList + ["isVideo"]
    # df = pd.DataFrame(data=videoFlowsDataset, columns=columnsList)
    # df.to_csv('video-dataset.csv', sep = ',', index = False)

    for filename in nonVideoFiles:
        otherDataset += read_nonvideo_capture('captures/Not-Video/'+filename)
        print("Finished file "+filename)

    print("Not Video dataset len:")
    print(len(otherDataset))

    for flow in otherDataset:
        flow["isVideo"] = 0

    vectorizer = DictVectorizer(sort=False)

    otherFlowsDataset = vectorizer.fit_transform(otherDataset).toarray()

    featuresList = get_feature_list()
    columnsList = featuresList + ["isVideo"]
    df = pd.DataFrame(data=otherFlowsDataset, columns=columnsList)
    df.to_csv('not-video-dataset.csv', sep = ',', index = False)


    #3 cenários, light, medium e heavy
    #variando número de features, de clsusters, etc
    #analisar tradeoff entre memória e acurácia
    #citar feature selection, citar referências, falar que é um trabalho futuro