import json
import os

from result_capture_reader import read_result_capture

analysisDirMobile = 'Mobile/analysis/'
analysisDirDesktop = 'Desktop/analysis/'

def generate_metrics(results, output):
    true_p = 0
    false_p = 0
    true_n = 0
    false_n = 0
    total_video = 0
    total_not_video = 0

    true_p_bytes = 0
    true_n_bytes = 0
    total_bytes = 0

    for result in results:
        pred = result["IsVideo_pred"]
        GT = result["IsVideo_GT"]
        length = result["SumPktLength"]
        total_bytes += length

        if GT == 1:
            total_video += 1
        else: total_not_video += 1

        if pred == 1 and GT == 1:
            true_p += 1
            true_p_bytes += length
        elif pred == 1 and GT == 0:
            false_p += 1
        elif pred == 0 and GT == 0:
            true_n += 1
            true_n_bytes += length
        elif pred == 0 and GT == 1:
            false_n += 1

    total = true_n + true_p + false_n + false_p
    accuracy = (true_p + true_n)/total
    precision = 0
    recall = 0
    f1 = 0

    if false_n != 0:
        precision = true_p/(true_p + false_p)
        recall = true_p/(true_p + false_n)
        f1 = 2*( (precision*recall)/(precision+recall) )

    byte_accuracy = (true_p_bytes+true_n_bytes)/total_bytes

    metrics = {
        "Total": total,
        "Total_video": total_video,
        "Total_not_video": total_not_video,
        "Byte_accuracy": byte_accuracy,
        "Accuracy": accuracy,
        "Precision": precision,
        "Recall": recall,
        "F1": f1,
        "True_positives": true_p,
        "True_negatives": true_n,
        "False_positives": false_p,
        "False_negatives": false_n,
        "Total_bytes": total_bytes,
        "True_p_bytes": true_p_bytes,
        "True_n_bytes": true_n_bytes
    }

    outputFile = open(output, "w")
    json_object = json.dumps(metrics, indent=4)
    outputFile.write(json_object)

def filter_results(results):
    filtered = [result for result in results if (result["FlowDuration"]/1000000) > 10]
    return filtered

videoMobileApps = [
    "filimo",
    "telewebion",
    "youtube-mobile"
]

videoDesktopApps = [
    "youtube-desktop",
    "netflix"
]

nonVideoMobileApps = [
    "dropbox-mobile",
    "gmaps"
]

nonVideoDesktopApps = [
    "dropbox-desktop",
    "amazon"
]

analysisDir = 'Analysis/'

def get_analysis_file(isVideo, isDesktop, app):
    dirName = 'Analysis/'
    if isVideo:
        dirName += 'Video/'
    else:
        dirName += 'Not-Video/'

    if isDesktop:
        dirName += 'Desktop/'
    else:
        dirName += 'Mobile/'

    dirName += app+'-analysis.json'
    return dirName

def get_metrics_file(isVideo, isDesktop, app, isFiltered):
    dirName = 'Analysis/'
    if isVideo:
        dirName += 'Video/'
    else:
        dirName += 'Not-Video/'

    if isDesktop:
        dirName += 'Desktop/'
    else:
        dirName += 'Mobile/'

    if isFiltered:
        dirName += app+'-filtered-metrics.json'
    else:
        dirName += app+'-metrics.json'
            
    return dirName

def generate_apps_metrics(appList, isVideo, isDesktop):
    results = []
    filteredResults = []

    for app in appList:
        pathname = get_analysis_file(isVideo, isDesktop, app)

        f = open(pathname)
        appResults = json.load(f)
        filteredResults = filter_results(appResults)

        metricsFile = get_metrics_file(isVideo, isDesktop, app, False)
        filteredMetricsFile = get_metrics_file(isVideo, isDesktop, app, True)
        
        generate_metrics(appResults, metricsFile)
        #generate_metrics(filteredResults, filteredMetricsFile)

        results += appResults
        filteredResults += filteredResults

    return results, filteredResults

if __name__ == '__main__':
    results = []
    filteredResults = []
    mobileResults = []
    filteredMobileResults = []
    desktopResults = []
    filteredDesktopResults = []

    videoMobileResults, filteredVideoMobileResults = generate_apps_metrics(videoMobileApps, isVideo=True, isDesktop=False)

    mobileResults += videoMobileResults
    filteredMobileResults += filteredVideoMobileResults
    results += videoMobileResults
    filteredResults += filteredVideoMobileResults


    nonVideoMobileResults, filteredNonVideoMobileResults = generate_apps_metrics(nonVideoMobileApps, isVideo=False, isDesktop=False)

    mobileResults += nonVideoMobileResults
    filteredMobileResults += filteredNonVideoMobileResults
    results += nonVideoMobileResults
    filteredResults += filteredNonVideoMobileResults


    videoDesktopResults, filteredVideoDesktopResults = generate_apps_metrics(videoDesktopApps, isVideo=True, isDesktop=True)

    desktopResults += videoDesktopResults
    filteredDesktopResults += filteredVideoDesktopResults
    results += videoDesktopResults
    filteredResults += filteredVideoDesktopResults


    nonVideoDesktopResults, filteredNonVideoDesktopResults = generate_apps_metrics(nonVideoDesktopApps, isVideo=False, isDesktop=True)

    desktopResults += nonVideoDesktopResults
    filteredDesktopResults += filteredNonVideoDesktopResults
    results += nonVideoDesktopResults
    filteredResults += filteredNonVideoDesktopResults


    generate_metrics(results, 'full-metrics.json')
    generate_metrics(mobileResults, 'mobile-metrics.json')
    generate_metrics(desktopResults, 'desktop-metrics.json')

    #generate_metrics(filteredResults, 'filtered-metrics.json')
    #generate_metrics(filteredMobileResults, 'filtered-mobile-metrics.json')
    #generate_metrics(filteredDesktopResults, 'filtered-desktop-metrics.json')
