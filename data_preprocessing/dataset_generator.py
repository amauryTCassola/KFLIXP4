from sklearn.feature_extraction import DictVectorizer
import pandas as pd
from capture_reader import read_video_capture, read_nonvideo_capture, get_feature_list
from rich import print
import os
import json

videoCapDir = os.path.join(os.getcwd(), 'captures', 'Train', 'Video')
notVideoCapDir = os.path.join(os.getcwd(), 'captures', 'Train', 'Not-Video')

videoMobile = os.path.join(videoCapDir, 'Mobile')
videoDesktop = os.path.join(videoCapDir, 'Desktop')

filimoDir = os.path.join(videoMobile, 'Filimo')
telewebionDir = os.path.join(videoMobile, 'Telewebion')
youtubeMobileDir = os.path.join(videoMobile, 'Youtube')

netflixDir = os.path.join(videoDesktop, 'Netflix')
twitchDir = os.path.join(videoDesktop, 'Twitch')
youtubeDesktopDir = os.path.join(videoDesktop, 'Youtube')

notVideoMobile = os.path.join(notVideoCapDir, 'Mobile')
notVideoDesktop = os.path.join(notVideoCapDir, 'Desktop')

mobileVideoApps = [
    "Filimo",
    "Telewebion",
    "Youtube"
]

desktopVideoApps = [
    "Netflix",
    "Twitch",
    "Youtube"
]

videoDirsDict = dict({
    "Mobile": {
        "Filimo": filimoDir,
        "Telewebion": telewebionDir,
        "Youtube": youtubeMobileDir
    },
    "Desktop": {
        "Netflix": netflixDir,
        "Twitch": twitchDir,
        "Youtube": youtubeDesktopDir
    }
})

if __name__ == '__main__':

    resultCountDict = dict({
        "Mobile": {
            "Total": 0,
        },
        "Desktop": {
            "Total": 0,
        },
        "Total": 0
    })

    videoDataset = []
    otherDataset = []

    ############ VIDEO ###################
    mobileVideoFlowCount = 0
    for app in mobileVideoApps:
        appDir = videoDirsDict["Mobile"][app]
        appFiles = os.listdir(appDir)
        flowCount = 0
        for filename in appFiles:
            result = read_video_capture(appDir+'/'+filename)
            flowCount += len(result)
            videoDataset += result
            print("Finished "+app+" file "+filename)
            print("Captured flows: "+str(len(result)))

        resultCountDict["Mobile"][app] = flowCount
        mobileVideoFlowCount += flowCount

    resultCountDict["Mobile"]["TotalVideo"] = mobileVideoFlowCount

    desktopVideoFlowCount = 0
    for app in desktopVideoApps:
        appDir = videoDirsDict["Desktop"][app]
        appFiles = os.listdir(appDir)
        flowCount = 0
        for filename in appFiles:
            result = read_video_capture(appDir+'/'+filename)
            flowCount += len(result)
            videoDataset += result
            print("Finished "+app+" file "+filename)
            print("Captured flows: "+str(len(result)))

        resultCountDict["Desktop"][app] = flowCount
        desktopVideoFlowCount += flowCount
    resultCountDict["Desktop"]["TotalVideo"] = desktopVideoFlowCount


    print("Video dataset len:")
    print(len(videoDataset))

    for flow in videoDataset:
        flow["isVideo"] = 1

    vectorizer = DictVectorizer(sort=False)

    videoFlowsDataset = vectorizer.fit_transform(videoDataset).toarray()

    featuresList = get_feature_list()
    columnsList = featuresList + ["isVideo"]
    df = pd.DataFrame(data=videoFlowsDataset, columns=columnsList)
    df.to_csv('video-dataset.csv', sep = ',', index = False)


    ############ NON-VIDEO ###################

    mobileNonVideoFiles = os.listdir(notVideoMobile)
    desktopNonVideoFiles = os.listdir(notVideoDesktop)

    mobileFlowCount = 0
    desktopFlowCount = 0

    for filename in mobileNonVideoFiles:
        result = read_nonvideo_capture(notVideoMobile+'/'+filename)
        mobileFlowCount += len(result)
        otherDataset += result
        print("Finished file "+filename)
        print("Captured flows: "+str(len(result)))

    resultCountDict["Mobile"]["TotalNot-Video"] = mobileFlowCount

    for filename in desktopNonVideoFiles:
        result = read_nonvideo_capture(notVideoDesktop+'/'+filename)
        desktopFlowCount += len(result)
        otherDataset += result
        print("Finished file "+filename)
        print("Captured flows: "+str(len(result)))

    resultCountDict["Desktop"]["TotalNot-Video"] = desktopFlowCount


    resultCountDict["Mobile"]["Total"] = mobileFlowCount + mobileVideoFlowCount
    resultCountDict["Desktop"]["Total"] = desktopFlowCount + desktopVideoFlowCount
    resultCountDict["Total"] = mobileFlowCount + mobileVideoFlowCount + desktopFlowCount + desktopVideoFlowCount

    logFile = open("dataset-gen-log.json", "w")
    json_object = json.dumps(resultCountDict, indent=4)
    logFile.write(json_object)

    print("Not Video dataset len:")
    print(len(otherDataset))

    for flow in otherDataset:
        flow["isVideo"] = 0

    vectorizer2 = DictVectorizer(sort=False)

    otherFlowsDataset = vectorizer2.fit_transform(otherDataset).toarray()

    df = pd.DataFrame(data=otherFlowsDataset, columns=columnsList)
    df.to_csv('not-video-dataset.csv', sep = ',', index = False)

    #3 cenários, light, medium e heavy
    #variando número de features, de clsusters, etc
    #analisar tradeoff entre memória e acurácia
    #citar feature selection, citar referências, falar que é um trabalho futuro