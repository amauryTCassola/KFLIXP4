import pyshark
import ipaddress
import ast
import json
import os

from result_capture_reader import read_result_capture

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

capDir = 'Captures/'
analysisDir = 'Analysis/'

def create_analysis_file(isVideo, isDesktop, app):
    dirName = ''
    if isVideo:
        dirName += 'Video/'
    else:
        dirName += 'Not-Video/'

    if isDesktop:
        dirName += 'Desktop/'
    else:
        dirName += 'Mobile/'

    capFilename = capDir+dirName+app+'-result.pcap'
    analysisFilename = analysisDir+dirName+app+'-analysis.json'

    result = read_result_capture(capFilename, isVideo)

    analysisFile = open(analysisFilename, "w")
    json_object = json.dumps(result, indent=4)
    analysisFile.write(json_object)

if __name__ == '__main__':
    for app in videoMobileApps:
        isVideo = True
        isDesktop = False
        create_analysis_file(isVideo, isDesktop, app)

    for app in nonVideoMobileApps:
        isVideo = False
        isDesktop = False
        create_analysis_file(isVideo, isDesktop, app)

    for app in videoDesktopApps:
        isVideo = True
        isDesktop = True
        create_analysis_file(isVideo, isDesktop, app)

    for app in nonVideoDesktopApps:
        isVideo = False
        isDesktop = True
        create_analysis_file(isVideo, isDesktop, app)