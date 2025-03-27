from sklearn.feature_extraction import DictVectorizer
import pandas as pd
from capture_reader import read_video_capture, read_nonvideo_capture, get_feature_list
from rich import print
import os
import json

# videoCapDir = os.path.join(os.getcwd(), 'captures', 'Train', 'Video')
# notVideoCapDir = os.path.join(os.getcwd(), 'captures', 'Train', 'Not-Video')

trainCapDir = os.path.join(os.getcwd(), 'captures', 'Train')

#videoMobile = os.path.join(videoCapDir, 'Mobile')
#videoDesktop = os.path.join(videoCapDir, 'Desktop')

#filimoDir = os.path.join(videoMobile, 'Filimo')
#telewebionDir = os.path.join(videoMobile, 'Telewebion')
#youtubeMobileDir = os.path.join(videoMobile, 'Youtube')

netflixDir = os.path.join(trainCapDir, 'Netflix')
#twitchDir = os.path.join(videoDesktop, 'Twitch')
youtubeDesktopDir = os.path.join(trainCapDir, 'Youtube')

#notVideoMobile = os.path.join(notVideoCapDir, 'Mobile')
notVideoDesktop = os.path.join(trainCapDir, 'Web')

# mobileVideoApps = [
#     "Filimo",
#     "Telewebion",
#     "Youtube"
# ]

desktopVideoApps = [
    "Netflix",
    "Youtube"
]

videoDirsDict = dict({
    # "Mobile": {
    #     "Filimo": filimoDir,
    #     "Telewebion": telewebionDir,
    #     "Youtube": youtubeMobileDir
    # },
    "Desktop": {
        "Netflix": netflixDir,
#        "Twitch": twitchDir,
        "Youtube": youtubeDesktopDir
    }
})

if __name__ == '__main__':

    videoDict = dict({
        "Youtube": 0,
        "Netflix": 0
    })

    videoDataset = []
    otherDataset = []

    ############ VIDEO ###################
    # mobileVideoFlowCount = 0
    # for app in mobileVideoApps:
    #     appDir = videoDirsDict["Mobile"][app]
    #     appFiles = os.listdir(appDir)
    #     flowCount = 0
    #     for filename in appFiles:
    #         result = read_video_capture(appDir+'/'+filename)
    #         flowCount += len(result)
    #         videoDataset += result
    #         print("Finished "+app+" file "+filename)
    #         print("Captured flows: "+str(len(result)))

    #     resultCountDict["Mobile"][app] = flowCount
    #     mobileVideoFlowCount += flowCount

    # resultCountDict["Mobile"]["TotalVideo"] = mobileVideoFlowCount

    totalFlow = 0

    totalVideoFlow = 0

    totalNonVideoFlow = 0

    for app in desktopVideoApps:
        appDir = videoDirsDict["Desktop"][app]
        appFiles = os.listdir(appDir)
        totalApp = 0
        for filename in appFiles:
            result = read_video_capture(appDir+'/'+filename)
            thisCount= len(result)
            totalVideoFlow += thisCount
            videoDataset += result
            totalApp += thisCount
            print("Finished "+app+" file "+filename)
            print("Captured video flows: "+str(thisCount))
        videoDict[app] = totalApp


    # print("Video dataset len:")
    # print(len(videoDataset))

    # for flow in videoDataset:
    #     flow["isVideo"] = 1

    # vectorizer = DictVectorizer(sort=False)

    # videoFlowsDataset = vectorizer.fit_transform(videoDataset).toarray()

    featuresList = get_feature_list()
    columnsList = featuresList + ["isVideo"]
    df = pd.DataFrame(data=videoDataset, columns=columnsList)
    #df.to_csv('video-dataset.csv', sep = ',', index = False)


    ############ NON-VIDEO ###################

    #mobileNonVideoFiles = os.listdir(notVideoMobile)
    desktopNonVideoFiles = os.listdir(notVideoDesktop)

    #mobileFlowCount = 0
    #desktopFlowCount = 0

    # for filename in mobileNonVideoFiles:
    #     result = read_nonvideo_capture(notVideoMobile+'/'+filename)
    #     mobileFlowCount += len(result)
    #     otherDataset += result
    #     print("Finished file "+filename)
    #     print("Captured flows: "+str(len(result)))

    # resultCountDict["Mobile"]["TotalNot-Video"] = mobileFlowCount

    for filename in desktopNonVideoFiles:
        result = read_nonvideo_capture(notVideoDesktop+'/'+filename)
        totalNonVideoFlow += len(result)
        otherDataset += result
        print("Finished file "+filename)
        print("Captured flows: "+str(len(result)))

    # resultCountDict["Desktop"]["TotalNot-Video"] = desktopFlowCount


    # #resultCountDict["Mobile"]["Total"] = mobileFlowCount + mobileVideoFlowCount
    # resultCountDict["Desktop"]["Total"] = desktopFlowCount + desktopVideoFlowCount
    # #resultCountDict["Total"] = mobileFlowCount + mobileVideoFlowCount + desktopFlowCount + desktopVideoFlowCount
    # resultCountDict["Total"] = desktopFlowCount + desktopVideoFlowCount

    # logFile = open("dataset-gen-log.json", "w")
    # json_object = json.dumps(resultCountDict, indent=4)
    # logFile.write(json_object)

    print("Not Video dataset len:")
    print(len(otherDataset))

    df = pd.DataFrame(data=otherDataset, columns=columnsList)
    #df.to_csv('not-video-dataset.csv', sep = ',', index = False)

    totalFlow = totalVideoFlow + totalNonVideoFlow
    resultCountDict = dict({
        "Total": totalFlow,
        "VideoFlows": totalVideoFlow,
        "NonVideoFlows": totalNonVideoFlow,
        "Youtube": videoDict["Youtube"],
        "Netflix": videoDict["Netflix"]
    })

    logFile = open("dataset-gen-log.json", "w")
    json_object = json.dumps(resultCountDict, indent=4)
    logFile.write(json_object)
