Introduction
============
This dataset contains the annotations and assessments of student performances for the 2013–2014 Florida all-state auditions. The dataset is available on request from the Florida Bandmasters Association (FBA).

Dataset Description
===================
The data set contains 3,343 student recordings with 18 different instruments covering the instrument groups woodwind, brass, and percussion. The performances are assessed by expert judges in different categories. The overall audio length, not only containing recorded performances but pauses and spoken announcements as well, is longer than 270h. The data is anonymized - personal identification of students and judges is impossible.

Annotations
===========
The file structure resembles the structure of the audio files and is split into three main categories: concert band, middle school, and symphonic band. The annotated data is split into the following text files:

1. *_assessments.txt
--------------------
Contains the judge assessments of a student’s audition. Students were assessed in different categories (ex. note accuracy) and separately for different segments of the audition (ex. technical etude). Assessments are normalized to [0,1], and -1 indicates a missing assessment. The assessments are organized into a 10 x 26 matrix where rows represent segments and columns represent categories:

Rows (10 segments):
1. lyricalEtude
2. technicalEtude
3. scalesChromatic
4. scalesMajor
5. sightReading
6. malletEtude
7. snareEtude
8. timpaniEtude
9. readingMallet
10. readingSnare

Columns (26 categories):
1. articulation
2. artistry
3. musicalityTempoStyle
4. noteAccuracy
5. rhythmicAccuracy
6. toneQuality
7. articulationStyle
8. musicalityPhrasingStyle
9. noteAccuracyConsistency
10. tempoConsistency
11. Ab
12. A
13. Bb
14. B
15. C
16. Db
17. D
18. Eb
19. E
20. F
21. Gb
22. G
23. chromatic
24. musicalityStyle
25. noteAccuracyTone
26. rhythmicAccuracyArticulation

2. *_instrument.txt
-------------------
ENTER DESCRIPTION HERE

3. *_segment.txt
----------------
ENTER DESCRIPTION HERE

Contact
=======
Alexander Lerch
alexander.lerch@gatech.edu

Georgia Tech Center for Music Technology
840 McMillan Street
Atlanta, GA 30332