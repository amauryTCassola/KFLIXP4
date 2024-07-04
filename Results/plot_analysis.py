import json
import matplotlib.pyplot as plt 

dir = 'Metrics-full/'
if __name__ == '__main__':
    youtubeMobile = json.load(open(dir+'youtube-mobile-metrics.json'))
    youtubeDesktop = json.load(open(dir+'youtube-mobile-analysis.json.json'))
    netflix = json.load(open(dir+'netflix-analysis.json.json'))
    telewebion = json.load(open(dir+'telewebion-analysis.json.json'))
    filimo = json.load(open(dir+'filimo-analysis.json.json'))


    apps = ["Youtube\n(mobile)", "Youtube\n(desktop)", "Netflix", "Telewebion", "Filimo"]

    accs = [youtubeMobile["Accuracy"], youtubeDesktop["Accuracy"], netflix["Accuracy"], telewebion["Accuracy"], filimo["Accuracy"]]
    precs = [youtubeMobile["Precision"], youtubeDesktop["Precision"], netflix["Precision"], telewebion["Precision"], filimo["Precision"]]
    recalls = [youtubeMobile["Recall"], youtubeDesktop["Recall"], netflix["Recall"], telewebion["Recall"], filimo["Recall"]]
    f1s = [youtubeMobile["F1"], youtubeDesktop["F1"], netflix["F1"], telewebion["F1"], filimo["F1"]]

    plt.figure()
    plt.bar(apps, precs, width = 0.2)
    plt.xlabel("Aplicações")
    plt.ylabel("Acurácia")

    plt.figure()
    plt.bar(apps, precs, width = 0.2)
    plt.xlabel("Aplicações")
    plt.ylabel("Precisão")


    plt.figure()
    plt.bar(apps, recalls, width = 0.2)
    plt.xlabel("Aplicações")
    plt.ylabel("Recall")

    plt.figure()
    plt.bar(apps, f1s, width = 0.2)
    plt.xlabel("Aplicações")
    plt.ylabel("F1")

    plt.show()